import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _dialogOpen = false;
  bool _suppressWarning = false;

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
              (prev.counter > 15) && (curr.counter <= 15) && (curr.counter > 0);

          final leftWarningWhileOpen =
              (_dialogOpen) && (prev.counter <= 15) && (curr.counter > 15);

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

          if (_dialogOpen && state.counter > 15) {
            Navigator.of(context, rootNavigator: true).maybePop();
            _dialogOpen = false;
            _suppressWarning = false;
          }

          switch (state.status) {
            case EnumGeneralStateStatus.success:
              if (state.authType == AuthType.login) {
                AppDialog(context).infoDialog(
                  "Numara Size Mi Ait?",
                  "${state.phoneNumber} numarası size mi ait?",
                  firstActionText: "EVET",
                  secondActionText: "HAYIR",
                  firstOnPressed: () {
                    NavigationService.ns.goBack();
                    context.read<PatientLoginCubit>().setPageType(
                      PageType.verifySms,
                    );
                  },
                  secondOnPressed: () {
                    NavigationService.ns.goBack();
                    AppDialog(
                      context,
                    ).infoDialog("Bilgi", "Lütfen doğru numarayı giriniz.");
                  },
                );
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
          return Scaffold(body: _body(context, state));
        },
      ),
    );
  }

  _body(BuildContext cubitContext, PatientLoginState state) {
    switch (state.pageType) {
      case PageType.auth:
        return Column(
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
                    CustomInputContainer(
                      type: EnumTextformfield.tc,
                      child: Expanded(
                        child: Text(state.tcNo, textAlign: TextAlign.left),
                      ),
                    ),
                    if (state.authType == AuthType.register) ...[
                      CustomInputContainer(
                        type: EnumTextformfield.tc,
                        child: Expanded(
                          child: Text(state.tcNo, textAlign: TextAlign.left),
                        ),
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
                          state.authType == AuthType.login
                              ? cubitContext
                                    .read<PatientLoginCubit>()
                                    .userLogin()
                              : cubitContext
                                    .read<PatientLoginCubit>()
                                    .userRegister();
                        }
                      },
                    ),
                    if (state.tcNo.isNotEmpty)
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          iconColor: Colors.red,
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        onPressed: () {
                          _clean(cubitContext);
                        },
                        icon: Iconify(
                          IconParkSolid.clear_format,
                          color: Colors.red,
                        ),
                        label: Text(ConstantString().clear),
                      ),
                    KioskCardWidget(),
                    VirtualKeypad(pageType: PageType.auth),
                    LanguageButtonWidget(),
                  ],
                ),
              ),
            ),
          ],
        );
      case PageType.verifySms:
        return Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: context.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Lütfen SMS Kodunuzu Giriniz.'),
                  CustomInputContainer(
                    type: EnumTextformfield.otpCode,
                    child: Expanded(
                      child: Text(state.otpCode, textAlign: TextAlign.left),
                    ),
                  ),
                ],
              ),
            ),
            Text('Phone Page'),
            VirtualKeypad(pageType: PageType.verifySms),
          ],
        );
    }
  }

  _clean(BuildContext ctx) {
    ctx.read<PatientLoginCubit>().clean();
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
              );
            },
          ),
        );
      },
    );
  }
}
