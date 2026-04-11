import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Application principale.
///
/// Ce fichier centralise :
/// - le thème global
/// - le routeur principal
/// - la configuration générale de MaterialApp
///
/// Pourquoi utiliser ConsumerWidget ici ?
/// Parce que le routeur dépend de Riverpod (`WidgetRef`)
/// pour lire l'état d'authentification et appliquer les redirections.
class ThielalApp extends ConsumerWidget {
  const ThielalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On crée l'instance du routeur à partir de l'état global.
    // Cela permet de protéger les routes selon :
    // - utilisateur connecté ou non
    // - rôle user / staff / admin
    final router = AppRouter.router(ref);

    return MaterialApp.router(
      // On retire la bannière DEBUG pour garder une interface plus propre
      // pendant le développement et les démonstrations.
      debugShowCheckedModeBanner: false,

      // Nom affiché par Flutter pour l'application.
      title: 'Thielal / LifeLink',

      // Thème global de l'application.
      theme: AppTheme.lightTheme,

      // Routeur principal basé sur GoRouter.
      routerConfig: router,
    );
  }
}
