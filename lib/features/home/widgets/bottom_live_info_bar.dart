import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class BottomLiveInfoBar extends StatelessWidget {
  final int livesSaved;
  final int activeDonors;

  const BottomLiveInfoBar({
    super.key,
    required this.livesSaved,
    required this.activeDonors,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        24,
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),

              borderRadius: BorderRadius.circular(22),

              border: Border.all(color: Colors.white.withOpacity(0.5)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),

                  blurRadius: 20,

                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Row(
              children: [
                /// ICON
                Container(
                  height: 56,
                  width: 56,

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE53946), Color(0xFFC1121F)],
                    ),

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: const Icon(
                    Icons.favorite_rounded,

                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 16),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        '$livesSaved ${l10n.livesSavedToday}',

                        style: const TextStyle(
                          fontWeight: FontWeight.w900,

                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                       '$activeDonors ${l10n.activeDonorsInYourArea}',

                        style: const TextStyle(
                          color: AppColors.textSecondary,

                          height: 1.4,

                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                const Icon(
                  Icons.arrow_forward_ios_rounded,

                  size: 16,

                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
