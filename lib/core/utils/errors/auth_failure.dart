import 'package:firebase_auth/firebase_auth.dart';
import 'failures.dart';

/// Failure related to Firebase Authentication operations.
///
/// Use factory constructors for common errors:
/// ```dart
/// AuthFailure.invalidEmail()
/// AuthFailure.userNotFound()
/// AuthFailure.wrongPassword()
/// ```
///
/// Or create from Firebase exception:
/// ```dart
/// try {
///   await FirebaseAuth.instance.signInWithEmailAndPassword(...);
/// } on FirebaseAuthException catch (e) {
///   return Left(AuthFailure.fromException(e));
/// }
/// ```
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });

  // Named constructors for common errors
  factory AuthFailure.invalidEmail() => const AuthFailure(
        message: 'The email address is not valid.',
        code: 'invalid-email',
      );

  factory AuthFailure.userDisabled() => const AuthFailure(
        message: 'This user account has been disabled.',
        code: 'user-disabled',
      );

  factory AuthFailure.userNotFound() => const AuthFailure(
        message: 'No user found for this email.',
        code: 'user-not-found',
      );

  // factory AuthFailure.invalidCredential() => const AuthFailure(
  //       message: 'Email not registered.',
  //       code: 'invalid-credential',
  //     );

  factory AuthFailure.accountExistsWithDifferentCredential() =>
      const AuthFailure(
        message: 'An account already exists with the same email address '
            'but different sign-in credentials.',
        code: 'account-exists-with-different-credential',
      );

  factory AuthFailure.wrongPassword() => const AuthFailure(
        message: 'Incorrect password provided.',
        code: 'wrong-password',
      );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
        message: 'This email is already in use.',
        code: 'email-already-in-use',
      );

  factory AuthFailure.operationNotAllowed() => const AuthFailure(
        message: 'Operation not allowed. Please contact support.',
        code: 'operation-not-allowed',
      );

  factory AuthFailure.weakPassword() => const AuthFailure(
        message: 'Password is too weak.',
        code: 'weak-password',
      );

  factory AuthFailure.tooManyRequests() => const AuthFailure(
        message: 'Too many attempts. Please try again later.',
        code: 'too-many-requests',
      );

  /// Create AuthFailure from FirebaseAuthException
  factory AuthFailure.fromException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthFailure.invalidEmail();
      case 'user-disabled':
        return AuthFailure.userDisabled();
      case 'user-not-found':
        return AuthFailure.userNotFound();
      // case 'invalid-credential':
      //   return AuthFailure.invalidCredential();
      case 'account-exists-with-different-credential':
        return AuthFailure.accountExistsWithDifferentCredential();
      case 'wrong-password':
        return AuthFailure.wrongPassword();
      case 'email-already-in-use':
        return AuthFailure.emailAlreadyInUse();
      case 'operation-not-allowed':
        return AuthFailure.operationNotAllowed();
      case 'weak-password':
        return AuthFailure.weakPassword();
      case 'too-many-requests':
        return AuthFailure.tooManyRequests();
      default:
        return AuthFailure(
          message:
              exception.message ?? 'Authentication failed. Please try again.',
          code: exception.code,
        );
    }
  }
}
