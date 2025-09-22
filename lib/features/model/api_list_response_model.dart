import '../../core/utility/logger_service.dart';

class ApiListResponse<T> {
  final bool? success;
  final String? message;
  final List<T>? data;

  ApiListResponse({this.success, this.message, this.data});

  /// JSON'dan nesne oluşturma
  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    MyLog("ApiListResponse").d(json);
    final rawData = json['data'] ?? [];
    return ApiListResponse<T>(
      success: json['success'],
      message: json['message'],
      data: rawData is List
          ? rawData
                .map((item) => fromJsonT(item as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': (data ?? []).map((item) => toJsonT(item)).toList(),
    };
  }
}
