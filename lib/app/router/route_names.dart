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
  // Auth flow
  // ==========================
  static const String entryIdentity = '/entry-identity';
  static const String otpVerification = '/otp-verification';
  static const String register = '/register';
  static const String setPassword = '/set-password';

  static const String loginUser = '/login-user';
  static const String loginOffice = '/login-office';

  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // ==========================
  // App core
  // ==========================
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String map = '/map';

  static const String alerts = '/alerts';
  static const String donations = '/donations';
  static const String centers = '/centers';
  static const String donors = '/donors';
  static const String demandeSang = '/demandeSang';

  // ==========================
  // Dashboards protégés
  // ==========================
  static const String directorDashboard = '/director/dashboard';
  static const String staffDashboard = '/staff/dashboard';
  static const String adminDashboard = '/admin/dashboard';

  // ==========================
  // Staff / Director module
  // ==========================
  static const String createStaff = '/director/create-staff';
  static const String staffRequests = '/staff/requests';
  static const String staffDonors = '/staff/donors';
  static const String bloodStock = '/staff/blood-stock';
  static const String qrScan = '/staff/qr-scan';
  static const String qrGenerate = '/staff/qr-generate';
}
