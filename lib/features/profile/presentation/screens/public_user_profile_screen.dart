import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/config/env.dart';
import '../../../../core/config/api_endpoints.dart';
import '../../../auth/application/auth_controller.dart';

class PublicUserProfileScreen extends ConsumerStatefulWidget {
  final int userId;

  const PublicUserProfileScreen({super.key, required this.userId});

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
  // LOAD PROFILE
  // =========================
  Future<void> loadUserProfile() async {
    try {
      final token = ref.read(authControllerProvider).accessToken;

      final response = await http.get(
        Uri.parse("${Env.baseUrl}/users/public/${widget.userId}"),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("PROFILE STATUS => ${response.statusCode}");
      debugPrint("PROFILE BODY => ${response.body}");

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 && data["success"] == true) {
        setState(() {
          user = data["data"];
          loading = false;
        });
      } else {
        setState(() {
          user = null;
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ Erreur profil public: $e");

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  // =========================
  // CALL USER
  // =========================
  Future<void> callUser(String phone) async {
    final Uri uri = Uri(scheme: "tel", path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // =========================
  // CHAT
  // =========================
  Future<void> openChat() async {
    try {
      final token = ref.read(authControllerProvider).accessToken;

      final response = await http.post(
        Uri.parse("${Env.baseUrl}${ApiEndpoints.createConversation}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"user2": widget.userId}),
      );

      final data = jsonDecode(response.body);
      if (data["success"] != true) return;

      final conversation = data["data"];

      if (!mounted) return;

      context.push(
        "/chat/${conversation["id_conversation"]}",
        extra: {
          "fullName": "${user?["prenom"] ?? ""} ${user?["nom"] ?? ""}",
          "otherUserId": widget.userId,
        },
      );
    } catch (e) {
      debugPrint("❌ chat error $e");
    }
  }

  // =========================
  // SAFE VALUE (IMPORTANT)
  // =========================
  String format(dynamic v, String fallback) {
    if (v == null) return fallback;

    final s = v.toString().trim();

    if (s.isEmpty || s == "null") {
      return fallback;
    }

    return s;
  }

  // =========================
  // TILE
  // =========================
  Widget infoTile({
    required IconData icon,
    required String label,
    required dynamic value,
    Color? color,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: (color ?? Colors.red).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color ?? Colors.red, size: 26),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value.toString(),
                  softWrap: true,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fullName = "${user?["prenom"] ?? ""} ${user?["nom"] ?? ""}".trim();

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FB),

      body:
          loading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
              : user == null
              ? Center(
                child: Text(
                  l10n.profileNotFound,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              )
              : SafeArea(
                // 🔥 IMPORTANT: SCROLL GLOBAL
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ================= HEADER =================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFE53946), Color(0xFFC1121F)],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                            bottomRight: Radius.circular(35),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white24,
                              child: Text(
                                fullName.isNotEmpty
                                    ? fullName[0].toUpperCase()
                                    : "?",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              fullName.isEmpty ? l10n.user : fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              format(
                                user?["statut_groupe_sanguin"],
                                l10n.notAvailable,
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      // ================= BODY =================
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            infoTile(
                              icon: Icons.phone,
                              label: l10n.phone,
                              value: format(
                                user?["telephone"],
                                l10n.notAvailable,
                              ),
                              color: Colors.green,
                              isDark: isDark,
                            ),

                            infoTile(
                              icon: Icons.location_on,
                              label: l10n.city,
                              value: format(user?["ville"], l10n.notAvailable),
                              color: Colors.purple,
                              isDark: isDark,
                            ),

                            infoTile(
                              icon: Icons.social_distance,
                              label: l10n.estimatedDistance,
                              value:
                                  user?["distance_km"] == null
                                      ? l10n.notAvailable
                                      : "${user?["distance_km"]} km",
                              color: Colors.orange,
                              isDark: isDark,
                            ),

                            infoTile(
                              icon: Icons.bloodtype,
                              label: l10n.bloodGroup,
                              value: format(
                                user?["groupe_sanguin"],
                                l10n.notAvailable,
                              ),
                              color: Colors.red,
                              isDark: isDark,
                            ),

                            infoTile(
                              icon: Icons.verified,
                              label: l10n.medicalStatus,
                              value: format(
                                user?["statut_groupe_sanguin"],
                                l10n.notAvailable,
                              ),
                              color: Colors.blue,
                              isDark: isDark,
                            ),

                            const SizedBox(height: 30),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () => callUser(
                                          format(
                                            user?["telephone"],
                                            l10n.notAvailable,
                                          ),
                                        ),
                                    icon: const Icon(Icons.call),
                                    label: Text(l10n.call),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: openChat,
                                    icon: const Icon(Icons.message),
                                    label: Text(l10n.message),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE53946),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
