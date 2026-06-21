import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thielal/features/onboarding/presentation/onboarding_screen.dart';

// CHAT
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/conversations_screen.dart';

// AUTH
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/screens/entry_identity_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_user_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/set_password_screen.dart';


// USER
import '../../features/home/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/public_user_profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/centers/presentation/screens/centers_map_screen.dart';
import '../../features/donations/presentation/screens/donation_history_screen.dart';
import '../../features/donations/presentation/screens/demande_sang_screen.dart';
import 'package:thielal/features/donations/presentation/screens/my_demandes_screen.dart';

import '../../features/notifications/presentation/screens/notifications_list_screen.dart';
import '../../features/alerts/data/models/alert_model.dart';

// SPLASH
import '../../features/splash/presentation/splash_screen.dart';
import '../../core/navigation/main_navigation.dart';
import 'route_names.dart';

// acceptation des condistion
import '../../features/auth/presentation/screens/terms_screen.dart';
import '../../features/auth/presentation/screens/privacy_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: RouteNames.splash,

      redirect: (context, state) {
        final authState = ref.read(authControllerProvider);

        final isAuthenticated =
            authState.isAuthenticated &&
            authState.currentUser != null &&
            authState.accessToken != null &&
            authState.accessToken!.isNotEmpty;

        final roleId = authState.currentUser?.roleId;
        final path = state.uri.path;

        final publicRoutes = <String>{
          RouteNames.splash,
          RouteNames.loginUser,
          RouteNames.forgotPassword,
          RouteNames.resetPassword,
          RouteNames.onboarding,

          RouteNames.terms,
          RouteNames.privacy,
        };

        final registrationRoutes = <String>{
          RouteNames.entryIdentity,
          RouteNames.otpVerification,
          RouteNames.register,
          RouteNames.setPassword,
        };

        final isPublic = publicRoutes.contains(path);
        final isRegistrationRoute = registrationRoutes.contains(path);

        final isInRegistrationFlow =
            authState.pendingPhone != null ||
            authState.pendingEmail != null ||
            authState.otpVerified ||
            authState.pendingUserId != null;

        // =========================
        // NON CONNECTÉ
        // =========================
        if (!isAuthenticated) {
          if (path == RouteNames.entryIdentity) return null;

          if (path == RouteNames.home && isInRegistrationFlow) {
            return null;
          }

          if (path == RouteNames.otpVerification ||
              path == RouteNames.register ||
              path == RouteNames.setPassword) {
            return isInRegistrationFlow ? null : RouteNames.loginUser;
          }

          if (isPublic) return null;

          return RouteNames.loginUser;
        }

        // =========================
        // CONNECTÉ
        // =========================
        if (isPublic || isRegistrationRoute) {
          if (roleId == 1) return RouteNames.adminDashboard;
          if (roleId == 3) return RouteNames.staffDashboard;
          if (roleId == 4) return RouteNames.directorDashboard;

          return RouteNames.home;
        }

        return null;
      },

      routes: [
        // ================= SPLASH =================
        GoRoute(
          path: RouteNames.splash,
          builder: (_, __) => const SplashScreen(),
        ),

        GoRoute(
          path: RouteNames.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),

        // ================= AUTH =================
        GoRoute(
          path: RouteNames.loginUser,
          builder: (_, __) => const LoginUserScreen(),
        ),

        GoRoute(
          path: RouteNames.onboarding,
          builder: (_, __) => const _PlaceholderScreen(title: 'Onboarding'),
        ),

        GoRoute(
          path: RouteNames.entryIdentity,
          builder: (_, __) => const EntryIdentityScreen(),
        ),

        GoRoute(
          path: RouteNames.otpVerification,
          builder:
              (_, __) => const _PlaceholderScreen(title: 'OTP Verification'),
        ),

        GoRoute(
          path: RouteNames.register,
          builder: (_, __) => const RegisterScreen(),
        ),

        GoRoute(
          path: RouteNames.terms,
          builder: (_, __) => const TermsScreen(),
        ),

        GoRoute(
          path: RouteNames.privacy,
          builder: (_, __) => const PrivacyScreen(),
        ),

        GoRoute(
          path: RouteNames.setPassword,
          builder: (_, __) => const SetPasswordScreen(),
        ),

        GoRoute(
          path: RouteNames.forgotPassword,
          builder: (_, __) => const ForgotPasswordScreen(),
        ),

        GoRoute(
          path: RouteNames.resetPassword,
          builder: (_, state) {
            final extra = state.extra as Map<String, dynamic>?;

            return ResetPasswordScreen(
              telephone: extra?['telephone']?.toString(),
            );
          },
        ),

        // ================= APP SHELL =================
        ShellRoute(
          builder: (context, state, child) {
            return MainNavigation(child: child);
          },
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (_, __) => const HomeScreen(),
            ),

            GoRoute(
              path: RouteNames.profile,
              builder: (_, __) => const ProfileScreen(),
            ),

            GoRoute(
              path: '${RouteNames.publicProfile}/:id',
              builder: (context, state) {
                final userId = int.parse(state.pathParameters['id']!);

                return PublicUserProfileScreen(userId: userId);
              },
            ),

            GoRoute(
              path: RouteNames.settings,
              builder: (_, __) => const SettingsScreen(),
            ),

            GoRoute(
              path: RouteNames.map,
              builder: (context, state) {
                final extra = state.extra;

                debugPrint('MAP EXTRA => ${extra.runtimeType}');

                return CentersMapScreen(
                  initialSearch: extra is String ? extra : null,
                  initialCenter: extra is AlertCenterModel ? extra : null,
                );
              },
            ),

            GoRoute(
              path: '/notifications',
              builder: (_, __) => const NotificationsListScreen(),
            ),

            GoRoute(
              path: RouteNames.donations,
              builder: (_, __) => const DonationHistoryScreen(),
            ),

            GoRoute(
              path: RouteNames.demandeSang,
              builder: (_, __) => const DemandeSangScreen(),
            ),

            GoRoute(
              path: '/my-demandes',
              builder: (_, __) => const MyDemandesScreen(),
            ),
          ],
        ),

        // ================= CHAT =================
        GoRoute(
          path: RouteNames.conversations,
          builder: (_, __) => const ConversationsScreen(),
        ),

        GoRoute(
          path: '/chat/:conversationId',
          builder: (context, state) {
            final conversationId = int.parse(
              state.pathParameters['conversationId']!,
            );

            final extra = state.extra as Map<String, dynamic>?;

            return ChatScreen(
              conversationId: conversationId,
              fullName: extra?["fullName"] ?? "Discussion",
              otherUserId: extra?["otherUserId"],
            );
          },
        ),



        // ================= STAFF =================
        // GoRoute(
        //   path: RouteNames.staffDashboard,
        //   builder: (_, __) => const StaffDashboardScreen(),
        // ),

        // GoRoute(
        //   path: RouteNames.staffRequests,
        //   builder: (_, __) => const BloodRequestsScreen(),
        // ),

        // GoRoute(
        //   path: RouteNames.staffDonors,
        //   builder: (_, __) => const NearbyDonorsScreen(),
        // ),

        // GoRoute(
        //   path: RouteNames.bloodStock,
        //   builder: (_, __) => const BloodStockScreen(),
        // ),

        // GoRoute(
        //   path: RouteNames.qrScan,
        //   builder: (_, __) => const QrScanScreen(),
        // ),

        // GoRoute(
        //   path: RouteNames.qrGenerate,
        //   builder: (_, __) => const QrGenerateScreen(),
        // ),

        // // ================= DIRECTOR =================
        // GoRoute(
        //   path: RouteNames.directorDashboard,
        //   builder: (_, __) => const DirectorDashboardScreen(),
        // ),

        // GoRoute(
        //   path: RouteNames.createStaff,
        //   builder: (_, __) => const CreateStaffScreen(),
        // ),



        // // ================= ADMIN =================
        GoRoute(
          path: RouteNames.adminDashboard,
          builder:
              (_, __) => const _PlaceholderScreen(title: 'Admin Dashboard'),
        ),
      ],

      errorBuilder:
          (_, state) => Scaffold(
            body: Center(child: Text('Route introuvable : ${state.uri.path}')),
          ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
