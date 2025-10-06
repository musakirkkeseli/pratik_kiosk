import 'package:kiosk/product/patient_transaction/model/Patient_transaction_request_model.dart';
import 'package:kiosk/product/patient_transaction/service/IPatientTransactionService.dart';

import '../../../features/model/api_list_response_model.dart';

class PatientTransactionService extends IPatientTransactionService {
  PatientTransactionService(super.http);

  @override
  Future<ApiListResponse<AssociationsModel>> getAssociationList() async {
    return http.requestList<AssociationsModel>(
      requestFunction: () => http.get(associationList),
      fromJson: (json) => AssociationsModel.fromJson(json),
    );
  }
}
