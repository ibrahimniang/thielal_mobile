import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';

class BloodGroupChip extends StatelessWidget {
  final String bloodGroup;
  final bool verified;
  final bool large;

  const BloodGroupChip({
    super.key,
    required this.bloodGroup,
    this.verified = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 18 : 12,
        vertical: large ? 10 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(
          large ? 40 : AppRadius.xl,
        ),
        border: Border.all(
          color: AppColors.primaryRed.withOpacity(0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bloodtype_rounded,
            size: large ? 20 : 16,
            color: const Color.fromARGB(255, 244, 239, 239),
          ),

          SizedBox(width: large ? 8 : 6),

          Text(
            bloodGroup,
            style: TextStyle(
              color: const Color.fromARGB(255, 244, 239, 239),
              fontWeight: FontWeight.w800,
              fontSize: large ? 16 : 13,
            ),
          ),

          if (verified) ...[
            SizedBox(width: large ? 10 : 6),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child:  Row(
                children: [
                  Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    l10n.verified,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}