import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class ProgressStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: totalSteps == 0 ? 0 : currentStep / totalSteps,
          minHeight: 8,
          borderRadius: BorderRadius.circular(99),
          backgroundColor: AppColors.border,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Étape $currentStep / $totalSteps',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
