import 'package:dio/dio.dart';

/// Outil de transformation des erreurs réseau.
///
/// Rôle :
/// convertir une DioException en message lisible
/// pour l'utilisateur final.
///
/// Important pour l'équipe :
/// ce fichier évite de gérer les messages d'erreur
/// manuellement dans tous les écrans.
class NetworkExceptions {
  NetworkExceptions._();

  /// Retourne un message utilisateur selon le type d'erreur Dio.
  static String getMessage(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return 'Délai de connexion dépassé';

      case DioExceptionType.sendTimeout:
        return 'Délai d’envoi dépassé';

      case DioExceptionType.receiveTimeout:
        return 'Délai de réception dépassé';

      case DioExceptionType.badResponse:
        return _extractServerMessage(exception);

      case DioExceptionType.cancel:
        return 'Requête annulée';

      case DioExceptionType.connectionError:
        return 'Erreur de connexion réseau';

      case DioExceptionType.unknown:
        return 'Une erreur inconnue est survenue';

      case DioExceptionType.badCertificate:
        return 'Certificat invalide';
    }
  }

  /// Essaie d'extraire le vrai message renvoyé par le backend.
  ///
  /// Si le backend renvoie un JSON du style :
  /// { "message": "Erreur spécifique" }
  /// alors on l'affiche à l'utilisateur.
  static String _extractServerMessage(DioException exception) {
    final data = exception.response?.data;

    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? 'Erreur serveur';
    }

    return 'Erreur serveur';
  }
}
