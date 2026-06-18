import 'package:flutter/material.dart';

class ProfileHeaderActions extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;

  const ProfileHeaderActions({
    super.key,
    this.onNotificationTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _actionButton(
          context: context,
          icon: Icons.notifications_rounded,
          onTap: onNotificationTap,
        ),

        const SizedBox(width: 12),

        _actionButton(
          context: context,
          icon: Icons.settings_rounded,
          onTap: onSettingsTap,
        ),
      ],
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 52,
        width: 52,

        decoration: BoxDecoration(
          color: isDark
              ? colors.surface.withOpacity(0.6)
              : Colors.white.withOpacity(0.16),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: isDark
                ? colors.outline.withOpacity(0.25)
                : Colors.white.withOpacity(0.18),
          ),
        ),

        child: Icon(
          icon,
          color: isDark ? colors.onSurface : Colors.white,
        ),
      ),
    );
  }
}