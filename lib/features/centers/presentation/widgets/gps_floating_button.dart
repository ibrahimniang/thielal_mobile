import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class GpsFloatingButton extends StatelessWidget {
  final VoidCallback onTap;

  const GpsFloatingButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE53946), Color(0xFFC1121F)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Icons.my_location_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
