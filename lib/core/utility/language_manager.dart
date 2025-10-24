import 'package:flutter/material.dart';

import '../../features/utility/const/constant_string.dart';

class LanguageManager {
  LanguageManager._();
  static final LanguageManager instance = LanguageManager._();

  Locale _currentLocale = const Locale('tr');

  void setLocale(Locale locale) {
    _currentLocale = locale;
  }

  Locale get currentLocale => _currentLocale;
  String get languageCode => _currentLocale.languageCode;

  String _getLanguageFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return "Türkçe";
      case 'en':
        return "English";
      case 'ar':
        return "العربية";
      case 'ru':
        return "Русский";
      default:
        return "English";
    }
  }

  String _getLanguageFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return '🇹🇷';
      case 'en':
        return '🇬🇧';
      case 'ar':
        return '🇸🇦';
      default:
        return '🌐';
    }
  }

  String get currentLanguage => _getLanguageFromLocale(_currentLocale);

  late final List<AppSupportLanguage> appSupportLanguageList = ConstantString
      .SUPPORTED_LOCALE
      .map(
        (locale) => AppSupportLanguage(
          locale: locale,
          language: _getLanguageFromLocale(locale),
          flag: _getLanguageFlag(locale),
        ),
      )
      .toList();
}

class AppSupportLanguage {
  final Locale locale;
  final String language;
  final String flag;

  AppSupportLanguage({
    required this.locale,
    required this.language,
    required this.flag,
  });
}
