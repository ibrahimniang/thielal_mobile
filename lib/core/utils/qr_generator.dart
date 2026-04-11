import 'dart:convert';

class QrGenerator {
  QrGenerator._();

  static String generateDonationQrData({
    required int userId,
    required String fullName,
    required String bloodGroup,
  }) {
    final data = {
      'user_id': userId,
      'full_name': fullName,
      'blood_group': bloodGroup,
    };

    return jsonEncode(data);
  }
}
