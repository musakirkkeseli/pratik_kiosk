// import '../../../features/model/api_response_model.dart';
// import '../../../features/model/patient_price_detail_model.dart';
// import 'IPriceDetailsService.dart';

// class PriceDetailsService extends IPriceDetailsService {
//   PriceDetailsService(super.http);

//   @override
//   Future<ApiResponse<PatientTransactionDetailsResponseModel>> postPatientPrice(
//     String patientId,
//   ) async {
//     return http.request<PatientTransactionDetailsResponseModel>(
//       requestFunction: () =>
//           http.post(patientPricePath, data: {'PatientID': patientId}),
//       fromJson: (json) =>
//           PatientTransactionDetailsResponseModel.fromJson(json as Map<String, dynamic>),
//     );
//   }
// }
