import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../../application/profile_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../donations/application/donation_controller.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

import '../widgets/profile_loading_shimmer.dart';
import '../widgets/profile_error_state.dart';
import '../widgets/profile_responsive_wrapper.dart';

import '../widgets/profile_sliver_background.dart';
import '../widgets/profile_hero_section.dart';
import '../widgets/profile_tab_bar.dart';

import '../widgets/profile_section_title.dart';

import '../widgets/donor_level_progress.dart';
import '../widgets/profile_medical_status_card.dart';
import '../widgets/next_donation_card.dart';

import '../widgets/badge_level_card.dart';
import '../widgets/certificate_preview_modal.dart';

import '../widgets/donation_timeline_card.dart';

import '../widgets/qr_premium_card.dart';

import '../widgets/medical_info_tile.dart';

import '../widgets/premium_profile_button.dart';

import '../widgets/empty_profile_state.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileControllerProvider);

    final donationsAsync = ref.watch(myDonationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: profileState.when(
        loading: () => const ProfileLoadingShimmer(),

        error:
            (e, _) => ProfileErrorState(
              message: e.toString(),

              onRetry: () {
                ref.read(profileControllerProvider.notifier).refreshProfile();
              },
            ),

        data: (user) {
          if (user == null) {
            return EmptyProfileState(
              title: l10n.profileNotFound,

              subtitle: l10n.unableToLoadUserData,

              icon: Icons.person_off_rounded,
            );
          }

          return NestedScrollView(
            headerSliverBuilder: (_, innerScrolled) {
              return [
                /// =====================================================
                /// SLIVER APP BAR
                /// =====================================================
                SliverAppBar(
                  stretch: true,
                  
                  expandedHeight: 360,

                  pinned: true,

                  elevation: 0,

                  automaticallyImplyLeading: false,

                  backgroundColor: AppColors.primaryRed,

                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        /// BG
                        const ProfileSliverBackground(),

                        /// CONTENT
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: [
                                ProfileHeroSection(
                                  fullName: user.fullName,

                                  bloodGroup: user.groupeSanguin ?? '--',

                                  verified: user.profilComplet,

                                  donationsCount: donationsAsync.maybeWhen(
                                    data: (d) => d.length,

                                    orElse: () => 0,
                                  ),

                                  savedLives: donationsAsync.maybeWhen(
                                    data: (d) => d.length * 3,
                                    orElse: () => 0,
                                  ),

                                  points: user.points ?? 0,

                                  onEditTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const EditProfileScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// =====================================================
                /// TAB BAR
                /// =====================================================
                SliverPersistentHeader(
                  pinned: true,

                  delegate: _ProfileTabDelegate(
                    child: Container(
                      color: const Color(0xFFF5F7FB),

                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),

                      child: ProfileTabBar(controller: _tabController),
                    ),
                  ),
                ),
              ];
            },

            /// =====================================================
            /// BODY
            /// =====================================================
            body: ProfileResponsiveWrapper(
              child: TabBarView(
                controller: _tabController,

                children: [
                  /// OVERVIEW
                  _overviewTab(user, donationsAsync, l10n),

                  /// HISTORY
                  _historyTab(user, donationsAsync, l10n),

                  /// QR
                  _qrTab(user, l10n),

                  /// INFOS
                  _infosTab(user, l10n),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// =====================================================
  /// OVERVIEW TAB
  /// =====================================================

  Widget _overviewTab(
    dynamic user,
    AsyncValue donationsAsync,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),

      child: Column(
        children: [
          /// LEVEL
          DonorLevelProgress(points: user.points ?? 0),

          const SizedBox(height: 18),

          /// MEDICAL STATUS
          ProfileMedicalStatusCard(
            verified: user.profilComplet,

            bloodGroup: user.groupeSanguin ?? '--',
          ),

          const SizedBox(height: 24),

          /// NEXT DONATION
          NextDonationCard(nextDonationDate: null),

          const SizedBox(height: 20),

          /// TITLE
          ProfileSectionTitle(
            title: l10n.badgesRewards,

            subtitle: l10n.donorProgress,

            icon: Icons.workspace_premium_rounded,
          ),

          const SizedBox(height: 20),

          /// BADGES
          GridView.count(
            crossAxisCount: 2,

            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            crossAxisSpacing: 16,
            mainAxisSpacing: 16,

            childAspectRatio: 1.18,

            children: [
              BadgeLevelCard(
                title: l10n.bronze,

                description: l10n.firstDonorLevel,

                icon: Icons.workspace_premium_rounded,

                color: Colors.brown,

                unlocked: (user.points ?? 0) >= 50,
              ),

              BadgeLevelCard(
                title: l10n.silver,

                description: l10n.regularDonor,

                icon: Icons.workspace_premium_rounded,

                color: Colors.grey,

                unlocked: (user.points ?? 0) >= 200,
              ),

              BadgeLevelCard(
                title: l10n.gold,

                description: l10n.exemplaryDonor,

                icon: Icons.workspace_premium_rounded,

                color: Colors.amber,

                unlocked: (user.points ?? 0) >= 500,
              ),

              BadgeLevelCard(
                title: l10n.elite,

                description: l10n.lifelinkHero,

                icon: Icons.emoji_events_rounded,

                color: Colors.purple,

                unlocked: (user.points ?? 0) >= 1000,
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// =====================================================
  /// HISTORY TAB
  /// =====================================================

  Widget _historyTab(
    dynamic user,
    AsyncValue donationsAsync,
    AppLocalizations l10n,
  ) {
    return donationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (e, _) => Center(child: Text('${l10n.historyError} : $e')),

      data: (dons) {
        if (dons.isEmpty) {
          return EmptyProfileState(
            title: l10n.noDonationRecorded,

            subtitle: l10n.donationHistoryWillAppear,

            icon: Icons.history_rounded,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),

          itemCount: dons.length,

          itemBuilder: (_, index) {
            final don = dons[index];

            return DonationTimelineCard(
              hospitalName: don.centre?.nom ?? l10n.unknownCenter,

              donationDate: don.dateDon,

              bloodGroup: don.groupeSanguin ?? '--',

              validated: true,

              savedLives: 3,

              onCertificateTap: () {
                final certificat = don.certificat?.urlCertificat;

                if (certificat == null || certificat.trim().isEmpty) {
                  return;
                }

                CertificatePreviewModal.show(
                  context,

                  donorName:
                      user.fullName.isEmpty
                          ? l10n.lifelinkDonor
                          : user.fullName,

                  bloodGroup: don.groupeSanguin ?? user.groupeSanguin ?? '--',

                  hospitalName: don.centre?.nom ?? l10n.unknownCenter,

                  donationDate: don.dateDon.toString(),

                  certificateUrl: certificat,
                );
              },
            );
          },
        );
      },
    );
  }

  /// =====================================================
  /// QR TAB
  /// =====================================================

  Widget _qrTab(dynamic user, AppLocalizations l10n) {
    final qr = user.qrCode?.trim() ?? '';

    if (qr.isEmpty) {
      return EmptyProfileState(
        title: l10n.qrUnavailable,

        subtitle: l10n.qrGeneratedAutomatically,

        icon: Icons.qr_code_rounded,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),

      child: Column(
        children: [
          QrPremiumCard(
            qrData: qr,

            fullName: user.fullName,

            bloodGroup: user.groupeSanguin ?? '--',

            verified: user.profilComplet,

            onShareWhatsapp: () {
              debugPrint('Partager WhatsApp');
            },

            onShareEmail: () {
              debugPrint('Partager Email');
            },
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }

  /// =====================================================
  /// INFOS TAB
  /// =====================================================

  Widget _infosTab(dynamic user, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),

      child: Column(
        children: [
          /// TITLE
          ProfileSectionTitle(
            title: l10n.personalInformation,

            subtitle: l10n.medicalInformationContacts,

            icon: Icons.person_rounded,
          ),

          const SizedBox(height: 24),

          /// INFOS
          MedicalInfoTile(
            icon: Icons.badge_rounded,

            label: l10n.fullName,

            value: user.fullName.isEmpty ? '--' : user.fullName,
          ),

          MedicalInfoTile(
            icon: Icons.phone_rounded,

            label: l10n.phone,

            value: user.telephone ?? '--',
          ),

          MedicalInfoTile(
            icon: Icons.email_rounded,

            label: l10n.email,

            value: user.email ?? 'Aucun email',
          ),

          MedicalInfoTile(
            icon: Icons.location_city_rounded,

            label: l10n.city,

            value: user.ville ?? '--',
          ),

          MedicalInfoTile(
            icon: Icons.location_on_rounded,

            label: l10n.district,

            value: user.quartier ?? '--',
          ),

          MedicalInfoTile(
            icon: Icons.bloodtype_rounded,

            label: l10n.bloodGroup,

            value: user.groupeSanguin ?? '--',

            iconColor: AppColors.primaryRed,
          ),

          MedicalInfoTile(
            icon: Icons.verified_rounded,

            label: l10n.medicalStatus,

            value: user.profilComplet ? l10n.verified : l10n.notVerified,

            iconColor: user.profilComplet ? Colors.green : Colors.orange,
          ),

          const SizedBox(height: 24),

          /// BUTTON
          PremiumProfileButton(
            text: l10n.editProfile,

            icon: Icons.edit_rounded,

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/// =====================================================
/// TAB DELEGATE
/// =====================================================

class _ProfileTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _ProfileTabDelegate({required this.child});

  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
