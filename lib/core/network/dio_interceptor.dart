import 'package:dio/dio.dart';

import 'token_storage.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

import '../../app/router/app_router.dart';
// import '../../app/router/route_names.dart';
import '../providers/app_container.dart';
import '../services/session_logout_service.dart';

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
  static bool _handling401 = false;
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
    print('DIO ERROR => ${err.response?.statusCode}');
    if (err.response?.statusCode == 401) {
      if (!_handling401) {
        _handling401 = true;

        final context = rootNavigatorKey.currentContext;

        if (context != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              final l10n = AppLocalizations.of(context)!;
              return AlertDialog(
                title: Text(l10n.sessionExpired),
                content: Text(l10n.sessionExpiredMessage),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();

                      await SessionLogoutService.logout(appContainer);

                      _handling401 = false;
                    },
                    child: Text(l10n.ok),
                  ),
                ],
              );
            },
          );
        }
      }
    }
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      final context = rootNavigatorKey.currentContext;

      if (context != null) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            final l10n = AppLocalizations.of(context)!;
            return AlertDialog(
              title: Text(l10n.noInternetConnection),
              content: Text(l10n.checkInternetAndRetry),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.ok),
                ),
              ],
            );
          },
        );
      }

      return;
    }

    return;
  }
}
