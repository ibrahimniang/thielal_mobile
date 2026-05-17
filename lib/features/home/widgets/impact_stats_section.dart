import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
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

  Widget _buildCard({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(22),
        ),

        child: Column(
          children: [
            Text(
              value,

              style: const TextStyle(
                fontSize: 24,

                fontWeight: FontWeight.w900,

                color: AppColors.primaryRed,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 13),
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
        _buildCard(title: l10n.savedLives, value: totalLives.toString()),

        const SizedBox(width: 12),

        _buildCard(title: l10n.activeCenters, value: activeCenters.toString()),

        const SizedBox(width: 12),

        _buildCard(
          title: l10n.urgentRequests,

          value: urgentRequests.toString(),
        ),
      ],
    );
  }
}
