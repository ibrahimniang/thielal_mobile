import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/config/api_endpoints.dart';

class ProfileRemoteService {
  final Dio _dio = ApiClient().dio;

  Future<Response> getProfile() async {
    return await _dio.get(ApiEndpoints.me);
  }

  Future<Response> updateProfile({
    required String nom,
    required String prenom,
    String? ville,
    String? quartier,
  }) async {
    return await _dio.put(
      ApiEndpoints.updateMe,
      data: {
        'nom': nom,
        'prenom': prenom,
        'ville': ville,
        'quartier': quartier,
      },
    );
  }

  Future<void> requestEmailChange(String email) async {
    await _dio.post(ApiEndpoints.requestEmailChange, data: {'email': email});
  }

  Future<void> verifyEmailChange({
    required String email,
    required String code,
  }) async {
    await _dio.post(
      ApiEndpoints.verifyEmailChange,
      data: {'email': email, 'code': code},
    );
  }

  Future<void> requestPhoneChange(String phone) async {
    await _dio.post(
      ApiEndpoints.requestPhoneChange,
      data: {'telephone': phone},
    );
  }

  Future<void> verifyPhoneChange({
    required String phone,
    required String code,
  }) async {
    await _dio.post(
      ApiEndpoints.verifyPhoneChange,
      data: {'telephone': phone, 'code': code},
    );
  }

  Future<Response> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    print(_dio.options.headers);
    return await _dio.put(
      '/users/location',
      data: {'latitude': latitude, 'longitude': longitude},
    );
  }
}
