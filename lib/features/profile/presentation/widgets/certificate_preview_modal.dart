import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app/theme/app_colors.dart';
// import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class CertificatePreviewModal extends StatelessWidget {
  final String donorName;

  final String bloodGroup;

  final String hospitalName;

  final String donationDate;

  final String certificateUrl;

  static const String appLink = "#########";

  const CertificatePreviewModal({
    super.key,
    required this.donorName,
    required this.bloodGroup,
    required this.hospitalName,
    required this.donationDate,
    required this.certificateUrl,
  });

  /// =========================================================
  /// OPEN MODAL
  /// =========================================================

  static Future<void> show(
    BuildContext context, {
    required String donorName,
    required String bloodGroup,
    required String hospitalName,
    required String donationDate,
    required String certificateUrl,
  }) async {
    await showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder:
          (_) => CertificatePreviewModal(
            donorName: donorName,
            bloodGroup: bloodGroup,
            hospitalName: hospitalName,
            donationDate: donationDate,
            certificateUrl: certificateUrl,
          ),
    );
  }

  /// =========================================================
  /// SHARE
  /// =========================================================

  Future<void> _shareCertificate(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    await Share.share('''
🩸 ${l10n.lifelinkDonationCertificate}

${l10n.donor}: $donorName
${l10n.bloodGroup}: $bloodGroup
${l10n.center}: $hospitalName
${l10n.date}: $donationDate

 Certificat :
$certificateUrl

 Réalisé via LifeLink Mauritanie

 Téléchargez l'application :
$appLink

#LifeLink
#DonDeSang
''');
  }

  /// =========================================================
  /// OPEN URL
  /// =========================================================

  Future<void> _openCertificate() async {
    final uri = Uri.parse(certificateUrl);
    print("CERTIFICATE URL => $certificateUrl");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// =========================================================
  /// BUILD
  /// =========================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formattedDate = DateFormat(
      'dd/MM/yyyy • HH:mm',
    ).format(DateTime.parse(donationDate));
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

      child: Container(
        height: MediaQuery.of(context).size.height * 0.90,

        decoration: const BoxDecoration(
          color: Color(0xFFF5F7FB),

          borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
        ),

        child: Column(
          children: [
            /// =====================================================
            /// HANDLE
            /// =====================================================
            const SizedBox(height: 14),

            Container(
              width: 70,
              height: 6,

              decoration: BoxDecoration(
                color: Colors.grey.shade300,

                borderRadius: BorderRadius.circular(30),
              ),
            ),

            const SizedBox(height: 20),

            /// =====================================================
            /// HEADER
            /// =====================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Row(
                children: [
                  /// ICON
                  Container(
                    height: 64,
                    width: 64,

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryRed,
                          AppColors.primaryRed.withOpacity(0.75),
                        ],
                      ),

                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: const Icon(
                      Icons.workspace_premium_rounded,

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
                          l10n.lifelinkCertificate,

                          style: TextStyle(
                            fontSize: 24,

                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          l10n.officialBloodDonationCertificate,

                          style: TextStyle(
                            fontWeight: FontWeight.w500,

                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// =====================================================
            /// CERTIFICATE PREVIEW
            /// =====================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),

                child: Column(
                  children: [
                    /// CERTIFICATE CARD
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(28),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(30),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),

                            blurRadius: 24,

                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          /// TOP LOGO
                          Container(
                            height: 88,
                            width: 88,

                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryRed,

                                  AppColors.primaryRed.withOpacity(0.7),
                                ],
                              ),

                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.favorite_rounded,

                              color: Colors.white,

                              size: 42,
                            ),
                          ),

                          const SizedBox(height: 22),

                          /// TITLE
                          Text(
                            l10n.donationCertificate.toUpperCase(),

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontWeight: FontWeight.w900,

                              fontSize: 24,

                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'LifeLink Mauritanie',

                            style: TextStyle(
                              color: Colors.grey[700],

                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// DONOR
                          _infoRow(label: l10n.donor, value: donorName),

                          const SizedBox(height: 18),

                          _infoRow(label: l10n.bloodGroup, value: bloodGroup),

                          const SizedBox(height: 18),

                          _infoRow(label: l10n.center, value: hospitalName),

                          const SizedBox(height: 18),

                          _infoRow(label: l10n.date, value: formattedDate),

                          const SizedBox(height: 34),

                          /// VERIFIED
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.10),

                              borderRadius: BorderRadius.circular(30),
                            ),

                            child: Row(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                Icon(
                                  Icons.verified_rounded,

                                  color: Colors.green,
                                ),

                                SizedBox(width: 10),

                                Text(
                                  l10n.verifiedCertificate,

                                  style: TextStyle(
                                    color: Colors.green,

                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          /// FOOTER
                          Text(
                            l10n.thankYouBloodDonation,

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: Colors.grey[700],

                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// =====================================================
                    /// ACTIONS
                    /// =====================================================
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            icon: Icons.download_rounded,

                            label: l10n.download,

                            color: AppColors.primaryRed,

                            onTap: _openCertificate,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: _actionButton(
                            icon: Icons.share_rounded,

                            label: l10n.share,

                            color: const Color(0xFF161B4B),

                            onTap: () => _shareCertificate(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// SOCIALS
                    Row(
                      children: [
                        Expanded(
                          child: _socialButton(
                            icon: FontAwesomeIcons.whatsapp,

                            text: 'WhatsApp',

                            color: Colors.green,
                            onTap: () => _shareCertificate(context),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _socialButton(
                            icon: FontAwesomeIcons.facebook,

                            text: 'Facebook',

                            color: Colors.blue,
                            onTap: () => _shareCertificate(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _socialButton(
                            icon: FontAwesomeIcons.snapchat,

                            text: 'Snapchat',

                            color: Colors.orange,
                            onTap: () => _shareCertificate(context),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _socialButton(
                            icon: FontAwesomeIcons.google,

                            text: 'Email',

                            color: AppColors.primaryRed,
                            onTap: () => _shareCertificate(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================================================
  /// INFO ROW
  /// =========================================================

  Widget _infoRow({required String label, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,

            style: TextStyle(
              color: Colors.grey[700],

              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          flex: 2,

          child: Text(
            value,

            textAlign: TextAlign.right,

            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ),
      ],
    );
  }

  /// =========================================================
  /// ACTION BUTTON
  /// =========================================================

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),

        decoration: BoxDecoration(
          color: color,

          borderRadius: BorderRadius.circular(22),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, color: Colors.white),

            const SizedBox(width: 10),

            Text(
              label,

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

  /// =========================================================
  /// SOCIAL BUTTON
  /// =========================================================

  Widget _socialButton({
    required IconData icon,
    required String text,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),

        decoration: BoxDecoration(
          color: color.withOpacity(0.12),

          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, color: color),

            const SizedBox(width: 8),

            Text(
              text,

              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
