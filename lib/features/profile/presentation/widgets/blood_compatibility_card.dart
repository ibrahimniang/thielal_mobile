import 'package:flutter/material.dart';
import 'profile_section_card.dart';

class BloodCompatibilityCard extends StatelessWidget {
  final List<String> groups;

  const BloodCompatibilityCard({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'Compatibilité sanguine',
      icon: Icons.bloodtype_rounded,
      child:
          groups.isEmpty
              ? const Text('Aucune donnée disponible')
              : Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    groups
                        .map(
                          (g) => Chip(
                            label: Text(g),
                            backgroundColor: Colors.red.shade100,
                            side: BorderSide(color: Colors.red.shade200),
                          ),
                        )
                        .toList(),
              ),
    );
  }
}
