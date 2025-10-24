import 'package:flutter/material.dart';

/// Kolay renk erişimi için extension
extension AppColors on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // Ana renkler
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.background;
  Color get surfaceColor => colorScheme.surface;
  
  // Durum renkleri
  Color get errorColor => colorScheme.error;
  Color get successColor => Colors.green;
  Color get warningColor => Colors.orange;
  Color get infoColor => Colors.blue;
  
  // Özel renkler
  Color get textFieldBorderColor => Colors.grey[300]!;
  Color get dividerColor => Colors.grey[200]!;
  Color get cardBackgroundColor => Colors.white;
}
