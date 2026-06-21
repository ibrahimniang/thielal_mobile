import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';

class BloodGroupChip extends StatelessWidget {
  final String bloodGroup;
  final bool verified;
  final bool large;

  const BloodGroupChip({
    super.key,
    required this.bloodGroup,
    this.verified = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = colors.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 18 : 12,
        vertical: large ? 10 : 6,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? colors.surface.withOpacity(0.6)
            : baseColor.withOpacity(0.08),

        borderRadius: BorderRadius.circular(
          large ? 40 : AppRadius.xl,
        ),

        border: Border.all(
          color: isDark
              ? colors.outline.withOpacity(0.3)
              : baseColor.withOpacity(0.18),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bloodtype_rounded,
            size: large ? 20 : 16,
            color: isDark ? colors.onSurface : baseColor,
          ),

          SizedBox(width: large ? 8 : 6),

          Text(
            bloodGroup,
            style: TextStyle(
              color: isDark ? colors.onSurface : baseColor,
              fontWeight: FontWeight.w800,
              fontSize: large ? 16 : 13,
            ),
          ),

          if (verified) ...[
            SizedBox(width: large ? 10 : 6),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),

              decoration: BoxDecoration(
                color: isDark
                    ? Colors.green.withOpacity(0.18)
                    : Colors.green.withOpacity(0.12),

                borderRadius: BorderRadius.circular(30),

                border: Border.all(
                  color: Colors.green.withOpacity(0.35),
                ),
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    l10n.verified,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}