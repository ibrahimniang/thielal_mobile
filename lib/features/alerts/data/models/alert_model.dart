class AlertModel {
  final int id;

  final String title;

  final String message;

  final String type;

  final String bloodGroup;

  final String city;

  /// 🔥 quantité backend
  final int quantity;

  /// 🔥 statut backend
  final String status;

  final DateTime createdAt;

  final AlertCenterModel? center;

  AlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.bloodGroup,
    required this.city,
    required this.quantity,
    required this.status,
    required this.createdAt,
    this.center,
  });

  factory AlertModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AlertModel(
      /// 🔥 backend demandes
      id:
          json['id_demande'] ??
          json['id_alerte'] ??
          0,

      /// 🔥 fallback
      title:
          json['titre'] ??
          'Urgence sanguine',

      message:
          json['message'] ??
          '',

      /// 🔥 défaut urgent
      type:
          json['type'] ??
          'urgent',

      bloodGroup:
          json['groupe_sanguin'] ??
          '',

      city:
          json['ville'] ??
          '',

      /// 🔥 quantité
      quantity:
          json['quantite'] ??
          1,

      /// 🔥 statut
      status:
          json['statut'] ??
          'en attente',

      createdAt:
          DateTime.parse(
            json['date_creation'],
          ),

      center:
          json['centre'] != null
              ? AlertCenterModel.fromJson(
                  json['centre'],
                )
              : null,
    );
  }
}

class AlertCenterModel {
  final int id;

  final String name;

  final String city;

  final String address;

  final double latitude;

  final double longitude;

  final String phone;

  AlertCenterModel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
  });

  factory AlertCenterModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AlertCenterModel(
      id:
          json['id_centre'] ??
          0,

      name:
          json['nom'] ??
          '',

      city:
          json['ville'] ??
          '',

      address:
          json['adresse'] ??
          '',

      latitude:
          (json['latitude']
                  as num?)
              ?.toDouble() ??
          0.0,

      longitude:
          (json['longitude']
                  as num?)
              ?.toDouble() ??
          0.0,

      phone:
          json['telephone'] ??
          '',
    );
  }
}