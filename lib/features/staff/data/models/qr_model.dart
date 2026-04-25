class QrModel {
  final String qrCode;
  final int userId;

  QrModel({required this.qrCode, required this.userId});

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(qrCode: json['qr_code'], userId: json['user_id']);
  }
}
