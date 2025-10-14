import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/core/utils/services/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  late MockToastService mockService;
  final getIt = GetIt.instance;

  setUp(() {
    // Register mock service
    mockService = MockToastService();
    getIt.registerSingleton<ToastService>(mockService);
  });

  tearDown(() {
    getIt.reset();
  });

  group('AppToast', () {
    test('show() calls service with correct parameters', () {
      AppToast.show(
        message: 'Test message',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
      );

      expect(mockService.calls.length, 1);
      final call = mockService.lastCall!;
      expect(call.message, 'Test message');
      expect(call.gravity, ToastGravity.BOTTOM);
      expect(call.backgroundColor, Colors.blue);
    });

    test('success() shows green toast', () {
      AppToast.success('Operation successful');

      expect(
          mockService.wasShownWith(
            message: 'Operation successful',
            backgroundColor: Colors.green,
          ),
          isTrue);
    });

    test('error() shows red toast', () {
      AppToast.error('Something went wrong');

      expect(
          mockService.wasShownWith(
            message: 'Something went wrong',
            backgroundColor: Colors.red,
          ),
          isTrue);
    });

    test('warning() shows orange toast', () {
      AppToast.warning('Please be careful');

      expect(
          mockService.wasShownWith(
            message: 'Please be careful',
            backgroundColor: Colors.orange,
          ),
          isTrue);
    });

    test('info() shows blue toast', () {
      AppToast.info('For your information');

      expect(
          mockService.wasShownWith(
            message: 'For your information',
            backgroundColor: Colors.blue,
          ),
          isTrue);
    });

    test('cancel() calls service cancel', () {
      AppToast.cancel();

      expect(mockService.cancelCallCount, 1);
    });

    test('multiple toasts are tracked', () {
      AppToast.success('First');
      AppToast.error('Second');
      AppToast.info('Third');

      expect(mockService.calls.length, 3);
      expect(mockService.calls[0].message, 'First');
      expect(mockService.calls[1].message, 'Second');
      expect(mockService.calls[2].message, 'Third');
    });
  });
}
