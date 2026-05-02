class CentreModel {
  final int idCentre;
  final String nom;
  final String ville;

  CentreModel({
    required this.idCentre,
    required this.nom,
    required this.ville,
  });

  factory CentreModel.fromJson(Map<String, dynamic> json) {
    return CentreModel(
      idCentre: json['id_centre'],
      nom: json['nom'],
      ville: json['ville'],
    );
  }
}