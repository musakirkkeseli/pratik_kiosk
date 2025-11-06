import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utility/language_manager.dart';
import '../../cubit/patient_login_cubit.dart';

class LanguageButtonWidget extends StatelessWidget {
  final BuildContext cubitContext;
  const LanguageButtonWidget({super.key, required this.cubitContext});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: LanguageManager.instance.appSupportLanguageList.map((language) {
        final isSelected = context.locale == language.locale;
        return OutlinedButton(
          onPressed: () async {
            cubitContext.read<PatientLoginCubit>().onChanged('force');
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
