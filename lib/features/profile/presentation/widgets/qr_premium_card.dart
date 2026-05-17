import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

import 'blood_group_chip.dart';
import 'profile_glass_card.dart';
import '../../../../l10n/app_localizations.dart';

class QrPremiumCard extends StatelessWidget {
  final String qrData;

  final String fullName;

  final String bloodGroup;

  final bool verified;

  final VoidCallback? onShareWhatsapp;
  final VoidCallback? onShareEmail;

  const QrPremiumCard({
    super.key,
    required this.qrData,
    required this.fullName,
    required this.bloodGroup,
    required this.verified,
    this.onShareWhatsapp,
    this.onShareEmail,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ProfileGlassCard(
      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),

      child: Column(
        children: [
          /// QR
          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(28),

              border: Border.all(
                color: AppColors.primaryRed,
                width: 2,
              ),

              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRed
                      .withOpacity(0.10),

                  blurRadius: 18,

                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 220,
              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          /// NAME
          Text(
            fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 18),

          /// BLOOD GROUP
          BloodGroupChip(
            bloodGroup: bloodGroup,
            verified: verified,
            large: true,
          ),

          const SizedBox(height: 24),

          Text(
            l10n.presentQrAtDonationCenters,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 28),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  icon: Icons.chat_rounded,
                  text: 'WhatsApp',
                  color: Colors.green,
                  onTap: onShareWhatsapp,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _actionButton(
                  icon: Icons.email_rounded,
                  text: 'Email',
                  color: AppColors.primaryRed,
                  onTap: onShareEmail,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// SECURITY
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: const Color(0xFF171B4D),

              borderRadius:
                  BorderRadius.circular(24),
            ),

            child:  Row(
              children: [
                Icon(
                  Icons.lock_rounded,
                  color: Colors.amber,
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    l10n.secureDonationQrInfo,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String text,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color: color,

          borderRadius: BorderRadius.circular(
            AppRadius.xl,
          ),
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              color: Colors.white,
            ),

            const SizedBox(width: 8),

            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}