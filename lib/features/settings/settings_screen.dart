import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import '../../app/router/app_router.dart';
import '../../app/router/route_names.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Paramètres"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= COMPTE =================
          _sectionTitle("Compte"),

          _tile(
            icon: Icons.person,
            title: "Mon profil",
            onTap: () => context.go(RouteNames.profile),
          ),

          _tile(icon: Icons.lock, title: "Changer mot de passe", onTap: () {}),

          const SizedBox(height: 20),

          // ================= APP =================
          _sectionTitle("Application"),

          _tile(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () {},
          ),

          _tile(icon: Icons.language, title: "Langue", onTap: () {}),

          const SizedBox(height: 20),

          // ================= DON =================
          _sectionTitle("Don de sang"),

          _tile(icon: Icons.bloodtype, title: "Mes dons", onTap: () {}),

          _tile(icon: Icons.location_on, title: "Centres de don", onTap: () {}),

          const SizedBox(height: 30),

          // ================= LOGOUT =================
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              // 👉 à connecter avec ton authController
              context.go(RouteNames.loginUser);
            },
            child: const Text("Se déconnecter"),
          ),
        ],
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
