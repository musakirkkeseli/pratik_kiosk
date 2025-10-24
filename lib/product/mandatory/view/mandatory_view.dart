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

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
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
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    MandatoryResponseModel item = state.data[index];
                    
                    // Her item için controller oluştur
                    _controllers.putIfAbsent(
                      item.id ?? '',
                      () => TextEditingController(),
                    );
                    final controller = _controllers[item.id ?? '']!;
                    
                    return Column(
                     
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextfieldWidget(
                          type: EnumTextformfield.mandatory,
                          customLabel: item.labelCaption ?? "",
                          controller: controller,
                          customValidator: (value) {
                            if (item.isNullable == "0" &&
                                (value == null || value.isEmpty)) {
                              return ConstantString().fieldRequired;
                            }
                            if (item.minValue != null) {
                              int minLength = int.tryParse(item.minValue!) ?? 0;
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
                                  item.id ?? "",
                                  newValue ?? "",
                                );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      default:
        return Center(child: Text(ConstantString().errorOccurred));
    }
  }
}
