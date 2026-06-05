import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../l10n/app_localizations.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({
    super.key,
    required this.child,
  });

  int _index(String location) {
    if (location.startsWith(RouteNames.home)) {
      return 0;
    }

    if (location.startsWith(RouteNames.map)) {
      return 1;
    }

    if (location.startsWith(RouteNames.demandeSang)) {
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

    final location =
        GoRouterState.of(context).uri.toString();

    final currentIndex =
        _index(location);

    return Scaffold(
      extendBody: true,

      /// ==========================================
      /// BODY
      /// ==========================================
      body: SafeArea(
        bottom: false,
        child: child,
      ),

      /// ==========================================
      /// NAVIGATION
      /// ==========================================
      bottomNavigationBar: SafeArea(
        top: false,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            14,
            0,
            14,
            10,
          ),

          child: SizedBox(
            height: 82,

            child: Stack(
              alignment:
                  Alignment.bottomCenter,

              clipBehavior: Clip.none,

              children: [
                /// ==========================================
                /// BACKGROUND NAVBAR
                /// ==========================================
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,

                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      28,
                    ),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 20,
                        sigmaY: 20,
                      ),

                      child: Container(
                        height: 66,

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),

                        decoration: BoxDecoration(
                          color:
                              Colors.white.withOpacity(
                            0.92,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            28,
                          ),

                          border: Border.all(
                            color:
                                Colors.white.withOpacity(
                              0.45,
                            ),
                          ),

                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(
                                0.08,
                              ),

                              blurRadius: 24,

                              offset:
                                  const Offset(
                                0,
                                10,
                              ),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            /// ==========================================
                            /// HOME
                            /// ==========================================
                            Expanded(
                              child: _NavItem(
                                icon:
                                    Icons.home_rounded,

                                label:
                                    l10n.home,

                                selected:
                                    currentIndex ==
                                        0,

                                onTap: () {
                                  context.go(
                                    RouteNames.home,
                                  );
                                },
                              ),
                            ),

                            /// ==========================================
                            /// MAP
                            /// ==========================================
                            Expanded(
                              child: _NavItem(
                                icon: Icons
                                    .location_on_rounded,

                                label:
                                    l10n.centers,

                                selected:
                                    currentIndex ==
                                        1,

                                onTap: () {
                                  context.go(
                                    RouteNames.map,
                                  );
                                },
                              ),
                            ),

                            /// CENTER SPACE
                            const SizedBox(
                              width: 74,
                            ),

                            /// ==========================================
                            /// SETTINGS
                            /// ==========================================
                            Expanded(
                              child: _NavItem(
                                icon: Icons
                                    .settings_rounded,

                                label:
                                    l10n.settings,

                                selected:
                                    currentIndex ==
                                        3,

                                onTap: () {
                                  context.go(
                                    RouteNames
                                        .settings,
                                  );
                                },
                              ),
                            ),

                            /// ==========================================
                            /// NOTIFICATIONS
                            /// ==========================================
                            Expanded(
                              child: _NavItem(
                                icon: Icons
                                    .notifications_rounded,

                                label: l10n
                                    .notifications,

                                selected:
                                    currentIndex ==
                                        4,

                                onTap: () {
                                  context.go(
                                    RouteNames
                                        .notifications,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// ==========================================
                /// CENTER FLOATING BUTTON
                /// ==========================================
                Positioned(
                  top: -6,

                  child: GestureDetector(
                    onTap: () {
                      context.go(
                        RouteNames.demandeSang,
                      );
                    },

                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration:
                              const Duration(
                            milliseconds: 250,
                          ),

                          height: 68,
                          width: 68,

                          decoration: BoxDecoration(
                            gradient:
                                const LinearGradient(
                              begin:
                                  Alignment.topLeft,

                              end: Alignment
                                  .bottomRight,

                              colors: [
                                Color(
                                  0xFFE53946,
                                ),

                                Color(
                                  0xFFC1121F,
                                ),
                              ],
                            ),

                            shape: BoxShape.circle,

                            border: Border.all(
                              color:
                                  Colors.white,

                              width: 5,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(
                                  0xFFE53946,
                                ).withOpacity(
                                  0.32,
                                ),

                                blurRadius: 20,

                                offset:
                                    const Offset(
                                  0,
                                  8,
                                ),
                              ),
                            ],
                          ),

                          child: Icon(
                            Icons
                                .bloodtype_rounded,

                            color:
                                Colors.white,

                            size: currentIndex ==
                                    2
                                ? 34
                                : 30,
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Text(
                          l10n.request,

                          style: TextStyle(
                            color:
                                currentIndex ==
                                        2
                                    ? const Color(
                                      0xFFE53946,
                                    )
                                    : Colors
                                        .grey
                                        .shade500,

                            fontWeight:
                                FontWeight.w800,

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
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          AnimatedContainer(
            duration:
                const Duration(
              milliseconds: 220,
            ),

            height: 36,
            width: 36,

            decoration: BoxDecoration(
              color: selected
                  ? const Color(
                    0xFFE53946,
                  ).withOpacity(0.12)
                  : Colors.transparent,

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: Icon(
              icon,

              color: selected
                  ? const Color(
                    0xFFE53946,
                  )
                  : Colors.grey.shade500,

              size: 22,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,

            overflow:
                TextOverflow.ellipsis,

            style: TextStyle(
              color: selected
                  ? const Color(
                    0xFFE53946,
                  )
                  : Colors.grey.shade500,

              fontSize: 10,

              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}