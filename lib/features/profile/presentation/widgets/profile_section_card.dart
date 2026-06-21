//6
import 'dart:ui';
import 'package:flutter/material.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final colors =
        Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark
                ? colors.surfaceContainerHighest
                : Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? colors.outline.withOpacity(0.3)
                  : Colors.white.withOpacity(0.75),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  isDark ? 0.20 : 0.04,
                ),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: isDark
                          ? colors.primary
                          : Colors.red.shade600,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}