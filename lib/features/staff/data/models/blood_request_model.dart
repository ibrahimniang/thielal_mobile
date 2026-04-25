class BloodRequestModel {
  final int id;
  final String bloodGroup;
  final String status;
  final String? patientName;
  final DateTime? createdAt;

  BloodRequestModel({
    required this.id,
    required this.bloodGroup,
    required this.status,
    this.patientName,
    this.createdAt,
  });

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestModel(
      id: json['id'],
      bloodGroup: json['blood_group'],
      status: json['status'],
      patientName: json['patient_name'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }
}
