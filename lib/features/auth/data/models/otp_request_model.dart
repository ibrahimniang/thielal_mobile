class OtpRequestModel {
  final String? phone;
  final String? email;
  final String code;

  const OtpRequestModel({this.phone, this.email, required this.code});

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'email': email, 'code': code};
  }
}
