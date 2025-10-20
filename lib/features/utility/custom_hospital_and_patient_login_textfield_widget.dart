import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';

class CustomHospitalAndPatientLoginTextfieldWidget extends StatelessWidget {
  final EnumTextformfield type;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  const CustomHospitalAndPatientLoginTextfieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: type.obscureText,
            keyboardType: type.keyboardType,
            inputFormatters: type.inputFormatters,
            maxLength: type.maxLength,
            validator: type.validator,
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              counterText: '', // maxLength sayacını kaldırır
            ),
          ),
        ),
      ],
    );
  }
}
