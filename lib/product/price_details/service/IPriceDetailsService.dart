// import '../../../core/utility/http_service.dart';
// import '../../../features/model/api_response_model.dart';
// import '../../../features/model/patient_price_detail_model.dart';

// abstract class IPriceDetailsService {
//   final IHttpService http;

//   IPriceDetailsService(this.http);

//   final String patientPricePath =
//       IPriceDetailsServicePath.patientPrice.rawValue;

//   Future<ApiResponse<PatientTransactionDetailsResponseModel>> postPatientPrice(String patientId);
// }

// enum IPriceDetailsServicePath { patientPrice }

// //BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
// extension IPriceDetailsServicePathExtension on IPriceDetailsServicePath {
//   String get rawValue {
//     switch (this) {
//       case IPriceDetailsServicePath.patientPrice:
//         return '/patient-transaction/transaction-details';
//     }
//   }
// }
