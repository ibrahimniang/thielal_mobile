import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class BloodRequestCta extends StatelessWidget {
  final VoidCallback? onTap;

  const BloodRequestCta({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final gradientColors = isDark
        ? [
            colorScheme.primary.withOpacity(0.9),
            colorScheme.primary.withOpacity(0.75),
          ]
        : const [
            Color(0xFFE53946),
            Color(0xFFC1121F),
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),

      child: GestureDetector(
        onTap: onTap,

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(AppSpacing.xl),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),

            borderRadius: BorderRadius.circular(28),

            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.red).withOpacity(0.25),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),

          child: Row(
            children: [
              /// ICON
              Container(
                height: 62,
                width: 62,

                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),

                child: Icon(
                  Icons.bloodtype_rounded,
                  color: colorScheme.onPrimary,
                  size: 34,
                ),
              ),

              const SizedBox(width: 18),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.iNeedBlood,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      l10n.sendUrgentBloodRequest,
                      style: TextStyle(
                        color: colorScheme.onPrimary.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// ARROW
              Container(
                height: 50,
                width: 50,

                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}