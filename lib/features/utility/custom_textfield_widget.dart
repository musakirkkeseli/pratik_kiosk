import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/features/utility/custom_input_container.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';

class CustomTextfieldWidget extends StatelessWidget {
  final EnumTextformfield type;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? customValidator;
  final int? customMaxLength;
  final List<TextInputFormatter>? customInputFormatters;
  final String? customLabel; // Dinamik label için
  final bool readOnly; // Readonly özelliği
  final FocusNode? focusNode; // Focus yönetimi
  final TextInputAction? textInputAction; // Enter aksiyonu
  final void Function()? onFieldSubmitted; // Enter'a basıldığında

  const CustomTextfieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSaved,
    this.customValidator,
    this.customMaxLength,
    this.customInputFormatters,
    this.customLabel,
    required this.type,
    this.readOnly = false,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputContainer(
      type: type,
      customLabel: customLabel,
      child: TextFormField(
        controller: controller,
        obscureText: type.obscureText,
        keyboardType: type.keyboardType,
        inputFormatters: customInputFormatters ?? type.inputFormatters,
        maxLength: customMaxLength ?? type.maxLength,
        validator: customValidator ?? type.validator,
        onChanged: onChanged,
        onSaved: onSaved,
        readOnly: readOnly,
        focusNode: focusNode,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (_) => onFieldSubmitted?.call(),
        style: TextStyle(
          fontSize: 25,
          color: readOnly ? Colors.grey.shade600 : Colors.black,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          counterText: '', // maxLength sayacını kaldırır
        ),
      ),
    );
  }
}
