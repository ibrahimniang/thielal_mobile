/// Centralisation de tous les endpoints backend.
///
/// Pourquoi faire ça ?
/// - éviter d'écrire les routes API à la main partout
/// - éviter les fautes de frappe
/// - simplifier les futures modifications backend
///
/// Règle d'équipe :
/// tout nouvel endpoint backend doit être ajouté ici avant usage.
class ApiEndpoints {
  ApiEndpoints._();

  // ==========================
  // AUTH
  // ==========================

  /// Envoi OTP
  static const String sendOtp = '/auth/send-otp';

  /// Vérification OTP
  static const String verifyOtp = '/auth/verify-otp';

  /// Mot de passe oublié
  static const String forgotPasswordSendCode =
      '/auth/forgot-password/send-code';
  static const String forgotPasswordVerifyCode =
      '/auth/forgot-password/verify-code';
  static const String forgotPasswordResetPassword =
      '/forgot-password/reset-password';

  /// Inscription par étapes
  static const String registerStep1 = '/auth/register/step-1';
  static const String registerStep2 = '/auth/register/step-2';
  static const String registerStep3 = '/auth/register/step-3';

  /// Définition mot de passe après inscription
  static const String setPassword = '/auth/set-password';

  /// Connexion mobile utilisateur
  static const String loginUser = '/auth/login-user';

  /// Connexion back-office
  static const String loginOffice = '/auth/login-office';

  // ==========================
  // USER / PROFILE
  // ==========================

  /// Profil utilisateur connecté
  static const String me = '/users/me';
  static const String updateMe = '/users/me';

  /// Mise à jour localisation utilisateur
  static const String updateLocation = '/location';

  /// Changement email / téléphone avec vérification
  static const String requestEmailChange = '/users/request-email-change';
  static const String verifyEmailChange = '/users/verify-email-change';
  static const String requestPhoneChange = '/users/request-phone-change';
  static const String verifyPhoneChange = '/users/verify-phone-change';

  // ==========================
  // DONATIONS
  // ==========================

  static const String scanQr = '/scan-qr';
  static const String myDons = '/my-dons';
  static const String demandeSang = '/demande-sang';
  static const String demandes = '/demandes';
  static const String generateQr = '/generate-qr';
  static const String nearbyDonors = '/nearby-donors';
  static const String donneurs = '/donneurs';

  /// Génère dynamiquement l'URL certificat selon l'id du don.
  static String certificatByDonId(dynamic donId) => '/certificat/$donId';

  // ==========================
  // NOTIFICATIONS
  // ==========================

  /// Attention :
  /// ici la route "/" suppose que le Dio utilisé pour les notifications
  /// pointe vers le bon module backend.
  static const String notifications = '/';

  static const String unreadCount = '/unread-count';

  /// Marquer notification comme lue
  static String markAsRead(dynamic id) => '/$id/read';

  /// Enregistrement du device token
  static const String registerDevice = '/register-device';

  // ==========================
  // ADMIN / DIRECTOR / STAFF
  // ==========================

  static const String createBackOffice = '/users/admin/create-backoffice';
  static const String createStaffByDirector = '/users/admin/create-staff';

  /// Vérification du groupe sanguin d'un utilisateur par le staff
  static String verifyBloodGroupByUserId(dynamic id) =>
      '/$id/verify-blood-group';
}
