import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/profile_controller.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Carte Donneur Médicale'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Erreur: $e")),

        data: (user) {
          if (user == null) {
            return const Center(child: Text("Aucun profil"));
          }

          final compatibleGroups = _getCompatibleGroups(
            user.groupeSanguin ?? '',
          );
          final points = user.points ?? 0;
          final badge = _getBadge(points);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ================= CARTE DONNEUR =================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.red, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.health_and_safety,
                        size: 45,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        user.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Groupe sanguin: ${user.groupeSanguin ?? '--'}",
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 10),

                      // STATUS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              user.profilComplet ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.profilComplet
                              ? "Donneur vérifié"
                              : "En attente de validation",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // POINTS
                      Text(
                        "Points: $points",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Niveau: $badge",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ================= QR CODE =================
                if (user.qrCode != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Carte QR Donneur",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Image.network(
                            user.qrCode!,
                            height: 150,
                            errorBuilder:
                                (_, __, ___) =>
                                    const Icon(Icons.qr_code, size: 100),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // ================= BADGES =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _badge(Icons.emoji_events, "Bronze", Colors.brown),
                    _badge(Icons.emoji_events, "Argent", Colors.grey),
                    _badge(Icons.emoji_events, "Or", Colors.amber),
                  ],
                ),

                const SizedBox(height: 20),

                // ================= COMPATIBILITÉ =================
                _sectionCard(
                  title: "Compatibilité sanguine",
                  child: Wrap(
                    spacing: 8,
                    children:
                        compatibleGroups
                            .map(
                              (g) => Chip(
                                label: Text(g),
                                backgroundColor: Colors.red.shade100,
                              ),
                            )
                            .toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= HISTORIQUE DONS =================
                _sectionCard(
                  title: "Historique de dons",
                  child: Column(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.bloodtype, color: Colors.red),
                        title: Text("Don de sang"),
                        subtitle: Text("12 Mars 2026"),
                      ),
                      ListTile(
                        leading: Icon(Icons.bloodtype, color: Colors.red),
                        title: Text("Don de sang"),
                        subtitle: Text("20 Janvier 2026"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ================= ACTION =================
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                  child: const Text("Modifier profil"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _badge(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // ================= LOGIQUE =================

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
