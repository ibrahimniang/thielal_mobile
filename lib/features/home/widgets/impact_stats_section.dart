import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class ImpactStatsSection extends StatelessWidget {
  final int totalLives;
  final int activeCenters;
  final int urgentRequests;

  const ImpactStatsSection({
    super.key,
    required this.totalLives,
    required this.activeCenters,
    required this.urgentRequests,
  });

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
        ),

        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        _buildCard(
          context,
          title: l10n.savedLives,
          value: totalLives.toString(),
        ),

        const SizedBox(width: 12),

        _buildCard(
          context,
          title: l10n.activeCenters,
          value: activeCenters.toString(),
        ),

        const SizedBox(width: 12),

        _buildCard(
          context,
          title: l10n.urgentRequests,
          value: urgentRequests.toString(),
        ),
      ],
    );
  }
}