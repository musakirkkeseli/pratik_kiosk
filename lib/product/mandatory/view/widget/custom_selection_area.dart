import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/extension/input_decoration_extension.dart';
import 'package:kiosk/features/utility/extension/text_theme_extension.dart';

import '../../../../features/utility/custom_input_container.dart';
import '../../../../features/utility/enum/enum_object_type.dart';
import '../../../../features/utility/enum/enum_textformfield.dart';

class CustomSelectionArea extends StatefulWidget {
  final String label;
  final String text;
  final ObjectType? objectType;
  final bool? maskValue;
  const CustomSelectionArea({
    super.key,
    required this.label,
    required this.text,
    this.objectType = ObjectType.unknown,
    this.maskValue = false,
  });

  @override
  State<CustomSelectionArea> createState() => _CustomSelectionAreaState();
}

class _CustomSelectionAreaState extends State<CustomSelectionArea> {
  final ValueNotifier<bool> _maskNotifier = ValueNotifier<bool>(false);
  String maskedText = '';

  @override
  void initState() {
    super.initState();
    _maskNotifier.value = widget.maskValue ?? false;
    maskedText = displayTextFunction();
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputContainer(
      type: EnumTextformfield.mandatory,
      customLabel: widget.label,
      child: InputDecorator(
        isFocused: false,
        decoration: InputDecoration().mandatoryDecoration,
        child: maskFunction(),
      ),
    );
  }

  maskFunction() {
    return ValueListenableBuilder(
      valueListenable: _maskNotifier,
      builder: (context, maskNotifierValue, child) {
        return Row(
          children: [
            Expanded(
              child: selectionAreaFun(
                maskNotifierValue ? maskedText : widget.text,
                maskNotifierValue,
              ),
            ),
            IconButton(
              icon: Icon(
                maskNotifierValue ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade600,
                size: 20,
              ),
              onPressed: () {
                _maskNotifier.value = !maskNotifierValue;
              },
            ),
          ],
        );
      },
    );
  }

  SelectionArea selectionAreaFun(String text, bool maskNotifierValue) {
    return SelectionArea(
      child: SelectableText(
        text,
        maxLines: 1,
        showCursor: true,
        style: context.inputFieldReadOnly,
      ),
    );
  }

  displayTextFunction() {
    final text = widget.text;
    switch (widget.objectType) {
      case ObjectType.integer:
        if (text.length <= 4) return List.filled(text.length, '•').join();
        final visible = text.substring(text.length - 4);
        final masked = List.filled(text.length - 4, '•').join();
        return '$masked$visible';
      default:
        return List.filled(text.length, '•').join();
    }
  }
}
