class CertificatModel {
  final int idCertificat;
  final String urlCertificat;

  CertificatModel({
    required this.idCertificat,
    required this.urlCertificat,
  });

  factory CertificatModel.fromJson(Map<String, dynamic> json) {
    return CertificatModel(
      idCertificat: json['id_certificat'],
      urlCertificat: json['url_certificat'],
    );
  }
}