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

class SetPasswordScreen extends ConsumerStatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.setPassword)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _passwordController,
                  hintText: l10n.password,
                  labelText: l10n.password,
                  obscureText: _obscure1,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                    icon: Icon(
                      _obscure1 ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmController,
                  hintText: l10n.confirmPassword,
                  labelText: l10n.confirmation,
                  obscureText: _obscure2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.confirmPasswordMessage;
                    }
                    if (value.trim() != _passwordController.text.trim()) {
                      return l10n.passwordsDoNotMatch;
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure2 = !_obscure2),
                    icon: Icon(
                      _obscure2 ? Icons.visibility_off : Icons.visibility,
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
                const SizedBox(height: 20),
                CustomButton(
                  text: l10n.save,
                  isLoading: authState.isLoading,
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    await ref
                        .read(authControllerProvider.notifier)
                        .setPassword(password: _passwordController.text.trim());

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
                              password: _passwordController.text.trim(),
                            );
                      }

                      if (!mounted) return;

                      if (ref.read(authControllerProvider).isAuthenticated) {
                        context.go(RouteNames.home);
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
