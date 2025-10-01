import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/navigation_service.dart';

import '../../model/section_model.dart';

class SectionSearchListViewWidget extends StatelessWidget {
  final List<SectionItems> sectionItemList;
  const SectionSearchListViewWidget({super.key, required this.sectionItemList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sectionItemList.length,
      itemBuilder: (context, index) {
        SectionItems section = sectionItemList[index];
        return Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      section.sectionName ==
                              "ConstantString().otherBranches.locale"
                          ? "ConstantString().nutritionAndDietetics.locale"
                          : section.sectionName ?? "",
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
                NavigationService.ns.routeTo(
                  "DoctorSearchView",
                  arguments: {"sectionId": section.sectionId ?? 0},
                );
              },
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
