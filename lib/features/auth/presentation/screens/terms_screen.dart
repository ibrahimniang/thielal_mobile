import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text("Conditions d'utilisation"),
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
                  "Conditions générales d'utilisation",
                  style: TextStyle(
                    color: colors.onPrimary.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Dernière mise à jour : Juin 2026",
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _card(context, "1. Introduction générale",
              "Thièlal est une plateforme nationale dédiée à la coordination du don de sang en Mauritanie."),

          _card(context, "2. Acceptation des conditions",
              "L’utilisation de l’application implique l’acceptation totale des présentes conditions."),

          _card(context, "3. Âge minimum (18+)",
              "L’application est strictement réservée aux personnes majeures. Toute fausse déclaration est interdite."),

          _card(context, "4. Création de compte",
              "Les informations doivent être exactes et mises à jour régulièrement."),

          _card(context, "5. Responsabilité du compte",
              "L’utilisateur est responsable de son compte et de toute activité associée."),

          _card(context, "6. Authentification OTP",
              "Connexion sécurisée par SMS OTP, ne jamais partager les codes."),

          _card(context, "7. Localisation",
              "Utilisée uniquement pour connecter donneurs et patients. Jamais commerciale."),

          _card(context, "8. Don de sang & QR Code",
              "Chaque utilisateur possède un QR unique pour valider les dons en centre médical."),

          _card(context, "9. Historique médical",
              "Suivi des dons uniquement pour usage médical et statistique."),

          _card(context, "10. Urgences",
              "Fonction d’alerte réservée aux situations réelles uniquement."),

          _card(context, "11. Comportement utilisateur",
              "Interdiction de fraude, harcèlement ou abus du système."),

          _card(context, "12. Sanctions",
              "Suspension ou suppression de compte en cas de violation."),

          _card(context, "13. Responsabilité médicale",
              "Thièlal n’est pas un service médical, les décisions appartiennent aux professionnels."),

          _card(context, "14. Données personnelles",
              "Aucune donnée n’est vendue. Protection stricte des informations."),

          _card(context, "15. Consentement",
              "L’utilisateur accepte explicitement les conditions lors de l’inscription."),

          _card(context, "16. Modification",
              "Les conditions peuvent être mises à jour à tout moment."),

          _card(context, "17. Contact",
              "Support accessible via les canaux officiels de l’application."),
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
              fontSize: 14.5,
              color: colors.onSurface.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}