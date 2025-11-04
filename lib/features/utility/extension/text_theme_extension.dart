import 'package:flutter/material.dart';

/// TextTheme için kolay kullanım extension'ı
/// Uygulama genelinde tutarlı text stilleri için
extension AppTextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Başlıklar
  TextStyle get pageTitle =>
      textTheme.headlineLarge!.copyWith(color: Theme.of(this).primaryColor);

  TextStyle get sectionTitle =>
      textTheme.titleLarge!.copyWith(color: Theme.of(this).primaryColor);

  TextStyle get cardTitle =>
      textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600);

  // Body metinler
  TextStyle get bodyPrimary => textTheme.bodyLarge!;

  TextStyle get bodySecondary =>
      textTheme.bodyMedium!.copyWith(color: Colors.grey[600]);

  // Butonlar
  TextStyle get buttonText =>
      textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600);

  // Küçük metinler
  TextStyle get caption =>
      textTheme.bodySmall!.copyWith(color: Colors.grey[500]);

  // Özel renkli metinler
  TextStyle get primaryText =>
      textTheme.bodyLarge!.copyWith(color: Theme.of(this).primaryColor);

  TextStyle get errorText => textTheme.bodyMedium!.copyWith(color: Colors.red);

  TextStyle get successText =>
      textTheme.bodyLarge!.copyWith(color: Colors.green, fontSize: 20);
}
