/// Constantes globales de l'application.
///
/// On centralise ici :
/// - les timeouts réseau
/// - les clés de stockage local
///
/// Important pour l'équipe :
/// toute nouvelle clé globale doit être définie ici.
class AppConstants {
  AppConstants._();

  // ==========================
  // TIMEOUTS RESEAU
  // ==========================

  /// Temps maximum pour établir la connexion HTTP
  static const Duration connectTimeout = Duration(seconds: 20);

  /// Temps maximum pour recevoir une réponse HTTP
  static const Duration receiveTimeout = Duration(seconds: 20);

  // ==========================
  // CLES DE STOCKAGE LOCAL
  // ==========================

  /// Clé de stockage de l'access token
  static const String accessTokenKey = 'access_token';

  /// Clé de stockage du refresh token
  static const String refreshTokenKey = 'refresh_token';

  /// Clé éventuelle pour sauvegarder les données utilisateur
  static const String userKey = 'user_data';

  /// Clé éventuelle pour la langue choisie dans l'application
  static const String localeKey = 'app_locale';
}
