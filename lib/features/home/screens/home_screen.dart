import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../auth/application/auth_controller.dart';
import '../../../core/services/location_service.dart';
import '../../profile/application/profile_controller.dart'; // ✅ AJOUT

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
      _initLocation(); // ✅ AJOUT
    });
  }

  /// ✅ NOUVELLE FONCTION LOCALISATION
  Future<void> _initLocation() async {
    try {
      final service = LocationService();

      final position = await service.getLocation();

      if (position != null) {
        print("LAT: ${position.latitude}");
        print("LNG: ${position.longitude}");

        await ref
            .read(profileControllerProvider.notifier)
            .updateLocation(position.latitude, position.longitude);

        print("LOCATION SENT TO BACKEND");
      } else {
        print("LOCATION NOT AVAILABLE");
      }
    } catch (e) {
      print("LOCATION ERROR: $e");
    }
  }

  void _showSetPasswordModalIfNeeded() {
    if (_passwordModalShown) return;

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
                      final isValid = formKey.currentState?.validate() ?? false;
                      if (!isValid) return;

                      await ref
                          .read(authControllerProvider.notifier)
                          .setPassword(
                            password: passwordController.text.trim(),
                          );

                      if (!mounted) return;

                      final state = ref.read(authControllerProvider);
                      if (state.errorMessage == null) {
                        final identifier =
                            state.pendingPhone ?? state.pendingEmail;

                        if (identifier != null && identifier.isNotEmpty) {
                          await ref
                              .read(authControllerProvider.notifier)
                              .completeRegistrationAndLogin(
                                identifier: identifier,
                                password: passwordController.text.trim(),
                              );
                        }

                        if (!mounted) return;

                        final newState = ref.read(authControllerProvider);
                        if (newState.isAuthenticated && dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
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

    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: SafeArea(
        child: Padding(
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
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tableau de bord',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Cette zone accueillera prochainement les informations principales de l’utilisateur : alertes, statut de don, centres proches, notifications et historique.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              CustomButton(
                text: 'Déconnexion',
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
