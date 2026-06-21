import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  const ProfileSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final colors =
        Theme.of(context).colorScheme;

    return Row(
      children: [
        /// ICON
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primaryRed.withOpacity(0.15)
                : AppColors.primaryRed.withOpacity(0.10),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryRed,
          ),
        ),

        const SizedBox(width: 16),

        /// TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? colors.onSurface
                      : Colors.black,
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 6),

                Text(
                  subtitle!,
                  style: TextStyle(
                    color: isDark
                        ? colors.onSurface.withOpacity(0.7)
                        : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}