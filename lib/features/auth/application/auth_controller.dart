//lib/features/auth/application/auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/network/network_exceptions.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/services/device_service.dart';

import '../../devices/data/device_repository.dart';

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

      final data = await _repository.sendOtp(phone: phone, email: email);

      final bool success = data['success'] == true;
      final String? message = data['message']?.toString();

      if (!success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: message ?? "Impossible d'envoyer le code OTP",
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        pendingPhone: phone,
        pendingEmail: email,
        clearError: true,
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

      final data = await _repository.verifyOtp(
        phone: phone,
        email: email,
        code: code,
      );

      final bool success = data['success'] == true;
      final String? message = data['message']?.toString();

      if (!success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: message ?? "Code OTP invalide",
        );
        return;
      }

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
        pendingUserId: userId,
        otpVerified: true,
        clearError: true,
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
        phone: state.pendingPhone,
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
    required bool aDonneRecemment,
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
        aDonneRecemment: aDonneRecemment,
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

  void clearPendingUser() {
    state = state.copyWith(
      clearPendingPhone: true,
      clearPendingEmail: true,
      clearPendingUserId: true,
    );
  }

  // ==========================
  // LOGIN USER
  // ==========================

  Future<void> loginUser({
    required String identifier,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        isAuthenticated: false,
        clearUser: true,
        clearToken: true,
      );

      final result = await _repository.loginUser(
        identifier: identifier,
        password: password,
      );

      await SessionStorage.saveSessionExpiry(
        DateTime.now().add(const Duration(minutes: 10)),
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,

        /// 🔥 user temporaire
        currentUser: result.$1,

        accessToken: result.$2.accessToken,

        clearError: true,
      );

      /// ======================================
      /// LOAD VRAI PROFIL COMPLET
      /// ======================================

      await loadCurrentUser();
      try {
        final device = await DeviceService.getDeviceInfo();

        await DeviceRepository().registerDevice(device);
      } catch (e) {
        print("DEVICE REGISTER ERROR => $e");
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        clearUser: true,
        clearToken: true,
        errorMessage: _mapError(e),
      );
    }
  }

  // ==========================
  // LOGIN OFFICE
  // ==========================

  Future<void> loginOffice({
    required String identifier,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        isAuthenticated: false,
        clearUser: true,
        clearToken: true,
      );

      final result = await _repository.loginOffice(
        identifier: identifier,
        password: password,
      );

      await SessionStorage.saveSessionExpiry(
        DateTime.now().add(const Duration(minutes: 10)),
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,

        /// 🔥 user temporaire
        currentUser: result.$1,

        accessToken: result.$2.accessToken,

        clearError: true,
      );

      /// ======================================
      /// LOAD VRAI PROFIL COMPLET
      /// ======================================

      await loadCurrentUser();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        clearUser: true,
        clearToken: true,
        errorMessage: _mapError(e),
      );
    }
  }

  // ==========================
  // LOGIN UNIFIÉ (PROPRE)
  // ==========================
  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        isAuthenticated: false,
        clearUser: true,
        clearToken: true,
      );

      final bool isEmail = identifier.contains('@');
      Position? position;

      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } catch (_) {}

      final result =
          isEmail
              ? await _repository.loginOffice(
                identifier: identifier,
                password: password,
              )
              : await _repository.loginUser(
                identifier: identifier,
                password: password,
                latitude: position?.latitude,
                longitude: position?.longitude,
              );
      await SessionStorage.saveSessionExpiry(
        DateTime.now().add(const Duration(minutes: 10)),
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,

        /// 🔥 user temporaire
        currentUser: result.$1,

        accessToken: result.$2.accessToken,

        clearError: true,
      );

      /// ======================================
      /// LOAD VRAI PROFIL COMPLET
      /// ======================================

      await loadCurrentUser();
      try {
        final device = await DeviceService.getDeviceInfo();

        await DeviceRepository().registerDevice(device);
      } catch (e) {
        print("DEVICE REGISTER ERROR => $e");
      }

      await SecureStorageService.setHasCompletedEntryFlow(true);
      final saved = await SecureStorageService.hasCompletedEntryFlow();
      print('AUTH DEBUG -> hasCompletedEntryFlow saved after login: $saved');
    } catch (e) {
      final message = _mapError(e);
      print('LOGIN DEBUG -> error: $message');
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        clearUser: true,
        clearToken: true,
        errorMessage: _mapError(e),
      );
    }
  }
  // ==========================
  // FORGOT PASSWORD
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

      print(
        'AUTH DEBUG -> saved token: ${token != null && token.isNotEmpty ? "FOUND" : "NOT FOUND"}',
      );

      if (token == null || token.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          clearUser: true,
          clearToken: true,
        );
        return;
      }

      final isExpired = await SessionStorage.isSessionExpired();

      print('AUTH DEBUG -> session expired: $isExpired');

      if (isExpired) {
        await logout();

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          clearUser: true,
          clearToken: true,
        );
        return;
      }

      final user = await _repository.getCurrentUser();

      print(
        'AUTH DEBUG -> current user loaded: ${user.idUtilisateur}, roleId: ${user.roleId}',
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: user,
        accessToken: token,
      );
    } catch (e) {
      print('AUTH DEBUG -> loadCurrentUser error: $e');

      await logout();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        clearUser: true,
        clearToken: true,
        errorMessage: _mapError(e),
      );
    }
  }

  // ==========================
  // COMPLETE REGISTRATION + LOGIN
  // ==========================
  Future<void> completeRegistrationAndLogin({
    required String identifier,
    required String password,
  }) async {
    await login(identifier: identifier, password: password);

    final saved = await SecureStorageService.hasCompletedEntryFlow();
    print(
      'AUTH DEBUG -> hasCompletedEntryFlow after completeRegistrationAndLogin: $saved',
    );
  }

  Future<void> logout() async {
    // ✅ On supprime seulement les tokens
    await _repository.logout();

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
      final message = error.toString();

      if (message.startsWith('Exception: ')) {
        return message.replaceFirst('Exception: ', '').trim();
      }

      return message.isNotEmpty ? message : 'Une erreur est survenue';
    }
  }

  Future<void> checkAuth() async {
    final token = await _repository.getSavedAccessToken();

    if (token != null && token.isNotEmpty) {
      state = state.copyWith(isAuthenticated: true, accessToken: token);
    } else {
      state = state.copyWith(
        isAuthenticated: false,
        clearUser: true,
        clearToken: true,
      );
    }
  }

  /// ==========================
  /// ROLE HELPERS
  /// ==========================

  bool isAdmin() {
    final roleId = state.currentUser?.roleId;
    return roleId == 1;
  }

  bool isUser() {
    final roleId = state.currentUser?.roleId;
    return roleId == 2;
  }

  bool isStaff() {
    final roleId = state.currentUser?.roleId;
    return roleId == 3;
  }

  bool isDirector() {
    final roleId = state.currentUser?.roleId;
    return roleId == 4;
  }

  String? get roleName {
    return state.currentUser?.role?.nomRole;
  }
}
