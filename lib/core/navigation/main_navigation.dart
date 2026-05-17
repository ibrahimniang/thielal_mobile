import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../l10n/app_localizations.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  int _index(String location) {
    if (location.startsWith(RouteNames.home)) {
      return 0;
    }

    if (location.startsWith(RouteNames.map)) {
      return 1;
    }

    if (location.startsWith(RouteNames.donations)) {
      return 2;
    }

    if (location.startsWith(RouteNames.settings)) {
      return 3;
    }

    if (location.startsWith(RouteNames.notifications)) {
      return 4;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final location = GoRouterState.of(context).uri.toString();

    final currentIndex = _index(location);

    final items = [
      {'icon': Icons.home_rounded, 'label': l10n.home},

      {'icon': Icons.location_on_rounded, 'label': l10n.centers},

      {'icon': Icons.bloodtype_rounded, 'label': l10n.request},

      {'icon': Icons.settings_rounded, 'label': l10n.settings},

      {'icon': Icons.notifications_rounded, 'label': l10n.notifications},
    ];

    return Scaffold(
      extendBody: true,

      body: child,

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

        child: SizedBox(
          height: 95,

          child: Stack(
            clipBehavior: Clip.none,

            alignment: Alignment.bottomCenter,

            children: [
              /// ==========================================
              /// NAVBAR BACKGROUND
              /// ==========================================
              Positioned(
                bottom: 0,

                left: 0,
                right: 0,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                    child: Container(
                      height: 78,

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),

                        borderRadius: BorderRadius.circular(32),

                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
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
                        children: List.generate(items.length, (index) {
                          final item = items[index];

                          final isSelected = currentIndex == index;

                          final isCenter = index == 2;

                          /// ==========================================
                          /// CENTER BUTTON
                          /// ==========================================

                          if (isCenter) {
                            return Expanded(child: const SizedBox());
                          }

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    context.go(RouteNames.home);
                                    break;

                                  case 1:
                                    context.go(RouteNames.map);
                                    break;

                                  case 3:
                                    context.go(RouteNames.settings);
                                    break;

                                  case 4:
                                    context.go(RouteNames.notifications);
                                    break;
                                }
                              },

                              behavior: HitTestBehavior.opaque,

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),

                                    height: 44,
                                    width: 44,

                                    decoration: BoxDecoration(
                                      gradient:
                                          isSelected
                                              ? const LinearGradient(
                                                colors: [
                                                  Color(0xFFE53946),
                                                  Color(0xFFC1121F),
                                                ],
                                              )
                                              : null,

                                      borderRadius: BorderRadius.circular(16),
                                    ),

                                    child: Icon(
                                      item['icon'] as IconData,

                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.grey.shade500,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    item['label'] as String,

                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? const Color(0xFFE53946)
                                              : Colors.grey.shade500,

                                      fontSize: 11,

                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),

              /// ==========================================
              /// CENTER FLOATING BUTTON
              /// ==========================================
              Positioned(
                top: -8,

                child: GestureDetector(
                  onTap: () {
                    /// 🔥 ROUTE DEMANDE SANG
                    context.go(RouteNames.demandeSang);
                  },

                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),

                        height: 76,
                        width: 76,

                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,

                            end: Alignment.bottomRight,

                            colors: [Color(0xFFE53946), Color(0xFFC1121F)],
                          ),

                          shape: BoxShape.circle,

                          border: Border.all(color: Colors.white, width: 6),

                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE53946).withOpacity(0.40),

                              blurRadius: 24,

                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),

                        child: const Icon(
                          Icons.bloodtype_rounded,

                          color: Colors.white,

                          size: 34,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        l10n.request,

                        style: TextStyle(
                          color: Color(0xFFE53946),

                          fontWeight: FontWeight.w800,

                          fontSize: 11,
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
    );
  }
}
