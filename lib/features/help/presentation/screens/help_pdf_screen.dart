import 'package:flutter/material.dart';

class HelpPdfScreen extends StatelessWidget {
  const HelpPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text("Aide Life-Link"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// ================= HEADER =================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.primary.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Image.asset('assets/images/logo.png', height: 70),
                const SizedBox(height: 10),
                Text(
                  "Life-Link (Thiéllal)",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Guide d'utilisation complet",
                  style: TextStyle(
                    color: colors.onPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _card(context, "1. Introduction",
              "Life-Link permet de connecter donneurs et patients rapidement pour sauver des vies."),

          _card(context, "2. Connexion et inscription",
              "Connexion par téléphone ou email avec OTP pour sécuriser le compte."),

          _card(context, "3. Profil utilisateur",
              "Modifier vos informations personnelles (ville, quartier, groupe sanguin)."),

          _card(context, "4. Dons de sang",
              "Chaque don vous rapporte des points et badges (Bronze → Élite)."),

          _card(context, "5. Chat & communication",
              "Discutez et appelez directement les donneurs proches."),

          /// ================= NOTIFICATIONS =================
          _card(
            context,
            "6. Notifications",
            "",
            extra: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bullet(context, "📲 Notifications in-app"),
                _bullet(context, "🔔 Push Firebase"),
                _bullet(context, "📩 SMS urgence"),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.red.withOpacity(0.15)
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    "🚨 URGENT : Une personne a besoin de sang (O+, A-, etc). "
                    "Ouvrez l’app immédiatement pour participer.",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.red.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Les utilisateurs compatibles dans la même ville reçoivent automatiquement les alertes.",
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          _card(context, "7. Participation",
              "",
              extra: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bullet(context, "✔ Participer à une demande"),
                  _bullet(context, "💬 Envoyer un message"),
                  _bullet(context, "👤 Voir le profil"),

                  const SizedBox(height: 8),

                  Text(
                    "Le bouton message ouvre directement le chat.",
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
          ),

          _card(context, "8. Conclusion",
              "Life-Link connecte les donneurs en temps réel pour sauver des vies."),
        ],
      ),
    );
  }

  /// ================= CARD =================
  Widget _card(BuildContext context, String title, String text, {Widget? extra}) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                height: 1.5,
                color: colors.onSurface.withOpacity(0.85),
              ),
            ),
          ],
          if (extra != null) ...[
            const SizedBox(height: 10),
            extra,
          ]
        ],
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.brightness_1, size: 6, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}