import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:kiosk/product/auth/patient_login/services/patient_services.dart';

import '../../../../core/utility/logger_service.dart';
import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/custom_hospital_and_patient_login_textfield_widget.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/enum/enum_textformfield.dart';
import '../../../../features/utility/tenant_http_service.dart';
import '../../../../features/widget/custom_appbar.dart';
import '../../../../features/widget/custom_button.dart';
import '../cubit/patient_login_cubit.dart';
import '../model/patient_register_request_model.dart';
import '../../../../features/widget/inactivity_warning_dialog.dart';
import 'widget/kiosk_card_widget.dart';

class PatientView extends StatefulWidget {
  final AuthType? authType;
  const PatientView({super.key, this.authType});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tcController = kReleaseMode
      ? TextEditingController()
      : TextEditingController(text: "41467192600");
  final TextEditingController _birthDayController = TextEditingController();
  bool _dialogOpen = false;
  bool _suppressWarning = false; // Devam Et sonrası popup yeniden açılmasın

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
              (prev.counter > 15) && (curr.counter <= 15) && (curr.counter > 0);

          final leftWarningWhileOpen =
              (_dialogOpen) && (prev.counter <= 15) && (curr.counter > 15);

          return counterControl ||
              failureTransition ||
              enteredWarning ||
              leftWarningWhileOpen;
        },
        listener: (context, state) async {
          MyLog.debug("listener counter: ${state.counter}");

          if (state.counter == 0) {
            _clean(context);
            context.read<PatientLoginCubit>().stopCounter();
            SnackbarService().showSnackBar(
              'Süre doldu. Lütfen tekrar deneyin.',
            );
            _suppressWarning = false;
          }
          if (state.counter > 0 &&
              state.counter <= 15 &&
              !_dialogOpen &&
              !_suppressWarning) {
            _showTimeDialog(context);
          }

          // Sayaç tekrar 10’un üstüne çıktıysa popup’ı kapat
          if (_dialogOpen && state.counter > 15) {
            Navigator.of(context, rootNavigator: true).maybePop();
            _dialogOpen = false;
            _suppressWarning =
                false; // güvenli eşik üstünde, tekrar gösterilebilir
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
            body: Column(
              children: [
                CustomAppBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 200.0,
                    vertical: 20.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 30,
                      children: [
                        Text(ConstantString().enterYourTurkishIdNumber),
                        CustomHospitalAndPatientLoginTextfieldWidget(
                          type: EnumTextformfield.tc,
                          controller: _tcController,
                          onChanged: (String value) {
                            context.read<PatientLoginCubit>().onChanged(value);
                          },
                        ),
                        if (state.authType == AuthType.register) ...[
                          CustomHospitalAndPatientLoginTextfieldWidget(
                            controller: _birthDayController,
                            type: EnumTextformfield.birthday,
                            onChanged: (String value) {
                              context.read<PatientLoginCubit>().onChanged(
                                value,
                              );
                            },
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: const Divider(height: 24),
                        ),
                        CustomButton(
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: MediaQuery.of(context).size.height * 0.07,
                          label: ConstantString().signIn,
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
                        ),
                        if (_tcController.text.trim().isNotEmpty)
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              iconColor: Colors.red,
                              foregroundColor: Colors.red,
                              side: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                            onPressed: () {
                              _clean(context);
                            },
                            icon: Iconify(
                              IconParkSolid.clear_format,
                              color: Colors.red,
                            ),
                            label: Text(ConstantString().clear),
                          ),
                        KioskCardWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _clean(BuildContext ctx) {
    FocusScope.of(ctx).unfocus();
    _formKey.currentState?.reset();
    _tcController.clear();
    _birthDayController.clear();
    final cubit = ctx.read<PatientLoginCubit>();
    if (widget.authType != AuthType.login) {
      cubit.setAuthType(AuthType.login);
    }
    ctx.read<PatientLoginCubit>().stopCounter();
  }

  void _showTimeDialog(BuildContext context) {
    _dialogOpen = true;
    final cubit = context.read<PatientLoginCubit>();
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<PatientLoginCubit, PatientLoginState>(
            builder: (dialogCtx, s) {
              final remaining = s.counter;
              return InactivityWarningDialog(
                remaining: Duration(seconds: remaining),
                secondaryLabel: 'Kapat',
                onContinue: () {
                  dialogCtx.read<PatientLoginCubit>().stopCounter();

                  dialogCtx.read<PatientLoginCubit>().onChanged('force');
                  Navigator.of(dialogCtx).pop();
                  _dialogOpen = false;
                  _suppressWarning = true;
                },
                // onLogout: () {
                //   dialogCtx.read<PatientLoginCubit>().stopCounter();
                //   Navigator.of(dialogCtx).pop();
                //   _dialogOpen = false;
                //   _suppressWarning = true;
                // },
              );
            },
          ),
        );
      },
    );
  }
}
