import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../model/mandatory_request_model.dart';
import '../model/mandatory_response_model.dart';

abstract class IMandatoryService {
  final IHttpService http;

  IMandatoryService(this.http);

  final String listMandatoryPath = IMandatoryServicePath.listMandatory.rawValue;

  Future<ApiListResponse<MandatoryResponseModel>> postMandatory(
    MandatoryRequestModel request,
  );
}

enum IMandatoryServicePath { listMandatory }

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IMandatoryServicePathExtension on IMandatoryServicePath {
  String get rawValue {
    switch (this) {
      case IMandatoryServicePath.listMandatory:
        return '/patient-transaction/mandatory-fields';
    }
  }
}
