import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthFailure', () {
    group('Named Constructors', () {
      test('invalidEmail creates correct failure', () {
        final failure = AuthFailure.invalidEmail();

        expect(failure.message, 'The email address is not valid.');
        expect(failure.code, 'invalid-email');
      });

      test('userNotFound creates correct failure', () {
        final failure = AuthFailure.userNotFound();

        expect(failure.message, 'No user found for this email.');
        expect(failure.code, 'user-not-found');
      });

      test('wrongPassword creates correct failure', () {
        final failure = AuthFailure.wrongPassword();

        expect(failure.message, 'Incorrect password provided.');
        expect(failure.code, 'wrong-password');
      });

      test('emailAlreadyInUse creates correct failure', () {
        final failure = AuthFailure.emailAlreadyInUse();

        expect(failure.message, 'This email is already in use.');
        expect(failure.code, 'email-already-in-use');
      });

      test('weakPassword creates correct failure', () {
        final failure = AuthFailure.weakPassword();

        expect(failure.message, 'Password is too weak.');
        expect(failure.code, 'weak-password');
      });
    });

    group('Equality', () {
      test('same failures are equal', () {
        final failure1 = AuthFailure.invalidEmail();
        final failure2 = AuthFailure.invalidEmail();

        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('different failures are not equal', () {
        final failure1 = AuthFailure.invalidEmail();
        final failure2 = AuthFailure.wrongPassword();

        expect(failure1, isNot(equals(failure2)));
      });

      test('failures with same message and code are equal', () {
        const failure1 = AuthFailure(
          message: 'Test message',
          code: 'test-code',
        );
        const failure2 = AuthFailure(
          message: 'Test message',
          code: 'test-code',
        );

        expect(failure1, equals(failure2));
      });
    });

    group('toString', () {
      test('includes message and code', () {
        final failure = AuthFailure.invalidEmail();

        expect(
          failure.toString(),
          contains('invalid-email'),
        );
        expect(
          failure.toString(),
          contains('The email address is not valid.'),
        );
      });
    });

    group('Type Safety', () {
      test('AuthFailure is a Failure', () {
        final failure = AuthFailure.invalidEmail();

        expect(failure, isA<AuthFailure>());
      });

      test('can distinguish between failure types', () {
        final authFailure = AuthFailure.invalidEmail();

        expect(authFailure, isA<AuthFailure>());
      });
    });

    group('Code Preservation', () {
      test('preserves original error code', () {
        const customFailure = AuthFailure(
          message: 'Custom error',
          code: 'custom-code-123',
        );

        expect(customFailure.code, 'custom-code-123');
      });

      test('can be used for programmatic handling', () {
        final failure = AuthFailure.invalidEmail();

        switch (failure.code) {
          case 'invalid-email':
            // Handle invalid email
            expect(true, isTrue);
            break;
          case 'wrong-password':
            fail('Should not reach here');
          default:
            fail('Should not reach here');
        }
      });
    });
  });
}
