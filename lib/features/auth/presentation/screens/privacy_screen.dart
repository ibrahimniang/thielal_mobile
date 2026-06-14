import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Politique de confidentialité"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Politique de confidentialité de Thièlal",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 6),

            Text(
              "Dernière mise à jour : Juin 2026",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 20),

            _sectionTitle("1. Introduction"),
            _paragraph(
              "La présente Politique de confidentialité décrit la manière dont Thièlal collecte, "
              "utilise, conserve et protège les données personnelles des utilisateurs. "
              "En utilisant l’application, l’utilisateur accepte les pratiques décrites ci-dessous."
            ),

            _sectionTitle("2. Données collectées"),
            _paragraph(
              "Thièlal peut collecter plusieurs types de données nécessaires au bon fonctionnement du service :"
              "\n\n"
              "• Nom et prénom\n"
              "• Numéro de téléphone\n"
              "• Groupe sanguin\n"
              "• Localisation approximative ou précise (si autorisée)\n"
              "• Historique des dons de sang\n"
              "• Identifiant QR Code utilisateur\n"
              "• Données techniques (type d’appareil, version, logs)"
            ),

            _sectionTitle("3. Finalité de la collecte"),
            _paragraph(
              "Les données collectées sont utilisées exclusivement pour :"
              "\n\n"
              "• Identifier les donneurs de sang compatibles\n"
              "• Localiser les centres de santé proches\n"
              "• Gérer les urgences sanitaires\n"
              "• Assurer la sécurité du système\n"
              "• Générer des statistiques nationales anonymisées"
            ),

            _sectionTitle("4. Utilisation de la localisation"),
            _paragraph(
              "La localisation est utilisée uniquement pour améliorer la rapidité et l’efficacité du service. "
              "Elle permet de rapprocher les donneurs et les patients en cas d’urgence."
            ),
            _paragraph(
              "L’utilisateur peut :\n"
              "• Autoriser une seule fois\n"
              "• Autoriser uniquement pendant l’utilisation\n"
              "• Refuser complètement l’accès"
            ),
            _paragraph(
              "Aucune donnée de localisation n’est vendue ou utilisée à des fins commerciales."
            ),

            _sectionTitle("5. Partage des données"),
            _paragraph(
              "Les données peuvent être partagées uniquement avec :"
              "\n\n"
              "• Les hôpitaux partenaires\n"
              "• Les centres de transfusion sanguine\n"
              "• Les autorités sanitaires compétentes"
            ),
            _paragraph(
              "Aucune donnée personnelle n’est vendue, louée ou utilisée par des tiers non autorisés."
            ),

            _sectionTitle("6. Données médicales"),
            _paragraph(
              "Les informations liées au groupe sanguin et aux dons sont considérées comme sensibles. "
              "Elles sont traitées avec un haut niveau de sécurité et ne sont accessibles qu’aux établissements autorisés."
            ),

            _sectionTitle("7. QR Code et identification"),
            _paragraph(
              "Chaque utilisateur possède un QR Code unique permettant l’identification sécurisée lors des dons. "
              "Ce QR Code est utilisé uniquement dans les centres de santé partenaires pour valider les dons."
            ),

            _sectionTitle("8. Conservation des données"),
            _paragraph(
              "Les données sont conservées uniquement pendant la durée nécessaire au fonctionnement du service. "
              "Les comptes inactifs peuvent être supprimés après une période définie."
            ),
            _paragraph(
              "Certaines données anonymisées peuvent être conservées pour des statistiques nationales."
            ),

            _sectionTitle("9. Sécurité des données"),
            _paragraph(
              "Thièlal utilise des mesures de sécurité avancées pour protéger les données contre :"
              "\n\n"
              "• accès non autorisé\n"
              "• perte de données\n"
              "• modification illégale\n"
              "• cyberattaques"
            ),
            _paragraph(
              "Les données sensibles sont chiffrées et protégées par des protocoles sécurisés."
            ),

            _sectionTitle("10. Droits de l’utilisateur"),
            _paragraph(
              "L’utilisateur dispose des droits suivants :"
              "\n\n"
              "• accès à ses données\n"
              "• modification des informations\n"
              "• suppression du compte\n"
              "• retrait du consentement"
            ),

            _paragraph(
              "La suppression du compte entraîne l’effacement des données personnelles, "
              "sauf obligations légales ou statistiques anonymisées."
            ),

            _sectionTitle("11. Consentement"),
            _paragraph(
              "L’utilisation de Thièlal implique un consentement explicite de l’utilisateur "
              "concernant la collecte et l’utilisation de ses données."
            ),

            _sectionTitle("12. Données des mineurs"),
            _paragraph(
              "L’application est strictement réservée aux personnes âgées de 18 ans et plus. "
              "Aucune donnée de mineur n’est volontairement collectée."
            ),

            _sectionTitle("13. Services tiers"),
            _paragraph(
              "L’application peut utiliser des services tiers tels que :"
              "\n\n"
              "• Firebase (notifications)\n"
              "• Google Maps (localisation)\n"
              "• SMS OTP (authentification)"
            ),

            _sectionTitle("14. Modifications"),
            _paragraph(
              "Cette politique peut être mise à jour à tout moment pour des raisons légales ou techniques. "
              "Les utilisateurs seront informés en cas de changement important."
            ),

            _sectionTitle("15. Contact"),
            _paragraph(
              "Pour toute question concernant la protection des données, l’utilisateur peut contacter "
              "l’équipe Thièlal via les canaux officiels de l’application."
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 26, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15.5,
          height: 1.8,
        ),
      ),
    );
  }
}