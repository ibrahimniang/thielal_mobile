import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../app/services/locale_service.dart';

import '../../l10n/app_localizations.dart';

import '../profile/application/profile_controller.dart';
import '../donations/application/donation_controller.dart';
import '../auth/application/auth_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          Colors.grey.shade100,

      appBar: AppBar(
        title: Text(
          l10n.settings,
        ),

        backgroundColor:
            Colors.red,

        foregroundColor:
            Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(
          16,
        ),

        children: [
          /// =====================================================
          /// ACCOUNT
          /// =====================================================

          _sectionTitle(
            l10n.profile,
          ),

          _tile(
            icon: Icons.person,

            title: l10n.myProfile,

            onTap:
                () => context.go(
                  RouteNames.profile,
                ),
          ),

          _tile(
            icon: Icons.lock,

            title: l10n.password,

            onTap: () {},
          ),

          const SizedBox(height: 20),

          /// =====================================================
          /// APP
          /// =====================================================

          _sectionTitle(
            l10n.settings,
          ),

          _tile(
            icon:
                Icons.notifications,

            title:
                l10n.notifications,

            onTap: () {},
          ),

          /// =====================================================
          /// LANGUAGE
          /// =====================================================

          _tile(
            icon: Icons.language,

            title: l10n.language,

            onTap: () {
              showModalBottomSheet(
                context: context,

                shape:
                    const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(
                            top:
                                Radius.circular(
                                  24,
                                ),
                          ),
                    ),

                builder:
                    (_) => Padding(
                      padding:
                          const EdgeInsets.all(
                            16,
                          ),

                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: [
                          const SizedBox(
                            height: 8,
                          ),

                          Container(
                            width: 60,
                            height: 6,

                            decoration:
                                BoxDecoration(
                                  color:
                                      Colors
                                          .grey
                                          .shade300,

                                  borderRadius:
                                      BorderRadius.circular(
                                        30,
                                      ),
                                ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Text(
                            l10n.changeLanguage,

                            style:
                                const TextStyle(
                                  fontSize: 20,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          /// FR
                          ListTile(
                            leading:
                                const Text(
                                  "🇫🇷",
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),

                            title: Text(
                              l10n.french,
                            ),

                            trailing:
                                const Icon(
                                  Icons
                                      .arrow_forward_ios_rounded,

                                  size: 16,
                                ),

                            onTap: () {
                              localeNotifier
                                      .value =
                                  const Locale(
                                    'fr',
                                  );

                              Navigator.pop(
                                context,
                              );
                            },
                          ),

                          /// EN
                          ListTile(
                            leading:
                                const Text(
                                  "🇺🇸",
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),

                            title: Text(
                              l10n.english,
                            ),

                            trailing:
                                const Icon(
                                  Icons
                                      .arrow_forward_ios_rounded,

                                  size: 16,
                                ),

                            onTap: () {
                              localeNotifier
                                      .value =
                                  const Locale(
                                    'en',
                                  );

                              Navigator.pop(
                                context,
                              );
                            },
                          ),

                          /// AR
                          ListTile(
                            leading:
                                const Text(
                                  "🇲🇷",
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),

                            title: Text(
                              l10n.arabic,
                            ),

                            trailing:
                                const Icon(
                                  Icons
                                      .arrow_forward_ios_rounded,

                                  size: 16,
                                ),

                            onTap: () {
                              localeNotifier
                                      .value =
                                  const Locale(
                                    'ar',
                                  );

                              Navigator.pop(
                                context,
                              );
                            },
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
              );
            },
          ),

          const SizedBox(height: 20),

          /// =====================================================
          /// DONATION
          /// =====================================================

          _sectionTitle(
            l10n.donations,
          ),

          _tile(
            icon:
                Icons.bloodtype_rounded,

            title:
                l10n.donationHistory,

            onTap: () {},
          ),

          _tile(
            icon:
                Icons.location_on_rounded,

            title:
                l10n.healthCenters,

            onTap: () {},
          ),

          const SizedBox(height: 30),

          /// =====================================================
          /// LOGOUT
          /// =====================================================

          ElevatedButton(
            style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,

                  minimumSize:
                      const Size(
                        double.infinity,
                        50,
                      ),

                  shape:
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                              16,
                            ),
                      ),
                ),

            onPressed: () async {
              /// LOGOUT
              await ref
                  .read(
                    authControllerProvider
                        .notifier,
                  )
                  .logout();

              /// CLEAR PROFILE
              ref.invalidate(
                profileControllerProvider,
              );

              /// CLEAR DONATIONS
              ref.invalidate(
                myDonationsProvider,
              );

              if (!context.mounted) {
                return;
              }

              /// REDIRECT
              context.go(
                RouteNames.loginUser,
              );
            },

            child: Text(
              l10n.logout,

              style: const TextStyle(
                color: Colors.white,

                fontWeight:
                    FontWeight.w700,

                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// =====================================================
  /// SECTION TITLE
  /// =====================================================

  Widget _sectionTitle(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),

      child: Text(
        title,

        style: const TextStyle(
          fontWeight: FontWeight.bold,

          fontSize: 16,
        ),
      ),
    );
  }

  /// =====================================================
  /// TILE
  /// =====================================================

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,

      shape:
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
                  15,
                ),
          ),

      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.red,
        ),

        title: Text(
          title,
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),

        onTap: onTap,
      ),
    );
  }
}