import 'package:google_sign_in/google_sign_in.dart';
import 'failures.dart';

/// Failure related to Google Sign-In operations.
class GoogleSignInFailure extends Failure {
  const GoogleSignInFailure({
    required super.message,
    super.code,
  });

  factory GoogleSignInFailure.cancelled() => const GoogleSignInFailure(
        message: 'Google sign-in cancelled by user.',
        code: 'sign-in-cancelled',
      );

  factory GoogleSignInFailure.configurationError() => const GoogleSignInFailure(
        message: 'Google sign-in configuration error.',
        code: 'configuration-error',
      );

  factory GoogleSignInFailure.networkError() => const GoogleSignInFailure(
        message: 'Network error during Google sign-in.',
        code: 'network-error',
      );

  factory GoogleSignInFailure.unknown() => const GoogleSignInFailure(
        message: 'Unknown Google sign-in error.',
        code: 'unknown-error',
      );

  factory GoogleSignInFailure.fromException(GoogleSignInException exception) {
    switch (exception.code) {
      case GoogleSignInExceptionCode.canceled:
        return GoogleSignInFailure.cancelled();
      case GoogleSignInExceptionCode.clientConfigurationError:
        return GoogleSignInFailure.configurationError();
      case GoogleSignInExceptionCode.interrupted:
        return GoogleSignInFailure.networkError();
      default:
        return GoogleSignInFailure(
          message: 'Google sign-in error: ${exception.description}',
          code: exception.code.toString(),
        );
    }
  }
}
