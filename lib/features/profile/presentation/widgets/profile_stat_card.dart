import 'package:flutter/material.dart';
import '../../../../app/theme/app_radius.dart';

class ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Gradient? gradient;

  const ProfileStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        height: 118,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: gradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        colors.surface.withOpacity(0.9),
                        colors.surface.withOpacity(0.6),
                      ]
                    : [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.10),
                      ],
              ),

          borderRadius: BorderRadius.circular(AppRadius.xl),

          border: Border.all(
            color: isDark
                ? colors.outline.withOpacity(0.25)
                : Colors.white.withOpacity(0.15),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isDark ? colors.onSurface : Colors.white,
            ),

            const SizedBox(height: 12),

            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? colors.onSurface : Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? colors.onSurface.withOpacity(0.75)
                    : Colors.white.withOpacity(0.82),
              ),
            ),
          ],
        ),
      ),
    );
  }
}