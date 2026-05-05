import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

import '../../application/profile_controller.dart';
import 'package:thielal/features/donations/application/donation_controller.dart';

import '../widgets/profile_header_card.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_badge_item.dart';
import '../widgets/blood_compatibility_card.dart';
import '../widgets/profile_action_button.dart';

import 'edit_profile_screen.dart';

import '../../../../shared/widgets/app_loading_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);

    // AJOUT : récupération des vrais dons
    final donsAsync = ref.watch(myDonationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Votre Profil'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.red.shade50.withOpacity(0.55),
              Colors.green.shade50.withOpacity(0.35),
              Colors.blue.shade50.withOpacity(0.40),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: state.when(
          loading: () =>
              const AppLoadingView(message: 'Chargement du profil...'),

          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                "Erreur: $e",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          data: (user) {
            if (user == null) {
              return const Center(
                child: Text(
                  "Aucun profil",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }

            final compatibleGroups =
                _getCompatibleGroups(user.groupeSanguin ?? '');

            final points = user.points ?? 0;
            final badge = _getBadge(points);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileHeaderCard(
                    fullName: user.fullName,
                    bloodGroup: user.groupeSanguin ?? '--',
                    profilComplet: user.profilComplet,
                    points: points,
                    badge: badge,
                  ),

                  const SizedBox(height: 20),

                  /// QR CODE
                  ProfileSectionCard(
                    title: "Carte QR Donneur",
                    icon: Icons.qr_code_rounded,
                    child: Column(
                      children: [
                        if (user.qrCode != null &&
                            user.qrCode!.trim().isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: QrImageView(
                              data: user.qrCode!.trim(),
                              version: QrVersions.auto,
                              size: 130,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "QR code scannable du donneur",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ] else ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.qr_code_2_rounded,
                                  size: 56,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Aucun QR code n’a encore été généré pour ce donneur.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BADGES
                  ProfileSectionCard(
                    title: "Badges",
                    icon: Icons.workspace_premium_rounded,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: const [
                        ProfileBadgeItem(
                          icon: Icons.emoji_events,
                          label: "Bronze",
                          color: Colors.brown,
                        ),
                        ProfileBadgeItem(
                          icon: Icons.emoji_events,
                          label: "Argent",
                          color: Colors.grey,
                        ),
                        ProfileBadgeItem(
                          icon: Icons.emoji_events,
                          label: "Or",
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  BloodCompatibilityCard(groups: compatibleGroups),

                  const SizedBox(height: 20),

                  /// INFOS DONNEUR
                  ProfileSectionCard(
                    title: "Informations du donneur",
                    icon: Icons.person_rounded,
                    child: Column(
                      children: [
                        _infoTile(
                          icon: Icons.badge_outlined,
                          label: "Nom complet",
                          value: user.fullName.isEmpty
                              ? "--"
                              : user.fullName,
                        ),
                        _infoTile(
                          icon: Icons.phone_rounded,
                          label: "Téléphone",
                          value: user.telephone ?? "--",
                        ),
                        _infoTile(
                          icon: Icons.email_rounded,
                          label: "Email",
                          value:
                              user.email ?? "Aucun email ajouté",
                        ),
                        _infoTile(
                          icon: Icons.location_on_outlined,
                          label: "Ville / Quartier",
                          value:
                              "${user.ville ?? '--'} / ${user.quartier ?? '--'}",
                        ),
                        _infoTile(
                          icon: Icons.bloodtype_rounded,
                          label: "Groupe sanguin",
                          value:
                              user.groupeSanguin ?? "--",
                        ),
                        _infoTile(
                          icon: Icons.verified_rounded,
                          label: "Statut groupe sanguin",
                          value:
                              user.statutGroupeSanguin ??
                                  "Non vérifié",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// HISTORIQUE RÉEL DES DONS
                  ProfileSectionCard(
                    title: "Historique de dons",
                    icon: Icons.history_rounded,
                    child: donsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ),

                      error: (e, _) => Text(
                        "Erreur historique: $e",
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),

                      data: (dons) {
                        if (dons.isEmpty) {
                          return const Text(
                            "Aucun don enregistré",
                          );
                        }

                        return Column(
                          children: dons.map((don) {
                            final hasCertificat =
                                don.certificat != null;

                            return Container(
                              margin: const EdgeInsets.only(
                                  bottom: 12),
                              padding:
                                  const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      Colors.grey.shade200,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.bloodtype,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Don de sang (${don.groupeSanguin})",
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "Date : ${DateFormat('dd MMM yyyy').format(don.dateDon)}",
                                  ),

                                  Text(
                                    "Centre : ${don.centre?.nom ?? "Centre inconnu"}",
                                  ),

                                  Text(
                                    "Ville : ${don.centre?.ville ?? "Ville inconnue"}",
                                  ),

                                  const SizedBox(height: 8),

                                  if (hasCertificat)
                                    Align(
                                      alignment:
                                          Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () {
                                          debugPrint(
                                            "Certificat: ${don.certificat!.urlCertificat}",
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.description,
                                          color:
                                              Colors.deepPurple,
                                        ),
                                        label: const Text(
                                          "Voir certificat",
                                          style: TextStyle(
                                            color: Colors
                                                .deepPurple,
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    const Text(
                                      "Certificat non disponible",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  ProfileActionButton(
                    text: "Modifier profil",
                    icon: Icons.edit_rounded,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.red.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getCompatibleGroups(String group) {
    switch (group) {
      case "O-":
        return ["Tous les groupes"];
      case "O+":
        return ["O+", "A+", "B+", "AB+"];
      case "A-":
        return ["A-", "A+", "AB-", "AB+"];
      case "A+":
        return ["A+", "AB+"];
      case "B-":
        return ["B-", "B+", "AB-", "AB+"];
      case "B+":
        return ["B+", "AB+"];
      case "AB-":
        return ["AB-", "AB+"];
      case "AB+":
        return ["AB+"];
      default:
        return [];
    }
  }

  String _getBadge(int points) {
    if (points >= 500) return "Or 🟡";
    if (points >= 100) return "Argent ⚪";
    return "Bronze 🟤";
  }
}