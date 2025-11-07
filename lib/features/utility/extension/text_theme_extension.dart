import 'package:flutter/material.dart';

import '../const/constant_color.dart';

/// TextTheme için kolay kullanım extension'ı
/// Uygulama genelinde tutarlı text stilleri için
extension AppTextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Başlıklar
  TextStyle get pageTitle =>
      textTheme.headlineLarge!.copyWith(color: Theme.of(this).primaryColor);

  TextStyle get priceTitle => textTheme.headlineMedium!.copyWith(
    color: Theme.of(this).primaryColor,
    fontSize: 23,
  );

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

  TextStyle get hospitalNameText => textTheme.bodyLarge!.copyWith(
    color: ConstColor.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );
  TextStyle get tcLoginText =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.black, fontSize: 38);
  TextStyle get birthDayLoginText =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.black, fontSize: 28);
  TextStyle get otpLoginText =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.black, fontSize: 28);
        TextStyle get languageFlag =>
      textTheme.bodyMedium!.copyWith(fontSize: 35);
}
