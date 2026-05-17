import 'package:flutter/material.dart';

import '../../../../app/theme/app_gradients.dart';

class ProfileSliverBackground extends StatelessWidget {
  const ProfileSliverBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// EXTRA GLOW 1
        Positioned(
          top: 60,
          left: -30,

          child: Container(
            height: 140,
            width: 140,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),

        /// EXTRA GLOW 2
        Positioned(
          bottom: 120,
          right: -20,

          child: Container(
            height: 120,
            width: 120,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.03),
            ),
          ),
        ),

        /// EXTRA GLOW 3
        Positioned(
          top: 180,
          right: 40,

          child: Container(
            height: 60,
            width: 60,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ),

        /// MAIN GRADIENT
        Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryRed),
        ),

        /// TOP GLOW
        Positioned(
          top: -80,
          right: -40,

          child: Container(
            height: 220,
            width: 220,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),

        /// BOTTOM GLOW
        Positioned(
          bottom: -60,
          left: -40,

          child: Container(
            height: 180,
            width: 180,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }
}
