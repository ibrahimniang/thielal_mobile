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
    return Row(
      children: [
        /// ICON
        Container(
          height: 52,
          width: 52,

          decoration: BoxDecoration(
            color: AppColors.primaryRed.withOpacity(0.10),

            borderRadius: BorderRadius.circular(18),
          ),

          child: Icon(icon, color: AppColors.primaryRed),
        ),

        const SizedBox(width: 16),

        /// TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 6),

                Text(
                  subtitle!,

                  style: TextStyle(
                    color: Colors.grey[700],

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
