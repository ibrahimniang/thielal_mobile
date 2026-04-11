import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../application/auth_controller.dart';

class LoginOfficeScreen extends ConsumerStatefulWidget {
  const LoginOfficeScreen({super.key});

  @override
  ConsumerState<LoginOfficeScreen> createState() => _LoginOfficeScreenState();
}

class _LoginOfficeScreenState extends ConsumerState<LoginOfficeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isAuthenticated) {
        final role = next.currentUser?.role?.toLowerCase();

        if (role == 'admin') {
          context.go(RouteNames.adminDashboard);
        } else {
          context.go(RouteNames.staffDashboard);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion back-office')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _identifierController,
                  hintText: 'Email ou téléphone',
                  labelText: 'Identifiant',
                  validator:
                      (value) => Validators.requiredField(
                        value,
                        fieldName: 'L’identifiant',
                      ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Mot de passe',
                  labelText: 'Mot de passe',
                  obscureText: _obscure,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
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
                  text: 'Se connecter',
                  isLoading: authState.isLoading,
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    await ref
                        .read(authControllerProvider.notifier)
                        .loginOffice(
                          identifier: _identifierController.text.trim(),
                          password: _passwordController.text.trim(),
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
