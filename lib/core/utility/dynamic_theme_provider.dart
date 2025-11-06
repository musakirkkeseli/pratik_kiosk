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
  String _logoUrl = "";
  String get logoUrl => _logoUrl;
  String _qrCodeUrl = "";
  String get qrCodeUrl => _qrCodeUrl;
  String _hospitalName = "";
  String get hospitalName => _hospitalName;

  void updateTheme(ConfigResponseModel config) {
    final hospitalName = config.hospitalName;
    if (hospitalName != null && hospitalName.isNotEmpty) {
      _hospitalName = hospitalName;
    } else {
      _hospitalName = "";
    }

    final primaryColorHex = config.color?.primaryColor;
    if (primaryColorHex != null) {
      final color = primaryColorHex.toColor();
      _themeData = ThemeData(
        primaryColor: color,
        colorScheme: ColorScheme.fromSeed(seedColor: color),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
          ),
        ),
      );
    }
    final logo = config.logo;
    if (logo != null) {
      _logoUrl = logo;
    }
    final qrCode = config.qrCode;
    if (qrCode != null) {
      _qrCodeUrl = qrCode;
    }
    notifyListeners();
  }
}
