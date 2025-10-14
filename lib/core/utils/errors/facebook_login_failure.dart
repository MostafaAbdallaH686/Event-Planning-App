import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'failures.dart';

/// Failure related to Facebook login operations.
class FacebookLoginFailure extends Failure {
  const FacebookLoginFailure({
    required super.message,
    super.code,
  });

  factory FacebookLoginFailure.cancelled() => const FacebookLoginFailure(
        message: 'Facebook login cancelled by user.',
        code: 'login-cancelled',
      );

  factory FacebookLoginFailure.failed([String? reason]) => FacebookLoginFailure(
        message: 'Facebook login failed${reason != null ? ": $reason" : "."}',
        code: 'login-failed',
      );

  factory FacebookLoginFailure.fromStatus(
    LoginStatus status, {
    String? message,
  }) {
    switch (status) {
      case LoginStatus.cancelled:
        return FacebookLoginFailure.cancelled();
      case LoginStatus.failed:
        return FacebookLoginFailure.failed(message);
      default:
        return FacebookLoginFailure(
          message: 'Unexpected Facebook login status: ${status.name}',
          code: 'unexpected-status',
        );
    }
  }
}
