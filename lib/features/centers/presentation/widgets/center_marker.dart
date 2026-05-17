import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class CenterMarker extends StatelessWidget {
  final VoidCallback onTap;

  const CenterMarker({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFE53946), Color(0xFFC1121F)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRed.withOpacity(0.35),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          Container(width: 4, height: 18, color: AppColors.primaryRed),
        ],
      ),
    );
  }
}
