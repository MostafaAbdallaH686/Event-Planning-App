import 'package:event_planning_app/core/utils/errors/firestore_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirestoreFailure', () {
    test('permissionDenied creates correct failure', () {
      final failure = FirestoreFailure.permissionDenied();

      expect(
        failure.message,
        "You don't have permission to perform this action.",
      );
      expect(failure.code, 'permission-denied');
    });

    test('notFound creates correct failure', () {
      final failure = FirestoreFailure.notFound();

      expect(failure.message, 'Requested document not found.');
      expect(failure.code, 'not-found');
    });

    test('unavailable creates correct failure', () {
      final failure = FirestoreFailure.unavailable();

      expect(
        failure.message,
        'Service is currently unavailable. Try again later.',
      );
      expect(failure.code, 'unavailable');
    });

    test('failures are comparable', () {
      final failure1 = FirestoreFailure.notFound();
      final failure2 = FirestoreFailure.notFound();

      expect(failure1, equals(failure2));
    });
  });
}
