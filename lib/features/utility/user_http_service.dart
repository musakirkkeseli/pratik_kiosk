import 'package:dio/dio.dart';

import '../../core/utility/http_service.dart';
import '../../core/utility/session_manager.dart';
import '../../core/utility/user_login_status_service.dart';

class UserHttpService extends HttpService {
  UserHttpService({String? baseUrl})
    : super.withInterceptor(
        interceptor: InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = UserLoginStatusService().accessToken;
            if (token != null &&
                token.isNotEmpty &&
                options.headers['Authorization'] == null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
          onError: (DioException e, handler) async {
            final status = e.response?.statusCode;
            if (status == 401 ||
                status == 403 ||
                status == 429 ||
                status == 409) {
              UserLoginStatusService()
                  .logout(reason: SessionEndReason.error);
            }
            handler.next(e);
          },
        ),
      );
}
