import 'package:dio/dio.dart';

import '../../core/utility/http_service.dart';
import '../../core/utility/cache_manager.dart';
import '../../core/utility/login_status_service.dart';

class UserHttpService extends HttpService {
  UserHttpService({
    String? baseUrl,
  }) : super.withInterceptor(
          interceptor: InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await CacheManager().readString('token');
              if (token != null && token.isNotEmpty && options.headers['Authorization'] == null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              handler.next(options);
            },
            onError: (DioException e, handler) async {
              if (e.response?.statusCode == 401) {
                LoginStatusService().logout();
              }
              handler.next(e);
            },
          ),
        );
}
