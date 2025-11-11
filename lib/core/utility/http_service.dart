import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../features/model/api_list_response_model.dart';
import '../../features/model/api_response_model.dart';
import '../../features/utility/const/constant_string.dart';
import '../../features/utility/navigation_service.dart';
import '../exception/network_exception.dart';
import 'analytics_service.dart';
import 'base_dio_service.dart';
import 'language_manager.dart';
import 'logger_service.dart';

abstract class IHttpService {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String path, {dynamic data});
  Future<Response> patch(String path, {dynamic data});
  Future<Response> put(String path, {dynamic data});
  Future<Response> delete(String path, {dynamic data});

  Future<ApiResponse<T>> request<T>({
    required Future<Response> Function() requestFunction,
    required T Function(Object? json) fromJson,
  });

  Future<ApiListResponse<T>> requestList<T>({
    required Future<Response> Function() requestFunction,
    required T Function(Map<String, dynamic>) fromJson,
  });
}

/// Tüm ortak kurulum burada. Farklılık: dışarıdan verilen InterceptorsWrapper.
class HttpService implements IHttpService {
  late final Dio _dio;

  /// Uygulama sürümü tek sefer alınır.
  static String? _appVersion;
  static Future<void> _ensureAppVersionLoaded() async {
    if (_appVersion != null) return;
    final info = await PackageInfo.fromPlatform();
    _appVersion = info.version;
  }

  /// DIKKAT: Ortak interceptor'lar + dışarıdan verilen InterceptorsWrapper eklenir.
  HttpService.withInterceptor({
    required InterceptorsWrapper interceptor,
    Duration connectTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ConstantString.backendUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': LanguageManager.instance.languageCode,
        },
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
      ),
    );

    // 1) Ortak interceptor (versiyon, stopwatch, Sentry, analytics, 400->forceUpdate)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _ensureAppVersionLoaded();
          if (_appVersion != null) {
            options.headers['x-app-version'] = _appVersion;
          }

          // Bu client referansını retry için ekstra'ya koyuyoruz
          options.extra['__client__'] = _dio;

          // Süre ölçümü ve Sentry Span
          options.extra['stopwatch'] = Stopwatch()..start();
          final parentSpan = Sentry.getSpan();
          ISentrySpan span;
          if (parentSpan != null) {
            span = parentSpan.startChild(
              'http.client',
              description: '${options.method} ${options.uri.path}',
            );
          } else {
            final ctx = SentryTransactionContext(
              '${options.method} ${options.uri.path}',
              'http.client',
            );
            span = Sentry.startTransactionWithContext(ctx);
          }
          options.extra['sentry_span'] = span;

          handler.next(options);
        },
        onResponse: (response, handler) async {
          final stopwatch =
              response.requestOptions.extra['stopwatch'] as Stopwatch?;
          stopwatch?.stop();

          if (stopwatch != null) {
            AnalyticsService().trackApiCall(
              method: response.requestOptions.method,
              endpoint: response.requestOptions.path,
              duration: stopwatch.elapsed,
              statusCode: response.statusCode,
              success: true,
            );
          }

          final span =
              response.requestOptions.extra['sentry_span'] as ISentrySpan?;
          if (span != null) {
            span.status = SpanStatus.ok();
            await span.finish();
          }

          handler.next(response);
        },
        onError: (DioException e, handler) async {
          final stopwatch = e.requestOptions.extra['stopwatch'] as Stopwatch?;
          stopwatch?.stop();

          final span = e.requestOptions.extra['sentry_span'] as ISentrySpan?;
          if (span != null) {
            span.throwable = e;
            span.status = SpanStatus.internalError();
            await span.finish();
          }

          AnalyticsService().logException(
            e,
            e.stackTrace,
            tag: 'dio_error',
            extras: {
              'url': e.requestOptions.uri.toString(),
              'method': e.requestOptions.method,
              'statusCode': e.response?.statusCode,
              'response': e.response?.data?.toString(),
            },
          );
          if (stopwatch != null) {
            AnalyticsService().trackApiCall(
              method: e.requestOptions.method,
              endpoint: e.requestOptions.path,
              duration: stopwatch.elapsed,
              statusCode: e.response?.statusCode,
              success: false,
            );
          }
          if (e.response?.statusCode == 400) {
            final data = e.response?.data;
            if (data is Map &&
                (data["statusEnum"] == "MINIMUM_APP_VERSION" ||
                    data["statusEnum"] == "WRONG_VERSION_NUMBER_FORMAT")) {
              NavigationService.ns.gotoForceUpdate();
            }
          }
          handler.next(e);
        },
      ),
    );

    _dio.interceptors.add(interceptor);

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  void updateLanguageHeader(String languageCode) {
    _dio.options.headers['Accept-Language'] = languageCode;
  }

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String path, {data}) {
    return _dio.post(path, data: data);
  }

  @override
  Future<Response> patch(String path, {data}) {
    return _dio.patch(path, data: data);
  }

  @override
  Future<Response> put(String path, {data}) {
    return _dio.put(path, data: data);
  }

  @override
  Future<Response> delete(String path, {data}) {
    return _dio.delete(path, data: data);
  }

  @override
  Future<ApiResponse<T>> request<T>({
    required Future<Response> Function() requestFunction,
    required T Function(Object? json) fromJson,
  }) async {
    try {
      final response = await requestFunction();
      final apiResponse = ApiResponse<T>.fromJson(response.data, fromJson);
      if (apiResponse.success) {
        return apiResponse;
      } else {
        throw NetworkException(apiResponse.message, 200);
      }
    } on DioException catch (e) {
      MyLog.debug("HttpService request DioException $e");
      final message = _extractErrorMessage(e);
      final statusCode = _extractErrorStatusCode(e);
      throw NetworkException(
        BaseDioService.service.handleDioError(e, message),
        statusCode,
      );
    } catch (e) {
      MyLog.debug("HttpService request catch $e");
      rethrow;
    }
  }

  @override
  Future<ApiListResponse<T>> requestList<T>({
    required Future<Response> Function() requestFunction,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await requestFunction();
      final apiResponse = ApiListResponse<T>.fromJson(response.data, fromJson);
      if (apiResponse.success ?? false) {
        return apiResponse;
      } else {
        throw NetworkException(apiResponse.message ?? "", 200);
      }
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      final statusCode = _extractErrorStatusCode(e);
      throw NetworkException(
        BaseDioService.service.handleDioError(e, message),
        statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data["message"]?.toString() ?? ConstantString().errorOccurred;
    }
    return ConstantString().errorOccurred;
  }

  int _extractErrorStatusCode(DioException e) {
    final data = e.response?.statusCode;
    if (data is int) {
      return data;
    }
    return 500;
  }
}
