import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/core/utility/logger_service.dart';
import 'package:kiosk/features/utility/custom_textfield_widget.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';
import 'package:kiosk/features/utility/extension/input_decoration_extension.dart';
import 'package:kiosk/features/widget/custom_button.dart';
import 'package:kiosk/product/mandatory/cubit/mandatory_cubit.dart';
import 'package:kiosk/product/mandatory/service/mandatory_service.dart';

import '../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/custom_input_container.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/user_http_service.dart';
import '../../../features/utility/extension/text_theme_extension.dart';
import '../../../features/utility/extension/color_extension.dart';
import '../model/mandatory_request_model.dart';
import '../model/mandatory_response_model.dart';
import '../../../features/utility/enum/enum_object_type.dart';

class MandatoryView extends StatefulWidget {
  final MandatoryRequestModel mandatoryRequestModel;
  const MandatoryView({super.key, required this.mandatoryRequestModel});

  @override
  State<MandatoryView> createState() => _State();
}

class _State extends State<MandatoryView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final List<String> _editableFields = [];
  final ScrollController _scrollController = ScrollController();
  // final MyLog _log = MyLog('MandatoryView');

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _focusNextEmptyField(
    int currentIndex,
    List<MandatoryResponseModel> data,
  ) {
    for (int i = currentIndex + 1; i < data.length; i++) {
      final nextId = data[i].id ?? '';
      if (_editableFields.contains(nextId)) {
        _focusNodes[nextId]?.requestFocus();
        return;
      }
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MandatoryCubit(
        mandatoryRequestModel: widget.mandatoryRequestModel,
        service: MandatoryService(UserHttpService()),
      )..fetchMandatory(),
      child: BlocBuilder<MandatoryCubit, MandatoryState>(
        builder: (context, state) {
          return _body(context, state);
        },
      ),
    );
  }

  _body(BuildContext cubitContext, MandatoryState state) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case EnumGeneralStateStatus.success:
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              child: CustomButton(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.06,
                label: ConstantString().completeRegistration,
                onPressed: () {
                  cubitContext
                      .read<MandatoryCubit>()
                      .mandatoryRequiredWarningClear();
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();
                    MyLog.debug("Mandatory Form Validated Successfully");
                    for (var element in state.data) {
                      if (element.fieldValue != null &&
                          (element.fieldValue ?? "").isNotEmpty) {
                        cubitContext.read<MandatoryCubit>().mandatoryValueSave(
                          element.id ?? '',
                          element.fieldValue ?? '',
                        );
                      }
                    }
                    context
                        .read<PatientRegistrationProceduresCubit>()
                        .mandatoryCheck(state.patientMandatoryData);
                  }
                },
              ),
            ),
            ListTile(
              title: Text(
                ConstantString().patientInformation,
                style: context.sectionTitle,
              ),
              leading: Icon(
                Icons.person,
                color: context.primaryColor,
                size: 40,
              ),
              subtitle: Text(
                ConstantString().filledFieldInfo,
                textAlign: TextAlign.start,
              ),
            ),
            const Divider(height: 30),
            ListView.builder(
              shrinkWrap: true,
              itemCount: state.requiredWarning.length,
              itemBuilder: (context, index) {
                String warning = state.requiredWarning[index];
                return Text("* $warning", style: context.errorText);
              },
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 6.0,
                  radius: const Radius.circular(10),
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(right: 40),
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      return inputAreas(state, index, cubitContext);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      default:
        return Center(child: Text(ConstantString().errorOccurred));
    }
  }

  inputAreas(MandatoryState state, int index, BuildContext cubitContext) {
    TextInputType? keyboardType;
    MandatoryResponseModel item = state.data[index];
    final itemId = item.id ?? '';
    final label = item.labelCaption ?? "";
    if (item.objectType == ObjectType.integer) {
      keyboardType = TextInputType.number;
    }

    _controllers.putIfAbsent(itemId, () {
      TextEditingController controller = TextEditingController(
        text: item.fieldValue ?? "",
      );
      if (item.fieldValue == null || item.fieldValue!.isEmpty) {
        if (!_editableFields.contains(itemId)) {
          _editableFields.add(itemId);
        }
      }
      return controller;
    });

    _focusNodes.putIfAbsent(itemId, () => FocusNode());

    final controller = _controllers[itemId]!;
    final focusNode = _focusNodes[itemId]!;
    final isReadOnly =
        item.fieldValue != null && (item.fieldValue ?? "").isNotEmpty;
    if (isReadOnly && item.objectType != ObjectType.dropdown) {
      return CustomInputContainer(
        type: EnumTextformfield.mandatory,
        customLabel: label,
        child: InputDecorator(
          isFocused: false,
          decoration: InputDecoration().mandatoryDecoration,
          child: SelectionArea(
            child: SelectableText(
              controller.text,
              maxLines: 1,
              showCursor: true,
              style: TextStyle(fontSize: 25, color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }
    if (item.objectType == ObjectType.dropdown && item.dropdownItems != null) {
      return CustomInputContainer(
        type: EnumTextformfield.mandatory,
        customLabel: label,
        child: DropdownButtonFormField<String>(
          initialValue: controller.text.isNotEmpty ? controller.text : null,
          decoration: InputDecoration().mandatoryDecoration,
          hint: Text(ConstantString().select),
          disabledHint: controller.text.isNotEmpty
              ? Text(controller.text)
              : null,
          items: item.dropdownItems!
              .map(
                (dropdownItem) => DropdownMenuItem<String>(
                  value: dropdownItem.value.toString(),
                  child: Text(dropdownItem.text ?? ""),
                ),
              )
              .toList(),
          onChanged: isReadOnly
              ? null
              : (newValue) {
                  controller.text = newValue ?? "";
                },
          onSaved: (newValue) {
            cubitContext.read<MandatoryCubit>().mandatoryValueSave(
              itemId,
              newValue ?? "",
            );
          },
          validator: (value) {
            if (item.isNullable == "0" && (value == null || value.isEmpty)) {
              cubitContext.read<MandatoryCubit>().mandatoryRequiredWarningSave(
                label,
                ConstantString().fieldRequired,
              );
              MyLog.debug("Mandatory Field Validation Failed: $label");
              return ConstantString().fieldRequired;
            }
            return null;
          },
        ),
      );
    }
    return CustomTextfieldWidget(
      type: EnumTextformfield.mandatory,
      customLabel: label,
      controller: controller,
      focusNode: focusNode,
      readOnly: isReadOnly,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      customInputFormatters: [
        ...?(item.objectType == ObjectType.integer
            ? [FilteringTextInputFormatter.digitsOnly]
            : null),
      ],
      onFieldSubmitted: () {
        _focusNextEmptyField(index, state.data);
      },
      customValidator: (value) {
        if (item.isNullable == "0" && (value == null || value.isEmpty)) {
          cubitContext.read<MandatoryCubit>().mandatoryRequiredWarningSave(
            label,
            ConstantString().fieldRequired,
          );
          MyLog.debug("Mandatory Field Validation Failed: $label");
          return ConstantString().fieldRequired;
        }
        if (item.minValue != null) {
          int minLength = int.tryParse(item.minValue ?? "") ?? 0;
          if ((value ?? "").length < minLength) {
            cubitContext.read<MandatoryCubit>().mandatoryRequiredWarningSave(
              label,
              "${ConstantString().minLengthError} $minLength",
            );
            return "${ConstantString().minLengthError} $minLength";
          }
        }
        return null;
      },
      customMaxLength: item.maxValue != null
          ? int.tryParse(item.maxValue!)
          : null,
      onSaved: (newValue) {
        cubitContext.read<MandatoryCubit>().mandatoryValueSave(
          itemId,
          newValue ?? "",
        );
      },
    );
  }
}
