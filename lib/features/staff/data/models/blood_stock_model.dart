class BloodStockModel {
  final int? centreId;
  final String? group;
  final int? quantity;

  BloodStockModel({this.centreId, this.group, this.quantity});

  factory BloodStockModel.fromJson(Map<String, dynamic> json) {
    return BloodStockModel(
      centreId: int.tryParse((json['centre_id'] ?? '').toString()),
      group:
          json['group']?.toString() ??
          json['blood_group']?.toString() ??
          json['groupe_sanguin']?.toString() ??
          json['type']?.toString(),
      quantity:
          int.tryParse(
            (json['quantity'] ?? json['stock'] ?? json['quantite'] ?? 0)
                .toString(),
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'centre_id': centreId, 'group': group, 'quantity': quantity};
  }
}
