import 'package:flutter/material.dart';

import '../app.dart';

class AppBootstrap {
  static Future<void> initialize() async {
    // Initialisations globales futures :
    // - SharedPreferences
    // - SecureStorage
    // - Firebase
    // - Sentry
    // - Remote config
  }
}

class ThielalAppBootstrap extends StatelessWidget {
  const ThielalAppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThielalApp();
  }
}
