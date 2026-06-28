import 'package:flutter/material.dart';

class ProfileBadgeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const ProfileBadgeItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: isDark
              ? color.withOpacity(0.25)
              : color.withOpacity(0.15),

          child: Icon(
            icon,
            color: isDark ? color : Colors.white,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}