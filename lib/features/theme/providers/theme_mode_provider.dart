import 'package:billing_and_sales_management/core/theme/theme_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  ThemeModeNotifier(this._storage);

  final ThemeStorage _storage;

  @override
  ThemeMode build() => _storage.load();

  Future<void> setMode(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    await _storage.save(mode);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  () => ThemeModeNotifier(ThemeStorage.instance),
);
