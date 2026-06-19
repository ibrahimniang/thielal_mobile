class DeviceModel {
  final int idAppareil;
  final String? nomAppareil;
  final String? marque;
  final String? modele;
  final String? systeme;
  final String? versionSysteme;
  final DateTime? derniereConnexion;

  DeviceModel({
    required this.idAppareil,
    this.nomAppareil,
    this.marque,
    this.modele,
    this.systeme,
    this.versionSysteme,
    this.derniereConnexion,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      idAppareil: json['id_appareil'] ?? 0,
      nomAppareil: json['nom_appareil'],
      marque: json['marque'],
      modele: json['modele'],
      systeme: json['systeme'],
      versionSysteme: json['version_systeme'],
      derniereConnexion:
          json['derniere_connexion'] != null
              ? DateTime.tryParse(json['derniere_connexion'])
              : null,
    );
  }
}