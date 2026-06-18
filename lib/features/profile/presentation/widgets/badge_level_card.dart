import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class BadgeLevelCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool unlocked;

  const BadgeLevelCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.unlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBg =
        isDark ? colors.surface : Colors.white;

    final Color textPrimary =
        isDark ? colors.onSurface : Colors.black;

    final Color textSecondary =
        isDark
            ? colors.onSurface.withOpacity(0.7)
            : Colors.grey[700]!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: cardBg,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: unlocked
              ? color.withOpacity(isDark ? 0.35 : 0.20)
              : isDark
                  ? colors.outline.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.08),
        ),

        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : Colors.black.withOpacity(0.03),

            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          /// ICON
          Container(
            height: 52,
            width: 52,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: unlocked
                  ? color.withOpacity(isDark ? 0.20 : 0.12)
                  : isDark
                      ? colors.surfaceContainerHighest
                      : Colors.grey.withOpacity(0.08),
            ),

            child: Icon(
              unlocked ? icon : Icons.lock_rounded,

              color: unlocked ? color : textSecondary,

              size: 24,
            ),
          ),

          const SizedBox(height: 14),

          /// TITLE
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: unlocked ? textPrimary : textSecondary,
            ),
          ),

          const SizedBox(height: 6),

          /// DESCRIPTION
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 12,
              height: 1.3,
              color: textSecondary,
            ),
          ),

          const SizedBox(height: 14),

          /// STATUS
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: unlocked
                  ? color.withOpacity(isDark ? 0.20 : 0.12)
                  : isDark
                      ? colors.surfaceContainerHighest
                      : Colors.grey.withOpacity(0.10),

              borderRadius: BorderRadius.circular(30),
            ),

            child: Text(
              unlocked ? l10n.unlocked : l10n.locked,

              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: unlocked ? color : textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}