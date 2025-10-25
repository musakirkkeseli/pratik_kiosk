import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/custom_textfield_widget.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';
import 'package:kiosk/product/mandatory/cubit/mandatory_cubit.dart';
import 'package:kiosk/product/mandatory/service/mandatory_service.dart';

import '../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/user_http_service.dart';
import '../../../features/utility/extension/text_theme_extension.dart';
import '../../../features/utility/extension/color_extension.dart';
import '../model/mandatory_request_model.dart';
import '../model/mandatory_response_model.dart';

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

  final Map<String, String> _fakeData = {
    'TC': '41467192600',
    'T.C': '41467192600',
    'T.C.': '41467192600',
    'TCKN': '41467192600',
    'Adres': 'Atatürk Mah. Cumhuriyet Cad. No:123 Daire:4 Beşiktaş/İstanbul',
    'Address': 'Atatürk Mah. Cumhuriyet Cad. No:123 Daire:4 Beşiktaş/İstanbul',
  };

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

  String? _getFakeData(String label) {
    final normalizedLabel = label.trim().toUpperCase();
    for (var key in _fakeData.keys) {
      if (normalizedLabel.contains(key.toUpperCase())) {
        return _fakeData[key];
      }
    }
    return null;
  }

  void _focusNextEmptyField(
    int currentIndex,
    List<MandatoryResponseModel> data,
  ) {
    // Bir sonraki boş alanı bul
    for (int i = currentIndex + 1; i < data.length; i++) {
      final nextId = data[i].id ?? '';
      if (_editableFields.contains(nextId)) {
        _focusNodes[nextId]?.requestFocus();
        return;
      }
    }
    // Eğer sonuna geldiyse klavyeyi kapat
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
          return _body(state);
        },
      ),
    );
  }

  _body(MandatoryState state) {
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();
                    context
                        .read<PatientRegistrationProceduresCubit>()
                        .mandatoryCheck(state.patientMandatoryData);
                  }
                },
                child: Text(ConstantString().completeRegistration),
              ),
            ),
            Row(
              spacing: MediaQuery.of(context).size.width * 0.01,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.person, color: context.primaryColor),
                Text(
                  ConstantString().patientInformation,
                  style: context.sectionTitle,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const Divider(height: 24),
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
                      MandatoryResponseModel item = state.data[index];
                      final itemId = item.id ?? '';
                      final label = item.labelCaption ?? "";

                      _controllers.putIfAbsent(itemId, () {
                        final fakeData = _getFakeData(label);
                        final controller = TextEditingController(
                          text: fakeData,
                        );

                        if (fakeData == null &&
                            !_editableFields.contains(itemId)) {
                          _editableFields.add(itemId);
                        }

                        return controller;
                      });

                      _focusNodes.putIfAbsent(itemId, () => FocusNode());

                      final controller = _controllers[itemId]!;
                      final focusNode = _focusNodes[itemId]!;
                      final isReadOnly = controller.text.isNotEmpty;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextfieldWidget(
                            type: EnumTextformfield.mandatory,
                            customLabel: label,
                            controller: controller,
                            focusNode: focusNode,
                            readOnly: isReadOnly,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: () {
                              _focusNextEmptyField(index, state.data);
                            },
                            customValidator: (value) {
                              if (item.isNullable == "0" &&
                                  (value == null || value.isEmpty)) {
                                return ConstantString().fieldRequired;
                              }
                              if (item.minValue != null) {
                                int minLength =
                                    int.tryParse(item.minValue!) ?? 0;
                                if ((value ?? "").length < minLength) {
                                  return "${ConstantString().minLengthError} $minLength";
                                }
                              }
                              return null;
                            },
                            customMaxLength: item.maxValue != null
                                ? int.tryParse(item.maxValue!)
                                : null,
                            onSaved: (newValue) {
                              context.read<MandatoryCubit>().mandatoryValueSave(
                                itemId,
                                newValue ?? "",
                              );
                            },
                          ),
                        ],
                      );
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
}
