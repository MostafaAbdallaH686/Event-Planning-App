import 'package:event_planning_app/core/utils/function/app_delay.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppDelay', () {
    group('delayLoading', () {
      test('waits for EXACTLY 700 milliseconds', () {
        FakeAsync().run((fakeAsync) {
          // Arrange: Track if the delay completed
          bool delayCompleted = false;

          //  Act: Start the delay and mark completion when done
          AppDelay.delayLoading().then((_) => delayCompleted = true);

          //  Assert 1: Before 700ms → NOT completed
          fakeAsync.elapse(const Duration(milliseconds: 699));
          expect(delayCompleted, isFalse,
              reason: 'Delay finished early (before 700ms)');

          //  Assert 2: After 700ms → COMPLETED
          fakeAsync.elapse(const Duration(milliseconds: 1)); // Total: 700ms
          expect(delayCompleted, isTrue,
              reason: 'Delay did not finish after 700ms');
        });
      });

      test('returns a Future<void> (type safety check)', () {
        //  Act: Get the return value
        final future = AppDelay.delayLoading();

        //  Assert: It’s a Future<void>
        expect(future, isA<Future<void>>());
      });
    });
  });
}
