import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../app/router/route_names.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/profile/application/profile_controller.dart';
import '../../features/donations/application/donation_controller.dart';

class SessionLogoutService {
  static bool _isLoggingOut = false;

  static Future<void> logout(ProviderContainer container) async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;

    try {
      await container.read(authControllerProvider.notifier).logout();
      final authState = container.read(authControllerProvider);

      debugPrint(
        'AFTER LOGOUT => '
        'auth=${authState.isAuthenticated}, '
        'user=${authState.currentUser}, '
        'token=${authState.accessToken}',
      );
      debugPrint('LOGOUT START');
      container.invalidate(profileControllerProvider);

      container.invalidate(myDonationsProvider);
      debugPrint('AUTH LOGOUT DONE');

      final context = rootNavigatorKey.currentContext;

      if (context != null && context.mounted) {
        debugPrint('GO LOGIN');
        debugPrint('LOGIN ROUTE = ${RouteNames.loginUser}');
        debugPrint('HOME ROUTE = ${RouteNames.home}');
        context.go(RouteNames.loginUser);
      }
    } finally {
      _isLoggingOut = false;
    }
  }
}
