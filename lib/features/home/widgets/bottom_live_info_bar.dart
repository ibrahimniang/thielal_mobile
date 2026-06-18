import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class BottomLiveInfoBar extends StatelessWidget {
  final int livesSaved;
  final int activeDonors;

  const BottomLiveInfoBar({
    super.key,
    required this.livesSaved,
    required this.activeDonors,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        24,
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

            decoration: BoxDecoration(
              color: isDark
                  ? colorScheme.surface.withOpacity(0.75)
                  : Colors.white.withOpacity(0.92),

              borderRadius: BorderRadius.circular(22),

              border: Border.all(
                color: isDark
                    ? colorScheme.outline.withOpacity(0.3)
                    : Colors.white.withOpacity(0.5),
              ),

              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.35)
                      : Colors.black.withOpacity(0.05),

                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Row(
              children: [
                /// ICON
                Container(
                  height: 56,
                  width: 56,

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              colorScheme.primary.withOpacity(0.9),
                              colorScheme.primary.withOpacity(0.7),
                            ]
                          : const [
                              Color(0xFFE53946),
                              Color(0xFFC1121F),
                            ],
                    ),

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 16),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        '$livesSaved ${l10n.livesSavedToday}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '$activeDonors ${l10n.activeDonorsInYourArea}',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          height: 1.4,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}