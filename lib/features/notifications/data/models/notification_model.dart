class NotificationModel {
  final int idNotification;
  final int utilisateurId;
  final String message;
  final bool lu;
  final DateTime dateCreation;

  final String type;
  final int? demandeId;

  // AJOUT
  final String nom;
  final String prenom;

  final String centreNom;

  NotificationModel({
    required this.idNotification,
    required this.utilisateurId,
    required this.message,
    required this.lu,
    required this.dateCreation,
    required this.type,
    this.demandeId,

    // AJOUT
    required this.nom,
    required this.prenom,

    required this.centreNom,
  });

  String get fullName => "$prenom $nom".trim();

  /// Convertir JSON -> Model
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      idNotification: int.tryParse(json['id_notification'].toString()) ?? 0,

      utilisateurId: int.tryParse(json['utilisateur_id'].toString()) ?? 0,

      centreNom:
          json['demande']?['centre']?['nom']?.toString() ??
          json['centre']?['nom']?.toString() ??
          '',
      message: json['message']?.toString() ?? '',

      lu: json['lu'] == true || json['lu'] == 1 || json['lu'] == "1",

      dateCreation:
          json['date_creation'] != null
              ? DateTime.tryParse(json['date_creation'].toString()) ??
                  DateTime.now()
              : DateTime.now(),

      type: json['type']?.toString() ?? 'info',

      demandeId:
          json['demande_id'] != null
              ? int.tryParse(json['demande_id'].toString())
              : null,

      // AJOUT
      nom: json['demande']?['utilisateur']?['nom']?.toString() ?? '',
      prenom: json['demande']?['utilisateur']?['prenom']?.toString() ?? '',
    );
  }
}
