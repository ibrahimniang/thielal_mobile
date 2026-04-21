import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../application/auth_controller.dart';

/// Écran d'entrée dans l'application.
///
/// UX choisie :
/// - l'utilisateur saisit son téléphone ou son email
/// - on envoie le code OTP
/// - un modal premium s'ouvre sur le même écran pour saisir le code
/// - un timer de 5 minutes est affiché
/// - si le code est valide -> redirection vers RegisterScreen
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

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _openOtpModal() async {
    final otpController = TextEditingController();
    final otpFormKey = GlobalKey<FormState>();

    Timer? timer;
    int remainingSeconds = 300;

    void startTimer(VoidCallback refresh) {
      timer?.cancel();
      remainingSeconds = 300;

      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingSeconds <= 0) {
          t.cancel();
          refresh();
          return;
        }

        remainingSeconds--;
        refresh();
      });
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            if (timer == null) {
              startTimer(() {
                if (modalContext.mounted) {
                  setModalState(() {});
                }
              });
            }

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

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.94),
                              Colors.red.shade50.withOpacity(0.88),
                              Colors.blue.shade50.withOpacity(0.82),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.75),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Form(
                          key: otpFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 52,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              const SizedBox(height: 20),

                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade500,
                                      Colors.red.shade700,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.20),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.verified_user_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),

                              const SizedBox(height: 18),

                              const Text(
                                'Vérification OTP',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Entrez le code reçu pour continuer votre inscription.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 18),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white.withOpacity(0.78),
                                  border: Border.all(
                                    color: Colors.red.shade100,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      color:
                                          remainingSeconds > 60
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        remainingSeconds > 0
                                            ? 'Le code expire dans ${_formatDuration(remainingSeconds)}'
                                            : 'Le code a expiré. Renvoyez un nouveau code.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color:
                                              remainingSeconds > 60
                                                  ? Colors.green.shade800
                                                  : Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 18),

                              CustomTextField(
                                controller: otpController,
                                hintText: 'Code OTP',
                                labelText: 'Code OTP',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Veuillez entrer le code OTP';
                                  }
                                  if (value.trim().length < 4) {
                                    return 'Code OTP invalide';
                                  }
                                  return null;
                                },
                              ),

                              if (authState.errorMessage != null) ...[
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.red.shade50,
                                    border: Border.all(
                                      color: Colors.red.shade100,
                                    ),
                                  ),
                                  child: Text(
                                    authState.errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 20),

                              CustomButton(
                                text: 'Vérifier',
                                isLoading: authState.isLoading,
                                onPressed:
                                    remainingSeconds <= 0
                                        ? null
                                        : () async {
                                          final isValid =
                                              otpFormKey.currentState
                                                  ?.validate() ??
                                              false;
                                          if (!isValid) return;

                                          await ref
                                              .read(
                                                authControllerProvider.notifier,
                                              )
                                              .verifyOtp(
                                                phone: authState.pendingPhone,
                                                email: authState.pendingEmail,
                                                code: otpController.text.trim(),
                                              );

                                          if (!mounted) return;

                                          final state = ref.read(
                                            authControllerProvider,
                                          );

                                          if (state.otpVerified) {
                                            timer?.cancel();
                                            if (modalContext.mounted) {
                                              Navigator.of(modalContext).pop();
                                            }
                                            context.go(RouteNames.register);
                                          }
                                        },
                              ),

                              const SizedBox(height: 10),

                              TextButton(
                                onPressed:
                                    authState.isLoading
                                        ? null
                                        : () async {
                                          final value =
                                              _identityController.text.trim();
                                          final email =
                                              _isEmail(value) ? value : null;
                                          final phone =
                                              _isEmail(value) ? null : value;

                                          await ref
                                              .read(
                                                authControllerProvider.notifier,
                                              )
                                              .sendOtp(
                                                phone: phone,
                                                email: email,
                                              );

                                          if (!mounted) return;

                                          if (ref
                                                  .read(authControllerProvider)
                                                  .errorMessage ==
                                              null) {
                                            otpController.clear();
                                            startTimer(() {
                                              if (modalContext.mounted) {
                                                setModalState(() {});
                                              }
                                            });
                                            setModalState(() {});
                                          }
                                        },
                                child: const Text('Renvoyer le code'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );

    timer?.cancel();
    otpController.dispose();
  }

  Widget _buildHeroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.red.shade50.withOpacity(0.88),
                Colors.green.shade50.withOpacity(0.75),
                Colors.blue.shade50.withOpacity(0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.78),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.blue.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade500, Colors.red.shade700],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.20),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sms_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Recevoir un code OTP',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Entrez votre numéro de téléphone ou votre email pour recevoir un code sécurisé et commencer votre inscription.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.45,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white.withOpacity(0.84),
            border: Border.all(color: Colors.white.withOpacity(0.76)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(title: const Text('Commencer'), elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.red.shade50.withOpacity(0.55),
              Colors.green.shade50.withOpacity(0.40),
              Colors.blue.shade50.withOpacity(0.45),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildHeroCard(),
                    const SizedBox(height: 22),
                    _buildInputCard(
                      Column(
                        children: [
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
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.red.shade50,
                                border: Border.all(color: Colors.red.shade100),
                              ),
                              child: Text(
                                authState.errorMessage!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Recevoir le code',
                            isLoading: authState.isLoading,
                            onPressed: () async {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (!isValid) return;

                              final value = _identityController.text.trim();
                              final email = _isEmail(value) ? value : null;
                              final phone = _isEmail(value) ? null : value;

                              await ref
                                  .read(authControllerProvider.notifier)
                                  .sendOtp(phone: phone, email: email);

                              if (!mounted) return;

                              final currentState = ref.read(
                                authControllerProvider,
                              );
                              if (currentState.errorMessage == null) {
                                await _openOtpModal();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
