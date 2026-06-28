import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
// import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

import 'blood_group_chip.dart';
import 'profile_glass_card.dart';

class DonationTimelineCard extends StatelessWidget {
  final String hospitalName;
  final DateTime donationDate;

  final String bloodGroup;

  final bool validated;

  final int savedLives;

  final VoidCallback? onCertificateTap;

  const DonationTimelineCard({
    super.key,
    required this.hospitalName,
    required this.donationDate,
    required this.bloodGroup,
    required this.validated,
    required this.savedLives,
    this.onCertificateTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: ProfileGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// TOP
            Row(
              children: [
                Container(
                  height: 68,
                  width: 68,

                  decoration: BoxDecoration(
                  color: AppColors.primaryRed.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(22),
                ),

                  child: const Icon(
                    Icons.bloodtype_rounded,
                    color: AppColors.primaryRed,
                    size: 32,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        hospitalName,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 16,
                            color: isDark ? Colors.white70 : Colors.grey[600],
                          ),

                          const SizedBox(width: 6),

                          Text(
                            DateFormat('dd MMM yyyy').format(donationDate),

                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.grey[700],

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// CHIPS
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                BloodGroupChip(bloodGroup: bloodGroup),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(30),
                ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: Colors.green,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        validated ? l10n.validated : l10n.pending,

                        style: TextStyle(
                          color: validated ? Colors.green : Colors.orange,

                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        size: 16,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        '$savedLives ${l10n.lives}',

                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            /// BUTTON
            GestureDetector(
              onTap: onCertificateTap,

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(vertical: 18),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF161B4B),
                      Color(0xFF232A67),
                    ],
                  ),

                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),

                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.workspace_premium_rounded, color: Colors.white),

                    SizedBox(width: 10),

                    Text(
                      l10n.viewCertificateShare,

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
