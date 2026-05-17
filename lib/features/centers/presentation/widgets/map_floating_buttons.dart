import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class MapFloatingButtons extends StatelessWidget {
  final VoidCallback onGpsTap;

  const MapFloatingButtons({super.key, required this.onGpsTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 18,
      bottom: 220,
      child: Column(
        children: [
          _button(icon: Icons.my_location_rounded, onTap: onGpsTap),

          const SizedBox(height: 14),

          _button(icon: Icons.layers_rounded, onTap: () {}),
        ],
      ),
    );
  }

  Widget _button({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        width: 58,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.primaryRed),
      ),
    );
  }
}
