

import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_response_model.dart';
import '../model/hospital_login_model.dart';

abstract class IhospitalLoginServices {
  final HttpService http;

  IhospitalLoginServices(this.http);

//baseUrl'nin sonuna kolaylıkla ekleme yapmak için kullanılır
  final String dashPath = IHospitalLoginServicesPath.dash.rawValue;

//requesti atacak olan fonksiyon tanımlanır
  Future<ApiResponse<HospitalLoginModel>> postLogin(String userName, String password);
}

enum IHospitalLoginServicesPath { dash }

//BaseUrl'nin sonuna anasayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IHomeServicePathExtension on IHospitalLoginServicesPath {
  String get rawValue {
    switch (this) {
      case IHospitalLoginServicesPath.dash:
        return '/kiosk_fake_api.php';
    }
  }
}
