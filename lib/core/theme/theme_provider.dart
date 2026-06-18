import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool(_key) ?? false;

    state = isDark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final newMode = state == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    state = newMode;

    await prefs.setBool(
      _key,
      newMode == ThemeMode.dark,
    );
  }

  Future<void> setTheme(
    ThemeMode mode,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    state = mode;

    await prefs.setBool(
      _key,
      mode == ThemeMode.dark,
    );
  }
}