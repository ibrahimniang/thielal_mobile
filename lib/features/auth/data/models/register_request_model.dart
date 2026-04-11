class RegisterRequestModel {
  final String? nom;
  final String? prenom;
  final String? genre;
  final String? dateNaissance;

  final String? telephone;
  final String? email;
  final String? ville;
  final String? quartier;
  final double? latitude;
  final double? longitude;

  final String? groupeSanguin;
  final bool accepteConditions;
  final bool acceptePolitiqueConfidentialite;

  final String? password;

  const RegisterRequestModel({
    this.nom,
    this.prenom,
    this.genre,
    this.dateNaissance,
    this.telephone,
    this.email,
    this.ville,
    this.quartier,
    this.latitude,
    this.longitude,
    this.groupeSanguin,
    this.accepteConditions = false,
    this.acceptePolitiqueConfidentialite = false,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'genre': genre,
      'date_naissance': dateNaissance,
      'telephone': telephone,
      'email': email,
      'ville': ville,
      'quartier': quartier,
      'latitude': latitude,
      'longitude': longitude,
      'groupe_sanguin': groupeSanguin,
      'accepte_conditions': accepteConditions,
      'accepte_politique_confidentialite': acceptePolitiqueConfidentialite,
      'password': password,
    };
  }

  RegisterRequestModel copyWith({
    String? nom,
    String? prenom,
    String? genre,
    String? dateNaissance,
    String? telephone,
    String? email,
    String? ville,
    String? quartier,
    double? latitude,
    double? longitude,
    String? groupeSanguin,
    bool? accepteConditions,
    bool? acceptePolitiqueConfidentialite,
    String? password,
  }) {
    return RegisterRequestModel(
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      genre: genre ?? this.genre,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      ville: ville ?? this.ville,
      quartier: quartier ?? this.quartier,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      groupeSanguin: groupeSanguin ?? this.groupeSanguin,
      accepteConditions: accepteConditions ?? this.accepteConditions,
      acceptePolitiqueConfidentialite:
          acceptePolitiqueConfidentialite ??
          this.acceptePolitiqueConfidentialite,
      password: password ?? this.password,
    );
  }
}
