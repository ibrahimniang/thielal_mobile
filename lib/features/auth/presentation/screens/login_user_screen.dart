import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../l10n/app_localizations.dart';

import '../../application/auth_controller.dart';
import '../../application/auth_state.dart';

class LoginUserScreen extends ConsumerStatefulWidget {
  const LoginUserScreen({super.key});

  @override
  ConsumerState<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends ConsumerState<LoginUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;

  ProviderSubscription<AuthState>? _authListener;

  @override
  void initState() {
    super.initState();

    _authListener = ref.listenManual<AuthState>(authControllerProvider, (
      previous,
      next,
    ) {
      if (!mounted) return;

      final wasAuthenticated = previous?.isAuthenticated == true;
      final isNowAuthenticated =
          next.isAuthenticated &&
          next.currentUser != null &&
          next.accessToken != null &&
          next.accessToken!.isNotEmpty;

      if (!wasAuthenticated && isNowAuthenticated) {
        final roleId = next.currentUser!.roleId;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          if (roleId == 1) {
            context.go(RouteNames.adminDashboard);
          } else if (roleId == 3) {
            context.go(RouteNames.staffDashboard);
          } else if (roleId == 4) {
            context.go(RouteNames.directorDashboard);
          } else {
            context.go(RouteNames.home);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _authListener?.close();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.red.shade500, Colors.red.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite_rounded,
            color: Colors.white,
            size: 42,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l10n.appName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).brightness ==
                Brightness.dark
            ? Colors.white
            : const Color(0xFF1B1F24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.loginSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
                    color: Theme.of(context).brightness ==
                Brightness.dark
            ? Colors.white70
            : Colors.grey.shade700,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard({
    required BuildContext context,
    required AuthState authState,
    required AuthController auth,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final isDark =
    Theme.of(context).brightness ==
    Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1B1B1B),
                  const Color(0xFF232323),
                  const Color(0xFF2A2A2A),
                ]
              : [
                  Colors.white.withOpacity(0.92),
                  Colors.red.shade50.withOpacity(0.86),
                  Colors.blue.shade50.withOpacity(0.72),
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
                color: Colors.black.withOpacity(0.05),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.red.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.login,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: _identifierController,
                  hintText: l10n.phone,
                  labelText: l10n.identifier,
                  validator:
                      (value) => Validators.requiredField(
                        value,
                        fieldName: l10n.identifier,
                      ),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  hintText: l10n.password,
                  labelText: l10n.password,
                  obscureText: _obscure,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _obscure = !_obscure);
                    },
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),

                if (authState.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
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

                const SizedBox(height: 22),

                CustomButton(
                  text: l10n.login,
                  isLoading: authState.isLoading,
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    print('LOGIN DEBUG -> form valid: $isValid');
                    if (!isValid) return;

                    await auth.login(
                      identifier: _identifierController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                  },
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => context.push(RouteNames.forgotPassword),
                  child: Text(l10n.forgotPassword),
                ),
                const SizedBox(height: 10),

                Wrap(
                  alignment: WrapAlignment.center,

                  crossAxisAlignment: WrapCrossAlignment.center,

                  children: [
                    Text(
                      'Nouveau sur LifeLink ?',

                      style: TextStyle(
                        color: Colors.grey.shade700,

                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        context.go(RouteNames.entryIdentity);
                      },

                      child: const Text(
                        'Continuer avec OTP',

                        style: TextStyle(
                          color: Colors.red,

                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final authState = ref.watch(authControllerProvider);
    final auth = ref.read(authControllerProvider.notifier);

    return Scaffold(
      backgroundColor:
        Theme.of(context).brightness ==
                Brightness.dark
            ? const Color(0xFF121212)
            : const Color(0xFFF7F9FC),
      /*appBar: AppBar(
        title: Text(l10n.login),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),*/
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.red.shade50.withOpacity(0.55),
              Colors.green.shade50.withOpacity(0.30),
              Colors.blue.shade50.withOpacity(0.42),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                /// BOUTON THEME
    Align(
      alignment: Alignment.topRight,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {
            // toggle theme
          },
          icon: const Icon(
            Icons.dark_mode_rounded,
          ),
        ),
      ),
    ),

                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 28),
                _buildFormCard(
                  context: context,
                  authState: authState,
                  auth: auth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
