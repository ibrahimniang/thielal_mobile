import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../app/services/locale_service.dart';

import '../../l10n/app_localizations.dart';

import '../profile/application/profile_controller.dart';
import '../donations/application/donation_controller.dart';
import '../auth/application/auth_controller.dart';
import '../../../../core/theme/theme_provider.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? colors.surface : const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: Text(l10n.settings),

       backgroundColor: isDark ? colors.surface : Colors.red,
       foregroundColor: isDark ? colors.onSurface : Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          /// =====================================================
          /// ACCOUNT
          /// =====================================================
          _sectionTitle(l10n.profile),

          _tile(
            context: context,
            icon: Icons.person,

            title: l10n.myProfile,

            onTap: () => context.go(RouteNames.profile),
          ),

          _tile(  context: context, icon: Icons.lock, title: l10n.password, onTap: () {}),

          const SizedBox(height: 20),

          /// =====================================================
          /// APP
          /// =====================================================
          _sectionTitle(l10n.settings),

          _tile(
             context: context,
            icon: Icons.notifications,

            title: l10n.notifications,

            onTap: () {},
          ),

          // ajout theme
          Card(
            elevation: 0,
            color: isDark ? colors.surfaceContainerHighest : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SwitchListTile(
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: Colors.red,
              ),
              title: const Text("Thème"),
              subtitle: Text(isDark ? "Mode sombre" : "Mode clair"),
              value: isDark,
              onChanged: (_) {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
          ),


          /// =====================================================
          /// LANGUAGE
          /// =====================================================
          _tile(
            context: context,
            icon: Icons.language,

            title: l10n.language,

            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,

                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),

                builder:
                    (_) => Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          const SizedBox(height: 8),

                          Container(
                            width: 60,
                            height: 6,

                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,

                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            l10n.changeLanguage,

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// FR
                          ListTile(
                            leading: const Text(
                              "🇫🇷",
                              style: TextStyle(fontSize: 24),
                            ),

                            title: Text(l10n.french),

                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,

                              size: 16,
                            ),

                            onTap: () {
                              localeNotifier.value = const Locale('fr');

                              Navigator.pop(context);
                            },
                          ),

                          /// EN
                          ListTile(
                            leading: const Text(
                              "🇺🇸",
                              style: TextStyle(fontSize: 24),
                            ),

                            title: Text(l10n.english),

                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,

                              size: 16,
                            ),

                            onTap: () {
                              localeNotifier.value = const Locale('en');

                              Navigator.pop(context);
                            },
                          ),

                          /// AR
                          ListTile(
                            leading: const Text(
                              "🇲🇷",
                              style: TextStyle(fontSize: 24),
                            ),

                            title: Text(l10n.arabic),

                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,

                              size: 16,
                            ),

                            onTap: () {
                              localeNotifier.value = const Locale('ar');

                              Navigator.pop(context);
                            },
                          ),

                          const SizedBox(height: 110),
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
          _sectionTitle(l10n.donations),

          _tile(
            context: context,
            icon: Icons.bloodtype_rounded,

            title: l10n.donationHistory,

            onTap: () {},
          ),

          _tile(
            context: context,
            icon: Icons.location_on_rounded,

            title: l10n.healthCenters,

            onTap: () {},
          ),

          const SizedBox(height: 30),

          /// =====================================================
          /// LOGOUT
          /// =====================================================
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,

              minimumSize: const Size(double.infinity, 50),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            onPressed: () async {
              /// LOGOUT
              await ref.read(authControllerProvider.notifier).logout();

              /// CLEAR PROFILE
              ref.invalidate(profileControllerProvider);

              /// CLEAR DONATIONS
              ref.invalidate(myDonationsProvider);

              if (!context.mounted) {
                return;
              }

              /// REDIRECT
              context.go(RouteNames.loginUser);
            },

            child: Text(
              l10n.logout,

              style: const TextStyle(
                color: Colors.white,

                fontWeight: FontWeight.w700,

                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  /// =====================================================
  /// SECTION TITLE
  /// =====================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Text(
        title,

        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
  required BuildContext context,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final colors = Theme.of(context).colorScheme;

  return Card(
    elevation: 0,
    color: isDark ? colors.surfaceContainerHighest : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDark ? Colors.white70 : Colors.black54,
      ),
      onTap: onTap,
    ),
  );
}
}
