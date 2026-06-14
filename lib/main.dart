import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:thielal/core/storage/secure_storage_service.dart';
import 'app/app.dart';

/// Point d'entrée principal de l'application.
///
/// Rôle de ce fichier :
/// - Initialiser Flutter
/// - Initialiser Firebase
/// - Réinitialiser le flag d'onboarding (si nécessaire)
/// - Injecter Riverpod
/// - Lancer l'application principale
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint("🔥 Firebase initialisé avec succès");

  // Réinitialisation du flag onboarding
  await SecureStorageService.clearOnboardingFlag();

  runApp(
    const ProviderScope(
      child: ThielalApp(),
    ),
  );
}