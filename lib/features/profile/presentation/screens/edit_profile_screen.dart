import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/profile_controller.dart';
import '../../data/models/profile_model.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/contact_change_dialog.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _villeController = TextEditingController();
  final _quartierController = TextEditingController();

  bool _initialized = false;
  bool _saving = false;

  void _init(ProfileModel? user) {
    if (_initialized || user == null) return;

    _nomController.text = user.nom ?? '';
    _prenomController.text = user.prenom ?? '';
    _villeController.text = user.ville ?? '';
    _quartierController.text = user.quartier ?? '';

    _initialized = true;
  }

  void _openNewPasswordDialog(String telephone) {
    final passwordController = TextEditingController();

    final confirmController = TextEditingController();

    final authController = ref.read(authControllerProvider.notifier);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Nouveau mot de passe"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Nouveau mot de passe",
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirmer le mot de passe",
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Annuler"),
            ),

            ElevatedButton(
              onPressed: () async {
                if (passwordController.text != confirmController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Les mots de passe ne correspondent pas"),
                    ),
                  );
                  return;
                }

                await authController.forgotPasswordResetPassword(
                  telephone: telephone,
                  password: passwordController.text,
                );

                if (!mounted) return;

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Mot de passe modifié avec succès"),
                  ),
                );
              },
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  void _openOtpResetDialog(String telephone) {
    final otpController = TextEditingController();

    final rootContext = context;

    final authController = ref.read(authControllerProvider.notifier);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Vérification OTP"),

          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Code OTP"),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Annuler"),
            ),

            ElevatedButton(
              onPressed: () async {
                await authController.forgotPasswordVerifyCode(
                  telephone: telephone,
                  code: otpController.text.trim(),
                );

                Navigator.pop(dialogContext);

                Future.delayed(const Duration(milliseconds: 200), () {
                  if (mounted) {
                    _openNewPasswordDialog(telephone);
                  }
                });
              },
              child: const Text("Vérifier"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _villeController.dispose();
    _quartierController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _saving = true);

    try {
      await ref
          .read(profileControllerProvider.notifier)
          .updateProfile(
            nom: _nomController.text.trim(),
            prenom: _prenomController.text.trim(),
            ville:
                _villeController.text.trim().isEmpty
                    ? null
                    : _villeController.text.trim(),
            quartier:
                _quartierController.text.trim().isEmpty
                    ? null
                    : _quartierController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdatedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdateError),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _openEmailDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (_) => ContactChangeDialog(
            title: l10n.changeAddEmail,
            valueLabel: l10n.email,
            keyboardType: TextInputType.emailAddress,
            onRequestCode: (ref, value) async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .requestEmail(value);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.codeSentByEmail),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            onVerify: (ref, value, code) async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .verifyEmail(value, code);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.emailUpdatedSuccessfully),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
    );
  }

  void _openPhoneDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (_) => ContactChangeDialog(
            title: l10n.changePhone,
            valueLabel: l10n.phone,
            keyboardType: TextInputType.phone,
            onRequestCode: (ref, value) async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .requestPhone(value);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.codeSentBySms),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            onVerify: (ref, value, code) async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .verifyPhone(value, code);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.phoneUpdatedSuccessfully),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
    );
  }

  void _openResetPasswordDialog() {
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Changer le mot de passe"),

          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: "Téléphone"),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Annuler"),
            ),

            ElevatedButton(
              onPressed: () async {
                final authController = ref.read(
                  authControllerProvider.notifier,
                );

                await authController.forgotPasswordSendCode(
                  telephone: phoneController.text.trim(),
                );

                Navigator.pop(dialogContext);

                Future.delayed(const Duration(milliseconds: 200), () {
                  if (mounted) {
                    _openOtpResetDialog(phoneController.text.trim());
                  }
                });
              },
              child: const Text("Envoyer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(l10n.editProfile),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.red.shade50.withOpacity(0.55),
              Colors.green.shade50.withOpacity(0.30),
              Colors.blue.shade50.withOpacity(0.40),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: state.when(
          loading: () => AppLoadingView(message: l10n.loadingProfile),
          error:
              (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "${l10n.error}: $e",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          data: (user) {
            _init(user);

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ProfileSectionCard(
                        title: l10n.personalInformation,
                        icon: Icons.person_rounded,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nomController,
                              decoration: InputDecoration(
                                labelText: l10n.lastName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.lastNameRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _prenomController,
                              decoration: InputDecoration(
                                labelText: l10n.firstName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.firstNameRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _villeController,
                              decoration: InputDecoration(
                                labelText: l10n.city,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _quartierController,
                              decoration: InputDecoration(
                                labelText: l10n.district,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      ProfileSectionCard(
                        title: l10n.contactDetails,
                        icon: Icons.contact_phone_rounded,
                        child: Column(
                          children: [
                            _contactTile(
                              icon: Icons.email_rounded,
                              title: l10n.currentEmail,
                              value: user?.email ?? l10n.noEmailAdded,
                            ),
                            const SizedBox(height: 12),
                            _contactTile(
                              icon: Icons.phone_rounded,
                              title: l10n.currentPhone,
                              value: user?.telephone ?? "--",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      ProfileSectionCard(
                        title: l10n.securityActions,
                        icon: Icons.verified_user_rounded,
                        child: Column(
                          children: [
                            ProfileActionButton(
                              text: l10n.changePhone,
                              icon: Icons.phone_android_rounded,
                              color: Colors.green,
                              onPressed: _openPhoneDialog,
                            ),
                            const SizedBox(height: 12),

                            ProfileActionButton(
                              text: "Changer le mot de passe",
                              icon: Icons.lock_reset_rounded,
                              color: Colors.orange,
                              onPressed: _openResetPasswordDialog,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      ProfileActionButton(
                        text: l10n.saveChanges,
                        icon: Icons.save_rounded,
                        onPressed: _saving ? () {} : _saveProfile,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
