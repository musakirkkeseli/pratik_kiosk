
// import 'package:flutter/material.dart';
// import 'package:pratik_section_search/model/section_model.dart';

// import '../../../../features/utility/const/constant_string.dart';



// class SectionSearchListViewWidget extends StatelessWidget {
//   final SectionListModel sectionListModel;
//   final int? branchId;
//   const SectionSearchListViewWidget(
//       {super.key, required this.sectionListModel, this.branchId});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: (sectionListModel.items ?? []).length,
//       itemBuilder: (context, index) {
//         SectionItems section = sectionListModel.items![index];
//         return Column(
//           children: [
//             ListTile(
//               title: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       section.sectionName ==
//                               ConstantString().otherBranches.locale
//                           ? ConstantString().nutritionAndDietetics.locale
//                           : section.sectionName ?? "",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //         builder: (context) => DoctorSearchPage(
//                 //               departmanId: section.sectionId,
//                 //               departmanName: section.sectionName,
//                 //             )));
//               },
//             ),
//             const Divider()
//           ],
//         );
//       },
//     );
//   }
// }
