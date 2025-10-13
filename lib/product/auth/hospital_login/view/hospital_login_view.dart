import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/core/widget/loading_widget.dart';
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';
import 'package:kiosk/product/auth/hospital_login/view/widget/hospital_login_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/utility/dynamic_theme_provider.dart';
import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/navigation_service.dart';
import '../../../../features/utility/tenant_http_service.dart';
import '../cubit/hospital_login_cubit.dart';
import '../services/hospital_and_user_login_services.dart';

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
        kioskDeviceId: 1,
        service: HospitalAndUserLoginServices(TenantHttpService()),
      ),
      child: BlocConsumer<HospitalLoginCubit, HospitalLoginState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) async {
          switch (state.status) {
            case EnumGeneralStateStatus.loading:
              _showLoading(context);
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
            appBar: AppBar(title: Text(ConstantString().hospitalLogin)),
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
        final hex = state.primaryColor;
        final themeProvider = Provider.of<DynamicThemeProvider>(context);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Configuration Screen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              if (hex != null)
                Text(
                  'Gelen Renk: ${themeProvider.themeData.primaryColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                ),
              const SizedBox(height: 12),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: themeProvider.themeData.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
              ),
            ],
          ),
        );
    }
  }

  void _showLoading(BuildContext context) {
    showDialog(
      useSafeArea: false,

      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        child: const SizedBox.expand(child: Center(child: LoadingWidget())),
      ),
    );
  }

  void _hideLoading(BuildContext context) {
    // Navigator yığında gerçekten bir sayfa varsa kapat
    if (Navigator.canPop(context)) {
      NavigationService.ns.goBack();
    }
  }
}
