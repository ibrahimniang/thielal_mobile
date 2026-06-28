import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class MedicalInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final VoidCallback? onTap;

  const MedicalInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color effectiveIconColor =
        iconColor ?? AppColors.primaryRed;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(
          bottom: AppSpacing.md,
        ),

        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),

        decoration: BoxDecoration(
          color: isDark ? colors.surface : Colors.white,

          borderRadius: BorderRadius.circular(
            AppRadius.xl,
          ),

          border: isDark
              ? Border.all(
                  color: colors.outline.withOpacity(0.2),
                )
              : null,

          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.25)
                  : Colors.black.withOpacity(0.04),

              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Row(
          children: [
            /// ICON
            Container(
              height: 52,
              width: 52,

              decoration: BoxDecoration(
                color: effectiveIconColor.withOpacity(
                  isDark ? 0.15 : 0.10,
                ),

                borderRadius: BorderRadius.circular(18),
              ),

              child: Icon(
                icon,
                color: effectiveIconColor,
              ),
            ),

            const SizedBox(width: 16),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isDark
                          ? colors.onSurface.withOpacity(0.7)
                          : Colors.grey[600],

                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isDark
                    ? colors.onSurface.withOpacity(0.5)
                    : Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}