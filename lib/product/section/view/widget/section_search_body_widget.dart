import 'package:flutter/material.dart';
import 'package:kiosk/product/section/model/section_model.dart';

import 'section_search_list_view_widget.dart';

class SectionSearchBodyWidget extends StatelessWidget {
  final List<SectionItems> sectionItemList;

  const SectionSearchBodyWidget({super.key, required this.sectionItemList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: Text(
          //     ConstantString().selectBranch,
      
          //     style: Theme.of(context).textTheme.titleMedium,
          //   ),
          // ),
          // const Divider(),
          SectionSearchListViewWidget(sectionItemList: sectionItemList),
        ],
      ),
    );
  }
}
