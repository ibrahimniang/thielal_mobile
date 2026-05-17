//1
import 'package:flutter/material.dart';
import 'profile_section_card.dart';
import '../../../../l10n/app_localizations.dart';

class BloodCompatibilityCard extends StatelessWidget {
  final List<String> groups;

  const BloodCompatibilityCard({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ProfileSectionCard(
      title: l10n.bloodCompatibility,
      icon: Icons.bloodtype_rounded,
      child:
          groups.isEmpty
              ? Text(l10n.noDataAvailable)
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
