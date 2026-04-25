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
    final token = await TokenStorage.getAccessToken();

    print('INTERCEPTOR -> token found: $token');
    print('INTERCEPTOR -> request url: ${options.uri}');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    print('INTERCEPTOR -> headers: ${options.headers}');

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
