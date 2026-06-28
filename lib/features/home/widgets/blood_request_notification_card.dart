import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class BloodRequestNotificationCard extends StatelessWidget {
  final String bloodGroup;
  final String city;
  final String date;
  final bool isRead;
  final VoidCallback? onTap;

  const BloodRequestNotificationCard({
    super.key,
    required this.bloodGroup,
    required this.city,
    required this.date,
    required this.isRead,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        isRead
            ? (isDark ? colorScheme.surface : Colors.grey.shade100)
            : (isDark ? colorScheme.surfaceVariant : const Color(0xFFE3F2FD));

    final borderColor =
        isRead
            ? (isDark ? colorScheme.outline : Colors.grey.shade300)
            : (isDark ? colorScheme.primary : const Color(0xFF4FC3F7));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: bgColor,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: borderColor),
      ),

      child: Row(
        children: [
          /// ICONE
          Container(
            height: 50,
            width: 50,

            decoration: BoxDecoration(
              color:
                  isDark
                      ? colorScheme.primary.withOpacity(0.15)
                      : const Color(0xFFFFEBEE),

              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.bloodtype,
              color: isDark ? colorScheme.primary : Colors.red,
            ),
          ),

          const SizedBox(width: 16),

          /// TEXTE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "🚨 ${l10n.bloodNeed} $bloodGroup",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  city,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  date,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// BOUTON
          Container(
            margin: const EdgeInsets.only(left: 12),

            child: ElevatedButton(
              onPressed: onTap,

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? colorScheme.primary : const Color(0xFFC1121F),

                foregroundColor: Colors.white,

                minimumSize: const Size(90, 42),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              child: Text(l10n.imGoing),
            ),
          ),
        ],
      ),
    );
  }
}
