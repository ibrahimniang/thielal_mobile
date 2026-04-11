import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../application/auth_controller.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? email;
  final String? code;

  const ResetPasswordScreen({super.key, this.email, this.code});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
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
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Réinitialiser le mot de passe')),
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
                  hintText: 'Nouveau mot de passe',
                  labelText: 'Nouveau mot de passe',
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
                  hintText: 'Confirmer le mot de passe',
                  labelText: 'Confirmation',
                  obscureText: _obscure2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer le mot de passe';
                    }
                    if (value.trim() != _passwordController.text.trim()) {
                      return 'Les mots de passe ne correspondent pas';
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
                  text: 'Mettre à jour',
                  isLoading: authState.isLoading,
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    if (widget.email == null || widget.code == null) return;

                    await ref
                        .read(authControllerProvider.notifier)
                        .forgotPasswordResetPassword(
                          email: widget.email!,
                          code: widget.code!,
                          newPassword: _passwordController.text.trim(),
                        );
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
