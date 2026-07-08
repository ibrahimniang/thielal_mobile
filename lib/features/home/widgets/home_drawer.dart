// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../profile/application/profile_controller.dart';

import '../../donations/application/donation_controller.dart';

import '../../../../l10n/app_localizations.dart';

import '../../../../app/services/locale_service.dart';

import '../../../../app/router/route_names.dart';
// import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

/// 🔥 IMPORT AUTH
import '../../auth/application/auth_controller.dart';

class HomeDrawer extends ConsumerWidget {
  final String? firstName;

  const HomeDrawer({super.key, this.firstName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    /// ==========================================
    /// USER LETTER
    /// ==========================================

    final letter =
        firstName != null && firstName!.trim().isNotEmpty
            ? firstName!.trim()[0].toUpperCase()
            : 'U';

    return GestureDetector(
      /// 🔥 fermer drawer si clique écran
      onTap: () {
        context.pop();
      },

      child: Material(
        color: Colors.black.withOpacity(isDark ? 0.35 : 0.18),

        child: Row(
          children: [
            /// ==========================================
            /// DRAWER
            /// ==========================================
            GestureDetector(
              onTap: () {},

              child: Container(
                width: MediaQuery.of(context).size.width * 0.78,

                height: double.infinity,

                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Theme.of(context).colorScheme.surface
                          : Colors.white,

                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(34),

                    bottomRight: Radius.circular(34),
                  ),
                ),

                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// ==========================================
                        /// HEADER
                        /// ==========================================
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),

                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  isDark
                                      ? [
                                        Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.9),
                                        Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.7),
                                      ]
                                      : [Color(0xFFE53946), Color(0xFFC1121F)],
                            ),

                            borderRadius: BorderRadius.circular(AppRadius.xl),
                          ),

                          child: Row(
                            children: [
                              /// AVATAR LETTER
                              Container(
                                height: 64,
                                width: 64,

                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),

                                  borderRadius: BorderRadius.circular(22),
                                ),

                                child: Center(
                                  child: Text(
                                    letter,

                                    style: const TextStyle(
                                      color: Colors.white,

                                      fontWeight: FontWeight.w900,

                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              /// TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      l10n.appName,

                                      style: TextStyle(
                                        color: Colors.white,

                                        fontSize: 22,

                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),

                                    SizedBox(height: 6),

                                    Text(
                                      l10n.smartDonationAndEmergencies,

                                      style: TextStyle(
                                        color: Colors.white70,

                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// ==========================================
                        /// MENU ITEMS
                        /// ==========================================
                        _drawerItem(
                          context,

                          icon: Icons.person_outline_rounded,

                          title: l10n.profile,

                          onTap: () {
                            context.pop();

                            context.push(RouteNames.profile);
                          },
                        ),

                        _drawerItem(
                          context,

                          icon: Icons.notifications_active_rounded,

                          title: l10n.notifications,

                          onTap: () {
                            context.pop();

                            context.push(RouteNames.notifications);
                          },
                        ),

                        _drawerItem(
                          context,
                          icon: Icons.history_rounded,
                          title: l10n.donationHistory,
                          onTap: () {
                            context.pop();
                            context.go(RouteNames.donations);
                          },
                        ),

                        /// 🔥 DEMANDES
                        _drawerItem(
                          context,

                          icon: Icons.bloodtype_rounded,

                          title: l10n.urgentRequests,

                          onTap: () {
                            context.pop();

                            context.push(RouteNames.demandeSang);
                          },
                        ),

                        /// 🔥 SETTINGS
                        _drawerItem(
                          context,

                          icon: Icons.settings_outlined,

                          title: l10n.settings,

                          onTap: () {
                            context.pop();

                            context.push(RouteNames.settings);
                          },
                        ),

                        const SizedBox(height: 30),

                        /// ==========================================
                        /// LANGUAGES
                        /// ==========================================
                        // Row(
                        //   children: [
                        //     Row(
                        //       children: [
                        //         _langButton(
                        //           context,
                        //           'FR',
                        //           onTap: () {
                        //             localeNotifier.value = const Locale('fr');
                        //           },
                        //         ),

                        //         const SizedBox(width: 10),

                        //         _langButton(
                        //         context,
                        //         'AR',
                        //           onTap: () {
                        //             localeNotifier.value = const Locale('ar');
                        //           },
                        //         ),

                        //         const SizedBox(width: 10),

                        //         _langButton(
                        //         context,
                        //         'EN',
                        //           onTap: () {
                        //             localeNotifier.value = const Locale('en');
                        //           },
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),

                        // const SizedBox(height: 26),

                        /// ==========================================
                        /// LOGOUT
                        /// ==========================================
                        GestureDetector(
                          onTap: () async {
                            /// LOGOUT AUTH
                            await ref
                                .read(authControllerProvider.notifier)
                                .logout();

                            /// CLEAR PROFILE
                            ref.invalidate(profileControllerProvider);

                            /// CLEAR DONATIONS
                            ref.invalidate(myDonationsProvider);

                            if (!context.mounted) return;

                            /// GO LOGIN
                            context.go(RouteNames.loginUser);
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),

                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),

                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout_rounded,

                                  color: Theme.of(context).colorScheme.primary,
                                ),

                                SizedBox(width: 12),

                                Text(
                                  l10n.logout,

                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,

                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// 🔥 reste écran clickable
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  /// ==========================================
  /// DRAWER ITEM
  /// ==========================================

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(18),

          onTap: onTap,

          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),

            child: Row(
              children: [
                /// ICON
                Container(
                  height: 46,
                  width: 46,

                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 14),

                /// TITLE
                Expanded(
                  child: Text(
                    title,

                    style: const TextStyle(
                      fontSize: 15,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                /// ARROW
                const Icon(
                  Icons.arrow_forward_ios_rounded,

                  size: 16,

                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ==========================================
  /// LANG BUTTON
  /// ==========================================

  Widget _langButton(BuildContext context, String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),

          borderRadius: BorderRadius.circular(14),
        ),

        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
