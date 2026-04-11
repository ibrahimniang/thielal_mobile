import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/screens/entry_identity_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_office_screen.dart';
import '../../features/auth/presentation/screens/login_user_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/set_password_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: RouteNames.splash,
      redirect: (context, state) {
        final authState = ref.read(authControllerProvider);
        final isAuthenticated = authState.isAuthenticated;
        final path = state.uri.path;

        final isInRegistrationFlow =
            authState.pendingPhone != null ||
            authState.pendingEmail != null ||
            authState.otpVerified;

        final publicRoutes = <String>[
          RouteNames.splash,
          RouteNames.onboarding,
          RouteNames.entryIdentity,
          RouteNames.otpVerification,
          RouteNames.register,
          RouteNames.setPassword,
          RouteNames.loginUser,
          RouteNames.loginOffice,
          RouteNames.forgotPassword,
          RouteNames.resetPassword,
        ];

        final registrationFlowRoutes = <String>[
          RouteNames.entryIdentity,
          RouteNames.register,
          RouteNames.home,
        ];

        if (!isAuthenticated) {
          if (isInRegistrationFlow && registrationFlowRoutes.contains(path)) {
            return null;
          }

          if (!publicRoutes.contains(path)) {
            return RouteNames.loginUser;
          }
        }

        if (isAuthenticated) {
          if (publicRoutes.contains(path)) {
            final role = authState.currentUser?.role?.toLowerCase();

            if (role == 'admin') {
              return RouteNames.adminDashboard;
            }

            if (role == 'staff' || role == 'directeur') {
              return RouteNames.staffDashboard;
            }

            return RouteNames.home;
          }
        }

        final role = authState.currentUser?.role?.toLowerCase();

        if (path.startsWith('/admin') && role != 'admin') {
          return RouteNames.home;
        }

        if (path.startsWith('/staff') &&
            role != 'staff' &&
            role != 'directeur') {
          return RouteNames.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RouteNames.splash,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: RouteNames.onboarding,
          builder:
              (_, __) => const _PlaceholderScreen(title: 'Onboarding Screen'),
        ),
        GoRoute(
          path: RouteNames.entryIdentity,
          builder: (_, __) => const EntryIdentityScreen(),
        ),
        GoRoute(
          path: RouteNames.register,
          builder: (_, __) => const RegisterScreen(),
        ),
        GoRoute(
          path: RouteNames.setPassword,
          builder: (_, __) => const SetPasswordScreen(),
        ),
        GoRoute(
          path: RouteNames.otpVerification,
          builder:
              (_, __) =>
                  const _PlaceholderScreen(title: 'OTP Verification Screen'),
        ),
        GoRoute(
          path: RouteNames.loginUser,
          builder: (_, __) => const LoginUserScreen(),
        ),
        GoRoute(
          path: RouteNames.loginOffice,
          builder: (_, __) => const LoginOfficeScreen(),
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
              email: extra?['email']?.toString(),
              code: extra?['code']?.toString(),
            );
          },
        ),
        GoRoute(path: RouteNames.home, builder: (_, __) => const HomeScreen()),
        GoRoute(
          path: RouteNames.profile,
          builder: (_, __) => const _PlaceholderScreen(title: 'Profile Screen'),
        ),
        GoRoute(
          path: RouteNames.settings,
          builder:
              (_, __) => const _PlaceholderScreen(title: 'Settings Screen'),
        ),
        GoRoute(
          path: RouteNames.notifications,
          builder:
              (_, __) =>
                  const _PlaceholderScreen(title: 'Notifications Screen'),
        ),
        GoRoute(
          path: RouteNames.alerts,
          builder: (_, __) => const _PlaceholderScreen(title: 'Alerts Screen'),
        ),
        GoRoute(
          path: RouteNames.donations,
          builder:
              (_, __) => const _PlaceholderScreen(title: 'Donations Screen'),
        ),
        GoRoute(
          path: RouteNames.centers,
          builder: (_, __) => const _PlaceholderScreen(title: 'Centers Screen'),
        ),
        GoRoute(
          path: RouteNames.donors,
          builder: (_, __) => const _PlaceholderScreen(title: 'Donors Screen'),
        ),
        GoRoute(
          path: RouteNames.staffDashboard,
          builder:
              (_, __) => const _PlaceholderScreen(title: 'Staff Dashboard'),
        ),
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
