import 'package:event_planning_app/core/utils/function/app_snak_bar.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(builder: (ctx) => child),
      ),
    );
  }

  group('AppSnackBar.showSnackBar', () {
    testWidgets('displays default snack with title & message',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestable(
        ElevatedButton(
          child: const Text('Show'),
          onPressed: () {
            AppSnackBar.showSnackBar(
              tester.element(find.byType(ElevatedButton)),
              title: 'Error!',
              message: 'Something went wrong',
            );
          },
        ),
      ));

      // Tap button to show snack
      await tester.tap(find.text('Show'));
      await tester.pump(); // start animation
      // Let snack appear
      await tester.pump(const Duration(milliseconds: 500));

      // Verify SnackBar content
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Error!'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);

      // Verify styling
      final snack = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snack.backgroundColor, AppColor.scaffoldBackground);
    });
  });

  group('AppSnackBar.showCustomSnackBar', () {
    testWidgets('displays floating snack with custom style',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestable(
        ElevatedButton(
          child: const Text('ShowCustom'),
          onPressed: () {
            AppSnackBar.showCustomSnackBar(
              tester.element(find.byType(ElevatedButton)),
              title: 'Hello',
              message: 'Custom bar',
            );
          },
        ),
      ));

      await tester.tap(find.text('ShowCustom'));
      await tester.pump(); // start animation
      // Let snack appear
      await tester.pump(const Duration(milliseconds: 500));

      // Verify SnackBar content
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Custom bar'), findsOneWidget);

      // Verify custom behavior and style
      final snack = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snack.behavior, SnackBarBehavior.floating);
      expect(snack.backgroundColor, AppColor.scaffoldBackground);
      expect(snack.duration, const Duration(seconds: 2));
    });
  });
}
