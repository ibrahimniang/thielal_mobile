import 'centre_model.dart';
import 'certificate_model.dart';

class DonationModel {
  final int idDon;
  final String groupeSanguin;
  final DateTime dateDon;

  final CentreModel? centre;
  final CertificatModel? certificat;

  DonationModel({
    required this.idDon,
    required this.groupeSanguin,
    required this.dateDon,
    this.centre,
    this.certificat,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      idDon: json['id_don'],
      groupeSanguin: json['groupe_sanguin'],
      dateDon: DateTime.parse(json['date_don']),

      centre: json['centre'] != null
          ? CentreModel.fromJson(json['centre'])
          : null,

      certificat: json['certificat'] != null
          ? CertificatModel.fromJson(json['certificat'])
          : null,
    );
  }
}