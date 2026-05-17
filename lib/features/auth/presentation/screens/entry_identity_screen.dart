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
import '../../../../l10n/app_localizations.dart';

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

  String _formatDurationShort(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _openOtpModal() async {
    final l10n = AppLocalizations.of(context)!;
    final otpFormKey = GlobalKey<FormState>();

    final otpControllers = List.generate(6, (_) => TextEditingController());
    final otpFocusNodes = List.generate(6, (_) => FocusNode());

    Timer? timer;
    int remainingSeconds = 300;

    String getOtpCode() {
      return otpControllers.map((c) => c.text).join();
    }

    void clearOtp() {
      for (final controller in otpControllers) {
        controller.clear();
      }
    }

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

                               Text(
                                l10n.otpVerification,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                l10n.enterOtpDescription,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 22),

                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                runSpacing: 10,
                                children: List.generate(6, (index) {
                                  return _OtpPinField(
                                    controller: otpControllers[index],
                                    focusNode: otpFocusNodes[index],
                                    autoFocus: index == 0,
                                    onChanged: (value) {
                                      if (value.length == 1 && index < 5) {
                                        otpFocusNodes[index + 1].requestFocus();
                                      }

                                      if (value.isEmpty && index > 0) {
                                        otpFocusNodes[index - 1].requestFocus();
                                      }

                                      setModalState(() {});
                                    },
                                  );
                                }),
                              ),

                              const SizedBox(height: 14),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  remainingSeconds > 0
                                      ? '${l10n.remainingTime} : ${_formatDurationShort(remainingSeconds)}'
                                      : l10n.otpExpired,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        remainingSeconds > 0
                                            ? Colors.grey.shade700
                                            : Colors.red.shade700,
                                  ),
                                ),
                              ),

                              if (authState.errorMessage != null) ...[
                                const SizedBox(height: 12),
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
                               text: l10n.verify,
                                isLoading: authState.isLoading,
                                onPressed:
                                    remainingSeconds <= 0
                                        ? null
                                        : () async {
                                          final code = getOtpCode();

                                          if (code.length < 6) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                               SnackBar(
                                                content: Text(
                                                  l10n.enterOtpCode
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          await ref
                                              .read(
                                                authControllerProvider.notifier,
                                              )
                                              .verifyOtp(
                                                phone: authState.pendingPhone,
                                                email: authState.pendingEmail,
                                                code: code,
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
                                            clearOtp();
                                            otpFocusNodes.first.requestFocus();
                                            startTimer(() {
                                              if (modalContext.mounted) {
                                                setModalState(() {});
                                              }
                                            });
                                            setModalState(() {});
                                          }
                                        },
                                child: Text(l10n.resendCode),
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
    for (final controller in otpControllers) {
      controller.dispose();
    }
    for (final node in otpFocusNodes) {
      node.dispose();
    }
  }

  Widget _buildHeroCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              Text(
                l10n.receiveOtp,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.receiveOtpDescription,
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
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(l10n.start),
        elevation: 0,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
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
                    _buildHeroCard(context),
                    const SizedBox(height: 22),
                    _buildInputCard(
                      Column(
                        children: [
                          CustomTextField(
                            controller: _identityController,
                            hintText: l10n.phoneOrEmail,
                            labelText: l10n.phoneOrEmail,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.requiredField;
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
                            text: l10n.receiveCode,
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

class _OtpPinField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autoFocus;
  final ValueChanged<String> onChanged;

  const _OtpPinField({
    required this.controller,
    required this.focusNode,
    required this.autoFocus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fieldColor = Colors.white.withOpacity(0.35);

    return SizedBox(
      width: 38,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          filled: true,
          fillColor: fieldColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 2,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.90),
              width: 1.8,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
