import '../data/models/user_model.dart';

/// Représente l'état global d'authentification de l'application.
///
/// Ce state sert à suivre :
/// - les chargements en cours
/// - la connexion utilisateur
/// - l'utilisateur actuellement connecté
/// - le token d'accès
/// - les erreurs à afficher
/// - l'identité en attente pendant le flow OTP
/// - si l'OTP a été validé ou non
///
/// Important pour l'équipe :
/// cet objet doit rester simple, immutable, et facile à copier
/// avec `copyWith()`.
class AuthState {
  /// Indique si une action auth est en cours :
  /// login, OTP, register, reset password, etc.
  final bool isLoading;

  /// Indique si l'utilisateur est authentifié.
  final bool isAuthenticated;

  /// Utilisateur actuellement connecté.
  final UserModel? currentUser;

  /// Access token courant.
  ///
  /// Remarque :
  /// le refresh token est stocké côté secure storage,
  /// on ne le garde pas forcément dans le state UI.
  final String? accessToken;

  /// Message d'erreur à afficher dans l'interface.
  final String? errorMessage;

  /// Téléphone saisi lors du flow OTP / inscription.
  final String? pendingPhone;

  /// Email saisi lors du flow OTP / inscription.
  final String? pendingEmail;

  /// Indique si le code OTP a été validé.
  final bool otpVerified;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.currentUser,
    this.accessToken,
    this.errorMessage,
    this.pendingPhone,
    this.pendingEmail,
    this.otpVerified = false,
  });

  /// Permet de créer une nouvelle version du state
  /// sans modifier l'instance existante.
  ///
  /// Les paramètres `clear...` servent à vider explicitement
  /// certaines valeurs quand nécessaire.
  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? currentUser,
    String? accessToken,
    String? errorMessage,
    String? pendingPhone,
    String? pendingEmail,
    bool? otpVerified,
    bool clearError = false,
    bool clearUser = false,
    bool clearToken = false,
    bool clearPendingPhone = false,
    bool clearPendingEmail = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: clearUser ? null : (currentUser ?? this.currentUser),
      accessToken: clearToken ? null : (accessToken ?? this.accessToken),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      pendingPhone:
          clearPendingPhone ? null : (pendingPhone ?? this.pendingPhone),
      pendingEmail:
          clearPendingEmail ? null : (pendingEmail ?? this.pendingEmail),
      otpVerified: otpVerified ?? this.otpVerified,
    );
  }
}
