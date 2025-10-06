import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/product/auth/patient_login/services/patient_services.dart';

import '../../../../core/utility/logger_service.dart';
import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/custom_hospital_and_patient_login_textfield_widget.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/enum/enum_textformfield.dart';
import '../../../../features/utility/tenant_http_service.dart';
import '../cubit/patient_login_cubit.dart';
import '../model/patient_register_request_model.dart';

class PatientView extends StatefulWidget {
  final AuthType? authType;
  const PatientView({super.key, this.authType});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  bool _dialogOpen = false;

  @override
  void dispose() {
    _tcController.dispose();
    _birthDayController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tcController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientLoginCubit>(
      create: (context) =>
          PatientLoginCubit(service: PatientServices(TenantHttpService())),
      child: BlocConsumer<PatientLoginCubit, PatientLoginState>(
        listenWhen: (prev, curr) {
          final counterControl = (prev.counter != 0) && (curr.counter == 0);
          final failureTransition =
              prev.status != EnumGeneralStateStatus.failure &&
              curr.status == EnumGeneralStateStatus.failure;
          final enteredWarning =
              (prev.counter > 10) && (curr.counter <= 10) && (curr.counter > 0);

          final leftWarningWhileOpen =
              (_dialogOpen) && (prev.counter <= 10) && (curr.counter > 10);

          return counterControl ||
              failureTransition ||
              enteredWarning ||
              leftWarningWhileOpen;
        },
        listener: (context, state) async {
          MyLog.debug("listener counter: ${state.counter}");

          if (state.counter == 0) {
            _clean();
            context.read<PatientLoginCubit>().stopCounter();
            SnackbarService().showSnackBar(
              'Süre doldu. Lütfen tekrar deneyin.',
            );
          }
          if (state.counter > 0 && state.counter <= 10 && !_dialogOpen) {
            _showTimeDialog(context);
          }

          // Sayaç tekrar 10’un üstüne çıktıysa popup’ı kapat
          if (_dialogOpen && state.counter > 10) {
            Navigator.of(context, rootNavigator: true).maybePop();
            _dialogOpen = false;
          }

          switch (state.status) {
            case EnumGeneralStateStatus.failure:
              SnackbarService().showSnackBar(
                state.message ?? ConstantString().errorOccurred,
              );
              break;
            default:
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(ConstantString().patientLogin)),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomHospitalAndPatientLoginTextfieldWidget(
                      type: EnumTextformfield.tc,
                      controller: _tcController,
                      onChanged: (String value) {
                        context.read<PatientLoginCubit>().onChanged(value);
                      },
                    ),
                    if (state.authType == AuthType.register)
                      CustomHospitalAndPatientLoginTextfieldWidget(
                        controller: _birthDayController,
                        type: EnumTextformfield.birthday,
                        onChanged: (String value) {
                          context.read<PatientLoginCubit>().onChanged(value);
                        },
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            final isValid =
                                _formKey.currentState?.validate() ?? false;
                            if (isValid) {
                              FocusScope.of(context).unfocus();
                              final state = context
                                  .read<PatientLoginCubit>()
                                  .state;

                              state.authType == AuthType.login
                                  ? context.read<PatientLoginCubit>().userLogin(
                                      tcNo: _tcController.text.trim(),
                                    )
                                  : context
                                        .read<PatientLoginCubit>()
                                        .userRegister(
                                          patientRegisterRequestModel:
                                              PatientRegisterRequestModel(
                                                tcNo: _tcController.text.trim(),
                                                birthDate: _birthDayController
                                                    .text
                                                    .trim(),
                                              ),
                                        );
                            }
                          },
                          label: Text(ConstantString().signIn),
                        ),
                        if (_tcController.text.trim().isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: () {
                              _clean();
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text("Temizle"),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _clean() {
    FocusScope.of(context).unfocus();
    _formKey.currentState?.reset();
    _tcController.clear();
    _birthDayController.clear();
    if (widget.authType == AuthType.register) {
      context.read<PatientLoginCubit>().setAuthType(AuthType.login);
    }
  }

  void _showTimeDialog(BuildContext context) {
    _dialogOpen = true;
    final cubit = context.read<PatientLoginCubit>();
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (dialogCtx) {
        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<PatientLoginCubit, PatientLoginState>(
            builder: (_, s) {
              final remaining = s.counter;
              return AlertDialog(
                title: const Text('Süre bitiyor'),
                content: Text('Kalan süre: ${remaining}s'),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.read<PatientLoginCubit>().onChanged('force');

                      Navigator.of(dialogCtx).pop();
                      _dialogOpen = false;
                    },
                    child: const Text('Devam Et'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<PatientLoginCubit>().stopCounter();
                      Navigator.of(dialogCtx).pop();
                      _dialogOpen = false;

                      _clean();
                    },
                    child: const Text('Kapat'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
