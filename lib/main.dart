import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:thielal/core/storage/secure_storage_service.dart';
import 'package:thielal/core/services/local_notification_service.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==========================
  // FIREBASE
  // ==========================
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint(
    "🔥 Firebase initialisé avec succès",
  );

  // ==========================
  // LOCAL NOTIFICATIONS
  // ==========================
  await LocalNotificationService
      .instance
      .initialize();

  debugPrint(
    "🔔 Local notifications initialisées",
  );

  // ==========================
  // ONBOARDING (OPTIONNEL)
  // ==========================
  // await SecureStorageService.clearOnboardingFlag();

  runApp(
    const ProviderScope(
      child: ThielalApp(),
    ),
  );
}