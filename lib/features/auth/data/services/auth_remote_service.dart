import 'package:dio/dio.dart';

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_client.dart';

/// Service distant auth.
///
/// Rôle :
/// - appeler directement les endpoints backend liés à l'authentification
/// - ne contient PAS de logique UI
/// - ne contient PAS de logique d'état
///
/// Important pour l'équipe :
/// ce fichier ne doit faire qu'une chose :
/// parler à l'API backend.
///
/// Toute transformation de réponse ou logique métier plus avancée
/// doit rester dans le repository.
class AuthRemoteService {
  /// Instance Dio centralisée de l'application.
  final Dio _dio = ApiClient().dio;

  // ==========================
  // OTP
  // ==========================

  /// Envoi d'un code OTP à un téléphone ou un email.
  Future<Response<dynamic>> sendOtp({String? phone, String? email}) async {
    return _dio.post(
      ApiEndpoints.sendOtp,
      data: {'telephone': phone, 'email': email},
    );
  }

  /// Vérification du code OTP envoyé à l'utilisateur.
  Future<Response<dynamic>> verifyOtp({
    String? phone,
    String? email,
    required String code,
  }) async {
    return _dio.post(
      ApiEndpoints.verifyOtp,
      data: {'telephone': phone, 'email': email, 'code': code},
    );
  }

  // ==========================
  // INSCRIPTION - STEP 1
  // ==========================

  /// Étape 1 de l'inscription :
  /// identité de base.
  Future<Response<dynamic>> registerStep1({
    required String nom,
    required String prenom,
    String? genre,
    String? dateNaissance,
    String? phone,
    String? email,
  }) async {
    return _dio.post(
      ApiEndpoints.registerStep1,
      data: {
        'nom': nom,
        'prenom': prenom,
        'genre': genre,
        'date_naissance': dateNaissance,
        'telephone': phone,
        'email': email,
      },
    );
  }

  // ==========================
  // INSCRIPTION - STEP 2
  // ==========================

  /// Étape 2 de l'inscription :
  /// localisation et coordonnées.
  Future<Response<dynamic>> registerStep2({
    String? phone,
    String? email,
    String? ville,
    String? quartier,
    double? latitude,
    double? longitude,
  }) async {
    return _dio.post(
      ApiEndpoints.registerStep2,
      data: {
        'telephone': phone,
        'email': email,
        'ville': ville,
        'quartier': quartier,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }

  // ==========================
  // INSCRIPTION - STEP 3
  // ==========================

  /// Étape 3 de l'inscription :
  /// données médicales + consentements.
  Future<Response<dynamic>> registerStep3({
    String? phone,
    String? email,
    String? groupeSanguin,
    required bool accepteConditions,
    required bool acceptePolitiqueConfidentialite,
  }) async {
    return _dio.post(
      ApiEndpoints.registerStep3,
      data: {
        'telephone': phone,
        'email': email,
        'groupe_sanguin': groupeSanguin,
        'accepte_conditions': accepteConditions,
        'accepte_politique_confidentialite': acceptePolitiqueConfidentialite,
      },
    );
  }

  // ==========================
  // MOT DE PASSE INITIAL
  // ==========================

  /// Définition du mot de passe après inscription.
  Future<Response<dynamic>> setPassword({
    String? phone,
    String? email,
    required String password,
  }) async {
    return _dio.post(
      ApiEndpoints.setPassword,
      data: {'telephone': phone, 'email': email, 'mot_de_passe': password},
    );
  }

  // ==========================
  // LOGIN
  // ==========================

  /// Connexion utilisateur mobile.
  Future<Response<dynamic>> loginUser({
    required String identifier,
    required String password,
  }) async {
    return _dio.post(
      ApiEndpoints.loginUser,
      data: {'identifier': identifier, 'mot_de_passe': password},
    );
  }

  /// Connexion back-office :
  /// admin / staff / directeur.
  Future<Response<dynamic>> loginOffice({
    required String identifier,
    required String password,
  }) async {
    return _dio.post(
      ApiEndpoints.loginOffice,
      data: {'identifier': identifier, 'mot_de_passe': password},
    );
  }

  // ==========================
  // FORGOT PASSWORD
  // ==========================

  /// Envoi du code de réinitialisation mot de passe.
  Future<Response<dynamic>> forgotPasswordSendCode({
    required String email,
  }) async {
    return _dio.post(
      ApiEndpoints.forgotPasswordSendCode,
      data: {'email': email},
    );
  }

  /// Vérifie le code OTP de reset password.
  Future<Response<dynamic>> forgotPasswordVerifyCode({
    required String email,
    required String code,
  }) async {
    return _dio.post(
      ApiEndpoints.forgotPasswordVerifyCode,
      data: {'email': email, 'code': code},
    );
  }

  /// Met à jour le mot de passe oublié.
  Future<Response<dynamic>> forgotPasswordResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    return _dio.post(
      ApiEndpoints.forgotPasswordResetPassword,
      data: {'email': email, 'code': code, 'new_password': newPassword},
    );
  }

  // ==========================
  // PROFIL CONNECTÉ
  // ==========================

  /// Récupère l'utilisateur connecté à partir du token courant.
  Future<Response<dynamic>> getMe() async {
    return _dio.get(ApiEndpoints.me);
  }
}
