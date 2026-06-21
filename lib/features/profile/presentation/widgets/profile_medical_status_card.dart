import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileMedicalStatusCard extends StatelessWidget {
  final bool verified;
  final String bloodGroup;

  const ProfileMedicalStatusCard({
    super.key,
    required this.verified,
    required this.bloodGroup,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = verified ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: verified
              ? (isDark
                  ? [
                      Colors.green.shade900,
                      Colors.green.shade700,
                    ]
                  : [
                      Colors.green.shade600,
                      Colors.green.shade400,
                    ])
              : (isDark
                  ? [
                      Colors.orange.shade900,
                      Colors.orange.shade700,
                    ]
                  : [
                      Colors.orange.shade600,
                      Colors.orange.shade400,
                    ]),
        ),

        borderRadius: BorderRadius.circular(30),
      ),

      child: Row(
        children: [
          /// ICON
          Container(
            height: 72,
            width: 72,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                isDark ? 0.10 : 0.14,
              ),

              borderRadius: BorderRadius.circular(24),
            ),

            child: Icon(
              verified
                  ? Icons.verified_rounded
                  : Icons.warning_rounded,

              color: Colors.white,

              size: 38,
            ),
          ),

          const SizedBox(width: 18),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  verified
                      ? l10n.medicalProfileVerified
                      : l10n.verificationRequired,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  verified
                      ? '${l10n.yourBloodGroup} $bloodGroup ${l10n.hasBeenValidated}'
                      : l10n.pleaseCompleteMedicalVerification,

                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
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