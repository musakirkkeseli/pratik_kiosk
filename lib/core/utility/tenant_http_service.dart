import 'package:dio/dio.dart';

import 'http_service.dart';
import 'cache_manager.dart';
import '../../features/utility/const/constant_string.dart';
import 'login_status_service.dart';

class TenantHttpService extends HttpService {
  TenantHttpService()
    : super.withInterceptor(
        interceptor: InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await CacheManager().readString("accessTokenKey");
            if (token != null &&
                token.isNotEmpty &&
                options.headers['Authorization'] == null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
          onError: (DioException e, handler) async {
            final status = e.response?.statusCode;
            final alreadyRetried =
                e.requestOptions.extra['__retried__'] == true;

            if (status != 401 || alreadyRetried == true) {
              return handler.next(e);
            }

            try {
              await _refreshTokenStatic(
                refreshPath: "refreshPath",
                accessTokenKey: "accessTokenKey",
                refreshTokenKey: "refreshTokenKey",
              );

              final newAccess = await CacheManager().readString("accessTokenKey");
              if (newAccess == null || newAccess.isEmpty) {
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
              return handler.resolve(response);
            } catch (_) {
              LoginStatusService().logout();
              return handler.next(e);
            }
          },
        ),
      );

  // Aynı anda çoklu refresh’i engellemek için paylaşılan future
  static Future<void>? _refreshing;

  static Future<void> _refreshTokenStatic({
    required String refreshPath,
    required String accessTokenKey,
    required String refreshTokenKey,
  }) async {
    if (_refreshing != null) {
      await _refreshing;
      return;
    }
    _refreshing = _doRefresh(
      refreshPath: refreshPath,
      accessTokenKey: accessTokenKey,
      refreshTokenKey: refreshTokenKey,
    );
    try {
      await _refreshing;
    } finally {
      _refreshing = null;
    }
  }

  static Future<void> _doRefresh({
    required String refreshPath,
    required String accessTokenKey,
    required String refreshTokenKey,
  }) async {
    final refresh = await CacheManager().readString(refreshTokenKey);
    if (refresh == null || refresh.isEmpty) {
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

    final res = await bare.post(
      refreshPath,
      data: {
        'refresh_token': refresh, // backend’e göre alan adını uyarlayın
      },
    );

    // Backend alan adlarını projeye göre düzenleyin
    final newAccess = (res.data?['access_token'] as String?)?.trim();
    final newRefresh =
        (res.data?['refresh_token'] as String?)?.trim() ?? refresh;

    if (newAccess == null || newAccess.isEmpty) {
      throw StateError('Access token güncellenemedi');
    }

    await CacheManager().writeString(accessTokenKey, newAccess);
    await CacheManager().writeString(refreshTokenKey, newRefresh);
  }
}
