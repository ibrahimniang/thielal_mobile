import '../../../../core/network/token_storage.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';
import '../services/auth_remote_service.dart';

/// Repository auth.
///
/// Rôle :
/// - servir d'intermédiaire entre le controller et le remote service
/// - transformer les réponses backend si besoin
/// - centraliser le stockage des tokens
///
/// Important pour l'équipe :
/// - le controller appelle le repository
/// - le repository appelle le remote service
/// - le remote service parle directement au backend
///
/// Donc :
/// UI -> Controller -> Repository -> RemoteService -> API
class AuthRepository {
  final AuthRemoteService _remoteService;

  AuthRepository({AuthRemoteService? remoteService})
    : _remoteService = remoteService ?? AuthRemoteService();

  // ==========================
  // OTP
  // ==========================

  /// Envoie un code OTP au backend.
  Future<void> sendOtp({String? phone, String? email}) async {
    await _remoteService.sendOtp(phone: phone, email: email);
  }

  /// Vérifie le code OTP auprès du backend.
  Future<void> verifyOtp({
    String? phone,
    String? email,
    required String code,
  }) async {
    await _remoteService.verifyOtp(phone: phone, email: email, code: code);
  }

  // ==========================
  // INSCRIPTION
  // ==========================

  /// Étape 1 de l'inscription.
  Future<void> registerStep1({
    required String nom,
    required String prenom,
    String? genre,
    String? dateNaissance,
    String? phone,
    String? email,
  }) async {
    await _remoteService.registerStep1(
      nom: nom,
      prenom: prenom,
      genre: genre,
      dateNaissance: dateNaissance,
      phone: phone,
      email: email,
    );
  }

  /// Étape 2 de l'inscription.
  Future<void> registerStep2({
    String? phone,
    String? email,
    String? ville,
    String? quartier,
    double? latitude,
    double? longitude,
  }) async {
    await _remoteService.registerStep2(
      phone: phone,
      email: email,
      ville: ville,
      quartier: quartier,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Étape 3 de l'inscription.
  Future<void> registerStep3({
    String? phone,
    String? email,
    String? groupeSanguin,
    required bool accepteConditions,
    required bool acceptePolitiqueConfidentialite,
  }) async {
    await _remoteService.registerStep3(
      phone: phone,
      email: email,
      groupeSanguin: groupeSanguin,
      accepteConditions: accepteConditions,
      acceptePolitiqueConfidentialite: acceptePolitiqueConfidentialite,
    );
  }

  /// Définit le mot de passe après inscription.
  Future<void> setPassword({
    String? phone,
    String? email,
    required String password,
  }) async {
    await _remoteService.setPassword(
      phone: phone,
      email: email,
      password: password,
    );
  }

  // ==========================
  // LOGIN USER
  // ==========================

  /// Connexion utilisateur mobile.
  ///
  /// Ici on :
  /// - récupère la réponse backend
  /// - extrait l'utilisateur
  /// - extrait les tokens
  /// - sauvegarde access + refresh tokens
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
  // LOGIN OFFICE
  // ==========================

  /// Connexion back-office admin/staff/directeur.
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
  // FORGOT PASSWORD
  // ==========================

  /// Envoie le code OTP de mot de passe oublié.
  Future<void> forgotPasswordSendCode({required String email}) async {
    await _remoteService.forgotPasswordSendCode(email: email);
  }

  /// Vérifie le code reçu pour le reset password.
  Future<void> forgotPasswordVerifyCode({
    required String email,
    required String code,
  }) async {
    await _remoteService.forgotPasswordVerifyCode(email: email, code: code);
  }

  /// Réinitialise le mot de passe oublié.
  Future<void> forgotPasswordResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _remoteService.forgotPasswordResetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }

  // ==========================
  // SESSION UTILISATEUR
  // ==========================

  /// Récupère le profil utilisateur connecté.
  Future<UserModel> getCurrentUser() async {
    final response = await _remoteService.getMe();
    final data = _extractPayload(response.data);
    return _extractUser(data);
  }

  /// Supprime les tokens sauvegardés localement.
  Future<void> logout() async {
    await TokenStorage.clearTokens();
  }

  /// Lit l'access token sauvegardé.
  Future<String?> getSavedAccessToken() async {
    return TokenStorage.getAccessToken();
  }

  // ==========================
  // HELPERS PRIVÉS
  // ==========================

  /// Extrait le vrai payload utile de la réponse backend.
  ///
  /// Beaucoup d'APIs retournent soit :
  /// - directement l'objet
  /// - soit un objet enveloppé dans `data`
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

  /// Extrait l'objet utilisateur depuis la réponse backend.
  ///
  /// On essaie plusieurs clés possibles pour rendre le frontend
  /// plus robuste face aux variations de réponse.
  UserModel _extractUser(Map<String, dynamic> data) {
    final possibleUser = data['user'] ?? data['utilisateur'] ?? data['profile'];

    if (possibleUser is Map<String, dynamic>) {
      return UserModel.fromJson(possibleUser);
    }

    return UserModel.fromJson(data);
  }

  /// Extrait les tokens depuis la réponse backend.
  ///
  /// Accepte plusieurs structures possibles :
  /// - tokens
  /// - tokenData
  /// - ou data directement
  AuthTokensModel _extractTokens(Map<String, dynamic> data) {
    final possibleTokens = data['tokens'] ?? data['tokenData'] ?? data;

    if (possibleTokens is Map<String, dynamic>) {
      return AuthTokensModel.fromJson(possibleTokens);
    }

    return const AuthTokensModel(accessToken: '', refreshToken: '');
  }
}
