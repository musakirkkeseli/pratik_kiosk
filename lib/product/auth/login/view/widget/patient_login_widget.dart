import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/utility/enum/enum_general_state_status.dart';
import '../../cubit/hospital_login_cubit.dart';

class PatientLoginWidget extends StatefulWidget {
  const PatientLoginWidget({super.key});

  @override
  State<PatientLoginWidget> createState() => _PatientLoginWidgetState();
}

class _PatientLoginWidgetState extends State<PatientLoginWidget> {
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
