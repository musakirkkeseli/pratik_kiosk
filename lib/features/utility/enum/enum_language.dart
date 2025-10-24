// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// import '../const/constant_string.dart';

// enum LanguageType { turkish, english, arabic }

// extension LanguageSelectedExtension on LanguageType {
//   LanguageType selectedLocalValue(BuildContext context) {
//     switch (context.locale) {
//       case ConstantString.TR_LOCALE:
//         return LanguageType.turkish;
//       case ConstantString.EN_LOCALE:
//         return LanguageType.english;
//       case ConstantString.AR_LOCALE:
//         return LanguageType.arabic;
//       default:
//         return LanguageType.turkish;
//     }
//   }
// }

// extension LanguageLocaleExtension on LanguageType {
//   Locale get localValue {
//     switch (this) {
//       case LanguageType.turkish:
//         return ConstantString.TR_LOCALE;
//       case LanguageType.english:
//         return ConstantString.EN_LOCALE;
//       case LanguageType.arabic:
//         return ConstantString.AR_LOCALE;
//     }
//   }
// }

// extension LanguageCountryCodeExtension on LanguageType {
//   String get countryCodeValue {
//     switch (this) {
//       case LanguageType.turkish:
//         return ConstantString.turkish;
//       case LanguageType.english:
//         return ConstantString.english;
//       case LanguageType.arabic:
//         return ConstantString.arabic;
//     }
//   }
// }
