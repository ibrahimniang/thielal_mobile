import 'package:flutter/material.dart';

class ProfileHeaderActions
    extends StatelessWidget {
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
          icon:
              Icons.notifications_rounded,
          onTap: onNotificationTap,
        ),

        const SizedBox(width: 12),

        _actionButton(
          icon: Icons.settings_rounded,
          onTap: onSettingsTap,
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 52,
        width: 52,

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(
            0.16,
          ),

          borderRadius:
              BorderRadius.circular(18),
        ),

        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}