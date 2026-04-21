import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/network/network_exceptions.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';
import '../../../core/storage/secure_storage_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return AuthController(repository);
  },
);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AuthState());

  // ==========================
  // OTP
  // ==========================

  Future<void> sendOtp({String? phone, String? email}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.sendOtp(phone: phone, email: email);

      state = state.copyWith(
        isLoading: false,
        pendingPhone: phone,
        pendingEmail: email,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  Future<void> verifyOtp({
    String? phone,
    String? email,
    required String code,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      /// 🔥 CORRECTION : récupérer data
      final data = await _repository.verifyOtp(
        phone: phone,
        email: email,
        code: code,
      );

      /// 🔥 EXTRACTION user_id
      final int? userId =
          data['user_id'] ??
          data['id_utilisateur'] ??
          (data['user'] is Map ? data['user']['id_utilisateur'] : null) ??
          (data['utilisateur'] is Map
              ? data['utilisateur']['id_utilisateur']
              : null);

      state = state.copyWith(
        isLoading: false,
        pendingPhone: phone ?? state.pendingPhone,
        pendingEmail: email ?? state.pendingEmail,
        pendingUserId: userId, // 🔥 IMPORTANT
        otpVerified: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // INSCRIPTION - ÉTAPE 1
  // ==========================

  Future<void> registerStep1({
    required String nom,
    required String prenom,
    String? genre,
    String? dateNaissance,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final userId = state.pendingUserId;
      if (userId == null) throw Exception("user_id manquant");

      await _repository.registerStep1(
        userId: userId,
        nom: nom,
        prenom: prenom,
        genre: genre,
        dateNaissance: dateNaissance,
        phone: state.pendingPhone,
        email: state.pendingEmail,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // INSCRIPTION - ÉTAPE 2
  // ==========================

  Future<void> registerStep2({
    String? ville,
    String? quartier,
    double? latitude,
    double? longitude,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final userId = state.pendingUserId;
      if (userId == null) throw Exception("user_id manquant");

      await _repository.registerStep2(
        userId: userId,
        phone: state.pendingPhone, // 🔥 AUTO
        email: state.pendingEmail,
        ville: ville,
        quartier: quartier,
        latitude: latitude,
        longitude: longitude,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // INSCRIPTION - ÉTAPE 3
  // ==========================

  Future<void> registerStep3({
    String? groupeSanguin,
    required bool accepteConditions,
    required bool acceptePolitiqueConfidentialite,
    required bool aDonneRecemment, // 🔥 AJOUT
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final userId = state.pendingUserId;
      if (userId == null) throw Exception("user_id manquant");

      await _repository.registerStep3(
        userId: userId,
        phone: state.pendingPhone,
        email: state.pendingEmail,
        groupeSanguin: groupeSanguin,
        accepteConditions: accepteConditions,
        acceptePolitiqueConfidentialite: acceptePolitiqueConfidentialite,
        aDonneRecemment: aDonneRecemment, // 🔥 IMPORTANT
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // MOT DE PASSE INITIAL
  // ==========================

  Future<void> setPassword({required String password}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final userId = state.pendingUserId;
      if (userId == null) throw Exception("user_id manquant");

      await _repository.setPassword(
        userId: userId,
        phone: state.pendingPhone,
        email: state.pendingEmail,
        password: password,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // LOGIN (INCHANGÉ)
  // ==========================

  Future<void> loginUser({
    required String identifier,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final result = await _repository.loginUser(
        identifier: identifier,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: result.$1,
        accessToken: result.$2.accessToken,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  Future<void> loginOffice({
    required String identifier,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final result = await _repository.loginOffice(
        identifier: identifier,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: result.$1,
        accessToken: result.$2.accessToken,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // FORGOT PASSWORD (FIX TELEPHONE)
  // ==========================

  Future<void> forgotPasswordSendCode({required String telephone}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.forgotPasswordSendCode(telephone: telephone);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  Future<void> forgotPasswordVerifyCode({
    required String telephone,
    required String code,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.forgotPasswordVerifyCode(
        telephone: telephone,
        code: code,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  Future<void> forgotPasswordResetPassword({
    required String telephone,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.forgotPasswordResetPassword(
        telephone: telephone,
        password: password,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // RESTE INTACT
  // ==========================

  Future<void> loadCurrentUser() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final token = await _repository.getSavedAccessToken();

      if (token == null || token.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          clearUser: true,
          clearToken: true,
        );
        return;
      }

      final user = await _repository.getCurrentUser();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: user,
        accessToken: token,
      );
    } catch (e) {
      await logout();
      state = state.copyWith(errorMessage: _mapError(e));
    }
  }

  Future<void> completeRegistrationAndLogin({
    required String identifier,
    required String password,
  }) async {
    await loginUser(identifier: identifier, password: password);
  }

  Future<void> logout() async {
    await SecureStorageService.instance.deleteAll();

    state = state.copyWith(
      isAuthenticated: false,
      clearUser: true,
      clearToken: true,
      clearError: true,
      clearPendingPhone: true,
      clearPendingEmail: true,
      clearPendingUserId: true,
      otpVerified: false,
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void setPendingIdentity({String? phone, String? email}) {
    state = state.copyWith(pendingPhone: phone, pendingEmail: email);
  }

  String _mapError(Object error) {
    final dynamic err = error;

    try {
      return NetworkExceptions.getMessage(err);
    } catch (_) {
      return 'Une erreur est survenue';
    }
  }

  Future<void> checkAuth() async {
    final token = await SecureStorageService.instance.read(key: 'token');

    if (token != null) {
      state = state.copyWith(isAuthenticated: true, accessToken: token);
    } else {
      state = state.copyWith(isAuthenticated: false);
    }
  }
}
