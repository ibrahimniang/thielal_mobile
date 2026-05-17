class CollecteModel {
  final int id;

  final String title;

  final String? description;

  final String? image;

  final String location;

  final String city;

  final double latitude;

  final double longitude;

  final String startHour;

  final String endHour;

  final DateTime date;

  final DateTime? endDate;

  final String status;

  final int? maxPlaces;

  final int participants;

  final List<dynamic> inscriptions;

  CollecteModel({
    required this.id,
    required this.title,
    this.description,
    this.image,
    required this.location,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.startHour,
    required this.endHour,
    required this.date,
    this.endDate,
    required this.status,
    this.maxPlaces,
    required this.participants,
    required this.inscriptions,
  });

  factory CollecteModel.fromJson(Map<String, dynamic> json) {
    return CollecteModel(
      id: json['id_collecte'],

      title: json['titre'] ?? '',

      description: json['description'],

      image: json['image'],

      location: json['lieu'] ?? '',

      city: json['ville'] ?? '',

      latitude: (json['latitude'] as num).toDouble(),

      longitude: (json['longitude'] as num).toDouble(),

      startHour: json['heure_debut'] ?? '',

      endHour: json['heure_fin'] ?? '',

      date: DateTime.parse(json['date_collecte']),

      endDate:
          json['date_fin'] != null ? DateTime.parse(json['date_fin']) : null,

      status: json['statut'] ?? '',

      maxPlaces: json['places_max'],

      participants: (json['inscriptions'] as List?)?.length ?? 0,
      inscriptions: json['inscriptions'] ?? [],
    );
  }
}
