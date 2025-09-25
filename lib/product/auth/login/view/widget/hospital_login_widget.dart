// hospital_login_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';
import 'package:kiosk/product/auth/login/view/widget/custom_hospital_login_textfield_widget.dart';

import '../../../../../core/utility/tenant_http_service.dart';
import '../../cubit/hospital_login_cubit.dart';
import '../../services/hospital_and_user_login_services.dart';
import 'patient_login_widget.dart';

class HospitalLoginWidget extends StatefulWidget {
  const HospitalLoginWidget({super.key});

  @override
  State<HospitalLoginWidget> createState() => _HospitalLoginWidgetState();
}

final TextEditingController userNameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _HospitalLoginWidgetState extends State<HospitalLoginWidget> {
  bool _pushedPatient = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HospitalLoginCubit>(
      create: (_) => HospitalLoginCubit(
        service: HospitalAndUserLoginServices(TenantHttpService()),
      ),
      child: BlocConsumer<HospitalLoginCubit, HospitalLoginState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) async {
          switch (state.status) {
            case EnumGeneralStateStatus.success:
              if (_pushedPatient) return;
              _pushedPatient = true;

              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<HospitalLoginCubit>(),
                    child: const PatientLoginWidget(),
                  ),
                ),
              );

              _pushedPatient = false;
              break;

            case EnumGeneralStateStatus.loading:
            case EnumGeneralStateStatus.failure:
              final msg = state.message;
              if (msg != null && msg.isNotEmpty) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(msg)));
              }
              break;

            default:
              break;
          }
        },
        builder: (context, state) {
          final bool isLoading = state.status == EnumGeneralStateStatus.loading;
          final VoidCallback? onPressed = isLoading
              ? null
              : () {
                  context.read<HospitalLoginCubit>().postUserLoginCubit(
                    username: userNameController.text,
                    password: passwordController.text,
                  );
                };

          final Widget buttonChild = isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Giriş Yap");

          return Scaffold(
            appBar: AppBar(title: const Text("Hastane Girişi")),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomHospitalLoginTextfieldWidget(
                    labelText: "Kullanıcı Adı",
                    controller: userNameController,
                  ),
                  const SizedBox(height: 16.0),
                  CustomHospitalLoginTextfieldWidget(
                    labelText: "Şifre",
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: buttonChild,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
