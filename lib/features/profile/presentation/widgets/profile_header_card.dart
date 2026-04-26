import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String fullName;
  final String bloodGroup;
  final bool profilComplet;
  final int points;
  final String badge;

  const ProfileHeaderCard({
    super.key,
    required this.fullName,
    required this.bloodGroup,
    required this.profilComplet,
    required this.points,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = profilComplet ? Colors.green : Colors.orange;
    final statusText =
        profilComplet ? 'Groupe sanguin vérifié' : 'En attente de vérification';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Colors.red.shade600,
            Colors.red.shade400,
            Colors.blue.shade500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              size: 34,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            fullName.isEmpty ? 'Utilisateur' : fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Groupe sanguin : $bloodGroup',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              statusText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Points : $points',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text('Niveau : $badge', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
