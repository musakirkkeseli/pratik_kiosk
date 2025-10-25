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
  final AuthType? authType;
  const PatientView({super.key, this.authType});

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
          final failureTransition =
              prev.status != EnumGeneralStateStatus.failure &&
              curr.status == EnumGeneralStateStatus.failure;
          final successTransition =
              prev.status != EnumGeneralStateStatus.success &&
              curr.status == EnumGeneralStateStatus.success;
          final enteredWarning =
              ((prev.counter ?? 0) > 15) &&
              ((curr.counter ?? 0) <= 15) &&
              ((curr.counter ?? 0) > 0);

          final leftWarningWhileOpen =
              (_dialogOpen) &&
              ((prev.counter ?? 0) <= 15) &&
              ((curr.counter ?? 0) > 15);

          return counterControl ||
              failureTransition ||
              successTransition ||
              enteredWarning ||
              leftWarningWhileOpen;
        },
        listener: (context, state) async {
          MyLog.debug("listener counter: ${state.counter}");

          if (state.counter == 0) {
            _clean(context);
            context.read<PatientLoginCubit>().stopCounter();
            Navigator.of(context, rootNavigator: true).maybePop(false);
            SnackbarService().showSnackBar(
              ConstantString().timeExpired,
            );
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
            case EnumGeneralStateStatus.success:
              if (state.authType == AuthType.login) {
                if (!_isOpenVerifyPhoneNumberDialog &&
                    !_isOpenWarningPhoneNumberDialog) {
                  _log.d(
                    "_isOpenVerifyPhoneNumberDialog $_isOpenVerifyPhoneNumberDialog // $_isOpenWarningPhoneNumberDialog //result ${!_isOpenVerifyPhoneNumberDialog || !_isOpenWarningPhoneNumberDialog}",
                  );
                  _isOpenVerifyPhoneNumberDialog = true;
                  verifyPhoneDialog(context, state.phoneNumber);
                }
              }
              break;
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
                      // KioskCardWidget(),
                      VirtualKeypad(pageType: state.pageType),
                      LanguageButtonWidget(),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.tcNo, textAlign: TextAlign.left),
                    validateTcValue == false
                        ? Text(ConstantString().validateTcText)
                        : SizedBox(),
                  ],
                ),
              );
            },
          ),
          if (state.authType == AuthType.register) ...[
            CustomInputContainer(
              type: EnumTextformfield.birthday,
              child: Text(state.birthDate, textAlign: TextAlign.left),
            ),
          ],
        ];
      case PageType.verifySms:
        return [
          Text('Lütfen SMS Kodunuzu Giriniz.'),
          CircularCountdown(
            total: Duration(seconds: 30),
            size: 100,
            strokeWidth: 8,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.grey.shade300,
          ),
          CustomInputContainer(
            type: EnumTextformfield.otpCode,
            child: ValueListenableBuilder(
              valueListenable: _validateOtp,
              builder: (context, validateOtpValue, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.otpCode, textAlign: TextAlign.left),
                    validateOtpValue == false
                        ? Text(ConstantString().validateOTPText)
                        : SizedBox(),
                  ],
                );
              },
            ),
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
            state.authType == AuthType.login
                ? cubitContext.read<PatientLoginCubit>().validateIdentity()
                : cubitContext.read<PatientLoginCubit>().userRegister();
          }
        };
    }

    return CustomButton(
      width: MediaQuery.of(context).size.width * 0.60,
      height: MediaQuery.of(context).size.height * 0.07,
      label: ConstantString().continueLabel,
      onPressed: onPressed,
    );
  }

  verifyPhoneDialog(BuildContext cubitContext, String phoneNumber) {
    cubitContext.read<PatientLoginCubit>().statusInitial();
    Navigator.of(context)
        .push(
          RawDialogRoute(
            pageBuilder: (dialogcontext, animation, secondaryAnimation) {
              return Center(
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              NavigationService.ns.goBack();
                            },
                          ),
                        ),
                        Text(
                          "Numara Size Mi Ait?",
                          textAlign: TextAlign.center,
                        ),
                        Text("$phoneNumber numarası size mi ait?"),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                NavigationService.ns.goBack();
                                _isOpenWarningPhoneNumberDialog = false;
                                AppDialog(context).infoDialog(
                                  "Bilgi",
                                  "Lütfen doğru numarayı giriniz.",
                                );
                              },
                              child: Text("Hayır"),
                            ),
                            TextButton(
                              onPressed: () {
                                NavigationService.ns.goBack();
                                _isOpenWarningPhoneNumberDialog = false;
                                cubitContext
                                    .read<PatientLoginCubit>()
                                    .sendOtpCode();
                              },
                              child: Text("Evet"),
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
        )
        .then((onValue) {
          _isOpenVerifyPhoneNumberDialog = false;
          _isOpenWarningPhoneNumberDialog = false;
        });
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
                      secondaryLabel: 'Kapat',
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
