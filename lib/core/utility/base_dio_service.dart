// hata yakalamaya yardımcı olur
import 'package:dio/dio.dart';

class BaseDioService {
  BaseDioService._();
  static final BaseDioService service = BaseDioService._();

  String handleDioError(DioException e,String? responseMessage) {
    String message;
    // MyLog.debug("handleDioError $responseMessage");
    if (responseMessage != null) {
        // MyLog.debug("handleDioError0");
      message = responseMessage;
    } else {
      switch (e.type) {
        case DioExceptionType.connectionError:
        // MyLog.debug("handleDioError1");
          message =
              "İnternet bağlantınızı kontrol edip daha sonra tekrar deneyin.";
          break;
        case DioExceptionType.connectionTimeout:
        // MyLog.debug("handleDioError2");
          message =
              responseMessage ?? "Bağlantı zaman aşımına uğradı.";
          break;
        case DioExceptionType.badCertificate:
        // MyLog.debug("handleDioError3");
          message =
              responseMessage ?? "Bir sorun oluştu:Hata kodu #1";
          break;
        case DioExceptionType.badResponse:
        // MyLog.debug("handleDioError4");
          message =
              responseMessage ?? "Bir sorun oluştu:Hata kodu #2";
          break;
        case DioExceptionType.receiveTimeout:
        // MyLog.debug("handleDioError5");
          message =
              responseMessage ?? "Bir sorun oluştu:Hata kodu #3";
          break;
        default:
        // MyLog.debug("handleDioError6");
          message =
              responseMessage ?? "Bir sorun oluştu:Hata kodu #5";
          break;
      }
    }

    return message;
  }
}