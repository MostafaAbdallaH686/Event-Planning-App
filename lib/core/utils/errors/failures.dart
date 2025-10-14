import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// All failures should extend this class and provide:
/// - [message]: Human-readable error message
/// - [code]: Error code for programmatic handling (optional)
///
/// Example:
/// ```dart
/// final failure = AuthFailure.invalidEmail();
/// print(failure.message); // "The email address is not valid."
/// print(failure.code);    // "invalid-email"
/// ```
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

/// Failure from network operations
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

  factory NetworkFailure.serverError() => const NetworkFailure(
        message: 'Server error. Please try again later.',
        code: 'server-error',
      );
}

/// Failure from cache operations
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });

  factory CacheFailure.notFound() => const CacheFailure(
        message: 'Data not found in cache.',
        code: 'cache-not-found',
      );
}

/// Generic failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.code,
  });

  factory UnexpectedFailure.fromException(Exception exception) =>
      UnexpectedFailure(
        message: exception.toString(),
        code: 'unexpected-error',
      );
}
