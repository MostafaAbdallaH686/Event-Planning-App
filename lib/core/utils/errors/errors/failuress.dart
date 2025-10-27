// lib/core/error/failures.dart
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// All failures should extend this class and provide:
/// - [message]: Human-readable error message
/// - [code]: Error code for programmatic handling (optional)
abstract class Failure extends Equatable {
  /// Human-readable error message
  final String message;

  /// Error code for programmatic handling
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

// ==================== Network/Server Failures ====================

/// Failure from server/API operations
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });

  /// Create from Dio error
  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(
          message: 'Connection timeout with server',
          code: 'connection-timeout',
        );

      case DioExceptionType.sendTimeout:
        return const ServerFailure(
          message: 'Send timeout with server',
          code: 'send-timeout',
        );

      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          message: 'Receive timeout with server',
          code: 'receive-timeout',
        );

      case DioExceptionType.badCertificate:
        return const ServerFailure(
          message: 'Bad SSL certificate',
          code: 'bad-certificate',
        );

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode ?? 0,
          dioError.response?.data,
        );

      case DioExceptionType.cancel:
        return const ServerFailure(
          message: 'Request was cancelled',
          code: 'request-cancelled',
        );

      case DioExceptionType.connectionError:
        return const ServerFailure(
          message: 'No internet connection',
          code: 'no-internet',
        );

      case DioExceptionType.unknown:
        if (dioError.message?.contains('SocketException') ?? false) {
          return const ServerFailure(
            message: 'No internet connection',
            code: 'no-internet',
          );
        }
        return ServerFailure(
          message: dioError.message ?? 'Unexpected error occurred',
          code: 'unknown-error',
        );
    }
  }

  /// Create from HTTP response
  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    // Extract message from response if available
    String? extractMessage(dynamic data) {
      if (data is Map<String, dynamic>) {
        return data['message'] as String?;
      }
      return null;
    }

    final message = extractMessage(response);

    switch (statusCode) {
      case 400:
        return ServerFailure(
          message: message ?? 'Bad request',
          code: 'bad-request',
        );

      case 401:
        return ServerFailure(
          message: message ?? 'Authentication required',
          code: 'unauthorized',
        );

      case 403:
        return ServerFailure(
          message: message ?? 'Access forbidden',
          code: 'forbidden',
        );

      case 404:
        return ServerFailure(
          message: message ?? 'Resource not found',
          code: 'not-found',
        );

      case 413:
        return ServerFailure(
          message: message ?? 'Payload too large',
          code: 'payload-too-large',
        );

      case 422:
        return ServerFailure(
          message: message ?? 'Unprocessable entity',
          code: 'unprocessable-entity',
        );

      case 429:
        return ServerFailure(
          message: message ?? 'Too many requests',
          code: 'rate-limit',
        );

      case 500:
        return ServerFailure(
          message: message ?? 'Internal server error',
          code: 'server-error',
        );

      case 502:
        return ServerFailure(
          message: message ?? 'Bad gateway',
          code: 'bad-gateway',
        );

      case 503:
        return ServerFailure(
          message: message ?? 'Service unavailable',
          code: 'service-unavailable',
        );

      default:
        return ServerFailure(
          message: message ?? 'Something went wrong',
          code: 'unknown-http-error',
        );
    }
  }
}

/// Network connectivity failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });

  factory NetworkFailure.noConnection() => const NetworkFailure(
        message: 'No internet connection. Please check your network.',
        code: 'no-connection',
      );

  factory NetworkFailure.timeout() => const NetworkFailure(
        message: 'Request timed out. Please try again.',
        code: 'timeout',
      );
}

// ==================== Auth Failures ====================

/// Authentication/Authorization failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });

  factory AuthFailure.notAuthenticated() => const AuthFailure(
        message: 'Please sign in to continue',
        code: 'not-authenticated',
      );

  factory AuthFailure.tokenExpired() => const AuthFailure(
        message: 'Your session has expired. Please sign in again.',
        code: 'token-expired',
      );

  factory AuthFailure.invalidCredentials() => const AuthFailure(
        message: 'Invalid email or password',
        code: 'invalid-credentials',
      );

  factory AuthFailure.accountDisabled() => const AuthFailure(
        message: 'Your account has been disabled',
        code: 'account-disabled',
      );
}

// ==================== Validation Failures ====================

/// Validation failures
class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure({
    required this.errors,
    String? message,
  }) : super(
          message: message ?? 'Validation failed',
          code: 'validation-error',
        );

  @override
  List<Object?> get props => [errors, message, code];

  String? getError(String field) => errors[field];
  bool hasError(String field) => errors.containsKey(field);
}

// ==================== Cache Failures ====================

/// Cache operation failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });

  factory CacheFailure.notFound() => const CacheFailure(
        message: 'Data not found in cache',
        code: 'cache-not-found',
      );

  factory CacheFailure.writeError() => const CacheFailure(
        message: 'Failed to write to cache',
        code: 'cache-write-error',
      );
}

// ==================== Generic Failures ====================

/// Unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.code = 'unexpected-error',
  });

  factory UnexpectedFailure.fromException(Exception exception) =>
      UnexpectedFailure(
        message: exception.toString(),
      );
}
