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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: isDark
          ? colors.surface
          : Colors.white,

          borderRadius: BorderRadius.circular(28),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isDark ? 0.30 : 0.05,
              ),

              blurRadius: 18,

              offset: const Offset(0, 6),
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
                    color: colors.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
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
                      Icon(Icons.circle, size: 6, color: Colors.green),

                      SizedBox(width: 6),

                      Text(
                        l10n.live,

                        style: TextStyle(
                          color: Colors.green,

                          fontWeight: FontWeight.w700,

                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// ==========================================
            /// LAST DONATION
            /// ==========================================
            if (latestDonation != null)
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: isDark
                      ? colors.error.withOpacity(0.12)
                      : Colors.red.withOpacity(0.06),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,

                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),

                        borderRadius: BorderRadius.circular(14),
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

                            style: TextStyle(
                              color: isDark
                                  ? colors.onSurface.withOpacity(0.7)
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 18),

            /// ==========================================
            /// STATS
            /// ==========================================
            Column(
  children: [
    Row(
      children: [
        Expanded(
          child: _card(
            context,
            icon:
                Icons.water_drop_rounded,

            iconColor:
                Colors.blueAccent,

            title:
                l10n.donations,

            value:
                donations.toString(),

            subtitle:
                l10n.totalValidated,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _card(
            context,
            icon:
                Icons.favorite_rounded,

            iconColor:
                Colors.redAccent,

            title:
                l10n.savedLives,

            value:
                livesSaved.toString(),

            subtitle:
                l10n.realImpact,
          ),
        ),
      ],
    ),

    const SizedBox(height: 12),

    _wideCard(
      context,
      icon: Icons.timer_rounded,

      iconColor:
          Colors.orangeAccent,

      title: l10n.delay,

      value:
          '$averageDelay ${l10n.minutes}',

      subtitle:
          l10n.averageTime,
    ),
  ],
),
          ],
        ),
      ),
    );
  }
Widget _wideCard(
  BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required String title,
  required String value,
  required String subtitle,
}) {
  final isDark =
      Theme.of(context).brightness == Brightness.dark;

  final colors =
      Theme.of(context).colorScheme;

  return Container(
    width: double.infinity,

    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: isDark
        ? colors.surfaceContainerHighest
        : AppColors.silverBackground,

      borderRadius:
          BorderRadius.circular(22),
    ),

    child: Row(
      children: [
        Container(
          height: 50,
          width: 50,

          decoration: BoxDecoration(
            color:
                iconColor.withOpacity(0.12),

            borderRadius:
                BorderRadius.circular(
                  16,
                ),
          ),

          child: Icon(
            icon,
            color: iconColor,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: TextStyle(
                  color: isDark
                      ? colors.onSurface.withOpacity(0.7)
                      : AppColors.textSecondary,

                  fontWeight:
                      FontWeight.w600,

                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,

                style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
              ),
            ],
          ),
        ),

        Container(
          padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),

          decoration: BoxDecoration(
            color:
                Colors.orange.withOpacity(
                  0.10,
                ),

            borderRadius:
                BorderRadius.circular(30),
          ),

          child: Text(
            subtitle,

            style: const TextStyle(
              color: Colors.orange,

              fontWeight:
                  FontWeight.w700,

              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _card(
  BuildContext context, {
  
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  })
   {
     final isDark =
      Theme.of(context).brightness == Brightness.dark;

     final colors =
       Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: isDark
          ? colors.surfaceContainerHighest
          : AppColors.silverBackground,

        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),

      child: Column(
        children: [
          Container(
            height: 44,
            width: 44,

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(height: 12),

          Text(
            title,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: isDark
                  ? colors.onSurface.withOpacity(0.7)
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: colors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

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
