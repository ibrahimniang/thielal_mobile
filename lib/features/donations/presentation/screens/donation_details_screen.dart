import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_controller.dart';

import '../../../participation/data/repositories/participation_repository.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

import '../../../alerts/data/models/alert_model.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../l10n/app_localizations.dart';

class DonationDetailsScreen extends ConsumerWidget {
  final AlertModel alert;

  final UserModel? user;

  const DonationDetailsScreen({super.key, required this.alert, this.user});

  bool get isUnavailable {
    if (user == null) {
      return false;
    }

    if (user!.dateProchainDon == null) {
      return false;
    }

    return DateTime.now().isBefore(user!.dateProchainDon!);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final center = alert.center;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.white,

        foregroundColor: Colors.black,

        centerTitle: true,

        title: Text(l10n.urgentDetails),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ==========================================
            /// URGENCE CARD
            /// ==========================================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
                ),

                borderRadius: BorderRadius.circular(28),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Container(
                        height: 64,
                        width: 64,

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Icon(
                          Icons.bloodtype_rounded,

                          color: Colors.white,

                          size: 34,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              center?.name ?? l10n.medicalCenter,

                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 22,

                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              alert.city,

                              style: const TextStyle(
                                color: Colors.white70,

                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      _badge(alert.bloodGroup),

                      const SizedBox(width: 10),

                      _badge(
                        alert.type.toLowerCase() == l10n.urgent
                            ? l10n.urgent
                            : l10n.normal,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    alert.message,

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 16,

                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            /// ==========================================
            /// MESSAGE MÉDICAL
            /// ==========================================
            if (isUnavailable)
              Container(
                width: double.infinity,

                margin: const EdgeInsets.only(bottom: 24),

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.10),

                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(color: Colors.orange.withOpacity(0.18)),
                ),

                child: Row(
                  children: [
                    const Icon(Icons.info_rounded, color: Colors.orange),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        '${l10n.recoveryPeriod}\n\n'
                        '${l10n.nextDonationDate} : '
                        '${user!.dateProchainDon!.day}/${user!.dateProchainDon!.month}/${user!.dateProchainDon!.year}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            /// ==========================================
            /// INFOS
            /// ==========================================
            Text(
              l10n.centerInformation,

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 18),

            _infoCard(
              context,
              icon: Icons.location_on_rounded,

              title: l10n.address,

              value: center?.address ?? l10n.addressUnavailable,
            ),

            const SizedBox(height: 14),

            _infoCard(
              context,
              icon: Icons.phone_rounded,

              title: l10n.phone,

              value: center?.phone ?? l10n.phoneUnavailable,

              isPhone: true,
            ),

            const SizedBox(height: 14),

            _infoCard(
              context,
              icon: Icons.location_city_rounded,

              title: l10n.city,

              value: center?.city ?? alert.city,
            ),

            const SizedBox(height: 32),

            /// ==========================================
            /// BUTTONS
            /// ==========================================
            SizedBox(
              width: double.infinity,

              height: 58,

              child: ElevatedButton.icon(
                onPressed: () {
                  debugPrint('CENTER NAME => ${center?.name}');

                  debugPrint('CENTER LAT => ${center?.latitude}');

                  debugPrint('CENTER LNG => ${center?.longitude}');

                  context.push(RouteNames.map, extra: center);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                icon: const Icon(Icons.map_rounded),

                label: Text(l10n.viewDirections),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,

              height: 58,

              child: OutlinedButton.icon(
                onPressed: () async {
                  if (isUnavailable) {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Don temporairement indisponible'),
                          content: Text(
                            'Vous ne pouvez pas encore effectuer un don.\n\n'
                            'Votre prochaine date de don autorisée est le '
                            '${user!.dateProchainDon!.day}/${user!.dateProchainDon!.month}/${user!.dateProchainDon!.year}.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );

                    return;
                  }
                  try {
                    final token = ref.read(authControllerProvider).accessToken;

                    final participationRepo = ParticipationRepository(
                      token: token,
                    );

                    debugPrint('ALERT ID => ${alert.id}');
                    await participationRepo.participer(alert.demandeId!);

                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('Participation enregistrée'),

                            content: Text(
                              'Vous participez maintenant à cette demande.\n\n'
                              'Centre : ${center?.name ?? "Centre médical"}\n\n'
                              'Veuillez contacter le centre ou vous y rendre pour effectuer votre don.',
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString().replaceFirst('Exception: ', ''),
                          ),
                        ),
                      );
                    }
                  }
                },

                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryRed),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                icon: const Icon(Icons.favorite_rounded),

                label: const Text('Je participe'),
              ),
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),

        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        text,

        style: const TextStyle(
          color: Colors.white,

          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    bool isPhone = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 20,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,

            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.10),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(icon, color: AppColors.primaryRed),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: AppColors.textSecondary,

                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  value,

                  style: const TextStyle(
                    fontWeight: FontWeight.w800,

                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          if (isPhone)
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: value));

                    debugPrint(l10n.phoneCopied);
                  },

                  icon: const Icon(Icons.copy_rounded),
                ),

                IconButton(
                  onPressed: () async {
                    final uri = Uri.parse('tel:$value');

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },

                  icon: const Icon(Icons.call_rounded),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
