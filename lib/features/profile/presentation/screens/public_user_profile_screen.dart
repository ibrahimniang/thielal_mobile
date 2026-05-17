import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/env.dart';
import '../../../../core/config/api_endpoints.dart';
import '../../../auth/application/auth_controller.dart';

class PublicUserProfileScreen extends ConsumerStatefulWidget {
  final int userId;

  const PublicUserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<PublicUserProfileScreen> createState() =>
      _PublicUserProfileScreenState();
}

class _PublicUserProfileScreenState
    extends ConsumerState<PublicUserProfileScreen> {
  Map<String, dynamic>? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  // =========================
  // Charger profil public
  // =========================
  Future<void> loadUserProfile() async {
    try {
      final token =
          ref.read(authControllerProvider).accessToken;

      final response = await http.get(
        Uri.parse(
          // IMPORTANT:
          // utilise ta nouvelle route backend publique
          "${Env.baseUrl}/users/public/${widget.userId}",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 &&
          data["success"] == true) {
        setState(() {
          user = data["data"];
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur profil public: $e");

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  // =========================
  // Appeler utilisateur
  // =========================
  Future<void> callUser(String phone) async {
    try {
      final Uri uri = Uri(
        scheme: "tel",
        path: phone,
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        debugPrint("Impossible d'appeler");
      }
    } catch (e) {
      debugPrint("Erreur appel: $e");
    }
  }

  // =========================
  // Ouvrir chat
  // =========================
  Future<void> openChat() async {
    try {
      final token =
          ref.read(authControllerProvider).accessToken;

      final response = await http.post(
        Uri.parse(
          "${Env.baseUrl}${ApiEndpoints.createConversation}",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "user2": widget.userId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["success"] != true) {
        debugPrint("Erreur création conversation");
        return;
      }

      final conversation = data["data"];

      if (!mounted) return;

      context.push(
        "/chat/${conversation["id_conversation"]}",
        extra: {
          "fullName":
              "${user?["nom"] ?? ""} ${user?["prenom"] ?? ""}",
          "otherUserId": widget.userId,
        },
      );
    } catch (e) {
      debugPrint("Erreur ouverture chat: $e");
    }
  }

  Widget infoTile(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullName =
        "${user?["nom"] ?? ""} ${user?["prenom"] ?? ""}";

    final phone =
        user?["telephone"]?.toString() ?? "--";

    final bloodGroup =
        user?["groupe_sanguin"]?.toString() ?? "--";

    final status =
        user?["statut_groupe_sanguin"]?.toString() ?? "--";

    final distance =
        user?["distance_km"] != null
            ? "${user!["distance_km"]} km"
            : "--";

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Profil utilisateur"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : user == null
              ? const Center(
                  child: Text(
                    "Utilisateur introuvable",
                  ),
                )
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            Colors.red.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        fullName,
                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // téléphone
                      infoTile(
                        Icons.phone,
                        "Téléphone",
                        phone,
                      ),

                      // distance
                      infoTile(
                        Icons.location_on,
                        "Distance",
                        distance,
                      ),

                      // groupe sanguin
                      infoTile(
                        Icons.bloodtype,
                        "Groupe sanguin",
                        bloodGroup,
                      ),

                      // statut
                      infoTile(
                        Icons.verified,
                        "Statut",
                        status,
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child:
                                ElevatedButton.icon(
                              onPressed:
                                  phone == "--"
                                      ? null
                                      : () =>
                                          callUser(
                                            phone,
                                          ),
                              icon:
                                  const Icon(
                                Icons.call,
                              ),
                              label:
                                  const Text(
                                "Appeler",
                              ),
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    Colors
                                        .green,
                                foregroundColor:
                                    Colors
                                        .white,
                                padding:
                                    const EdgeInsets
                                        .all(
                                  14,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child:
                                ElevatedButton.icon(
                              onPressed:
                                  openChat,
                              icon:
                                  const Icon(
                                Icons.message,
                              ),
                              label:
                                  const Text(
                                "Message",
                              ),
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    Colors.red,
                                foregroundColor:
                                    Colors.white,
                                padding:
                                    const EdgeInsets
                                        .all(
                                  14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}