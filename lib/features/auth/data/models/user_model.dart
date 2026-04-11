/// Modèle utilisateur principal.
///
/// Ce modèle représente l'utilisateur tel qu'il vient du backend.
/// Il est aligné avec la structure Prisma / API actuelle.
///
/// Important pour l'équipe :
/// - ce modèle sert dans l'auth
/// - il servira aussi plus tard dans le profil
/// - il faut éviter de dupliquer un autre "UserModel" inutilement
class UserModel {
  // ==========================
  // IDENTITÉ
  // ==========================
  final int idUtilisateur;
  final String? nom;
  final String? prenom;
  final String? genre;
  final DateTime? dateNaissance;

  // ==========================
  // CONTACT
  // ==========================
  final String? telephone;
  final String? email;
  final String? qrCode;

  // ==========================
  // LOCALISATION
  // ==========================
  final String? ville;
  final String? quartier;
  final double? latitude;
  final double? longitude;

  // ==========================
  // DONNÉES MÉDICALES
  // ==========================
  final String? groupeSanguin;
  final String? statutGroupeSanguin;
  final DateTime? dateProchainDon;

  // ==========================
  // ÉTAT DU PROFIL
  // ==========================
  final bool profilComplet;
  final bool actif;

  // ==========================
  // RÔLE / CENTRE
  // ==========================
  final int? centreId;
  final int? roleId;
  final String? role;

  // ==========================
  // CONSENTEMENTS
  // ==========================
  final bool accepteConditions;
  final bool acceptePolitiqueConfidentialite;
  final DateTime? dateAcceptationConditions;

  // ==========================
  // DATES SYSTÈME
  // ==========================
  final DateTime? dateCreation;
  final DateTime? dateMiseAJour;

  const UserModel({
    required this.idUtilisateur,
    this.nom,
    this.prenom,
    this.genre,
    this.dateNaissance,
    this.telephone,
    this.email,
    this.qrCode,
    this.ville,
    this.quartier,
    this.latitude,
    this.longitude,
    this.groupeSanguin,
    this.statutGroupeSanguin,
    this.dateProchainDon,
    this.profilComplet = false,
    this.actif = true,
    this.centreId,
    this.roleId,
    this.role,
    this.accepteConditions = false,
    this.acceptePolitiqueConfidentialite = false,
    this.dateAcceptationConditions,
    this.dateCreation,
    this.dateMiseAJour,
  });

  /// Nom complet pratique pour l'affichage UI.
  String get fullName {
    final first = nom ?? '';
    final last = prenom ?? '';
    return '$first $last'.trim();
  }

  /// Conversion depuis JSON backend -> UserModel Flutter.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleData = json['role'];
    String? resolvedRole;

    // Selon le backend, le rôle peut arriver :
    // - soit comme objet imbriqué
    // - soit comme simple chaîne
    if (roleData is Map<String, dynamic>) {
      resolvedRole = roleData['nom_role']?.toString();
    } else {
      resolvedRole =
          json['nom_role']?.toString() ??
          json['role_name']?.toString() ??
          json['role']?.toString();
    }

    return UserModel(
      idUtilisateur: _toInt(json['id_utilisateur']) ?? 0,
      nom: json['nom']?.toString(),
      prenom: json['prenom']?.toString(),
      genre: json['genre']?.toString(),
      dateNaissance: _toDateTime(json['date_naissance']),
      telephone: json['telephone']?.toString(),
      email: json['email']?.toString(),
      qrCode: json['qr_code']?.toString(),
      ville: json['ville']?.toString(),
      quartier: json['quartier']?.toString(),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      groupeSanguin: json['groupe_sanguin']?.toString(),
      statutGroupeSanguin: json['statut_groupe_sanguin']?.toString(),
      dateProchainDon: _toDateTime(json['date_prochain_don']),
      profilComplet: json['profil_complet'] == true,
      actif: json['actif'] != false,
      centreId: _toInt(json['centre_id']),
      roleId: _toInt(json['role_id']),
      role: resolvedRole,
      accepteConditions: json['accepte_conditions'] == true,
      acceptePolitiqueConfidentialite:
          json['accepte_politique_confidentialite'] == true,
      dateAcceptationConditions: _toDateTime(
        json['date_acceptation_conditions'],
      ),
      dateCreation: _toDateTime(json['date_creation']),
      dateMiseAJour: _toDateTime(json['date_mise_a_jour']),
    );
  }

  /// Helpers de parsing sécurisés
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
