import '../../../features/model/api_list_response_model.dart';
import '../model/mandatory_request_model.dart';
import '../model/mandatory_response_model.dart';
import 'IMandatoryService.dart';

class MandatoryService extends IMandatoryService {
  MandatoryService(super.http);

  @override
  Future<ApiListResponse<MandatoryResponseModel>> postMandatory(
    MandatoryRequestModel request,
  ) async {
    return http.requestList<MandatoryResponseModel>(
      requestFunction: () =>
          http.post(listMandatoryPath, data: request.toJson()),
      fromJson: (json) => MandatoryResponseModel.fromJson(json),
    );
  }
}
