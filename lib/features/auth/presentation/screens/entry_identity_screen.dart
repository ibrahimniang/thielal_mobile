import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../application/auth_controller.dart';

/// Écran d'entrée dans l'application.
///
/// UX choisie :
/// - l'utilisateur saisit son téléphone ou son email
/// - on envoie le code OTP
/// - un modal s'ouvre sur le même écran pour saisir le code
/// - si le code est valide -> redirection vers RegisterScreen
///
/// Remarque équipe :
/// on garde OtpVerificationScreen dans le projet si besoin de secours,
/// mais le flow principal passe désormais par ce modal.
class EntryIdentityScreen extends ConsumerStatefulWidget {
  const EntryIdentityScreen({super.key});

  @override
  ConsumerState<EntryIdentityScreen> createState() =>
      _EntryIdentityScreenState();
}

class _EntryIdentityScreenState extends ConsumerState<EntryIdentityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();

  @override
  void dispose() {
    _identityController.dispose();
    super.dispose();
  }

  bool _isEmail(String value) {
    return value.contains('@');
  }

  Future<void> _openOtpModal() async {
    final otpController = TextEditingController();
    final otpFormKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.screenPadding,
            AppSpacing.screenPadding,
            MediaQuery.of(modalContext).viewInsets.bottom +
                AppSpacing.screenPadding,
          ),
          child: Consumer(
            builder: (context, ref, _) {
              final authState = ref.watch(authControllerProvider);

              return Form(
                key: otpFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Vérification OTP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Entrez le code reçu pour continuer votre inscription.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: otpController,
                      hintText: 'Code OTP',
                      labelText: 'Code OTP',
                      keyboardType: TextInputType.number,
                      validator: Validators.otp,
                    ),
                    if (authState.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        authState.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Vérifier',
                      isLoading: authState.isLoading,
                      onPressed: () async {
                        final isValid =
                            otpFormKey.currentState?.validate() ?? false;
                        if (!isValid) return;

                        await ref
                            .read(authControllerProvider.notifier)
                            .verifyOtp(
                              phone: authState.pendingPhone,
                              email: authState.pendingEmail,
                              code: otpController.text.trim(),
                            );

                        if (!mounted) return;

                        final state = ref.read(authControllerProvider);
                        if (state.otpVerified) {
                          if (modalContext.mounted) {
                            Navigator.of(modalContext).pop();
                          }
                          context.go(RouteNames.register);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () async {
                        final value = _identityController.text.trim();
                        final email = _isEmail(value) ? value : null;
                        final phone = _isEmail(value) ? null : value;

                        await ref
                            .read(authControllerProvider.notifier)
                            .sendOtp(phone: phone, email: email);
                      },
                      child: const Text('Renvoyer le code'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Commencer')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Entrez votre numéro de téléphone ou votre email pour recevoir un code OTP.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _identityController,
                  hintText: 'Téléphone ou email',
                  labelText: 'Téléphone ou email',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                ),
                if (authState.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    authState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Recevoir le code',
                  isLoading: authState.isLoading,
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final value = _identityController.text.trim();
                    final email = _isEmail(value) ? value : null;
                    final phone = _isEmail(value) ? null : value;

                    await ref
                        .read(authControllerProvider.notifier)
                        .sendOtp(phone: phone, email: email);

                    if (!mounted) return;

                    final currentState = ref.read(authControllerProvider);
                    if (currentState.errorMessage == null) {
                      await _openOtpModal();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
