class CenterModel {
  final int id;
  final String nom;
  final String ville;
  final String adresse;
  final double latitude;
  final double longitude;
  final String? telephone;

  CenterModel({
    required this.id,
    required this.nom,
    required this.ville,
    required this.adresse,
    required this.latitude,
    required this.longitude,
    this.telephone,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id_centre'] ?? 0,

      nom: json['nom'] ?? '',

      ville: json['ville'] ?? '',

      adresse: json['adresse'] ?? '',

      latitude: (json['latitude'] as num).toDouble(),

      longitude: (json['longitude'] as num).toDouble(),

      telephone: json['telephone'],
    );
  }
}
