class ProfileModel {
  final int id;
  final String? nom;
  final String? prenom;
  final String? email;
  final String? telephone;
  final String? groupeSanguin;
  final bool profilComplet;
  final String? qrCode;
  final int? points;

  const ProfileModel({
    required this.id,
    this.nom,
    this.prenom,
    this.email,
    this.telephone,
    this.groupeSanguin,
    this.profilComplet = false,
    this.points,
    this.qrCode,
  });

  String get fullName => '${nom ?? ''} ${prenom ?? ''}'.trim();

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: int.tryParse(json['id_utilisateur'].toString()) ?? 0,
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      groupeSanguin: json['groupe_sanguin'],
      profilComplet:
          json['profil_complet'] == true ||
          json['profil_complet'] == 1 ||
          json['profil_complet'] == "1",
      qrCode: json['qr_code'],
      points: json['points'],
    );
  }
}
