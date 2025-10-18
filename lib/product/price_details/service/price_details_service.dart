import '../../../features/model/api_response_model.dart';
import '../model/price_model.dart';
import 'IPriceDetailsService.dart';

class PriceDetailsService extends IPriceDetailsService {
  PriceDetailsService(super.http);

  @override
  Future<ApiResponse<PatientPriceModel>> postPatientPrice(
    String patientId,
  ) async {
    return http.request<PatientPriceModel>(
      requestFunction: () =>
          http.post(patientPricePath, data: {'PatientID': patientId}),
      fromJson: (json) =>
          PatientPriceModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
