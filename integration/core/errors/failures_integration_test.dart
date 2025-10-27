// import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
// import 'package:event_planning_app/core/utils/errors/failures.dart';
// import 'package:event_planning_app/core/utils/errors/firestore_failure.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   group('Failures Integration', () {
//     test('can handle different failure types polymorphically', () {
//       final List<Failure> failures = [
//         AuthFailure.invalidEmail(),
//         FirestoreFailure.permissionDenied(),
//         NetworkFailure.noConnection(),
//       ];

//       for (final failure in failures) {
//         expect(failure.message, isNotEmpty);
//         expect(failure, isA<Failure>());
//       }
//     });

//     test('can switch on failure type', () {
//       Failure failure = AuthFailure.invalidEmail();

//       final result = switch (failure) {
//         AuthFailure() => 'auth-error',
//         FirestoreFailure() => 'firestore-error',
//         NetworkFailure() => 'network-error',
//         _ => 'unknown-error',
//       };

//       expect(result, 'auth-error');
//     });

//     test('failures maintain their specific types', () {
//       final Failure failure = AuthFailure.wrongPassword();

//       if (failure is AuthFailure) {
//         // Can access AuthFailure specific properties
//         expect(failure.code, 'wrong-password');
//       } else {
//         fail('Should be AuthFailure');
//       }
//     });
//   });
// }
