// lib/core/storage/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service centralisé pour le stockage sécurisé.
///
/// Rôle :
/// - fournir une seule instance de FlutterSecureStorage
/// - centraliser quelques helpers simples pour le projet
///
/// Important pour l'équipe :
/// on passe toujours par ce service, au lieu de créer
/// plusieurs instances de FlutterSecureStorage dans plusieurs fichiers.
class SecureStorageService {
  SecureStorageService._();

  /// Instance unique utilisée dans tout le projet.
  static const FlutterSecureStorage instance = FlutterSecureStorage();

  // ==========================
  // CLÉS LOCALES
  // ==========================
  static const String hasCompletedEntryFlowKey = 'has_completed_entry_flow';

  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
  // ==========================
  // HELPERS FLOW D'ENTRÉE
  // ==========================

  /// Indique si l'utilisateur a déjà terminé le premier flow
  /// d'entrée / inscription sur cet appareil.

  static Future<bool> hasCompletedEntryFlow() async {
    final value = await instance.read(key: hasCompletedEntryFlowKey);
    return value == 'true';
  }

  static Future<void> setHasCompletedEntryFlow(bool value) async {
    await instance.write(
      key: hasCompletedEntryFlowKey,
      value: value.toString(),
    );
  }

  /// Supprime uniquement ce flag si besoin de reset onboarding/auth local.
  static Future<void> clearEntryFlowFlag() async {
    await instance.delete(key: hasCompletedEntryFlowKey);
  }

  // ==========================
 // ONBOARDING
 // ==========================

  static Future<bool> hasSeenOnboarding() async {
    final value = await instance.read(
      key: hasSeenOnboardingKey,
    );

    return value == 'true';
  }

  static Future<void> setHasSeenOnboarding(
    bool value,
  ) async {
    await instance.write(
      key: hasSeenOnboardingKey,
      value: value.toString(),
    );
  }

  static Future<void> clearOnboardingFlag() async {
    await instance.delete(
      key: hasSeenOnboardingKey,
    );
  }
}
