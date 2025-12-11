import 'package:flutter/material.dart';

import '../const/constant_color.dart';

/// Kolay renk erişimi için extension
extension AppColors on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // Ana renkler
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.surface;
  Color get surfaceColor => colorScheme.surface;
  
  // Durum renkleri
  Color get errorColor => colorScheme.error;
  Color get successColor => ConstColor.green;
  Color get warningColor => ConstColor.orange;
  Color get infoColor => ConstColor.blue;
  
  // Özel renkler
  Color get textFieldBorderColor => ConstColor.grey300;
  Color get dividerColor => ConstColor.grey200;
  Color get cardBackgroundColor => ConstColor.white;
}
