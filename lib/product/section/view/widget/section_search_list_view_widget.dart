import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../../features/widget/item_button.dart';
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
        return ItemButton(
          title: section.sectionName ==
                  "ConstantString().otherBranches.locale"
              ? "ConstantString().nutritionAndDietetics.locale"
              : section.sectionName ?? "",
          onTap: () {
            context
                .read<PatientRegistrationProceduresCubit>()
                .selectSection(section);
          },
        );
      },
    );
  }
}
