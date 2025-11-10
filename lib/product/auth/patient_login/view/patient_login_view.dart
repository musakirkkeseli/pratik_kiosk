import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';
import 'package:kiosk/features/utility/extension/text_theme_extension.dart';
import 'package:kiosk/features/utility/navigation_service.dart';
import 'package:kiosk/product/auth/patient_login/services/patient_services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utility/logger_service.dart';
import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/custom_input_container.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/enum/enum_textformfield.dart';
import '../../../../features/utility/tenant_http_service.dart';
import '../../../../features/widget/app_dialog.dart';
import '../../../../features/widget/circular_countdown.dart';
import '../../../../features/widget/custom_appbar.dart';
import '../../../../features/widget/custom_button.dart';
import '../../../../core/utility/dynamic_theme_provider.dart';
import '../../../../core/utility/language_manager.dart';
import '../cubit/patient_login_cubit.dart';
import '../../../../features/widget/inactivity_warning_dialog.dart';
import 'widget/language_button_widget.dart';
import 'widget/virtual_keypad.dart';

class PatientLoginView extends StatefulWidget {
  const PatientLoginView({super.key});

  @override
  State<PatientLoginView> createState() => _PatientLoginViewState();
}

class _PatientLoginViewState extends State<PatientLoginView> {
  bool _dialogOpen = false;
  bool _isOpenVerifyPhoneNumberDialog = false;
  bool _isOpenWarningPhoneNumberDialog = false;
  final ValueNotifier<bool> _validateTc = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _validateOtp = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureTc = ValueNotifier<bool>(true);

