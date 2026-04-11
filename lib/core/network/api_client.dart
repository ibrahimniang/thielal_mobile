import 'package:dio/dio.dart';

import '../config/constants.dart';
import '../config/env.dart';
import 'dio_interceptor.dart';

/// Client HTTP centralisé de l'application.
///
/// Rôle :
/// - créer une seule instance Dio partagée
/// - appliquer la base URL du backend
/// - appliquer les timeouts
/// - injecter les headers par défaut
/// - ajouter les interceptors globaux
///
/// Important pour l'équipe :
/// tous les services API doivent passer par ce client.
/// On évite de créer plusieurs instances Dio à la main.
class ApiClient {
  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        // URL de base du backend Render / API principale
        baseUrl: Env.baseUrl,

        // Timeouts globaux
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,

        // Headers par défaut
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor personnalisé :
    // typiquement pour injecter automatiquement le token Bearer
    // dans les requêtes protégées.
    dio.interceptors.add(AppDioInterceptor());

    // LogInterceptor utile en développement pour voir :
    // - les requêtes envoyées
    // - les réponses reçues
    //
    // À désactiver plus tard en production si nécessaire.
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  /// Singleton : une seule instance partagée dans toute l'application.
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  /// Instance Dio exposée aux remote services.
  late final Dio dio;
}
