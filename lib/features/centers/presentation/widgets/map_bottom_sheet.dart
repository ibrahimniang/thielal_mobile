import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class MapBottomSheet extends StatelessWidget {
  final String centerName;
  final String address;
  final String distance;

  final VoidCallback onDirectionsTap;
  final VoidCallback onCallTap;

  const MapBottomSheet({
    super.key,
    required this.centerName,
    required this.address,
    required this.distance,
    required this.onDirectionsTap,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        110,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HANDLE
          Container(
            height: 5,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 24),

          /// HEADER
          Row(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE53946), Color(0xFFC1121F)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      centerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      address,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// DISTANCE CARD
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.silverBackground,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primaryRed,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    '${l10n.estimatedDistance} : $distance',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCallTap,
                  icon: const Icon(Icons.call_rounded),
                  label: Text(l10n.call),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onDirectionsTap,
                  icon: const Icon(Icons.navigation_rounded),
                  label: Text(l10n.route),
                ),
              ),
            ],
          ),

          const SizedBox(height: 0),
        ],
      ),
    );
  }
}
