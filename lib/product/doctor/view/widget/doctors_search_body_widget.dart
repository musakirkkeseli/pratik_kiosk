import 'package:flutter/material.dart';

import '../../model/doctor_model.dart';
import 'doctor_search_list_view_widget.dart';

class DoctorSearchBodyWidget extends StatelessWidget {
  final List<DoctorItems> doctorItemList;
  final bool isAppointment;

  const DoctorSearchBodyWidget({
    super.key,
    required this.doctorItemList,
    required this.isAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [DoctorListTileWidget(doctorItemList: doctorItemList, isAppointment: isAppointment)],
      ),
    );
  }
}
