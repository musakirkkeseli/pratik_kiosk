import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/appointment_cubit.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        switch (state.status) {
          case AppointmentStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case AppointmentStatus.failure:
            return Center(child: Text(state.message ?? 'Bir hata oluştu'));
          case AppointmentStatus.success:
            if (state.data.isEmpty) {
              return const Center(child: Text('Kayıt yok'));
            }
            return ListView.separated(
              itemCount: state.data.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final it = state.data[i];
                return ListTile(
                  title: Text(it.branchName ?? '-'),
                  subtitle: Text(it.doctorName ?? '-'),
                );
              },
            );
          case AppointmentStatus.initial:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
