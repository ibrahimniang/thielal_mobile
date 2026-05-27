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

  static const String scanQr = '/dons/scan-qr';
  static const String myDons = '/dons/my-dons';
  static const String demandeSang = '/dons/demande-sang';
  static const String demandes = '/dons/demandes';
  static const String generateQr = '/dons/generate-qr';

  static const String nearbyDonors = '/nearby-donors';
  static const String donneurs = '/dons/donneurs';

  // ==========================
  // BLOOD BANK / STOCK
  // ==========================

  static const String banque = '/banque';
  static const String banqueCentre = '/banque/centre';

  /// Génère dynamiquement l'URL certificat selon l'id du don
  static String certificatByDonId(dynamic donId) {
    return '/certificat/$donId';
  }

  // ==========================
  // NOTIFICATIONS
  // ==========================

  static const String notifications = '/notifications';


  //static const unreadCount = "/notifications/unread-count";

  static const String unreadCount = '/notifications/unread-count';


  /// Marquer notification comme lue

 /// static String markAsRead(dynamic id) => '/$id/read';
  ///static String markAsRead(int id) => "/notifications/$id/read";

  static String markAsRead(dynamic id) {
    return '/notifications/$id/read';
  }


  /// Enregistrement device
  static const String registerDevice = '/register-device';

  // ==========================
  // ADMIN / DIRECTOR / STAFF
  // ==========================

  static const String createBackOffice = '/users/admin/create-backoffice';

  static const String createStaffByDirector = '/users/admin/create-staff';

  static const String users = '/users';

  static String verifyBloodGroupByUserId(int userId) {
    return '$users/$userId/verify-blood-group';
  }

  // ==========================
  // CHAT
  // ==========================

  /// créer ou récupérer conversation
  static const String createConversation = '/chat/conversation';

  /// envoyer message
  static const String sendMessage = '/chat/message';

  /// liste conversations utilisateur
  static const String conversations = '/chat/conversations';

  /// messages d'une conversation
  static String messages(int conversationId) =>
      '/chat/messages/$conversationId';

  /// marquer comme lu
  static String markChatRead(int conversationId) =>
      '/chat/read/$conversationId';

  /// compteur non lus
  static const String unreadMessages = '/chat/unread-count';

  // ==========================
  // ALERTES
  // ==========================

  static const String alerts = '/alerts';

  // ==========================
  // CENTRES
  // ==========================

  static const String centres = '/centres';

  // ==========================
  // COLLECTES
  // ==========================

  static const String collectes = '/collectes';
}
