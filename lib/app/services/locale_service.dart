import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<Locale> localeNotifier =
    ValueNotifier(const Locale('fr'));

class LocaleService {
  static const String _localeKey = 'app_locale';

  static Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode = prefs.getString(_localeKey);

    if (languageCode != null) {
      localeNotifier.value = Locale(languageCode);
    }
  }

  static Future<void> changeLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_localeKey, languageCode);

    localeNotifier.value = Locale(languageCode);
  }
}