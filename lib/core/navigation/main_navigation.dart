import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thielal/features/notifications/presentation/controllers/notification_controller.dart';

import '../../app/router/route_names.dart';
import '../../l10n/app_localizations.dart';

class MainNavigation extends ConsumerWidget {
  final Widget child;

  const MainNavigation({
    super.key,
    required this.child,
  });

  int _index(String location) {

    if (location.startsWith(RouteNames.home)) return 0;
    if (location.startsWith(RouteNames.map)) return 1;
    if (location.startsWith(RouteNames.donations) ||
        location.startsWith(RouteNames.demandeSang)) return 2;
    if (location.startsWith(RouteNames.settings)) return 3;
    if (location.startsWith(RouteNames.notifications)) return 4;

    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

      /// ==========================================
      /// BODY
      /// ==========================================

    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _index(location);

    final unreadCountAsync =
        ref.watch(unreadNotificationCountProvider);

    unreadCountAsync.when(
      data: (count) => debugPrint('🔔 BADGE COUNT = $count'),
      loading: () => debugPrint('🔔 BADGE LOADING'),
      error: (e, _) => debugPrint('🔔 BADGE ERROR = $e'),
    );

    return Scaffold(
      extendBody: true,

      body: SafeArea(
        bottom: false,
        child: child,
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
          child: SizedBox(
            height: 82,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        height: 66,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.45),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _NavItem(
                                icon: Icons.home_rounded,
                                label: l10n.home,
                                selected: currentIndex == 0,
                                onTap: () => context.go(RouteNames.home),
                              ),
                            ),
                            Expanded(
                              child: _NavItem(
                                icon: Icons.location_on_rounded,
                                label: l10n.centers,
                                selected: currentIndex == 1,
                                onTap: () => context.go(RouteNames.map),
                              ),
                            ),
                            const SizedBox(width: 74),
                            Expanded(
                              child: _NavItem(
                                icon: Icons.settings_rounded,
                                label: l10n.settings,
                                selected: currentIndex == 3,
                                onTap: () => context.go(RouteNames.settings),
                              ),
                            ),
                            Expanded(
                              child: _NotificationNavItem(
                                label: l10n.notifications,
                                selected: currentIndex == 4,
                                unreadCountAsync: unreadCountAsync,
                                onTap: () => context.go(RouteNames.notifications),

                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: -6,
                  child: GestureDetector(
                    onTap: () => context.go(RouteNames.demandeSang),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 68,
                          width: 68,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFE53946),
                                Color(0xFFC1121F),
                              ],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                          child: Icon(
                            Icons.bloodtype_rounded,
                            color: Colors.white,
                            size: currentIndex == 2 ? 34 : 30,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.request,
                          style: TextStyle(
                            color: currentIndex == 2
                                ? const Color(0xFFE53946)
                                : Colors.grey.shade500,
                            fontWeight: FontWeight.w800,

                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// ==========================================
/// NAV ITEM
/// ==========================================

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFE53946).withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 22,
              color: selected
                  ? const Color(0xFFE53946)
                  : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected
                  ? const Color(0xFFE53946)
                  : Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

}

class _NotificationNavItem extends StatelessWidget {
  final bool selected;
  final String label;
  final AsyncValue<int> unreadCountAsync;
  final VoidCallback onTap;

  const _NotificationNavItem({
    required this.selected,
    required this.label,
    required this.unreadCountAsync,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFE53946).withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_rounded,
                  size: 22,
                  color: selected
                      ? const Color(0xFFE53946)
                      : Colors.grey.shade500,
                ),
                unreadCountAsync.when(
                  data: (count) {
                    if (count <= 0) return const SizedBox();
                    return Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: selected
                  ? const Color(0xFFE53946)
                  : Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
  