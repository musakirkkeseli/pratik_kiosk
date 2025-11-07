import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'logger_service.dart';

/// Uygulama açıkken her saat başı backend'e health check isteği atan servis
class PeriodicHealthCheckService {
  static final PeriodicHealthCheckService _instance = PeriodicHealthCheckService._internal();
  factory PeriodicHealthCheckService() => _instance;
  PeriodicHealthCheckService._internal();

  Timer? _timer;
  final Dio _dio = Dio();
  bool _isRunning = false;
  final MyLog _log = MyLog('PeriodicHealthCheckService');

  /// Servisi başlatır - her saat başı health check yapar
  void start({
    required String baseUrl,
    String endpoint = '/health',
    Duration interval = const Duration(hours: 1),
    Map<String, String>? headers,
  }) {
    if (_isRunning) {
      _log.w('Service already running');
      return;
    }

    _isRunning = true;
    _log.i('Starting periodic health check - Interval: ${interval.inMinutes} minutes');

    // İlk isteği hemen gönder
    _sendHealthCheck(baseUrl, endpoint, headers);

    // Periyodik timer başlat
    _timer = Timer.periodic(interval, (_) {
      _sendHealthCheck(baseUrl, endpoint, headers);
    });
  }

  /// Health check isteği gönderir
  Future<void> _sendHealthCheck(
    String baseUrl,
    String endpoint,
    Map<String, String>? headers,
  ) async {
    try {
      // Network kontrolü
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.mobile) &&
          !connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.ethernet) &&
          !connectivity.contains(ConnectivityResult.vpn)) {
        _log.w('No internet connection - skipping health check');
        return;
      }

      _log.i('Sending health check to: $baseUrl$endpoint');
      
      final response = await _dio.get(
        '$baseUrl$endpoint',
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        _log.i('Health check successful - Status: ${response.statusCode}');
      } else {
        _log.w('Health check returned status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _log.e('Health check failed - DioException: ${e.type} - ${e.message}');
    } catch (e) {
      _log.e('Health check failed - Error: $e');
    }
  }

  /// Servisi durdurur
  void stop() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _isRunning = false;
      _log.i('Periodic health check stopped');
    }
  }

  /// Servisin çalışıp çalışmadığını kontrol eder
  bool get isRunning => _isRunning;

  /// Manuel olarak tek bir health check yapar
  Future<void> triggerManualCheck({
    required String baseUrl,
    String endpoint = '/health',
    Map<String, String>? headers,
  }) async {
    _log.i('Manual health check triggered');
    await _sendHealthCheck(baseUrl, endpoint, headers);
  }
}
