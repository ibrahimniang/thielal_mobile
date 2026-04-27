import '../config/constants.dart';
import '../storage/secure_storage_service.dart';

/// Gestion centralisée des tokens.
///
/// Rôle :
/// - sauvegarder access token
/// - sauvegarder refresh token
/// - lire les tokens
/// - supprimer les tokens à la déconnexion
///
/// Important pour l'équipe :
/// on ne manipule pas directement les clés de storage dans les écrans.
/// Toute lecture/écriture de token passe ici.
class TokenStorage {
  TokenStorage._();

  /// Sauvegarde de l'access token.
  static Future<void> saveAccessToken(String token) async {
    if (token.trim().isEmpty) {
      print('TOKEN STORAGE -> access token vide, non sauvegardé');
      return;
    }

    print('TOKEN STORAGE -> saving access token: $token');
    await SecureStorageService.instance.write(
      key: AppConstants.accessTokenKey,
      value: token,
    );
  }

  /// Sauvegarde du refresh token.
  static Future<void> saveRefreshToken(String token) async {
    if (token.trim().isEmpty) {
      print('TOKEN STORAGE -> refresh token vide, non sauvegardé');
      return;
    }

    await SecureStorageService.instance.write(
      key: AppConstants.refreshTokenKey,
      value: token,
    );
  }

  /// Lecture de l'access token sauvegardé.
  static Future<String?> getAccessToken() async {
    final token = await SecureStorageService.instance.read(
      key: AppConstants.accessTokenKey,
    );
    print('TOKEN STORAGE -> read access token: $token');
    return token;
  }

  /// Lecture du refresh token sauvegardé.
  static Future<String?> getRefreshToken() async {
    return SecureStorageService.instance.read(
      key: AppConstants.refreshTokenKey,
    );
  }

  /// Suppression complète des tokens.
  ///
  /// Utilisé à la déconnexion ou quand une session devient invalide.
  static Future<void> clearTokens() async {
    await SecureStorageService.instance.delete(
      key: AppConstants.accessTokenKey,
    );

    await SecureStorageService.instance.delete(
      key: AppConstants.refreshTokenKey,
    );
  }
}
