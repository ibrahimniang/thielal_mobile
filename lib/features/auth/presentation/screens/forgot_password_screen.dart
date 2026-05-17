import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../application/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _telephoneController = TextEditingController();
  final _codeController = TextEditingController();

  bool _codeSent = false;

  @override
  void dispose() {
    _telephoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String? _validateTelephone(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.enterPhoneNumber;
    }

    if (value.trim().length < 8) {
      return l10n.invalidPhoneNumber;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotPassword)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _telephoneController,
                  hintText: l10n.phone,
                  labelText: l10n.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validateTelephone,
                ),
                if (_codeSent) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _codeController,
                    hintText: l10n.receivedCode,
                    labelText: l10n.otpCode,
                    validator: Validators.otp,
                  ),
                ],
                if (authState.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    authState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 20),
                CustomButton(
                  text: _codeSent ? l10n.verifyCode : l10n.sendCode,
                  isLoading: authState.isLoading,
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final authCtrl = ref.read(authControllerProvider.notifier);

                    if (!_codeSent) {
                      await authCtrl.forgotPasswordSendCode(
                        telephone: _telephoneController.text.trim(),
                      );

                      if (!mounted) return;

                      if (ref.read(authControllerProvider).errorMessage ==
                          null) {
                        setState(() => _codeSent = true);
                      }
                    } else {
                      await authCtrl.forgotPasswordVerifyCode(
                        telephone: _telephoneController.text.trim(),
                        code: _codeController.text.trim(),
                      );

                      if (!mounted) return;

                      if (ref.read(authControllerProvider).errorMessage ==
                          null) {
                        context.push(
                          RouteNames.resetPassword,
                          extra: {
                            'telephone': _telephoneController.text.trim(),
                          },
                        );
                      }
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
