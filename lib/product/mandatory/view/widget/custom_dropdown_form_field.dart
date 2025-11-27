import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/extension/input_decoration_extension.dart';

import '../../../../core/model/dropdown_model.dart';
import '../../../../core/utility/logger_service.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/custom_input_container.dart';
import '../../../../features/utility/enum/enum_textformfield.dart';
import '../../cubit/mandatory_cubit.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isReadOnly;
  final String itemId;
  final BuildContext cubitContext;
  final List<Options> optionList;
  final String isNullable;
  final bool? maskValue;
  const CustomDropdownFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.isReadOnly,
    required this.itemId,
    required this.cubitContext,
    required this.optionList,
    required this.isNullable,
    this.maskValue = false,
  });
  @override
  State<CustomDropdownFormField> createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  final ValueNotifier<bool> _obscure = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _obscure.value = widget.maskValue ?? false;
  }

  String _mask(String text) {
    if (text.isEmpty) return '';
    return List.filled(text.length, '•').join();
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputContainer(
      type: EnumTextformfield.mandatory,
      customLabel: widget.label,
      child: ValueListenableBuilder<bool>(
        valueListenable: _obscure,
        builder: (context, obscureValue, child) {
          return DropdownButtonFormField<String>(
            initialValue: widget.controller.text.isNotEmpty
                ? widget.controller.text
                : null,
            decoration: InputDecoration().mandatoryDecoration,
            hint: Text(ConstantString().select),
            disabledHint: widget.controller.text.isNotEmpty
                ? Text(widget.controller.text)
                : null,
            icon: widget.isReadOnly
                ? IconButton(
                    icon: Icon(
                      obscureValue ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      _obscure.value = !_obscure.value;
                    },
                  )
                : null,
            items: widget.optionList
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option.value.toString(),
                    child: Text(
                      obscureValue
                          ? _mask(option.text ?? "")
                          : option.text ?? "",
                    ),
                  ),
                )
                .toList(),
            onChanged: widget.isReadOnly
                ? null
                : (newValue) {
                    widget.controller.text = newValue ?? "";
                  },
            onSaved: (newValue) {
              widget.cubitContext.read<MandatoryCubit>().mandatoryValueSave(
                widget.itemId,
                newValue ?? "",
              );
            },
            validator: (value) {
              if (widget.isNullable == "0" &&
                  (value == null || value.isEmpty)) {
                widget.cubitContext
                    .read<MandatoryCubit>()
                    .mandatoryRequiredWarningSave(
                      widget.label,
                      ConstantString().fieldRequired,
                    );
                MyLog.debug(
                  "Mandatory Field Validation Failed: ${widget.label}",
                );
                return ConstantString().fieldRequired;
              }
              return null;
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _obscure.dispose();
    super.dispose();
  }
}
