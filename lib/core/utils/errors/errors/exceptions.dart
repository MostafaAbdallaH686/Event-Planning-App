/// Custom exception for Dio errors (thrown from data layer)
class CustomDioException implements Exception {
  final String message;
  final String? code;

  const CustomDioException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'CustomDioException: $message';
}

/// Server exception (thrown from data sources)
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Cache exception
class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}
