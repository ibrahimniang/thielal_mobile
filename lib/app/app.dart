import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import '../features/devices/data/device_repository.dart';

import '../l10n/app_localizations.dart';

import 'services/locale_service.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Application principale.
///
/// Ce fichier centralise :
/// - le thème global
/// - le routeur principal
/// - la configuration générale de MaterialApp
///
/// IMPORTANT :
/// le GoRouter doit être créé une seule fois.
/// S'il est recréé à chaque build, il repart sur `initialLocation`
/// et peut provoquer une boucle infinie sur le SplashScreen.
class ThielalApp extends ConsumerStatefulWidget {
  const ThielalApp({super.key});

  @override
  ConsumerState<ThielalApp> createState() => _ThielalAppState();
}

class _ThielalAppState extends ConsumerState<ThielalApp>
    with WidgetsBindingObserver {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _router = AppRouter.router(ref);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      try {
        await DeviceRepository().ping();

        debugPrint("📡 Device ping envoyé");
      } catch (e) {
        debugPrint("❌ Device ping error => $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: localeNotifier,

      builder: (context, locale, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,

          title: 'Thielal / LifeLink',

          theme: AppTheme.lightTheme,

          routerConfig: _router,

          /// =========================
          /// LOCALIZATION
          /// =========================
          locale: locale,

          localizationsDelegates: AppLocalizations.localizationsDelegates,

          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
