import '../models/profile_model.dart';
import '../services/profile_remote_service.dart';

class ProfileRepository {
  final ProfileRemoteService _service;

  ProfileRepository(this._service);

  // ==========================
  // GET PROFILE
  // ==========================
  Future<ProfileModel> getProfile() async {
    final res = await _service.getProfile();

    final data = _extractPayload(res.data);
    return ProfileModel.fromJson(data);
  }

  // ==========================
  // UPDATE PROFILE
  // ==========================
  Future<void> updateProfile({
    required String nom,
    required String prenom,
    String? ville,
    String? quartier,
  }) async {
    await _service.updateProfile(
      nom: nom,
      prenom: prenom,
      ville: ville,
      quartier: quartier,
    );
  }

  // ==========================
  // UPDATE LOCATION
  // ==========================
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    await _service.updateLocation(latitude: latitude, longitude: longitude);
  }

  // ==========================
  // EMAIL CHANGE
  // ==========================
  Future<void> requestEmailChange(String email) async {
    await _service.requestEmailChange(email);
  }

  Future<void> verifyEmailChange(String email, String code) async {
    await _service.verifyEmailChange(email: email, code: code);
  }

  // ==========================
  // PHONE CHANGE
  // ==========================
  Future<void> requestPhoneChange(String phone) async {
    await _service.requestPhoneChange(phone);
  }

  Future<void> verifyPhoneChange(String phone, String code) async {
    await _service.verifyPhoneChange(phone: phone, code: code);
  }

  // ==========================
  // HELPERS
  // ==========================
  Map<String, dynamic> _extractPayload(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final nested = responseData['data'];

      if (nested is Map<String, dynamic>) {
        return nested;
      }

      return responseData;
    }

    return <String, dynamic>{};
  }
}
