// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kiosk/product/auth/hospital_login/view/widget/custom_hospital_login_textfield_widget.dart';

// import '../../../../core/utility/http_service.dart';
// import '../cubit/hospital_login_cubit.dart';
// import '../services/hospital_login_services.dart';

// class HospitalLoginView extends StatefulWidget {
//   const HospitalLoginView({super.key});

//   @override
//   State<HospitalLoginView> createState() => _HospitalLoginViewState();
// }

// final TextEditingController userNameController = TextEditingController();
// final TextEditingController passwordController = TextEditingController();

// class _HospitalLoginViewState extends State<HospitalLoginView> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           HospitalLoginCubit(service: HospitalLoginServices(HttpService())),
//       child: BlocBuilder<HospitalLoginCubit, HospitalLoginState>(
//         builder: (context, state) {
//           return Scaffold(
//             appBar: AppBar(title: const Text("Hastane Girişi")),
//             body: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   CustomHospitalLoginTextfieldWidget(
//                     labelText: "Kullanıcı Adı",
//                     controller: userNameController,
//                   ),
//                   SizedBox(height: 16.0),
//                   CustomHospitalLoginTextfieldWidget(
//                     labelText: "Şifre",
//                     controller: passwordController,
//                   ),
//                   SizedBox(height: 10.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<HospitalLoginCubit>().postUserLoginCubit(
//                         username: userNameController.text,
//                         password: passwordController.text,
//                       );
//                     },
//                     child: const Text("Giriş Yap"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';
import 'package:kiosk/product/auth/hospital_login/view/widget/custom_hospital_login_textfield_widget.dart';

import '../../../../core/utility/http_service.dart';
import '../cubit/hospital_login_cubit.dart';
import '../services/hospital_login_services.dart';

class HospitalLoginView extends StatefulWidget {
  const HospitalLoginView({super.key});

  @override
  State<HospitalLoginView> createState() => _HospitalLoginViewState();
}

final TextEditingController userNameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _HospitalLoginViewState extends State<HospitalLoginView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HospitalLoginCubit>(
      create: (_) =>
          HospitalLoginCubit(service: HospitalLoginServices(HttpService())),
      child: BlocConsumer<HospitalLoginCubit, HospitalLoginState>(
        listener: (context, state) async {
          switch (state.status) {
            case EnumGeneralStateStatus.success:
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Başarılı'),
                  content: const Text('Giriş başarılı'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Tamam'),
                    ),
                  ],
                ),
              );
              break;

            case EnumGeneralStateStatus.loading:
            case EnumGeneralStateStatus.failure:
              final msg = state.message;
              if (msg != null && msg.isNotEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(msg)));
              }

            default:
              break;
          }
        },
        builder: (context, state) {
          // onPressed
          VoidCallback? onPressed;
          switch (state.status) {
            case EnumGeneralStateStatus.loading:
              onPressed = null; // disabled
              break;
            default: // initial / success / failure hepsi butonu aktif etsin
              onPressed = () {
                context.read<HospitalLoginCubit>().postUserLoginCubit(
                  username: userNameController.text,
                  password: passwordController.text,
                );
              };
              break;
          }

          // Buton child
          final Widget buttonChild = switch (state.status) {
            EnumGeneralStateStatus.loading => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            _ => const Text("Giriş Yap"),
          };

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
