import 'package:flutter/material.dart';

import '../../model/doctor_model.dart';
import 'section_search_list_view_widget.dart';



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
               " ConstantString().selectBranch",

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
