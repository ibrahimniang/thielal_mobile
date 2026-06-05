class NearbyDonorModel {
  final int id;

  final String? nom;

  final String? prenom;

  final String? telephone;

  final String? groupeSanguin;

  final double? latitude;

  final double? longitude;

  final double distance;

  const NearbyDonorModel({
    required this.id,
    this.nom,
    this.prenom,
    this.telephone,
    this.groupeSanguin,
    this.latitude,
    this.longitude,
    required this.distance,
  });

  factory NearbyDonorModel.fromJson(Map<String, dynamic> json) {
    return NearbyDonorModel(
      id: json['id'] ?? 0,

      nom: json['nom'],

      prenom: json['prenom'],

      telephone: json['telephone'],

      groupeSanguin: json['groupe_sanguin'],

      latitude: double.tryParse(json['latitude']?.toString() ?? ''),

      longitude: double.tryParse(json['longitude']?.toString() ?? ''),

      distance:
    double.tryParse(
      json['distance'].toString(),
    ) ?? 0,
    );
  }

  String get fullName {
    return '$nom $prenom';
  }
}
