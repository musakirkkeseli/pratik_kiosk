import 'package:flutter/material.dart';

import '../../model/doctor_model.dart';

class DoctorListTileWidget extends StatelessWidget {
  final List<DoctorItems> doctorItemList;
  const DoctorListTileWidget({super.key, required this.doctorItemList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: doctorItemList.length,
      itemBuilder: (context, index) {
        DoctorItems section = doctorItemList[index];
        return Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      section.doctorName ==
                              "ConstantString().otherBranches.locale"
                          ? "ConstantString().nutritionAndDietetics.locale"
                          : section.doctorName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => DoctorSearchPage(
                //               departmanId: section.sectionId,
                //               departmanName: section.sectionName,
                //             )));
              },
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
