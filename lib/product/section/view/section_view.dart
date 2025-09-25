// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pratik_section_search/cubit/section_search_cubit.dart';
// import 'package:pratik_section_search/model/section_model.dart';
// import 'package:pratik_section_search/pratik_section_search.dart';

// import '../../../core/widget/loading_widget.dart';
// import '../../../features/utility/const/constant_string.dart';

// class SectionSearchPage extends StatelessWidget {
//   final int? branchId;
//   const SectionSearchPage({super.key, this.branchId});

//   @override
//   Widget build(BuildContext context) {
//     return PratikSectionSearch(
//       backendUrl: ConstantString.backendUrl,
//       language: "ConstAppFunc.currentLanguage(context)",
//       branchId: branchId,
//       hospitalListId: "context.read<SelectHospitalCubit>().hospitalListId()",
//       baseViewBuilder: (BuildContext context, Widget child) {
//         return Scaffold(
//           appBar: AppBar(title: Text("Bölüm Seçimi")),
//           body: child,
//         );
//       },
//       loadingView: const LoadingWidget(),
//       successViewBuilder: (BuildContext context, SectionSearchComplated state) {
//         // return SectionSearchBodyWidget(
//         //   sectionListModel: state.sectionListModel ?? SectionListModel(),
//         //   branchId: branchId,
//         // );
//       },
//       errorViewBuilder: const AppErrorWidget(),
//     );
//   }

//   // _appbar(BuildContext context) {
//   //   return CustomAppBar(
//   //       title: branchId is int
//   //           ? ConstantString().branchs
//   //           : ConstantString().sections);
//   // }
// }
