import 'package:dio/dio.dart';
import 'package:kiosk/core/utility/logger_service.dart';

import '../../core/utility/http_service.dart';
import '../../product/auth/hospital_login/model/refresh_token_mode.dart';
import 'const/constant_string.dart';
import '../../core/utility/login_status_service.dart';

class TenantHttpService extends HttpService {
  TenantHttpService()
    : super.withInterceptor(
        interceptor: InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = LoginStatusService().accessToken;
            if (token != null &&
                token.isNotEmpty &&
                options.headers['Authorization'] == null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
          onError: (DioException e, handler) async {
            MyLog _refreshMylog = MyLog("TenantHttpService onError");

            final status = e.response?.statusCode;
            final alreadyRetried =
                e.requestOptions.extra['__retried__'] == true;

            if (status != 401 || alreadyRetried == true) {
              return handler.next(e);
            }
            if (status == 403 || status == 429 || status == 409) {
              LoginStatusService().logout();
              return handler.next(e);
            }

            try {
              await _refreshTokenStatic();
              _refreshMylog.d("_refreshTokenStatic finish");
              final newAccess = LoginStatusService().accessToken;
              if (newAccess == null || newAccess.isEmpty) {
                _refreshMylog.d("newAccess null");
                LoginStatusService().logout();
                return handler.next(e);
              }

              final RequestOptions original = e.requestOptions;

              final headers = Map<String, dynamic>.from(original.headers);
              headers['Authorization'] = 'Bearer $newAccess';

              final retried = RequestOptions(
                path: original.path,
                method: original.method,
                baseUrl: original.baseUrl,
                data: original.data,
                queryParameters: original.queryParameters,
                cancelToken: original.cancelToken,
                onReceiveProgress: original.onReceiveProgress,
                onSendProgress: original.onSendProgress,
                connectTimeout: original.connectTimeout,
                sendTimeout: original.sendTimeout,
                receiveTimeout: original.receiveTimeout,
                extra: {...original.extra, '__retried__': true},
                headers: headers,
                responseType: original.responseType,
                followRedirects: original.followRedirects,
                contentType: original.contentType,
                listFormat: original.listFormat,
                maxRedirects: original.maxRedirects,
                persistentConnection: original.persistentConnection,
                receiveDataWhenStatusError: original.receiveDataWhenStatusError,
                requestEncoder: original.requestEncoder,
                responseDecoder: original.responseDecoder,
                validateStatus: original.validateStatus,
              );
              _refreshMylog.d("istek refresh");

              // Aynı client ile retry: client referansını common onRequest içine koymuştuk.
              final Dio client =
                  (original.extra['__client__'] as Dio?) ??
                  Dio(
                    BaseOptions(
                      baseUrl: original.baseUrl.isNotEmpty
                          ? original.baseUrl
                          : ConstantString.backendUrl,
                    ),
                  );

              final response = await client.fetch(retried);
              _refreshMylog.d("istek finish ${response.data}");
              if (response.statusCode != 401 &&
                  response.statusCode != 403 &&
                  response.statusCode != 429 &&
                  response.statusCode != 409) {
                _refreshMylog.d("retry sonucu 400 - logout yapılmayacak");
                return handler.resolve(response);
              }
              return handler.resolve(response);
            } catch (err) {
              _refreshMylog.d("catch $e");
              if (err is DioException && err.response?.statusCode != 401) {
                return handler.next(err);
              }
              LoginStatusService().logout();
              return handler.next(e);
            }
          },
        ),
      );

  // Aynı anda çoklu refresh’i engellemek için paylaşılan future
  static Future<void>? _refreshing;

  static Future<void> _refreshTokenStatic() async {
    MyLog _refreshMylog = MyLog("_refreshTokenStatic");
    if (_refreshing != null) {
      _refreshMylog.d("_refreshing not null");
      await _refreshing;
      return;
    }
    _refreshing = _doRefresh();
    try {
      await _refreshing;
    } finally {
      _refreshing = null;
    }
  }

  static Future<void> _doRefresh() async {
    MyLog _dorefreshMylog = MyLog("_doRefresh");
    _dorefreshMylog.d("run");
    final refreshToken = LoginStatusService().refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      LoginStatusService().logout();
      _dorefreshMylog.d("refresh null");
      throw StateError('Refresh token yok');
    }

    // Interceptor zincirinden bağımsız "çıplak" dio
    final bare = Dio(
      BaseOptions(
        baseUrl: ConstantString.backendUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
    _dorefreshMylog.d("created bare");
    try {
      final res = await bare.post(
        "/auth/refresh-token",
        data: {
          'refreshToken': refreshToken, // backend’e göre alan adını uyarlayın
        },
      );
      _dorefreshMylog.d("response ${res.data}");

      RefreshTokenResponseModel? refreshTokenResponseModel =
          RefreshTokenResponseModel.fromJson(res.data["data"]);
      _dorefreshMylog.d("response ${refreshTokenResponseModel.toJson()}");
      final newAccess = (refreshTokenResponseModel.accessToken);
      final newRefresh = (refreshTokenResponseModel.refreshToken);

      if ((newAccess ?? "").isEmpty && (newRefresh ?? "").isEmpty) {
        LoginStatusService().logout();
        throw StateError('Access token güncellenemedi');
      } else {
        LoginStatusService().refreshTokens(
          accessToken: newAccess ?? "",
          refreshToken: newRefresh ?? "",
        );
      }
    } catch (e) {
      LoginStatusService().logout();
      _dorefreshMylog.d("catch $e");
      throw StateError('Token yenileme başarısız: $e');
    }
  }
}
