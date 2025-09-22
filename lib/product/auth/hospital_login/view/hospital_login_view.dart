import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';
import 'package:kiosk/product/auth/hospital_login/view/widget/custom_hospital_login_textfield_widget.dart';

import '../../../../core/utility/http_service.dart';
import '../cubit/hospital_login_cubit.dart';
import '../services/hospital_and_user_login_services.dart';

class HospitalLoginView extends StatefulWidget {
  const HospitalLoginView({super.key});

  @override
  State<HospitalLoginView> createState() => _HospitalLoginViewState();
}

final TextEditingController userNameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _HospitalLoginViewState extends State<HospitalLoginView> {
  bool _pushedPatient = false; // <-- eklendi

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HospitalLoginCubit>(
      create: (_) => HospitalLoginCubit(
        service: HospitalAndUserLoginServices(HttpService()),
      ),
      child: BlocConsumer<HospitalLoginCubit, HospitalLoginState>(
        // <<< SADECE status değiştiğinde listener çalışsın
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) async {
          switch (state.status) {
            case EnumGeneralStateStatus.success:
              // <<< Yalnızca ilk kez push et
              if (_pushedPatient) return;
              _pushedPatient = true;

              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<HospitalLoginCubit>(),
                    child: const PatientLoginView(),
                  ),
                ),
              );

              // Geri dönüldüğünde tekrar push etmesin
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

class PatientLoginView extends StatefulWidget {
  const PatientLoginView({super.key});

  @override
  State<PatientLoginView> createState() => _PatientLoginViewState();
}

class _PatientLoginViewState extends State<PatientLoginView> {
  final TextEditingController _tcController = TextEditingController();

  @override
  void dispose() {
    _tcController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final tc = _tcController.text.trim();

    if (!RegExp(r'^\d{11}$').hasMatch(tc)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen 11 haneli geçerli bir TC girin.')),
      );
      return;
    }

    context.read<HospitalLoginCubit>().verifyPatientTcCubit(userEnteredTc: tc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HospitalLoginCubit, HospitalLoginState>(
      listenWhen: (prev, curr) => prev.tcStatus != curr.tcStatus,
      listener: (context, state) async {
        if (state.tcStatus == EnumGeneralStateStatus.success) {
          // BAŞARILI POPUP
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Başarılı'),
              content: Text(state.message ?? 'TC doğrulandı.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // dialog kapat
                  child: const Text('Tamam'),
                ),
              ],
            ),
          );
        } else if (state.tcStatus == EnumGeneralStateStatus.failure) {
          final msg = state.message ?? 'TC doğrulama başarısız.';
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      builder: (context, state) {
        final isLoading = state.tcStatus == EnumGeneralStateStatus.loading;

        return Scaffold(
          appBar: AppBar(title: const Text("Hasta Girişi")),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _tcController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'TC Kimlik No',
                    hintText: '11 haneli TC',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _onSubmit(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _onSubmit,
                    icon: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.login),
                    label: Text(isLoading ? 'Doğrulanıyor...' : 'Giriş Yap'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
