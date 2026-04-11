/// Modèle des tokens d'authentification.
///
/// Ce modèle représente les tokens renvoyés par le backend
/// après une connexion réussie.
///
/// Important pour l'équipe :
/// selon l'API, les clés peuvent varier
/// (`accessToken`, `access_token`, `token`, etc.).
/// Ce modèle gère déjà plusieurs cas possibles.
class AuthTokensModel {
  final String accessToken;
  final String refreshToken;

  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
  });

  /// Conversion JSON backend -> modèle Flutter.
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken:
          json['accessToken']?.toString() ??
          json['access_token']?.toString() ??
          json['token']?.toString() ??
          '',
      refreshToken:
          json['refreshToken']?.toString() ??
          json['refresh_token']?.toString() ??
          '',
    );
  }
}
