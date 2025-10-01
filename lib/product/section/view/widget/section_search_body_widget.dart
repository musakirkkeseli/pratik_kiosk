import 'package:flutter/material.dart';
import 'package:kiosk/product/section/model/section_model.dart';

import '../../../../features/utility/const/constant_string.dart';
import 'section_search_list_view_widget.dart';

class SectionSearchBodyWidget extends StatelessWidget {
  final List<SectionItems> sectionItemList;

  const SectionSearchBodyWidget({super.key, required this.sectionItemList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CustomText(
            //   title: branchId is int
            //       ? "ConstantString().searchBranch"
            //       : "ConstantString().searchSection",
            //   onChanged: (keyword) {
            //     context
            //         .read<SectionSearchCubit>()
            //         .searchSection(keyword.toLowerCase());
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                ConstantString().selectBranch,

                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(),
            SectionSearchListViewWidget(sectionItemList: sectionItemList),
          ],
        ),
      ),
    );
  }
}
