// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kiosk/features/utility/navigation_service.dart';

// import '../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
// import '../../../core/utility/logger_service.dart';
// import '../../../core/widget/loading_widget.dart';
// import '../../../features/utility/const/constant_string.dart';
// import '../../../features/utility/enum/enum_general_state_status.dart';
// import '../../../features/utility/user_http_service.dart';
// import '../../../features/widget/item_button.dart';
// import '../cubit/patient_transaction_cubit.dart';
// import '../model/association_model.dart';
// import '../service/patient_transaction_service.dart';

// class PatientTransactionView extends StatelessWidget {
//   const PatientTransactionView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<PatientTransactionCubit>(
//       create: (context) => PatientTransactionCubit(
//         service: PatientTransactionService(UserHttpService()),
//       )..fetchAssociations(),
//       child: BlocBuilder<PatientTransactionCubit, PatientTransactionState>(
//         builder: (context, state) {
//           return Scaffold(body: _bodyFunc(state, context));
//         },
//       ),
//     );
//   }

//   Widget _bodyFunc(PatientTransactionState state, BuildContext context) {
//     switch (state.status) {
//       case EnumGeneralStateStatus.loading:
//         return const LoadingWidget();

//       case EnumGeneralStateStatus.success:
//         final List<AssocationModel> items = state.data;
//         if (items.isEmpty) {
//           return Center(child: Text(ConstantString().noAppointments));
//         }
//         return ListView.separated(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           itemCount: items.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 8),
//           itemBuilder: (_, i) {
//             final item = items[i];
//             return ItemButton(
//               title: item.assocationName ?? '-',
//               onTap: () {
//                 MyLog("PatientTransactionView").d(
//                   "Selected Association:\n"
//                   "  - ID: ${item.assocationId}\n"
//                   "  - Name: ${item.assocationName}\n"
//                   "  - GSS ID: ${item.gssAssocationId}",
//                 );
//                 if (item.gssAssocationId == "1") {
//                   Navigator.of(context).push(
//                     RawDialogRoute(
//                       pageBuilder: (dialogcontext, animation, secondaryAnimation) {
//                         return Center(
//                           child: Material(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Align(
//                                     alignment: Alignment.topRight,
//                                     child: IconButton(
//                                       icon: const Icon(Icons.close, size: 50),
//                                       onPressed: () {
//                                         NavigationService.ns.goBack();
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   ConstantString().associationGssInfoMessage,
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(height: 16),
//                                 state.insuranceData.isNotEmpty
//                                     ? Expanded(
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 16.0,
//                                           ),
//                                           child: ListView.separated(
//                                             shrinkWrap: true,
//                                             itemCount:
//                                                 state.insuranceData.length,
//                                             separatorBuilder: (_, __) =>
//                                                 const SizedBox(height: 12),
//                                             itemBuilder: (_, index) {
//                                               final insuranceItem =
//                                                   state.insuranceData[index];
//                                               return ItemButton(
//                                                 title:
//                                                     insuranceItem
//                                                         .insuredTypeName ??
//                                                     '',
//                                                 onTap: () {
//                                                   NavigationService.ns.goBack();
//                                                   context
//                                                       .read<
//                                                         PatientRegistrationProceduresCubit
//                                                       >()
//                                                       .selectAssociationWithInsurance(
//                                                         AssocationModel(
//                                                           assocationId:
//                                                               item.assocationId,
//                                                           assocationName: item
//                                                               .assocationName,
//                                                         ),
//                                                         insuranceItem,
//                                                       );
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       )
//                                     : Text(ConstantString().errorOccurred),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 } else {
//                   context
//                       .read<PatientRegistrationProceduresCubit>()
//                       .selectAssociation(
//                         AssocationModel(
//                           assocationId: item.assocationId,
//                           assocationName: item.assocationName,
//                         ),
//                       );
//                 }
//               },
//             );
//           },
//         );

//       default:
//         return Center(
//           child: Text(state.message ?? ConstantString().errorOccurred),
//         );
//     }
//   }
// }
