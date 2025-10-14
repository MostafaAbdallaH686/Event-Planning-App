import 'package:event_planning_app/core/utils/services/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  group('MockToastService', () {
    late MockToastService service;

    setUp(() {
      service = MockToastService();
    });

    test('tracks show() calls', () {
      service.show(message: 'Test message');

      expect(service.calls.length, 1);
      expect(service.calls.first.message, 'Test message');
    });

    test('tracks multiple show() calls', () {
      service.show(message: 'First');
      service.show(message: 'Second');
      service.show(message: 'Third');

      expect(service.calls.length, 3);
      expect(service.calls[0].message, 'First');
      expect(service.calls[1].message, 'Second');
      expect(service.calls[2].message, 'Third');
    });

    test('stores last call', () {
      service.show(message: 'First');
      service.show(message: 'Last');

      expect(service.lastCall?.message, 'Last');
    });

    test('tracks cancel() calls', () {
      service.cancel();
      service.cancel();

      expect(service.cancelCallCount, 2);
    });

    test('reset() clears all data', () {
      service.show(message: 'Test');
      service.cancel();

      service.reset();

      expect(service.calls, isEmpty);
      expect(service.cancelCallCount, 0);
      expect(service.lastCall, isNull);
    });

    test('wasShownWith() checks message', () {
      service.show(message: 'Success!');

      expect(service.wasShownWith(message: 'Success!'), isTrue);
      expect(service.wasShownWith(message: 'Error!'), isFalse);
    });

    test('wasShownWith() checks gravity', () {
      service.show(
        message: 'Test',
        gravity: ToastGravity.BOTTOM,
      );

      expect(service.wasShownWith(gravity: ToastGravity.BOTTOM), isTrue);
      expect(service.wasShownWith(gravity: ToastGravity.TOP), isFalse);
    });

    test('wasShownWith() checks backgroundColor', () {
      service.show(
        message: 'Test',
        backgroundColor: Colors.red,
      );

      expect(service.wasShownWith(backgroundColor: Colors.red), isTrue);
      expect(service.wasShownWith(backgroundColor: Colors.blue), isFalse);
    });

    test('wasShownWith() checks multiple conditions', () {
      service.show(
        message: 'Error',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
      );

      expect(
        service.wasShownWith(
          message: 'Error',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
        ),
        isTrue,
      );

      expect(
        service.wasShownWith(
          message: 'Error',
          gravity: ToastGravity.TOP,
        ),
        isFalse,
      );
    });

    test('stores custom parameters', () {
      service.show(
        message: 'Custom',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 18.0,
        timeInSecForIosWeb: 3,
      );

      final call = service.lastCall!;
      expect(call.message, 'Custom');
      expect(call.gravity, ToastGravity.BOTTOM);
      expect(call.backgroundColor, Colors.green);
      expect(call.textColor, Colors.black);
      expect(call.fontSize, 18.0);
      expect(call.timeInSecForIosWeb, 3);
    });
  });
}
