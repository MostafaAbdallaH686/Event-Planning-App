import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class Failures {
  final String errorMessage;

  const Failures(this.errorMessage);
}

class FirebaseFailure extends Failures {
  FirebaseFailure(super.errorMessage);

  @override
  String toString() => errorMessage;

  factory FirebaseFailure.fromAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return FirebaseFailure('The email address is not valid.');
      case 'user-disabled':
        return FirebaseFailure('This user account has been disabled.');
      case 'user-not-found':
        return FirebaseFailure('No user found for this email.');
      case 'invalid-credential':
        return FirebaseFailure('Email not registered.');
      case 'account-exists-with-different-credential':
        return FirebaseFailure(
            'An account already exists with the same email address but different sign-in credentials.');
      case 'wrong-password':
        return FirebaseFailure('Incorrect password provided.');
      case 'email-already-in-use':
        return FirebaseFailure('This email is already in use.');
      case 'operation-not-allowed':
        return FirebaseFailure(
            'Operation not allowed. Please contact support.');
      case 'weak-password':
        return FirebaseFailure('Password is too weak.');
      default:
        return FirebaseFailure('Authentication failed. Please try again.');
    }
  }

  factory FirebaseFailure.fromFirestoreException(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return FirebaseFailure(
            'You don’t have permission to perform this action.');
      case 'unavailable':
        return FirebaseFailure(
            'Service is currently unavailable. Try again later.');
      case 'not-found':
        return FirebaseFailure('Requested document not found.');
      case 'already-exists':
        return FirebaseFailure('Document already exists.');
      case 'cancelled':
        return FirebaseFailure('The operation was cancelled.');
      default:
        return FirebaseFailure('Unexpected Firestore error. Please try again.');
    }
  }

  factory FirebaseFailure.fromGoogleSignInException(
      GoogleSignInException exception) {
    switch (exception.code) {
      case GoogleSignInExceptionCode.canceled:
        return FirebaseFailure('Google sign-in cancelled');
      case GoogleSignInExceptionCode.clientConfigurationError:
        return FirebaseFailure('Google sign-in failed');
      default:
        return FirebaseFailure('Google sign-in error: ${exception.code}');
    }
  }

  factory FirebaseFailure.fromFacebookLogin(
      LoginStatus status, String? message) {
    if (status == LoginStatus.cancelled) {
      return FirebaseFailure('Facebook login cancelled by user');
    } else {
      return FirebaseFailure(
          'Facebook login failed: ${message ?? "Unknown error"}');
    }
  }
}
