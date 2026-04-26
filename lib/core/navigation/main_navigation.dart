import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  int _index(String location) {
    if (location.startsWith(RouteNames.home)) return 0;
    if (location.startsWith(RouteNames.map)) return 1;
    if (location.startsWith(RouteNames.profile)) return 2;
    if (location.startsWith(RouteNames.settings)) return 3;
    if (location.startsWith(RouteNames.notifications)) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _index(location);

    return Scaffold(
      body: child,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go(RouteNames.home);
              break;
            case 1:
              context.go(RouteNames.map);
              break;
            case 2:
              context.go(RouteNames.profile);
              break;
            case 3:
              context.go(RouteNames.settings);
              break;
            case 4:
              context.go(RouteNames.notifications);
          }
        },

        selectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Carte",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Paramètres",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "notifications",
          ),
        ],
      ),
    );
  }
}
