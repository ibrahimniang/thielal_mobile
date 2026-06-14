class DemandeModel {
  final int idDemande;
  final String groupeSanguin;
  final String ville;
  final int quantite;
  final String statut;

  final int utilisateurId;
  final String nom;
  final String prenom;

  DemandeModel({
    required this.idDemande,
    required this.groupeSanguin,
    required this.ville,
    required this.quantite,
    required this.statut,
    required this.utilisateurId,
    required this.nom,
    required this.prenom,
  });

  factory DemandeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DemandeModel(
      idDemande: json["id_demande"],

      groupeSanguin: json["groupe_sanguin"],

      ville: json["ville"],

      quantite: json["quantite"],

      statut: json["statut"],

      utilisateurId:
          json["utilisateur"]["id_utilisateur"],

      nom:
          json["utilisateur"]["nom"],

      prenom:
          json["utilisateur"]["prenom"],
    );
  }
}