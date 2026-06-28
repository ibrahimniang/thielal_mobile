import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text("Politique de confidentialité"),
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
                  colors.primary.withOpacity(0.75),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 70,
                ),
                const SizedBox(height: 10),
                Text(
                  "Thièlal / Life-Link",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Politique de confidentialité",
                  style: TextStyle(
                    color: colors.onPrimary.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Dernière mise à jour : Juin 2026",
                  style: TextStyle(
                    color: colors.onPrimary.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _card(context, "1. Introduction",
              "Cette politique décrit comment Thièlal collecte et protège vos données."),

          _card(context, "2. Données collectées",
              "Nom, téléphone, groupe sanguin, localisation, historique des dons, QR code, données techniques."),

          _card(context, "3. Finalité",
              "Identifier les donneurs compatibles, gérer les urgences et améliorer le service."),

          _card(context, "4. Localisation",
              "Utilisée uniquement pour connecter donneurs et patients rapidement. Jamais vendue."),

          _card(context, "5. Partage des données",
              "Uniquement avec hôpitaux et centres de transfusion autorisés."),

          _card(context, "6. Données médicales",
              "Données sensibles protégées et accessibles uniquement aux établissements agréés."),

          _card(context, "7. QR Code",
              "Chaque utilisateur possède un QR unique utilisé pour valider les dons."),

          _card(context, "8. Conservation",
              "Données conservées uniquement le temps nécessaire au service."),

          _card(context, "9. Sécurité",
              "Chiffrement et protection contre les accès non autorisés et cyberattaques."),

          _card(context, "10. Droits utilisateur",
              "Accès, modification, suppression et retrait de consentement."),

          _card(context, "11. Consentement",
              "L’utilisation de l’app implique l’acceptation de cette politique."),

          _card(context, "12. Mineurs",
              "Application réservée aux personnes âgées de 18 ans et plus."),

          _card(context, "13. Services tiers",
              "Firebase, Google Maps et services SMS OTP."),

          _card(context, "14. Modifications",
              "La politique peut être mise à jour à tout moment."),

          _card(context, "15. Contact",
              "Contact via les canaux officiels de l’application."),
        ],
      ),
    );
  }

  /// ================= CARD =================
  Widget _card(BuildContext context, String title, String text) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withOpacity(0.2),
        ),
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
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              height: 1.6,
              color: colors.onSurface.withOpacity(0.85),
              fontSize: 14.5,
            ),
          ),
        ],
      ),
    );
  }
}