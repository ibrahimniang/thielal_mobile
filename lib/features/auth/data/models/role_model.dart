class RoleModel {
  final int idRole;
  final String nomRole;

  const RoleModel({required this.idRole, required this.nomRole});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    final int parsedId =
        _toInt(
          json['id_role'] ?? json['id'] ?? json['role_id'] ?? json['roleId'],
        ) ??
        0;

    final String parsedName =
        json['nom_role']?.toString() ??
        json['name']?.toString() ??
        json['nom']?.toString() ??
        json['role_name']?.toString() ??
        '';

    return RoleModel(idRole: parsedId, nomRole: parsedName);
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }
}
