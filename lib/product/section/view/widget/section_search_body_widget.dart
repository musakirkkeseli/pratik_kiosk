// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pratik_section_search/cubit/section_search_cubit.dart';
// import 'package:pratik_section_search/model/section_model.dart';


// import '../../../../features/utility/const/constant_string.dart';
// import 'section_search_list_view_widget.dart';

// class SectionSearchBodyWidget extends StatelessWidget {
//   final SectionListModel sectionListModel;
//   final int? branchId;
//   const SectionSearchBodyWidget(
//       {super.key, required this.sectionListModel, this.branchId});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const PagePadding.v12h24(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomTextField(
//               title: branchId is int
//                   ? ConstantString().searchBranch
//                   : ConstantString().searchSection,
//               onChanged: (keyword) {
//                 context
//                     .read<SectionSearchCubit>()
//                     .searchSection(keyword.toLowerCase());
//               },
//             ),
//             Padding(
//               padding: const PagePadding.v18(),
//               child: Text(
//                 branchId is int
//                     ? ConstantString().selectBranch
//                     : ConstantString().selectSection,
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             ),
//             const Divider(),
//             SectionSearchListViewWidget(
//               sectionListModel: sectionListModel,
//               branchId: branchId,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
