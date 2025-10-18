import 'package:kiosk/product/patient_transaction/model/association_model.dart';
import 'package:kiosk/product/patient_transaction/service/IPatientTransactionService.dart';

import '../../../features/model/api_list_response_model.dart';
import '../model/insurance_model.dart';

class PatientTransactionService extends IPatientTransactionService {
  PatientTransactionService(super.http);

  @override
  Future<ApiListResponse<AssocationModel>> getAssociationList() async {
    return http.requestList<AssocationModel>(
      requestFunction: () => http.get(associationListPath),
      fromJson: (json) => AssocationModel.fromJson(json),
    );
  }

  @override
  Future<ApiListResponse<InsuranceModel>> getInsuranceList() async {
    return http.requestList<InsuranceModel>(
      requestFunction: () => http.get(insuranceListPath),
      fromJson: (json) => InsuranceModel.fromJson(json),
    );
  }
}
