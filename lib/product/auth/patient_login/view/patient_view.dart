import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:kiosk/features/utility/navigation_service.dart';
import 'package:kiosk/product/auth/patient_login/services/patient_services.dart';

import '../../../../core/utility/logger_service.dart';
import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/custom_input_container.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/enum/enum_textformfield.dart';
import '../../../../features/utility/tenant_http_service.dart';
import '../../../../features/widget/app_dialog.dart';
import '../../../../features/widget/circular_countdown.dart';
import '../../../../features/widget/custom_appbar.dart';
import '../../../../features/widget/custom_button.dart';
import '../cubit/patient_login_cubit.dart';
import '../../../../features/widget/inactivity_warning_dialog.dart';
import 'widget/kiosk_card_widget.dart';
import 'widget/language_button_widget.dart';
import 'widget/virtual_keypad.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  bool _dialogOpen = false;
  bool _isOpenVerifyPhoneNumberDialog = false;
  bool _isOpenWarningPhoneNumberDialog = false;
  final ValueNotifier<bool> _validateTc = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _validateOtp = ValueNotifier<bool>(true);

  final MyLog _log = MyLog("PatientView");

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientLoginCubit>(
      create: (context) =>
          PatientLoginCubit(service: PatientServices(TenantHttpService())),
      child: BlocConsumer<PatientLoginCubit, PatientLoginState>(
        listenWhen: (prev, curr) {
          final counterControl = (prev.counter != 0) && (curr.counter == 0);
          final transition = prev.status != curr.status;
          final enteredWarning =
              ((prev.counter ?? 0) > 15) &&
              ((curr.counter ?? 0) <= 15) &&
              ((curr.counter ?? 0) > 0);

          final leftWarningWhileOpen =
              (_dialogOpen) &&
              ((prev.counter ?? 0) <= 15) &&
              ((curr.counter ?? 0) > 15);

          return counterControl ||
              transition ||
              enteredWarning ||
              leftWarningWhileOpen;
        },
        listener: (context, state) async {
          MyLog.debug("listener counter: ${state.counter}");

          if (state.counter == 0) {
            _clean(context);
            context.read<PatientLoginCubit>().stopCounter();
            Navigator.of(context, rootNavigator: true).maybePop(false);
            SnackbarService().showSnackBar(ConstantString().timeExpired);
            if (_isOpenVerifyPhoneNumberDialog ||
                _isOpenWarningPhoneNumberDialog) {
              Navigator.of(context, rootNavigator: true).maybePop();
            }
          }
          if (state.counter is int) {
            if ((state.counter ?? 0) > 0 &&
                (state.counter ?? 0) <= 15 &&
                !_dialogOpen) {
              _showTimeDialog(context);
            }

            if (_dialogOpen && (state.counter ?? 0) > 15) {
              Navigator.of(context, rootNavigator: true).maybePop();
              _dialogOpen = false;
            }
          }

          switch (state.status) {
            case EnumGeneralStateStatus.loading:
              AppDialog(context).loadingDialog();
            case EnumGeneralStateStatus.success:
              Navigator.pop(context);
              if (state.pageType == PageType.auth) {
                if (!_isOpenVerifyPhoneNumberDialog &&
                    !_isOpenWarningPhoneNumberDialog) {
                  _log.d(
                    "_isOpenVerifyPhoneNumberDialog $_isOpenVerifyPhoneNumberDialog // $_isOpenWarningPhoneNumberDialog //result ${!_isOpenVerifyPhoneNumberDialog || !_isOpenWarningPhoneNumberDialog}",
                  );
                  _isOpenVerifyPhoneNumberDialog = true;
                  if (state.phoneNumber.length == 10) {
                    verifyPhoneDialog(context, state.phoneNumber);
                  } else {
                    AppDialog(context).infoDialog(
                      ConstantString().warning,
                      ConstantString().updatePhoneAtAdmission,
                    );
                  }
                }
              }
              break;
            case EnumGeneralStateStatus.failure:
              Navigator.pop(context);
              AppDialog(context).infoDialog(
                ConstantString().errorOccurred,
                state.message ?? ConstantString().errorOccurred,
              );
              context.read<PatientLoginCubit>().statusInitial();
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
                  child: Column(
                    spacing: 30,
                    children: [
                      ..._body(context, state),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: const Divider(height: 24),
                      ),
                      continueButton(context, state),
                      if (state.tcNo.isNotEmpty)
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
                      if (state.tcNo.isEmpty)
                      SizedBox(height: 48),
                      VirtualKeypad(pageType: state.pageType),
                      Visibility(
                        visible: state.pageType == PageType.auth,
                        child: LanguageButtonWidget(),
                      ),
                      // KioskCardWidget(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _body(BuildContext cubitContext, PatientLoginState state) {
    switch (state.pageType) {
      case PageType.auth:
        return [
          Text(ConstantString().enterYourTurkishIdNumber),
          ValueListenableBuilder(
            valueListenable: _validateTc,
            builder: (context, validateTcValue, child) {
              return CustomInputContainer(
                type: EnumTextformfield.tc,
                currentValue: state.tcNo,
                isValid: validateTcValue,
                errorMessage: ConstantString().validateTcText,
                onClear: () {
                  _validateTc.value = true;
                  cubitContext.read<PatientLoginCubit>().clearTcNo();
                },
                child: Text(
                  state.tcNo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              );
            },
          ),
        ];
      case PageType.register:
        return [
          Text(ConstantString().enterYourBirthDate),
          CustomInputContainer(
            type: EnumTextformfield.birthday,
            currentValue: state.birthDate,
            onClear: () {
              cubitContext.read<PatientLoginCubit>().clearBirthDate();
            },
            child: Text(
              state.birthDate.isEmpty ? '' : state.birthDate,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ),
        ];
      case PageType.verifySms:
        return [
          Text(ConstantString().pleaseEnterSmsCode),
          CircularCountdown(
            total: Duration(seconds: 150),
            size: 100,
            strokeWidth: 8,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.grey.shade300,
          ),
          ValueListenableBuilder(
            valueListenable: _validateOtp,
            builder: (context, validateOtpValue, child) {
              return CustomInputContainer(
                type: EnumTextformfield.otpCode,
                currentValue: state.otpCode,
                isValid: validateOtpValue,
                errorMessage: ConstantString().validateOTPText,
                onClear: () {
                  _validateOtp.value = true;
                  cubitContext.read<PatientLoginCubit>().clearOtpCode();
                },
                child: Text(
                  state.otpCode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
              );
            },
          ),
        ];
    }
  }

  continueButton(BuildContext cubitContext, PatientLoginState state) {
    Function()? onPressed;
    switch (state.pageType) {
      case PageType.verifySms:
        onPressed = () {
          _log.d("otpCode length ${state.otpCode.length}");
          if (state.otpCode.length != 6) {
            _validateOtp.value = false;
          } else {
            _validateOtp.value = true;
            cubitContext.read<PatientLoginCubit>().userLogin();
          }
        };
        break;
      case PageType.auth:
        onPressed = () {
          if (state.tcNo.length != 11) {
            _validateTc.value = false;
          } else {
            _validateTc.value = true;
            cubitContext.read<PatientLoginCubit>().validateIdentity();
          }
        };
        break;
      case PageType.register:
        onPressed = () {
          if (state.birthDate.length != 10) {
            // gg.aa.yyyy formatı için 10 karakter
            SnackbarService().showSnackBar(
              ConstantString().pleaseEnterValidBirthDate,
            );
          } else {
            cubitContext.read<PatientLoginCubit>().userRegister();
          }
        };
        break;
    }

    return CustomButton(
      width: MediaQuery.of(context).size.width * 0.60,
      height: MediaQuery.of(context).size.height * 0.07,
      label: ConstantString().continueLabel,
      onPressed: onPressed,
    );
  }

  verifyPhoneDialog(BuildContext cubitContext, String phoneNumber) {
    String secretPhoneNumber = phoneNumber.replaceRange(0, 6, "****");
    cubitContext.read<PatientLoginCubit>().statusInitial();
    AppDialog(context).infoDialog(
      ConstantString().isThisNumberYours,
      ConstantString().isThisNumberYoursWithPhone(secretPhoneNumber),
      firstActionText: ConstantString().no,
      firstOnPressed: () {
        NavigationService.ns.goBack();
        _isOpenWarningPhoneNumberDialog = false;
        AppDialog(context).infoDialog(
          ConstantString().warning,
          ConstantString().updatePhoneAtAdmission,
        );
      },
      secondActionText: ConstantString().yes,
      secondOnPressed: () {
        NavigationService.ns.goBack();
        _isOpenWarningPhoneNumberDialog = false;
        cubitContext.read<PatientLoginCubit>().sendOtpCode();
      },
      afterFunc: (onValue) {
        _isOpenVerifyPhoneNumberDialog = false;
        _isOpenWarningPhoneNumberDialog = false;
      },
    );
  }

  _clean(BuildContext ctx) {
    _validateTc.value = true;
    _dialogOpen = false;
    _isOpenVerifyPhoneNumberDialog = false;
    _isOpenWarningPhoneNumberDialog;
    _validateOtp.value = true;
    ctx.read<PatientLoginCubit>().clean();
  }

  void _showTimeDialog(BuildContext cubitContext) {
    _dialogOpen = true;
    final cubit = cubitContext.read<PatientLoginCubit>();
    Navigator.of(context)
        .push(
          RawDialogRoute(
            pageBuilder: (dialogcontext, animation, secondaryAnimation) {
              return BlocProvider.value(
                value: cubit,
                child: BlocBuilder<PatientLoginCubit, PatientLoginState>(
                  builder: (dialogCtx, s) {
                    final int remaining = s.counter ?? 0;
                    return InactivityWarningDialog(
                      remaining: Duration(seconds: remaining),
                      secondaryLabel: ConstantString().close,
                      onContinue: () {
                        dialogCtx.read<PatientLoginCubit>().onChanged('force');
                        NavigationService.ns.goBack();
                        _dialogOpen = false;
                      },
                    );
                  },
                ),
              );
            },
          ),
        )
        .then((onValue) {
          if (onValue == false) {
            _dialogOpen = false;
          } else {
            _dialogOpen = false;
            cubitContext.read<PatientLoginCubit>().onChanged('force');
          }
        });
  }
}
