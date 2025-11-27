import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/extension/text_theme_extension.dart';

import '../../../../../core/utility/language_manager.dart';
import '../../../../../features/utility/const/constant_color.dart';

class LanguageButtonWidget2 extends StatelessWidget {
  final BuildContext cubitContext;
  const LanguageButtonWidget2({super.key, required this.cubitContext});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: LanguageManager.instance.appSupportLanguageList.map((language) {
        final isSelected = context.locale == language.locale;
        return OutlinedButton(
          onPressed: () async {
            // cubitContext.read<PatientLoginCubit>().onChanged('force');
            await context.setLocale(language.locale);
            LanguageManager.instance.setLocale(language.locale);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Text(language.flag, style: context.languageFlag),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : ConstColor.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  language.language,
                  style: context.languageText.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? ConstColor.white
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
