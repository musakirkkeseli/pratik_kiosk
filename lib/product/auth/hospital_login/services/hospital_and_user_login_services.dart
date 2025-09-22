import '../../../../features/model/api_response_model.dart';
import '../model/hospital_login_model.dart';
import '../model/user_login_model.dart';
import 'IHospital_and_user_login_services.dart';

class HospitalAndUserLoginServices extends IhospitalAndUserLoginServices {
  HospitalAndUserLoginServices(super.http);

  @override
  Future<ApiResponse<HospitalLoginModel>> postLogin(
    String userName,
    String password,
  ) async {
    return http.request<HospitalLoginModel>(
      requestFunction: () => http.post(
        hospitalLogin,
        data: {'username': userName, 'password': password},
      ),
      fromJson: (json) =>
          HospitalLoginModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<UserLoginModel>> postLoginByTc(String tc) {
    return http.request<UserLoginModel>(
      requestFunction: () => http.post(userLogin, data: {'tc': tc}),
      fromJson: (json) => UserLoginModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
