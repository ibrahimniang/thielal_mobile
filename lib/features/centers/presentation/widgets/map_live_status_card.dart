import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class MapLiveStatusCard extends StatelessWidget {
  final int centersCount;
  final String city;

  const MapLiveStatusCard({
    super.key,
    required this.centersCount,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      left: 18,
      right: 18,
      bottom: 110,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),

              borderRadius: BorderRadius.circular(AppRadius.xl),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),

                  blurRadius: 24,

                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.12),

                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: AppColors.primaryRed,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Text(
                        l10n.availableCenters,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,

                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '$centersCount ${l10n.activeCentersIn} $city',

                        style: const TextStyle(
                          color: AppColors.textSecondary,

                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
