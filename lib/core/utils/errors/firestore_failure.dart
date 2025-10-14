import 'package:firebase_core/firebase_core.dart';
import 'failures.dart';

/// Failure related to Firestore operations.
///
/// Example:
/// ```dart
/// try {
///   await firestore.collection('users').doc(id).get();
/// } on FirebaseException catch (e) {
///   return Left(FirestoreFailure.fromException(e));
/// }
/// ```
class FirestoreFailure extends Failure {
  const FirestoreFailure({
    required super.message,
    super.code,
  });

  factory FirestoreFailure.permissionDenied() => const FirestoreFailure(
        message: "You don't have permission to perform this action.",
        code: 'permission-denied',
      );

  factory FirestoreFailure.unavailable() => const FirestoreFailure(
        message: 'Service is currently unavailable. Try again later.',
        code: 'unavailable',
      );

  factory FirestoreFailure.notFound() => const FirestoreFailure(
        message: 'Requested document not found.',
        code: 'not-found',
      );

  factory FirestoreFailure.alreadyExists() => const FirestoreFailure(
        message: 'Document already exists.',
        code: 'already-exists',
      );

  factory FirestoreFailure.cancelled() => const FirestoreFailure(
        message: 'The operation was cancelled.',
        code: 'cancelled',
      );

  factory FirestoreFailure.deadlineExceeded() => const FirestoreFailure(
        message: 'Operation timed out.',
        code: 'deadline-exceeded',
      );

  factory FirestoreFailure.fromException(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return FirestoreFailure.permissionDenied();
      case 'unavailable':
        return FirestoreFailure.unavailable();
      case 'not-found':
        return FirestoreFailure.notFound();
      case 'already-exists':
        return FirestoreFailure.alreadyExists();
      case 'cancelled':
        return FirestoreFailure.cancelled();
      case 'deadline-exceeded':
        return FirestoreFailure.deadlineExceeded();
      default:
        return FirestoreFailure(
          message: exception.message ??
              'Unexpected Firestore error. Please try again.',
          code: exception.code,
        );
    }
  }
}
