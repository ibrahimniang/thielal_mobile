import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/network/network_exceptions.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Provider du repository auth.
///
/// Rôle :
/// fournir une seule source d'accès aux appels backend liés à l'authentification.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider principal du controller auth.
///
/// Ce provider expose :
/// - l'état `AuthState`
/// - les actions métier de connexion / OTP / inscription / logout
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return AuthController(repository);
  },
);

/// Controller principal d'authentification.
///
/// Rôle :
/// - centraliser toute la logique auth du frontend
/// - parler au repository
/// - mettre à jour l'état global auth
///
/// Important pour les autres développeurs :
/// toute nouvelle logique liée à l'authentification doit passer ici,
/// pas directement dans les écrans.
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AuthState());

  // ==========================
  // OTP
  // ==========================

  /// Envoie un code OTP vers téléphone ou email.
  ///
  /// Utilisé dans le premier écran d'entrée de l'application.
  Future<void> sendOtp({String? phone, String? email}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.sendOtp(phone: phone, email: email);

      // On garde en mémoire l'identité utilisée pendant tout le flow.
      state = state.copyWith(
        isLoading: false,
        pendingPhone: phone,
        pendingEmail: email,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  /// Vérifie le code OTP saisi par l'utilisateur.
  Future<void> verifyOtp({
    String? phone,
    String? email,
    required String code,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.verifyOtp(phone: phone, email: email, code: code);

      state = state.copyWith(
        isLoading: false,
        pendingPhone: phone ?? state.pendingPhone,
        pendingEmail: email ?? state.pendingEmail,
        otpVerified: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // INSCRIPTION - ÉTAPE 1
  // ==========================

  /// Étape 1 de l'inscription :
  /// identité de base.
  Future<void> registerStep1({
    required String nom,
    required String prenom,
    String? genre,
    String? dateNaissance,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.registerStep1(
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

  /// Étape 2 de l'inscription :
  /// localisation / ville / quartier / coordonnées.
  Future<void> registerStep2({
    String? ville,
    String? quartier,
    double? latitude,
    double? longitude,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.registerStep2(
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

  /// Étape 3 de l'inscription :
  /// données médicales + consentements.
  Future<void> registerStep3({
    String? groupeSanguin,
    required bool accepteConditions,
    required bool acceptePolitiqueConfidentialite,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.registerStep3(
        phone: state.pendingPhone,
        email: state.pendingEmail,
        groupeSanguin: groupeSanguin,
        accepteConditions: accepteConditions,
        acceptePolitiqueConfidentialite: acceptePolitiqueConfidentialite,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // MOT DE PASSE INITIAL
  // ==========================

  /// Définit le mot de passe après inscription.
  Future<void> setPassword({required String password}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.setPassword(
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
  // LOGIN USER
  // ==========================

  /// Connexion utilisateur mobile.
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

  // ==========================
  // LOGIN OFFICE
  // ==========================

  /// Connexion back-office :
  /// admin / staff / directeur.
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
  // FORGOT PASSWORD
  // ==========================

  /// Envoie le code OTP de réinitialisation du mot de passe.
  Future<void> forgotPasswordSendCode({required String email}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.forgotPasswordSendCode(email: email);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  /// Vérifie le code OTP de reset password.
  Future<void> forgotPasswordVerifyCode({
    required String email,
    required String code,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.forgotPasswordVerifyCode(email: email, code: code);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  /// Met à jour le mot de passe oublié après validation du code.
  Future<void> forgotPasswordResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _repository.forgotPasswordResetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(e));
    }
  }

  // ==========================
  // SESSION UTILISATEUR
  // ==========================

  /// Recharge l'utilisateur connecté à partir du token sauvegardé.
  ///
  /// Utilisé au démarrage de l'application / splash plus tard.
  Future<void> loadCurrentUser() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final token = await _repository.getSavedAccessToken();

      // S'il n'y a pas de token, on remet l'état auth à zéro.
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
      // En cas d'échec, on nettoie la session.
      await logout();

      state = state.copyWith(errorMessage: _mapError(e));
    }
  }

  /// Permet de connecter automatiquement l'utilisateur
  /// juste après le set password.
  Future<void> completeRegistrationAndLogin({
    required String identifier,
    required String password,
  }) async {
    await loginUser(identifier: identifier, password: password);
  }

  /// Déconnexion complète.
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  // ==========================
  // HELPERS UI
  // ==========================

  /// Efface le dernier message d'erreur affiché.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Sauvegarde temporairement l'identité utilisée dans le flow OTP.
  void setPendingIdentity({String? phone, String? email}) {
    state = state.copyWith(pendingPhone: phone, pendingEmail: email);
  }

  /// Transforme une erreur brute en message lisible pour l'utilisateur.
  String _mapError(Object error) {
    final dynamic err = error;

    try {
      return NetworkExceptions.getMessage(err);
    } catch (_) {
      return 'Une erreur est survenue';
    }
  }
}
