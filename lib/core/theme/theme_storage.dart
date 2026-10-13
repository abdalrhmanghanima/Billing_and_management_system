import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight local persistence for the app-wide theme preference.
class ThemeStorage {
  ThemeStorage._();

  static final ThemeStorage instance = ThemeStorage._();

  static const String themeModeKey = 'app_theme_mode';

  SharedPreferences? _preferences;

  Future<void> init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
    } catch (_) {
      _preferences = null;
    }
  }

  ThemeMode load() {
    try {
      final raw = _preferences?.getString(themeModeKey);
      switch (raw) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    } catch (_) {
      return ThemeMode.system;
    }
  }

  Future<void> save(ThemeMode mode) async {
    try {
      await _preferences?.setString(themeModeKey, mode.name);
    } catch (_) {}
  }
}
