import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class BloodRequestCta extends StatelessWidget {
  final VoidCallback? onTap;

  const BloodRequestCta({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),

      child: GestureDetector(
        onTap: onTap,

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(AppSpacing.xl),

          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [Color(0xFFE53946), Color(0xFFC1121F)],
            ),

            borderRadius: BorderRadius.circular(28),

            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.28),

                blurRadius: 28,

                offset: const Offset(0, 14),
              ),
            ],
          ),

          child: Row(
            children: [
              /// ICON
              Container(
                height: 62,
                width: 62,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),

                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),

                child: const Icon(
                  Icons.bloodtype_rounded,

                  color: Colors.white,

                  size: 34,
                ),
              ),

              const SizedBox(width: 18),

              /// TEXT
               Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      l10n.iNeedBlood,

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 20,

                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                     l10n.sendUrgentBloodRequest,

                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// ARROW
              Container(
                height: 50,
                width: 50,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(18),
                ),

                child: const Icon(
                  Icons.arrow_forward_rounded,

                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
