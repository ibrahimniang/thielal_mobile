import 'package:flutter/material.dart';
import 'profile_section_card.dart';
import '../../../../l10n/app_localizations.dart';

class BloodCompatibilityCard extends StatelessWidget {
  final List<String> groups;

  const BloodCompatibilityCard({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ProfileSectionCard(
      title: l10n.bloodCompatibility,
      icon: Icons.bloodtype_rounded,
      child: groups.isEmpty
          ? Text(
              l10n.noDataAvailable,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.7),
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: groups.map((g) {
                return Chip(
                  label: Text(
                    g,
                    style: TextStyle(
                      color: isDark
                          ? colors.onSurface
                          : colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  backgroundColor: isDark
                      ? colors.surface.withOpacity(0.6)
                      : colors.primary.withOpacity(0.12),

                  side: BorderSide(
                    color: isDark
                        ? colors.outline.withOpacity(0.3)
                        : colors.primary.withOpacity(0.25),
                  ),
                );
              }).toList(),
            ),
    );
  }
}