import 'package:dio/dio.dart';

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_client.dart';

class ProfileRemoteService {
  final Dio _dio = ApiClient().dio;

  // ==========================
  // GET PROFILE
  // ==========================
  Future<Response<dynamic>> getProfile() {
    return _dio.get(ApiEndpoints.me);
  }

  // ==========================
  // UPDATE PROFILE
  // ==========================
  Future<Response<dynamic>> updateProfile({
    required String nom,
    required String prenom,
    String? ville,
    String? quartier,
  }) {
    return _dio.put(
      ApiEndpoints.updateMe,
      data: {
        'nom': nom,
        'prenom': prenom,
        'ville': ville,
        'quartier': quartier,
      },
    );
  }

  // ==========================
  // EMAIL CHANGE
  // ==========================
  Future<Response<dynamic>> requestEmailChange(String email) {
    return _dio.post(ApiEndpoints.requestEmailChange, data: {'email': email});
  }

  Future<Response<dynamic>> verifyEmailChange({
    required String email,
    required String code,
  }) {
    return _dio.post(
      ApiEndpoints.verifyEmailChange,
      data: {'email': email, 'code': code},
    );
  }

  // ==========================
  // PHONE CHANGE
  // ==========================
  Future<Response<dynamic>> requestPhoneChange(String phone) {
    return _dio.post(
      ApiEndpoints.requestPhoneChange,
      data: {'telephone': phone},
    );
  }

  // ==========================
// UPDATE LANGUAGE
// ==========================
Future<Response<dynamic>> updateLanguage(
  String langue,
) {
  return _dio.put(
    ApiEndpoints.updateMe,
    data: {
      'langue': langue,
    },
  );
}

  Future<Response<dynamic>> verifyPhoneChange({
    required String phone,
    required String code,
  }) {
    return _dio.post(
      ApiEndpoints.verifyPhoneChange,
      data: {'telephone': phone, 'code': code},
    );
  }

  // ==========================
  // UPDATE LOCATION
  // ==========================
  Future<Response<dynamic>> updateLocation({
    required double latitude,
    required double longitude,
  }) {
    // ✅ Idéalement, ajoute cette route dans ApiEndpoints :
    // static const String updateLocation = '/users/location';
    return _dio.put(
      '/users/location',
      data: {'latitude': latitude, 'longitude': longitude},
    );
  }
}
