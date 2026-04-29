import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../auth/application/auth_controller.dart';
import '../../../core/services/location_service.dart';
import '../../profile/application/profile_controller.dart';
import '../../../app/router/route_names.dart';

import '../widgets/quick_action_card.dart';
import '../widgets/emergency_banner.dart';
import '../widgets/blood_status_banner.dart';

// ✅ AJOUT IMPORT DEMANDE SANG
import '../../donations/presentation/screens/demande_sang_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _passwordModalShown = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSetPasswordModalIfNeeded();
      _initLocation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSetPasswordModalIfNeeded();
    });
  }

  Future<void> _initLocation() async {
    try {
      final service = LocationService();
      final position = await service.getLocation();

      if (position != null) {
        await ref
            .read(profileControllerProvider.notifier)
            .updateLocation(position.latitude, position.longitude);
      }
    } catch (_) {}
  }

  void _showSetPasswordModalIfNeeded() {
    if (_passwordModalShown) return;
    if (!mounted) return;

    final authState = ref.read(authControllerProvider);

    final shouldAskForPassword =
        !authState.isAuthenticated &&
        (authState.pendingPhone != null || authState.pendingEmail != null);

    if (!shouldAskForPassword) return;

    _passwordModalShown = true;
    _openSetPasswordModal();
  }

  Future<void> _openSetPasswordModal() async {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    bool obscure1 = true;
    bool obscure2 = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final authState = ref.watch(authControllerProvider);

            return AlertDialog(
              title: const Text('Créer votre mot de passe'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Pour finaliser votre compte, veuillez définir un mot de passe.',
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Mot de passe',
                        labelText: 'Mot de passe',
                        obscureText: obscure1,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le mot de passe est obligatoire';
                          }
                          if (value.trim().length < 6) {
                            return 'Le mot de passe doit contenir au moins 6 caractères';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setModalState(() {
                              obscure1 = !obscure1;
                            });
                          },
                          icon: Icon(
                            obscure1 ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: confirmController,
                        hintText: 'Confirmer le mot de passe',
                        labelText: 'Confirmation',
                        obscureText: obscure2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez confirmer le mot de passe';
                          }
                          if (value.trim() != passwordController.text.trim()) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setModalState(() {
                              obscure2 = !obscure2;
                            });
                          },
                          icon: Icon(
                            obscure2 ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                      if (authState.errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          authState.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Enregistrer',
                    isLoading: authState.isLoading,
                    onPressed: () async {
                      final isValid =
                          formKey.currentState?.validate() ?? false;
                      if (!isValid) return;

                      final auth =
                          ref.read(authControllerProvider.notifier);
                      final password = passwordController.text.trim();

                      await auth.setPassword(password: password);

                      if (!mounted) return;

                      final stateAfterSetPassword =
                          ref.read(authControllerProvider);

                      if (stateAfterSetPassword.errorMessage == null) {
                        final identifier =
                            stateAfterSetPassword.pendingPhone ??
                            stateAfterSetPassword.pendingEmail;

                        if (identifier != null && identifier.isNotEmpty) {
                          await auth.completeRegistrationAndLogin(
                            identifier: identifier,
                            password: password,
                          );
                        }

                        if (!mounted) return;

                        final newState = ref.read(authControllerProvider);

                        if (newState.isAuthenticated) {
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }

                          _passwordModalShown = false;
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    passwordController.dispose();
    confirmController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.currentUser;

    final bloodGroup =
        user?.groupeSanguin?.isNotEmpty == true
            ? user!.groupeSanguin!
            : 'Non défini';

    final bloodStatusRaw = user?.statutGroupeSanguin?.toLowerCase() ?? '';
    final bloodStatusLabel =
        bloodStatusRaw == 'verifie' ? 'Vérifié' : 'Non vérifié';
    final bloodStatusColor =
        bloodStatusRaw == 'verifie' ? Colors.green : Colors.orange;

    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),

      // ✅ AJOUT DU BOUTON FLOTTANT
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DemandeSangScreen(),
            ),
          );
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                user?.fullName.isNotEmpty == true
                    ? user!.fullName
                    : 'Utilisateur',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),

              EmergencyBanner(
                title: 'Urgence don de sang',
                description:
                    'Aidez rapidement en consultant les demandes urgentes et les centres disponibles.',
                onTap: () => context.push(RouteNames.donations),
              ),

              const SizedBox(height: 20),

              BloodStatusBanner(
                bloodGroup: bloodGroup,
                status: bloodStatusLabel,
                statusColor: bloodStatusColor,
              ),

              const SizedBox(height: 24),

              QuickActionCard(
                icon: Icons.favorite,
                title: 'Mes dons',
                subtitle: 'Consulter votre historique de dons',
                color: Colors.red,
                onTap: () => context.push(RouteNames.donations),
              ),

              const SizedBox(height: 12),

              QuickActionCard(
                icon: Icons.location_on,
                title: 'Centres proches',
                subtitle: 'Trouver les centres de don autour de vous',
                color: Colors.blue,
                onTap: () => context.push(RouteNames.centers),
              ),

              const SizedBox(height: 12),

              QuickActionCard(
                icon: Icons.notifications_active,
                title: 'Notifications',
                subtitle: 'Voir les alertes et messages importants',
                color: Colors.orange,
                onTap: () => context.push(RouteNames.notifications),
              ),

              const SizedBox(height: 24),

              CustomButton(
                text: 'Déconnexion',
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).logout();

                  if (!context.mounted) return;

                  context.go(RouteNames.loginUser);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}