class MyDemandeModel {
  final int idDemande;
  final String groupeSanguin;
  final String ville;
  final int quantite;
  final String statut;
  final String centreNom;
  final DateTime dateCreation;
  final int participants;

  MyDemandeModel({
    required this.idDemande,
    required this.groupeSanguin,
    required this.ville,
    required this.quantite,
    required this.statut,
    required this.centreNom,
    required this.dateCreation,
    required this.participants,
  });

  factory MyDemandeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyDemandeModel(
      idDemande: json["id_demande"],
      groupeSanguin: json["groupe_sanguin"] ?? "",
      ville: json["ville"] ?? "",
      quantite: json["quantite"] ?? 0,
      statut: json["statut"] ?? "",
      centreNom:
          json["centre"]?["nom"] ?? "",
      participants:
          (json["participations"] as List?)
              ?.length ??
          0,
      dateCreation: DateTime.parse(
        json["date_creation"],
      ),
    );
  }
}