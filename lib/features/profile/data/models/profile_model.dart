class ProfileModel {
  final int id;
  final String? nom;
  final String? prenom;
  final String? email;
  final String? telephone;

  final String? ville;
  final String? quartier;
  final double? latitude;
  final double? longitude;

  final String? groupeSanguin;
  final String? statutGroupeSanguin;

  final bool profilComplet;
  final String? qrCode;
  final int? points;

  const ProfileModel({
    required this.id,
    this.nom,
    this.prenom,
    this.email,
    this.telephone,
    this.ville,
    this.quartier,
    this.latitude,
    this.longitude,
    this.groupeSanguin,
    this.statutGroupeSanguin,
    this.profilComplet = false,
    this.qrCode,
    this.points,
  });

  String get fullName => '${nom ?? ''} ${prenom ?? ''}'.trim();

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final statutGroupe = json['statut_groupe_sanguin']?.toString();

    final bool isBloodGroupVerified =
        statutGroupe == 'verifie' || statutGroupe == 'verified';

    return ProfileModel(
      id: _toInt(json['id_utilisateur']) ?? _toInt(json['id']) ?? 0,
      nom: json['nom']?.toString(),
      prenom: json['prenom']?.toString(),
      email: json['email']?.toString(),
      telephone: json['telephone']?.toString(),

      ville: json['ville']?.toString(),
      quartier: json['quartier']?.toString(),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),

      groupeSanguin: json['groupe_sanguin']?.toString(),
      statutGroupeSanguin: statutGroupe,

      // ✅ règle métier du projet
      profilComplet: isBloodGroupVerified,

      qrCode: json['qr_code']?.toString(),
      points: _toInt(json['points']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }
}
