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
        
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            elevation: isSelected ? 2 : 0,
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            await context.setLocale(language.locale);
            LanguageManager.instance.setLocale(language.locale);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text(
                language.flag,
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                language.language,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

    
}