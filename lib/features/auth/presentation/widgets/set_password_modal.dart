import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_controller.dart';

class SetPasswordModal extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;

  const SetPasswordModal({
    super.key,
    this.onSuccess,
  });

  @override
  ConsumerState<SetPasswordModal>
  createState() =>
      _SetPasswordModalState();
}

class _SetPasswordModalState
    extends ConsumerState<
      SetPasswordModal
    > {
  final _passwordController =
      TextEditingController();

  final _confirmController =
      TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    final password =
        _passwordController.text.trim();

    final confirm =
        _confirmController.text.trim();

    if (password.length < 6) {
      _show(
        'Le mot de passe doit contenir au moins 6 caractères.',
      );
      return;
    }

    if (password != confirm) {
      _show(
        'Les mots de passe ne correspondent pas.',
      );
      return;
    }

    try {
      await ref
          .read(
            authControllerProvider
                .notifier,
          )
          .setPassword(
            password: password,
          );
          /// ======================================
/// AUTO LOGIN AFTER PASSWORD CREATION
/// ======================================

final authState =
    ref.read(
      authControllerProvider,
    );

final phone =
    authState.pendingPhone;

final email =
    authState.pendingEmail;

/// priorité téléphone
final identifier =
    phone != null &&
            phone.isNotEmpty
        ? phone
        : (email ?? '');

/// LOGIN
await ref
    .read(
      authControllerProvider
          .notifier,
    )
    .login(
      identifier: identifier,

      password: password,
    );

/// LOAD CURRENT USER
await ref
    .read(
      authControllerProvider
          .notifier,
    )
    .loadCurrentUser();

      if (!mounted) return;

      Navigator.pop(context);

      widget.onSuccess?.call();
    } catch (_) {}
  }

  void _show(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        ref.watch(
          authControllerProvider,
        );

    return PopScope(
      canPop: false,

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),

        child: Dialog(
          backgroundColor:
              Colors.transparent,

          insetPadding:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),

          child: Container(
            padding:
                const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                    34,
                  ),
            ),

            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                /// ICON
                Container(
                  height: 82,
                  width: 82,

                  decoration: BoxDecoration(
                    color:
                        Colors.red.withOpacity(
                          0.10,
                        ),

                    borderRadius:
                        BorderRadius.circular(
                          28,
                        ),
                  ),

                  child: const Icon(
                    Icons.lock_rounded,

                    color: Colors.red,

                    size: 42,
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                /// TITLE
                const Text(
                  'Sécurisez votre compte',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    fontSize: 24,

                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  'Créez maintenant votre mot de passe pour sécuriser votre compte LifeLink.',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    color:
                        Colors.grey.shade700,

                    height: 1.4,
                  ),
                ),

                const SizedBox(
                  height: 28,
                ),

                /// PASSWORD
                TextField(
                  controller:
                      _passwordController,

                  obscureText:
                      obscure1,

                  decoration:
                      InputDecoration(
                        hintText:
                            'Mot de passe',

                        prefixIcon:
                            const Icon(
                              Icons
                                  .lock_outline_rounded,
                            ),

                        suffixIcon:
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  obscure1 =
                                      !obscure1;
                                });
                              },

                              icon: Icon(
                                obscure1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),

                        filled: true,

                        fillColor:
                            Colors.grey.shade100,

                        border:
                            OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),

                              borderSide:
                                  BorderSide.none,
                            ),
                      ),
                ),

                const SizedBox(
                  height: 16,
                ),

                /// CONFIRM
                TextField(
                  controller:
                      _confirmController,

                  obscureText:
                      obscure2,

                  decoration:
                      InputDecoration(
                        hintText:
                            'Confirmer mot de passe',

                        prefixIcon:
                            const Icon(
                              Icons
                                  .shield_outlined,
                            ),

                        suffixIcon:
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  obscure2 =
                                      !obscure2;
                                });
                              },

                              icon: Icon(
                                obscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),

                        filled: true,

                        fillColor:
                            Colors.grey.shade100,

                        border:
                            OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),

                              borderSide:
                                  BorderSide.none,
                            ),
                      ),
                ),

                const SizedBox(
                  height: 26,
                ),

                /// BUTTON
                SizedBox(
                  width: double.infinity,

                  height: 56,

                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,

                          shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      20,
                                    ),
                              ),
                        ),

                    onPressed:
                        auth.isLoading
                            ? null
                            : _submit,

                    child:
                        auth.isLoading
                            ? const SizedBox(
                              height: 22,
                              width: 22,

                              child:
                                  CircularProgressIndicator(
                                    color:
                                        Colors
                                            .white,

                                    strokeWidth:
                                        2,
                                  ),
                            )
                            : const Text(
                              'Créer mon mot de passe',

                              style: TextStyle(
                                color:
                                    Colors.white,

                                fontSize: 16,

                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}