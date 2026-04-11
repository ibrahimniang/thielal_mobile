import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../auth/application/auth_controller.dart';

/// SplashScreen de démarrage.
///
/// Rôle :
/// - afficher le logo / écran de démarrage
/// - charger la session utilisateur
/// - rediriger automatiquement vers le bon écran
///
/// Logique actuelle :
/// - si un utilisateur est déjà connecté -> Home
/// - sinon -> EntryIdentity
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Petit délai pour laisser le splash visible
    await Future.delayed(const Duration(seconds: 2));

    // On tente de recharger la session utilisateur
    await ref.read(authControllerProvider.notifier).loadCurrentUser();

    if (!mounted) return;

    final authState = ref.read(authControllerProvider);

    if (authState.isAuthenticated) {
      context.go(RouteNames.home);
    } else {
      context.go(RouteNames.entryIdentity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO Dev2: remplacer par le vrai logo/image
            const Icon(Icons.favorite, size: 90, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              'Thielal / LifeLink',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