  final MyLog _log = MyLog("PatientLoginView");

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
              context.read<PatientLoginCubit>().statusInitial();
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
                      ConstantString().phoneNumberNotFound,
                      afterFunc: (onValue) {
                        _isOpenVerifyPhoneNumberDialog = false;
                        _isOpenWarningPhoneNumberDialog = false;
                      },
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
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                context.read<PatientLoginCubit>().onChanged('force');
              },
              child: Column(
                spacing: 10,
                children: [
                  CustomAppBar(),
                  Consumer<DynamicThemeProvider>(
                    builder: (context, themeProvider, child) {
                      final hospitalName = themeProvider.hospitalName;
                      if (hospitalName.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: context.primaryColor),
                        alignment: Alignment.center,
                        child: Text(
                          hospitalName,
                          style: context.hospitalNameText,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: _body(context, state),
                    ),
                  ),
                  const Divider(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          bottom: 50.0,
                        ),
                        child: LanguageButtonWidget(cubitContext: context),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 150.0),
                          child: Column(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              continueButton(context, state),
                              state.tcNo.isNotEmpty
                                  ? OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        iconColor: ConstColor.red,
                                        foregroundColor: ConstColor.red,
                                        side: const BorderSide(
                                          color: ConstColor.red,
                                          width: 1.5,
                                        ),
                                      ),
                                      onPressed: () {
                                        _clean(context);
                                      },
                                      icon: Iconify(
                                        IconParkSolid.clear_format,
                                        color: ConstColor.red,
                                      ),
                                      label: Text(ConstantString().clearData),
                                    )
                                  : SizedBox(height: 48),
                              VirtualKeypad(pageType: state.pageType),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 20.0,
                          bottom: 50.0,
                        ),
                        child: Consumer<DynamicThemeProvider>(
                          builder: (context, themeProvider, child) {
                            final qrCodeUrl = themeProvider.qrCodeUrl;
                            if (qrCodeUrl.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: ConstColor.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: CachedNetworkImage(
                                    imageUrl: qrCodeUrl,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const SizedBox.shrink(),
                                  ),
                                ),
                                Image.asset(
                                  ConstantString.downloadImage,
                                  width: 150,
                                  height: 120,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Column _body(BuildContext cubitContext, PatientLoginState state) {
    switch (state.pageType) {
      case PageType.auth:
        return Column(
          children: [
            const SizedBox(height: 40),
            Text(ConstantString().enterYourTurkishIdNumber),
            ValueListenableBuilder(
              valueListenable: _validateTc,
              builder: (context, validateTcValue, child) {
                return ValueListenableBuilder(
                  valueListenable: _obscureTc,
                  builder: (context, obscureTcValue, child) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomInputContainer(
                            type: EnumTextformfield.tc,
                            currentValue: state.tcNo,
                            isValid: validateTcValue,
                            errorMessage: ConstantString().validateTcText,
                            obscureText: obscureTcValue,
                            onToggleVisibility: () {
                              _obscureTc.value = !_obscureTc.value;
                            },
                            child: Text(
                              obscureTcValue && state.tcNo.isNotEmpty
                                  ? '*' * state.tcNo.length
                                  : state.tcNo,
                              textAlign: TextAlign.center,
                              style: context.tcLoginText,
                            ),
                          ),
                        ),
                        if (state.tcNo.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height *
                                      0.11 /
                                      2 -
                                  18,
                            ),
                            child: InkWell(
                              onTap: () {
                                _validateTc.value = true;
                                cubitContext
                                    .read<PatientLoginCubit>()
                                    .clearTcNo();
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      case PageType.register:
        return Column(
          children: [
            const SizedBox(height: 40),
            Text(ConstantString().enterYourBirthDate),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomInputContainer(
                    type: EnumTextformfield.birthday,
                    currentValue: state.birthDate,
                    child: Text(
                      state.birthDate.isEmpty ? '' : state.birthDate,
                      textAlign: TextAlign.center,
                      style: context.birthDayLoginText,
                    ),
                  ),
                ),
                if (state.birthDate.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.of(context).size.height * 0.11 / 2 - 18,
                    ),
                    child: InkWell(
                      onTap: () {
                        cubitContext.read<PatientLoginCubit>().clearBirthDate();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      case PageType.verifySms:
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(ConstantString().pleaseEnterSmsCode),
            ),
            CircularCountdown(
              total: Duration(seconds: 30),
              size: 100,
              strokeWidth: 8,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.grey.shade300,
            ),
            ValueListenableBuilder(
              valueListenable: _validateOtp,
              builder: (context, validateOtpValue, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CustomInputContainer(
                        type: EnumTextformfield.otpCode,
                        currentValue: state.otpCode,
                        isValid: validateOtpValue,
                        errorMessage: ConstantString().validateOTPText,
                        child: Text(
                          state.otpCode,
                          textAlign: TextAlign.center,
                          style: context.otpLoginText,
                        ),
                      ),
                    ),
                    if (state.otpCode.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).size.height * 0.11 / 2 -
                              18,
                        ),
                        child: InkWell(
                          onTap: () {
                            _validateOtp.value = true;
                            cubitContext
                                .read<PatientLoginCubit>()
                                .clearOtpCode();
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        );
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
            final tcError = EnumTextformfieldExtension.validateTC(state.tcNo);
            if (tcError != null) {
              _validateTc.value = false;
              SnackbarService().showSnackBar(tcError);
            } else {
              _validateTc.value = true;
              cubitContext.read<PatientLoginCubit>().validateIdentity();
            }
          }
        };
        break;
      case PageType.register:
        onPressed = () {
          if (state.birthDate.length != 10) {
            SnackbarService().showSnackBar(
              ConstantString().pleaseEnterValidBirthDate,
            );
          } else {
            final birthDateError = EnumTextformfieldExtension.validateBirthDate(
              state.birthDate,
            );
            if (birthDateError != null) {
              SnackbarService().showSnackBar(birthDateError);
            } else {
              cubitContext.read<PatientLoginCubit>().userRegister();
            }
          }
        };
        break;
    }

    return CustomButton(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.sizeOf(context).width * .5,
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

  _clean(BuildContext ctx) async {
    _validateTc.value = true;
    _dialogOpen = false;
    _isOpenVerifyPhoneNumberDialog = false;
    _isOpenWarningPhoneNumberDialog;
    _validateOtp.value = true;

    await ctx.setLocale(ConstantString.TR_LOCALE);
    LanguageManager.instance.setLocale(ConstantString.TR_LOCALE);

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
