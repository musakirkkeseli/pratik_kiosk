import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/model/dropdown_model.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/custom_input_container.dart';
import '../../../../features/utility/enum/enum_textformfield.dart';
import '../../../../features/utility/navigation_service.dart';
import '../../../../features/widget/item_button.dart';
import '../../cubit/mandatory_cubit.dart';

class CustomSelectButton extends StatefulWidget {
  final BuildContext cubitContext;
  final TextEditingController controller;
  final String label;
  final List<Options> optionList;
  final String itemId;
  final bool isReadOnly;
  final bool? maskValue;
  const CustomSelectButton({
    super.key,
    required this.cubitContext,
    required this.controller,
    required this.label,
    required this.optionList,
    required this.itemId,
    this.isReadOnly = false,
    this.maskValue = false,
  });

  @override
  State<CustomSelectButton> createState() => _CustomSelectButtonState();
}

class _CustomSelectButtonState extends State<CustomSelectButton> {
  final ValueNotifier<List<Options>> _optitons = ValueNotifier<List<Options>>(
    [],
  );
  final ValueNotifier<String> _optitonText = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    _optitons.value = widget.optionList;
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputContainer(
      type: EnumTextformfield.mandatory,
      customLabel: widget.label,
      child: InkWell(
        onTap: widget.isReadOnly
            ? null
            : () {
                Navigator.of(context).push(
                  RawDialogRoute(
                    pageBuilder: (dialogcontext, animation, secondaryAnimation) {
                      return Center(
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, size: 50),
                                    onPressed: () {
                                      NavigationService.ns.goBack();
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                ConstantString().associationGssInfoMessage,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: ConstantString().search,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  prefixIcon: const Icon(Icons.search),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _optitons.value = widget.optionList
                                        .where(
                                          (option) => option.text
                                              .toString()
                                              .toLowerCase()
                                              .contains(value.toLowerCase()),
                                        )
                                        .toList();
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              widget.optionList.isNotEmpty
                                  ? ValueListenableBuilder(
                                      valueListenable: _optitons,
                                      builder: (context, optitonsValue, child) {
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: optitonsValue.length,
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(height: 12),
                                              itemBuilder: (_, index) {
                                                final dropdownItem =
                                                    optitonsValue[index];
                                                return ItemButton(
                                                  title:
                                                      dropdownItem.text ?? '',
                                                  onTap: () {
                                                    widget.controller.text =
                                                        dropdownItem.value ??
                                                        '';
                                                    _optitonText.value =
                                                        dropdownItem.text ?? '';
                                                    widget.cubitContext
                                                        .read<MandatoryCubit>()
                                                        .mandatoryValueSave(
                                                          widget.itemId,
                                                          dropdownItem.value ??
                                                              "",
                                                        );
                                                    NavigationService.ns
                                                        .goBack();
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Text(ConstantString().errorOccurred),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 100,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ValueListenableBuilder(
            valueListenable: _optitonText,
            builder: (context, optitonTextValue, child) {
              return optitonTextValue.isEmpty
                  ? Text(ConstantString().selectToMakeChoice)
                  : Text(optitonTextValue);
            },
          ),
        ),
      ),
    );
  }
}
