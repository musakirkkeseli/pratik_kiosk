import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/custom_extension.dart';
import '../../product/auth/hospital_login/model/config_response_model.dart';

class DynamicThemeProvider extends ChangeNotifier {
  static final DynamicThemeProvider _instance =
      DynamicThemeProvider._internal();
  factory DynamicThemeProvider() => _instance;
  DynamicThemeProvider._internal();

  ThemeData _themeData = ThemeData.light();
  ThemeData get themeData => _themeData;

  void updateTheme(ConfigResponseModel config) {
    final primaryColorHex = config.color?.primaryColor;
    if (primaryColorHex != null) {
      final color = primaryColorHex.toColor();
      _themeData = ThemeData(
        primaryColor: color,
        colorScheme: ColorScheme.fromSeed(seedColor: color),
      );
      notifyListeners();
    }
  }
}
