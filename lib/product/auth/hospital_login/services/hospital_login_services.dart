import '../../../../features/model/api_response_model.dart';
import '../model/hospital_login_model.dart';
import 'Ihospital_login_services.dart';

class HospitalLoginServices extends IhospitalLoginServices {
  HospitalLoginServices(super.http);

  @override
  Future<ApiResponse<HospitalLoginModel>> postLogin(
    String userName,
    String password,
  ) async {
    return http.request<HospitalLoginModel>(
      requestFunction: () => http.post(
        dashPath,
        data: {'username': userName, 'password': password},
      ),
      fromJson: (json) =>
          HospitalLoginModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
