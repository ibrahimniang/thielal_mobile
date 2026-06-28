import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class MapFloatingButtons extends StatelessWidget {
  final VoidCallback onGpsTap;

  final VoidCallback? onLayersTap;

  const MapFloatingButtons({
    super.key,
    required this.onGpsTap,
    this.onLayersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,

      bottom: 150,

      child: Column(
        children: [
          /// =========================
          /// GPS BUTTON
          /// =========================
          _floatingButton(
            icon: Icons.my_location_rounded,

            onTap: onGpsTap,

            isPrimary: true,
            context: context,
          ),

          const SizedBox(height: 12),

          /// =========================
          /// MAP STYLE BUTTON
          /// =========================
          _floatingButton(
            context: context,
            icon: Icons.layers_rounded,

            onTap: onLayersTap ?? () {},

            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _floatingButton({
    required BuildContext context,
    required IconData icon,

    required VoidCallback onTap,

    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),

        height: 54,

        width: 54,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          color:
              isPrimary
                  ? AppColors.primaryRed
                  : Theme.of(context).colorScheme.surface,

          border: Border.all(
            color:
                isPrimary
                    ? Colors.white
                    : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 2,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  isPrimary
                      ? AppColors.primaryRed.withOpacity(0.25)
                      : Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Icon(
          icon,

          color: isPrimary ? Colors.white : AppColors.primaryRed,

          size: 24,
        ),
      ),
    );
  }
}
