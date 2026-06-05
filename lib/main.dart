import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'app/app.dart';

/// Point d'entrée principal de l'application.
///
/// Rôle de ce fichier :
/// - démarrer Flutter
/// - injecter Riverpod avec ProviderScope
/// - lancer l'application principale
///
/// Important :
/// On garde ce fichier très léger pour éviter de mélanger
/// la logique de démarrage avec la logique UI de l'application.
void main() {
  runApp(const ProviderScope(child: ThielalApp()));
}
