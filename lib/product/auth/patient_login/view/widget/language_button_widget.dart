import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utility/language_manager.dart';

class LanguageButtonWidget extends StatelessWidget {
  const LanguageButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: LanguageManager.instance.appSupportLanguageList.map((language) {
        final isSelected = context.locale == language.locale;

        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            elevation: isSelected ? 4 : 0,
            shadowColor: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.5)
                : null,
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: isSelected ? 2.5 : 1.5,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            await context.setLocale(language.locale);
            LanguageManager.instance.setLocale(language.locale);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Text(language.flag, style: const TextStyle(fontSize: 40)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  language.language,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
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
