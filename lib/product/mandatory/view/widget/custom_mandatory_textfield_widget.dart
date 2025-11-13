import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/features/utility/custom_input_container.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';
import 'package:kiosk/features/utility/extension/input_decoration_extension.dart';

class CustomMandatoryTextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? customValidator;
  final int? customMaxLength;
  final List<TextInputFormatter>? customInputFormatters;
  final String? customLabel;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function()? onFieldSubmitted;
  final TextInputType? keyboardType;
  final bool? obscureText;

  const CustomMandatoryTextfieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSaved,
    this.customValidator,
    this.customMaxLength,
    this.customInputFormatters,
    this.customLabel,
    this.readOnly = false,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.keyboardType,
    this.obscureText,
  });

  @override
  State<CustomMandatoryTextfieldWidget> createState() =>
      _CustomMandatoryTextfieldWidgetState();
}

class _CustomMandatoryTextfieldWidgetState
    extends State<CustomMandatoryTextfieldWidget> {
  final ValueNotifier<bool> _obscure = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _obscure.value = widget.obscureText ?? false;
  }

  @override
  void dispose() {
    _obscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputContainer(
      type: EnumTextformfield.mandatory,
      customLabel: widget.customLabel,
      child: ValueListenableBuilder<bool>(
        valueListenable: _obscure,
        builder: (context, obscure, child) {
          return TextFormField(
            controller: widget.controller,
            obscureText: obscure,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.customInputFormatters,
            maxLength: widget.customMaxLength,
            validator: widget.customValidator,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            readOnly: widget.readOnly,
            focusNode: widget.focusNode,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            onFieldSubmitted: (_) => widget.onFieldSubmitted?.call(),
            cursorColor: Colors.grey.shade700,
            style: TextStyle(fontSize: 25, color: Colors.black),
            decoration: InputDecoration().mandatoryDecoration.copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  _obscure.value = !_obscure.value;
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
