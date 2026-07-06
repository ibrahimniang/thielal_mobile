import 'package:dio/dio.dart';

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_client.dart';

class AuthRemoteService {
  final Dio _dio = ApiClient().dio;

  // ==========================
  // OTP
  // ==========================

  Future<Response<dynamic>> sendOtp({String? phone, String? email}) async {
    return _dio.post(
      ApiEndpoints.sendOtp,
      data: {'telephone': phone, 'email': email},
    );
  }

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

  Future<Response<dynamic>> registerStep1({
    required int userId, // 🔥 AJOUT
    required String nom,
    required String prenom,
    String? genre,
    String? dateNaissance,
    String? phone,
    String? langue,
    String? email,
  }) async {
    return _dio.post(
      ApiEndpoints.registerStep1,
      data: {
        'user_id': userId, // 🔥 IMPORTANT
        'nom': nom,
        'prenom': prenom,
        'genre': genre,
        'date_naissance': dateNaissance,
        'langue': langue,
      },
    );
  }

  // ==========================
  // INSCRIPTION - STEP 2
  // ==========================

  Future<Response<dynamic>> registerStep2({
    required int userId, // 🔥 AJOUT
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
        'user_id': userId, // 🔥 IMPORTANT
        'telephone': phone, // 🔥 téléphone OTP
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

  Future<Response<dynamic>> registerStep3({
    required int userId, // 🔥 AJOUT
    String? phone,
    String? email,
    String? groupeSanguin,
    required bool accepteConditions,
    required bool acceptePolitiqueConfidentialite,
    required bool aDonneRecemment, // 🔥 AJOUT
  }) async {
    return _dio.post(
      ApiEndpoints.registerStep3,
      data: {
        'user_id': userId, // 🔥 IMPORTANT
        'groupe_sanguin': groupeSanguin,
        'accepte_conditions': accepteConditions,
        'accepte_politique_confidentialite': acceptePolitiqueConfidentialite,
        'a_donne_recemment': aDonneRecemment, // 🔥 IMPORTANT
      },
    );
  }

  // ==========================
  // MOT DE PASSE INITIAL
  // ==========================

  Future<Response<dynamic>> setPassword({
    required int userId, // 🔥 AJOUT
    String? phone,
    String? email,
    required String password,
  }) async {
    return _dio.post(
      ApiEndpoints.setPassword,
      data: {
        'user_id': userId, // 🔥 IMPORTANT
        'password': password, // 🔥 FIX
      },
    );
  }

  // ==========================
  // LOGIN
  // ==========================

  bool _isEmail(String value) {
    return value.contains('@');
  }

  Future<Response<dynamic>> loginUser({
  required String identifier,
  required String password,
  double? latitude,
  double? longitude,
}) async {
  return _dio.post(
    ApiEndpoints.loginUser,
    data: _isEmail(identifier)
        ? {
            'email': identifier,
            'password': password,
            'latitude': latitude,
            'longitude': longitude,
          }
        : {
            'telephone': identifier,
            'password': password,
            'latitude': latitude,
            'longitude': longitude,
          },
  );
}
  Future<Response<dynamic>> loginOffice({
    required String identifier,
    required String password,
  }) async {
    return _dio.post(
      ApiEndpoints.loginOffice,
      data: {'email': identifier, 'password': password},
    );
  }

  // ==========================
  // FORGOT PASSWORD
  // ==========================

  Future<Response<dynamic>> forgotPasswordSendCode({
    required String telephone, // 🔥 FIX
  }) async {
    return _dio.post(
      ApiEndpoints.forgotPasswordSendCode,
      data: {'telephone': telephone},
    );
  }

  Future<Response<dynamic>> forgotPasswordVerifyCode({
    required String telephone, // 🔥 FIX
    required String code,
  }) async {
    return _dio.post(
      ApiEndpoints.forgotPasswordVerifyCode,
      data: {'telephone': telephone, 'code': code},
    );
  }

  Future<Response<dynamic>> forgotPasswordResetPassword({
    required String telephone, // 🔥 FIX
    required String password,
  }) async {
    return _dio.post(
      ApiEndpoints.forgotPasswordResetPassword,
      data: {'telephone': telephone, 'password': password},
    );
  }

  // ==========================
  // PROFIL CONNECTÉ
  // ==========================

  Future<Response<dynamic>> getMe() async {
    return _dio.get(ApiEndpoints.me);
  }
}
