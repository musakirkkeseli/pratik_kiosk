import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_string.dart';
import '../../model/doctor_model.dart';
import 'doctor_search_list_view_widget.dart';

class DoctorSearchBodyWidget extends StatelessWidget {
  final List<DoctorItems> doctorItemList;

  const DoctorSearchBodyWidget({super.key, required this.doctorItemList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                ConstantString().selectDoctor,

                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(),
            DoctorListTileWidget(doctorItemList: doctorItemList),
          ],
        ),
      ),
    );
  }
}
