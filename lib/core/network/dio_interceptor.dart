import 'package:dio/dio.dart';

import 'token_storage.dart';

/// Interceptor global de Dio.
///
/// Rôle actuel :
/// - récupérer automatiquement l'access token
/// - l'ajouter dans le header Authorization si disponible
///
/// Plus tard on pourra aussi y ajouter :
/// - refresh token automatique
/// - logs personnalisés
/// - gestion plus fine des erreurs 401/403
class AppDioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Lecture du token stocké localement
    final token = await TokenStorage.getAccessToken();

    // Si un token existe, on l'ajoute automatiquement
    // à chaque requête protégée.
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Pour le moment, on laisse juste passer l'erreur.
    // La transformation en message lisible se fait dans
    // NetworkExceptions et dans les controllers.
    return handler.next(err);
  }
}
