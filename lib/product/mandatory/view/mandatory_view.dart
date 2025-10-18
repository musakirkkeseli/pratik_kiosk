import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/core/utility/logger_service.dart';
import 'package:kiosk/product/mandatory/cubit/mandatory_cubit.dart';
import 'package:kiosk/product/mandatory/service/mandatory_service.dart';

import '../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/user_http_service.dart';
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
        return Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();
                    context
                        .read<PatientRegistrationProceduresCubit>()
                        .mandatoryCheck(state.patientMandatoryData);
                  }
                },
                child: const Text('Devam Et'),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  MandatoryResponseModel item = state.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: item.labelCaption),
                      validator: (value) {
                        if (item.isNullable == "0" &&
                            (value == null || value.isEmpty)) {
                          int minLength =
                              int.tryParse(item.minValue ?? "0") ?? 0;
                          MyLog.debug(
                            "Min length for ${item.labelCaption}: $minLength",
                          );
                          if ((value ?? "").length < minLength) {
                            return "${ConstantString().minLengthError} $minLength";
                          }
                          return ConstantString().fieldRequired;
                        }
                        return null;
                      },
                      maxLength: item.maxValue != null
                          ? int.tryParse(item.maxValue!)
                          : null,
                      onSaved: (newValue) {
                        context.read<MandatoryCubit>().mandatoryValueSave(
                          item.id ?? "",
                          newValue ?? "",
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      default:
        return Center(child: Text(ConstantString().errorOccurred));
    }
  }
}
