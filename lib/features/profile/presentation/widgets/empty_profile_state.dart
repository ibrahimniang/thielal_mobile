import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class EmptyProfileState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onActionTap;
  final String? actionText;

  const EmptyProfileState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onActionTap,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            /// ICON
            Container(
              height: 120,
              width: 120,

              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(
                  isDark ? 0.12 : 0.08,
                ),

                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                size: 58,
                color: AppColors.primaryRed,
              ),
            ),

            const SizedBox(height: 28),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 16),

            /// SUBTITLE
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? colors.onSurface.withOpacity(0.7)
                    : Colors.grey[700],

                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),

            if (onActionTap != null && actionText != null) ...[
              const SizedBox(height: 32),

              GestureDetector(
                onTap: onActionTap,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 18,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,

                    borderRadius: BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRed.withOpacity(
                          isDark ? 0.15 : 0.25,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Text(
                    actionText!,

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}