import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conditions d'utilisation"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Conditions générales d'utilisation de Thièlal",
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

            _sectionTitle("1. Introduction générale"),
            _paragraph(
              "Thièlal est une plateforme numérique nationale dédiée à la gestion, "
              "la coordination et l’optimisation du don de sang en République Islamique de Mauritanie. "
              "Elle est conçue pour répondre aux besoins urgents des établissements de santé, "
              "des patients et des donneurs volontaires."
            ),
            _paragraph(
              "L’objectif principal de Thièlal est de réduire le temps de réponse lors des urgences médicales "
              "liées au sang, tout en améliorant la traçabilité et la transparence des dons."
            ),

            _sectionTitle("2. Acceptation des conditions"),
            _paragraph(
              "En accédant ou en utilisant l’application Thièlal, l’utilisateur reconnaît avoir lu, "
              "compris et accepté l’intégralité des présentes conditions. "
              "Ces conditions constituent un accord légal entre l’utilisateur et la plateforme Thièlal."
            ),
            _paragraph(
              "Si l’utilisateur n’accepte pas ces conditions, il est tenu de ne pas utiliser l’application "
              "et de supprimer immédiatement son compte s’il en possède un."
            ),

            _sectionTitle("3. Âge minimum obligatoire (18 ans)"),
            _paragraph(
              "L’utilisation de l’application Thièlal est strictement réservée aux personnes âgées de 18 ans ou plus. "
              "Cette condition est obligatoire et non négociable."
            ),
            _paragraph(
              "Lors de l’inscription, l’utilisateur déclare sur l’honneur être majeur. "
              "Toute fausse déclaration constitue une violation grave des présentes conditions."
            ),
            _paragraph(
              "Thièlal se réserve le droit de demander une vérification supplémentaire en cas de doute "
              "sur l’âge déclaré de l’utilisateur."
            ),

            _sectionTitle("4. Création de compte"),
            _paragraph(
              "La création de compte nécessite des informations exactes, complètes et vérifiables. "
              "Ces informations incluent notamment le nom complet, le numéro de téléphone, "
              "le groupe sanguin et la localisation approximative."
            ),
            _paragraph(
              "L’utilisateur s’engage à maintenir ses informations à jour afin de garantir "
              "la qualité du service."
            ),

            _sectionTitle("5. Responsabilité du compte"),
            _paragraph(
              "L’utilisateur est entièrement responsable de son compte et de toute activité effectuée "
              "à partir de celui-ci. La confidentialité des identifiants doit être strictement maintenue."
            ),
            _paragraph(
              "Toute utilisation frauduleuse ou non autorisée doit être signalée immédiatement à l’équipe Thièlal."
            ),

            _sectionTitle("6. Authentification sécurisée"),
            _paragraph(
              "L’accès à l’application est sécurisé par un système OTP envoyé par SMS. "
              "Ce système garantit que seul le propriétaire du numéro peut accéder au compte."
            ),
            _paragraph(
              "L’utilisateur s’engage à ne jamais partager ses codes de vérification."
            ),

            _sectionTitle("7. Utilisation de la localisation"),
            _paragraph(
              "Thièlal peut demander l’accès à la localisation de l’utilisateur afin d’améliorer les services."
            ),
            _paragraph(
              "Cette localisation permet :"
              "\n• la recherche de donneurs compatibles"
              "\n• la localisation des centres de santé"
              "\n• la gestion des urgences sanitaires"
            ),
            _paragraph(
              "L’utilisateur peut choisir entre : autorisation unique, autorisation en utilisation, ou refus total."
            ),
            _paragraph(
              "La localisation n’est jamais utilisée à des fins commerciales ou publicitaires."
            ),

            _sectionTitle("8. Système de don de sang"),
            _paragraph(
              "Chaque utilisateur possède un identifiant unique sous forme de QR Code sécurisé."
            ),
            _paragraph(
              "Ce QR Code permet l’identification dans les centres de santé partenaires."
            ),
            _paragraph(
              "Lorsqu’un don est effectué, le personnel médical scanne le QR Code pour :"
              "\n• valider le don"
              "\n• enregistrer la date"
              "\n• mettre à jour le statut médical"
              "\n• générer un certificat numérique"
              "\n• alimenter les statistiques nationales"
            ),

            _sectionTitle("9. Historique médical"),
            _paragraph(
              "L’application conserve un historique des dons effectués. "
              "Ces données sont utilisées uniquement pour le suivi médical et statistique."
            ),

            _sectionTitle("10. Fonction d’urgence"),
            _paragraph(
              "Le bouton d’urgence permet d’alerter rapidement les donneurs compatibles."
            ),
            _paragraph(
              "Cette fonctionnalité doit être utilisée uniquement en cas de besoin réel."
            ),
            _paragraph(
              "Toute utilisation abusive peut entraîner une suspension immédiate du compte."
            ),

            _sectionTitle("11. Comportement utilisateur"),
            _paragraph(
              "L’utilisateur s’engage à respecter les règles suivantes :"
              "\n• aucune fraude"
              "\n• aucun faux signalement"
              "\n• aucun harcèlement"
              "\n• aucun abus du système"
            ),
            _paragraph(
              "Tout comportement contraire entraîne des sanctions."
            ),

            _sectionTitle("12. Sanctions"),
            _paragraph(
              "En cas de non-respect des présentes conditions, Thièlal peut :"
              "\n• suspendre le compte"
              "\n• supprimer le compte"
              "\n• bloquer définitivement l’accès"
            ),

            _sectionTitle("13. Responsabilité médicale"),
            _paragraph(
              "Thièlal n’est pas un service médical. "
              "Les décisions médicales sont prises uniquement par les professionnels de santé."
            ),

            _sectionTitle("14. Données personnelles"),
            _paragraph(
              "Les données sont protégées et utilisées uniquement pour le fonctionnement du service."
            ),
            _paragraph(
              "Aucune donnée n’est vendue à des tiers."
            ),

            _sectionTitle("15. Consentement"),
            _paragraph(
              "L’utilisateur donne son consentement explicite lors de l’inscription."
            ),

            _sectionTitle("16. Modification des conditions"),
            _paragraph(
              "Les conditions peuvent être modifiées à tout moment."
            ),

            _sectionTitle("17. Contact"),
            _paragraph(
              "Pour toute question, l’utilisateur peut contacter le support Thièlal."
            ),

            const SizedBox(height: 40),
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
      padding: const EdgeInsets.only(bottom: 10),
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