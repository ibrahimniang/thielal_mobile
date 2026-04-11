/// Centralisation de tous les chemins de navigation de l'application.
///
/// Pourquoi faire ça ?
/// - éviter d'écrire les routes "à la main" partout
/// - éviter les fautes de frappe
/// - faciliter les modifications futures
///
/// Règle d'équipe :
/// toute nouvelle route doit être ajoutée ici avant d'être utilisée.
class RouteNames {
  // ==========================
  // Splash / onboarding
  // ==========================
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // ==========================
  // Flux d'entrée utilisateur
  // ==========================
  // Première entrée dans l'application :
  // téléphone/email -> OTP -> inscription -> mot de passe
  static const String entryIdentity = '/entry-identity';
  static const String otpVerification = '/otp-verification';

  // ==========================
  // Inscription
  // ==========================
  static const String register = '/register';
  static const String setPassword = '/set-password';

  // ==========================
  // Connexion
  // ==========================
  static const String loginUser = '/login-user';
  static const String loginOffice = '/login-office';

  // ==========================
  // Mot de passe oublié
  // ==========================
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // ==========================
  // Application principale
  // ==========================
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  static const String alerts = '/alerts';
  static const String donations = '/donations';
  static const String centers = '/centers';
  static const String donors = '/donors';

  // ==========================
  // Espaces protégés staff / admin
  // ==========================
  static const String staffDashboard = '/staff/dashboard';
  static const String adminDashboard = '/admin/dashboard';
}
