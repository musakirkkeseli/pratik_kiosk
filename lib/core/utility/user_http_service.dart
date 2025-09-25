import 'package:dio/dio.dart';

import 'http_service.dart';
import 'cache_manager.dart';
import 'login_status_service.dart';

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
                // Kullanıcı akışı: refresh yok → direkt çıkış
                LoginStatusService().logout();
              }
              handler.next(e);
            },
          ),
        );
}
