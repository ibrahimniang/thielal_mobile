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
      left: 16,

      right: 90,

      top: 110,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,

              vertical: AppSpacing.md,
            ),

            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.88),

              borderRadius: BorderRadius.circular(AppRadius.xl),

              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.20),

                width: 1.4,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),

                  blurRadius: 18,

                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                /// =========================
                /// ICON
                /// =========================
                Container(
                  height: 46,

                  width: 46,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: LinearGradient(
                      begin: Alignment.topLeft,

                      end: Alignment.bottomRight,

                      colors: [
                        AppColors.primaryRed.withOpacity(0.16),

                        AppColors.primaryRed.withOpacity(0.06),
                      ],
                    ),
                  ),

                  child: const Icon(
                    Icons.local_hospital_rounded,

                    color: AppColors.primaryRed,

                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                /// =========================
                /// TEXTS
                /// =========================
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// TITLE
                      Text(
                        '$centersCount ${l10n.activeCenters}',

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontWeight: FontWeight.w800,

                          fontSize: 14,

                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// CITY
                      Text(
                        city.isEmpty ? l10n.locationLoading : city,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,

                          fontSize: 12,

                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                /// =========================
                /// LIVE DOT
                /// =========================
                Container(
                  height: 10,

                  width: 10,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: Colors.green,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.45),

                        blurRadius: 10,

                        spreadRadius: 2,
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
