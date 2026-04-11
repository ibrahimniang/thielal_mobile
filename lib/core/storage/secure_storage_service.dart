import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service centralisé pour le stockage sécurisé.
///
/// Rôle :
/// fournir une seule instance de FlutterSecureStorage
/// à toute l'application.
///
/// Important pour l'équipe :
/// on passe toujours par ce service, au lieu de créer
/// plusieurs instances de FlutterSecureStorage dans plusieurs fichiers.
class SecureStorageService {
  SecureStorageService._();

  /// Instance unique utilisée dans tout le projet.
  static const FlutterSecureStorage instance = FlutterSecureStorage();
}
