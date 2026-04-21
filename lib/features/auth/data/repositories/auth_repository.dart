import '../../../../core/network/token_storage.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';
import '../services/auth_remote_service.dart';

class AuthRepository {
  final AuthRemoteService _remoteService;

  AuthRepository({AuthRemoteService? remoteService})
    : _remoteService = remoteService ?? AuthRemoteService();

  // ==========================
  // OTP
  // ==========================

  Future<void> sendOtp({String? phone, String? email}) async {
    await _remoteService.sendOtp(phone: phone, email: email);
  }

  /// 🔥 CORRECTION : retourne data pour récupérer user_id
  Future<Map<String, dynamic>> verifyOtp({
    String? phone,
    String? email,
    required String code,
  }) async {
    final response = await _remoteService.verifyOtp(
      phone: phone,
      email: email,
      code: code,
    );

    return _extractPayload(response.data);
  }

  // ==========================
  // INSCRIPTION
  // ==========================

  Future<void> registerStep1({
    required int userId, // 🔥 AJOUT
    required String nom,
    required String prenom,
    String? genre,
    String? dateNaissance,
    String? phone,
    String? email,
  }) async {
    await _remoteService.registerStep1(
      userId: userId, // 🔥 IMPORTANT
      nom: nom,
      prenom: prenom,
      genre: genre,
      dateNaissance: dateNaissance,
      phone: phone,
      email: email,
    );
  }

  Future<void> registerStep2({
    required int userId, // 🔥 AJOUT
    String? phone,
    String? email,
    String? ville,
    String? quartier,
    double? latitude,
    double? longitude,
  }) async {
    await _remoteService.registerStep2(
      userId: userId, // 🔥 IMPORTANT
      phone: phone,
      email: email,
      ville: ville,
      quartier: quartier,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<void> registerStep3({
    required int userId, // 🔥 AJOUT
    String? phone,
    String? email,
    String? groupeSanguin,
    required bool accepteConditions,
    required bool acceptePolitiqueConfidentialite,
    required bool aDonneRecemment, // 🔥 AJOUT
  }) async {
    await _remoteService.registerStep3(
      userId: userId, // 🔥 IMPORTANT
      phone: phone,
      email: email,
      groupeSanguin: groupeSanguin,
      accepteConditions: accepteConditions,
      acceptePolitiqueConfidentialite: acceptePolitiqueConfidentialite,
      aDonneRecemment: aDonneRecemment, // 🔥 IMPORTANT
    );
  }

  Future<void> setPassword({
    required int userId, // 🔥 AJOUT
    String? phone,
    String? email,
    required String password,
  }) async {
    await _remoteService.setPassword(
      userId: userId, // 🔥 IMPORTANT
      phone: phone,
      email: email,
      password: password,
    );
  }

  // ==========================
  // LOGIN USER (INCHANGÉ)
  // ==========================

  Future<(UserModel user, AuthTokensModel tokens)> loginUser({
    required String identifier,
    required String password,
  }) async {
    final response = await _remoteService.loginUser(
      identifier: identifier,
      password: password,
    );

    final data = _extractPayload(response.data);
    final user = _extractUser(data);
    final tokens = _extractTokens(data);

    await TokenStorage.saveAccessToken(tokens.accessToken);
    await TokenStorage.saveRefreshToken(tokens.refreshToken);

    return (user, tokens);
  }

  // ==========================
  // LOGIN OFFICE (INCHANGÉ)
  // ==========================

  Future<(UserModel user, AuthTokensModel tokens)> loginOffice({
    required String identifier,
    required String password,
  }) async {
    final response = await _remoteService.loginOffice(
      identifier: identifier,
      password: password,
    );

    final data = _extractPayload(response.data);
    final user = _extractUser(data);
    final tokens = _extractTokens(data);

    await TokenStorage.saveAccessToken(tokens.accessToken);
    await TokenStorage.saveRefreshToken(tokens.refreshToken);

    return (user, tokens);
  }

  // ==========================
  // FORGOT PASSWORD (FIX TELEPHONE)
  // ==========================

  Future<void> forgotPasswordSendCode({required String telephone}) async {
    await _remoteService.forgotPasswordSendCode(telephone: telephone);
  }

  Future<void> forgotPasswordVerifyCode({
    required String telephone,
    required String code,
  }) async {
    await _remoteService.forgotPasswordVerifyCode(
      telephone: telephone,
      code: code,
    );
  }

  Future<void> forgotPasswordResetPassword({
    required String telephone,
    required String password,
  }) async {
    await _remoteService.forgotPasswordResetPassword(
      telephone: telephone,
      password: password,
    );
  }

  // ==========================
  // RESTE INTACT
  // ==========================

  Future<UserModel> getCurrentUser() async {
    final response = await _remoteService.getMe();
    final data = _extractPayload(response.data);
    return _extractUser(data);
  }

  Future<void> logout() async {
    await TokenStorage.clearTokens();
  }

  Future<String?> getSavedAccessToken() async {
    return TokenStorage.getAccessToken();
  }

  // ==========================
  // HELPERS (INCHANGÉS)
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

  UserModel _extractUser(Map<String, dynamic> data) {
    final possibleUser = data['user'] ?? data['utilisateur'] ?? data['profile'];

    if (possibleUser is Map<String, dynamic>) {
      return UserModel.fromJson(possibleUser);
    }

    return UserModel.fromJson(data);
  }

  AuthTokensModel _extractTokens(Map<String, dynamic> data) {
    final possibleTokens = data['tokens'] ?? data['tokenData'] ?? data;

    if (possibleTokens is Map<String, dynamic>) {
      return AuthTokensModel.fromJson(possibleTokens);
    }

    return const AuthTokensModel(accessToken: '', refreshToken: '');
  }
}
