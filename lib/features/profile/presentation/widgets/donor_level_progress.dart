import 'package:flutter/material.dart';

// import '../../../../app/theme/app_colors.dart';
// import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
class DonorLevelProgress extends StatelessWidget {
  final int points;

  const DonorLevelProgress({
    super.key,
    required this.points,
  });

  String get level {
    if (points >= 500) {
      return 'Elite';
    }

    if (points >= 250) {
      return 'Or';
    }

    if (points >= 100) {
      return 'Argent';
    }

    return 'Bronze';
  }

  double get progress {
    if (points >= 500) {
      return 1;
    }

    return points / 500;
  }

  Color get levelColor {
    if (points >= 500) {
      return Colors.purple;
    }

    if (points >= 250) {
      return Colors.amber;
    }

    if (points >= 100) {
      return Colors.grey;
    }

    return const Color(0xFFB45309);
  }
  String localizedLevel(
  BuildContext context,
) {
  final l10n =
      AppLocalizations.of(context)!;

  if (points >= 500) {
    return l10n.elite;
  }

  if (points >= 250) {
    return l10n.gold;
  }

  if (points >= 100) {
    return l10n.silver;
  }

  return l10n.bronze;
}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),

      decoration: BoxDecoration(
  gradient: isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF161B4B),
            Color(0xFF232A67),
          ],
        )
      : null,

  color: isDark ? null : Colors.white,

        borderRadius: BorderRadius.circular(
          28,
        ),

        boxShadow: [
          BoxShadow(
           color: isDark
            ? const Color(0xFF161B4B).withValues(alpha: 0.45)
            : Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          /// TOP
          Row(
            children: [
              Container(
                height: 58,
                width: 58,

                decoration: BoxDecoration(
                  color: levelColor.withValues(
                  alpha: isDark ? 0.20 : 0.10,
                ),

                  borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                ),

                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: levelColor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                     '${l10n.level} ${localizedLevel(context)}',

                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                   ),

                    const SizedBox(height: 6),

                    Text(
                      '$points ${l10n.donorPoints}',

                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey[700],

                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// PROGRESS
          ClipRRect(
            borderRadius:
                BorderRadius.circular(30),

            child: LinearProgressIndicator(
              value: progress,

              minHeight: 14,

              backgroundColor:
              isDark
                  ? Colors.white.withValues(alpha: 0.18)
                  : Colors.grey.withValues(alpha: 0.10),

              valueColor:
                  AlwaysStoppedAnimation(
                    levelColor,
                  ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            '${(progress * 100).toInt()}% ${l10n.donorProgression}',

            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}