import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class NextDonationCard extends StatelessWidget {
  final DateTime? nextDonationDate;

  final VoidCallback? onReminderTap;

  const NextDonationCard({
    super.key,
    required this.nextDonationDate,
    this.onReminderTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isEligible = nextDonationDate == null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF161B4B), Color(0xFF232A67)],
        ),

        borderRadius: BorderRadius.circular(32),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// TOP
          Row(
            children: [
              Container(
                height: 64,
                width: 64,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),

                  borderRadius: BorderRadius.circular(22),
                ),

                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  l10n.nextDonationPossible,

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          /// DATE
          Text(
            isEligible
                ? 'Apte à donner'
                : DateFormat('dd MMMM yyyy').format(nextDonationDate!),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            isEligible
                ? 'Vous pouvez effectuer un nouveau don de sang dès maintenant.'
                : 'Vous serez automatiquement notifié lorsque vous redeviendrez apte.',

            style: TextStyle(
              color: Colors.white.withOpacity(0.82),

              fontWeight: FontWeight.w500,

              height: 1.5,
            ),
          ),

          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),

            decoration: BoxDecoration(
              color: isEligible ? Colors.green : AppColors.primaryRed,

              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  isEligible
                      ? Icons.check_circle_rounded
                      : Icons.notifications_active_rounded,
                  color: Colors.white,
                ),

                const SizedBox(width: 10),

                Text(
                  isEligible
                      ? 'Disponible maintenant'
                      : 'Notification automatique activée',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
