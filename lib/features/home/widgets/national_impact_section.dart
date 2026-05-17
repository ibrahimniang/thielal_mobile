import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

import '../../donations/data/models/donation_model.dart';
import '../../../../l10n/app_localizations.dart';

class NationalImpactSection extends StatelessWidget {
  final int donations;

  final int livesSaved;

  final int averageDelay;

  final DonationModel? latestDonation;

  const NationalImpactSection({
    super.key,
    required this.donations,
    required this.livesSaved,
    required this.averageDelay,
    this.latestDonation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(AppSpacing.xl),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(28),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),

              blurRadius: 24,

              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ==========================================
            /// HEADER
            /// ==========================================
            Row(
              children: [
                Text(
  l10n.nationalImpact,

                  style: TextStyle(
                    fontWeight: FontWeight.w900,

                    fontSize: 15,

                    letterSpacing: 0.7,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.10),

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child:  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.green),

                      SizedBox(width: 6),

                      Text(
                        l10n.live,

                        style: TextStyle(
                          color: Colors.green,

                          fontWeight: FontWeight.w700,

                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            /// ==========================================
            /// LAST DONATION
            /// ==========================================
            if (latestDonation != null)
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.06),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: [
                    Container(
                      height: 52,
                      width: 52,

                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Icon(
                        Icons.favorite_rounded,

                        color: Colors.red,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
  l10n.lastValidatedDonation,

                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            latestDonation!.centre?.nom ??
    l10n.unknownCenter,

                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 28),

            /// ==========================================
            /// STATS
            /// ==========================================
            Row(
              children: [
                Expanded(
                  child: _card(
                    icon: Icons.water_drop_rounded,

                    iconColor: Colors.blueAccent,

                   title: l10n.donations,

                    value: donations.toString(),

                    subtitle: l10n.totalValidated,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _card(
                    icon: Icons.favorite_rounded,

                    iconColor: Colors.redAccent,

                    title: l10n.savedLives,

                    value: livesSaved.toString(),

                    subtitle: l10n.realImpact,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _card(
                    icon: Icons.timer_rounded,

                    iconColor: Colors.orangeAccent,

                   title: l10n.delay,

                    value: '$averageDelay ${l10n.minutes}',

                    subtitle: l10n.averageTime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.silverBackground,

        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),

      child: Column(
        children: [
          Container(
            height: 52,
            width: 52,

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(height: 16),

          Text(
            title,

            textAlign: TextAlign.center,

            style: const TextStyle(
              color: AppColors.textSecondary,

              fontWeight: FontWeight.w600,

              fontSize: 12,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,

            style: const TextStyle(
              color: Colors.green,

              fontWeight: FontWeight.w700,

              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
