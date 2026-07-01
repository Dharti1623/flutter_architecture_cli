import 'package:flutter/material.dart';
import 'package:test_app_dir/core/storage/app_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  LocalizationService() {
    _loadLocale();
  }

  void _loadLocale() {
    final String? languageCode = AppPreferences().getString(_localeKey);
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale.languageCode == locale.languageCode) return;
    _currentLocale = locale;
    notifyListeners();
    await AppPreferences().setString(_localeKey, locale.languageCode);
  }

  List<Locale> get supportedLocales => const [
        Locale('en'),
      ];
}
