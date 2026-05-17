import 'package:flutter/material.dart';

/// =====================================================
/// GLOBAL LOCALE NOTIFIER
/// =====================================================

final ValueNotifier<Locale>
localeNotifier =
    ValueNotifier(
      const Locale('fr'),
    );