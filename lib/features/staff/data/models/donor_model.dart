class DonorModel {
  final int id;
  final String name;
  final String? phone;
  final String bloodGroup;
  final double? distance;

  DonorModel({
    required this.id,
    required this.name,
    this.phone,
    required this.bloodGroup,
    this.distance,
  });

  factory DonorModel.fromJson(Map<String, dynamic> json) {
    final nom = json['nom']?.toString() ?? '';
    final prenom = json['prenom']?.toString() ?? '';
    final fullName = '$nom $prenom'.trim();

    return DonorModel(
      id:
          int.tryParse(
            (json['id'] ?? json['id_utilisateur'] ?? 0).toString(),
          ) ??
          0,
      name:
          fullName.isEmpty ? (json['name']?.toString() ?? 'Donneur') : fullName,
      phone: json['telephone']?.toString(),
      bloodGroup:
          json['blood_group']?.toString() ??
          json['groupe_sanguin']?.toString() ??
          '',
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }
}
