import 'package:flutter/material.dart';

class ProfileActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color color;

  const ProfileActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? color.withOpacity(0.9)
              : color,

          foregroundColor: Colors.white,

          minimumSize: const Size(double.infinity, 52),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          elevation: isDark ? 2 : 0,
        ),

        onPressed: onPressed,

        icon: Icon(icon ?? Icons.edit_rounded),

        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}