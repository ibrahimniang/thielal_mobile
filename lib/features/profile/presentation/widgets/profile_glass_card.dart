import 'dart:ui';

import 'package:flutter/material.dart';

// import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class ProfileGlassCard extends StatelessWidget {
  final Widget child;

  final EdgeInsets? padding;
  final double? borderRadius;

  const ProfileGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius ?? 28,
      ),

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 14,
          sigmaY: 14,
        ),

        child: Container(
          width: double.infinity,

          padding:
              padding ??
              const EdgeInsets.all(
                AppSpacing.lg,
              ),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.82),

            borderRadius: BorderRadius.circular(
              borderRadius ?? 28,
            ),

            border: Border.all(
              color: Colors.white.withOpacity(0.45),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),

                blurRadius: 20,

                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: child,
        ),
      ),
    );
  }
}