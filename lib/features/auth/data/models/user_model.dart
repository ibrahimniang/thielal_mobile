// lib/features/auth/data/models/user_model.dart

import 'role_model.dart';

/// Modèle utilisateur principal.
/// Aligné avec le backend Prisma (roles + utilisateur).
///
/// IMPORTANT :
/// - rôle est un objet (RoleModel)
/// - compatible auth USER / STAFF / DIRECTEUR / ADMIN
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
  // ÉTAT PROFIL
  // ==========================
  final bool profilComplet;
  final bool actif;

  // ==========================
  // RÔLE (PRISMA RELATION)
  // ==========================
  final int? roleId;
  final RoleModel? role;

  // ==========================
  // CENTRE
  // ==========================
  final int? centreId;

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
    this.roleId,
    this.role,
    this.centreId,
    this.accepteConditions = false,
    this.acceptePolitiqueConfidentialite = false,
    this.dateAcceptationConditions,
    this.dateCreation,
    this.dateMiseAJour,
  });

  /// Nom complet pour UI
  String get fullName {
    final first = nom ?? '';
    final last = prenom ?? '';
    return '$first $last'.trim();
  }

  // ==========================
  // JSON -> MODEL
  // ==========================
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final dynamic roleData =
        json['role'] ?? json['roles'] ?? json['role_data'] ?? json['roleInfo'];

    RoleModel? parsedRole;

    if (roleData is Map<String, dynamic>) {
      parsedRole = RoleModel.fromJson(roleData);
    } else if (roleData is String) {
      final int parsedRoleId =
          _toInt(json['role_id']) ??
          _toInt(json['id_role']) ??
          _toInt(json['roleId']) ??
          0;

      parsedRole = RoleModel(idRole: parsedRoleId, nomRole: roleData);
    } else if (json['nom_role'] != null || json['role_name'] != null) {
      final int parsedRoleId =
          _toInt(json['role_id']) ??
          _toInt(json['id_role']) ??
          _toInt(json['roleId']) ??
          0;

      parsedRole = RoleModel(
        idRole: parsedRoleId,
        nomRole:
            json['nom_role']?.toString() ?? json['role_name']?.toString() ?? '',
      );
    }

    final statutGroupe = json['statut_groupe_sanguin']?.toString();

    final bool isBloodGroupVerified =
        statutGroupe == 'verifie' || statutGroupe == 'verified';

    return UserModel(
      idUtilisateur:
          _toInt(json['id_utilisateur']) ??
          _toInt(json['id']) ??
          _toInt(json['user_id']) ??
          0,

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
      statutGroupeSanguin: statutGroupe,
      dateProchainDon: _toDateTime(json['date_prochain_don']),

      // ✅ profil complet seulement si groupe sanguin vérifié
      profilComplet: isBloodGroupVerified,

      actif: json['actif'] != false,

      roleId:
          parsedRole?.idRole ??
          _toInt(json['role_id']) ??
          _toInt(json['id_role']) ??
          _toInt(json['roleId']),

      role: parsedRole,

      centreId:
          _toInt(json['centre_id']) ??
          _toInt(json['id_centre']) ??
          _toInt(json['centreId']),

      accepteConditions: json['accepte_conditions'] == true,
      acceptePolitiqueConfidentialite:
          json['accepte_politique_confidentialite'] == true,
      dateAcceptationConditions: _toDateTime(
        json['date_acceptation_conditions'],
      ),

      dateCreation: _toDateTime(json['date_creation']),
      dateMiseAJour:
          _toDateTime(json['date_mise_a_jour']) ??
          _toDateTime(json['updated_at']),
    );
  }

  // ==========================
  // HELPERS
  // ==========================
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
