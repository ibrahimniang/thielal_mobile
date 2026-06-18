import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';

class PremiumHomeNavigation extends StatelessWidget {
  final int currentIndex;

  const PremiumHomeNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(30),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),

            blurRadius: 30,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          /// HOME
          _item(
            context,
            icon: Icons.home_rounded,
            index: 0,
            route: RouteNames.home,
          ),

          /// MAP
          _item(
            context,
            icon: Icons.map_rounded,
            index: 1,
            route: RouteNames.map,
          ),

          /// CENTER BUTTON
          GestureDetector(
            onTap: () {
              /// TODO
              /// DEMANDE SANG
            },

            child: Container(
              height: 68,
              width: 68,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              ),

                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.35),

                    blurRadius: 24,

                    offset: const Offset(0, 12),
                  ),
                ],
              ),

              Icon(
                Icons.bloodtype_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 34,
              ),
            ),
          ),

          /// NOTIFICATIONS
          _item(
            context,
            icon: Icons.notifications_rounded,
            index: 3,
            route: RouteNames.notifications,
          ),

          /// PROFILE
          _item(
            context,
            icon: Icons.person_rounded,
            index: 4,
            route: RouteNames.profile,
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required int index,
    required String route,
  }) {
    final selected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        context.go(route);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color:
             selected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.10)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(18),
        ),

        child: Icon(
          icon,

         color: selected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),

          size: 28,
        ),
      ),
    );
  }
}
