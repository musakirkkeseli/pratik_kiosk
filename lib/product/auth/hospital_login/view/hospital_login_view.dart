import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';
import 'package:kiosk/product/auth/hospital_login/view/widget/hospital_login_widget.dart';

import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/navigation_service.dart';
import '../../../../features/utility/tenant_http_service.dart';
import '../../../../features/widget/app_dialog.dart';
import '../cubit/hospital_login_cubit.dart';
import '../services/hospital_and_user_login_services.dart';
import 'widget/config_widget.dart';

class HospitalLoginView extends StatefulWidget {
  const HospitalLoginView({super.key});

  @override
  State<HospitalLoginView> createState() => _HospitalLoginViewState();
}

class _HospitalLoginViewState extends State<HospitalLoginView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HospitalLoginCubit>(
      create: (_) => HospitalLoginCubit(
        kioskDeviceId: 3,
        service: HospitalAndUserLoginServices(TenantHttpService()),
      ),
      child: BlocConsumer<HospitalLoginCubit, HospitalLoginState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) async {
          switch (state.status) {
            case EnumGeneralStateStatus.loading:
              AppDialog(context).loadingDialog();
              break;
            case EnumGeneralStateStatus.success:
              _hideLoading(context);
              break;
            case EnumGeneralStateStatus.failure:
              _hideLoading(context);
              SnackbarService().showSnackBar(
                state.message ?? ConstantString().errorOccurred,
              );
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: _body(context, state),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, HospitalLoginState state) {
    switch (state.loginStatus) {
      case EnumHospitalLoginStatus.login:
        return HospitalLoginWidget();
      case EnumHospitalLoginStatus.config:
        return ConfigWidget();
    }
  }

  void _hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      NavigationService.ns.goBack();
    }
  }
}
