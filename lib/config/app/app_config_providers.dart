import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en'));

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    state = locale;
  }

  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'en'
        ? const Locale('es')
        : const Locale('en');
    await setLocale(newLocale);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>(
  (ref) => LanguageNotifier(),
);
