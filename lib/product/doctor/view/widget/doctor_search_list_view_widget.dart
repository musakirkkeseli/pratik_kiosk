import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../../features/widget/item_button.dart';
import '../../model/doctor_model.dart';

class DoctorListTileWidget extends StatelessWidget {
  final List<DoctorItems> doctorItemList;
  const DoctorListTileWidget({super.key, required this.doctorItemList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: doctorItemList.length,
      itemBuilder: (context, index) {
        DoctorItems doctor = doctorItemList[index];
        return ItemButton(
          title: doctor.doctorName ?? "",
          onTap: () {
            context.read<PatientRegistrationProceduresCubit>().selectDoctor(
              doctor,
            );
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
