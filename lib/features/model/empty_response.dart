class EmptyResponse {
  const EmptyResponse();

  factory EmptyResponse.fromJson(Object? _) {
    return const EmptyResponse();
  }

  Map<String, dynamic> toJson() => {};
}