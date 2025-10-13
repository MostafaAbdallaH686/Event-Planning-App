import 'package:event_planning_app/core/utils/function/app_width_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper widget to provide MediaQuery with fixed size
  Widget wrapWithMediaQuery({required Widget child, required Size size}) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  group('AppWidthHeight percentageOfWidth', () {
    testWidgets('calculates correct width percentage', (tester) async {
      const testNum = 100.0; // design units

      await tester.pumpWidget(wrapWithMediaQuery(
        size: const Size(375, 812),
        child: Builder(
          builder: (context) {
            final result = AppWidthHeight.percentageOfWidth(context, testNum);
            expect(result, closeTo(100, 0.01)); // 100 logical pixels
            return const SizedBox();
          },
        ),
      ));
    });

    testWidgets('calculates correct width for different screen size',
        (tester) async {
      const testNum = 100.0;

      await tester.pumpWidget(wrapWithMediaQuery(
        size: const Size(750, 1624), // double the design width and height
        child: Builder(
          builder: (context) {
            final result = AppWidthHeight.percentageOfWidth(context, testNum);
            expect(result, closeTo(200, 0.01)); // scaled up
            return const SizedBox();
          },
        ),
      ));
    });
  });
  testWidgets('handles zero value', (tester) async {
    await tester.pumpWidget(wrapWithMediaQuery(
      size: const Size(375, 812),
      child: Builder(
        builder: (context) {
          final result = AppWidthHeight.percentageOfWidth(context, 0);
          expect(result, closeTo(0, 0.01));
          return const SizedBox();
        },
      ),
    ));
  });

  testWidgets('handles very large screen', (tester) async {
    const testNum = 100.0;

    await tester.pumpWidget(wrapWithMediaQuery(
      size: const Size(2000, 3000), // Large screen
      child: Builder(
        builder: (context) {
          final result = AppWidthHeight.percentageOfWidth(context, testNum);
          final expected = (2000 / 375) * 100;
          expect(result, closeTo(expected, 0.01));
          return const SizedBox();
        },
      ),
    ));
  });
  testWidgets('throws assertion error for negative width value',
      (tester) async {
    await tester.pumpWidget(wrapWithMediaQuery(
      size: const Size(375, 812),
      child: Builder(
        builder: (context) {
          expect(
            () => AppWidthHeight.percentageOfWidth(context, -50),
            throwsA(isA<AssertionError>()),
          );
          return const SizedBox();
        },
      ),
    ));
  });
  testWidgets('handles fractional screen size', (tester) async {
    const testNum = 100.0;

    await tester.pumpWidget(wrapWithMediaQuery(
      size: const Size(400.5, 900.3),
      child: Builder(
        builder: (context) {
          final result = AppWidthHeight.percentageOfWidth(context, testNum);
          final expected = (400.5 / 375) * 100;
          expect(result, closeTo(expected, 0.01));
          return const SizedBox();
        },
      ),
    ));
  });
  testWidgets('handles very small screen', (tester) async {
    const testNum = 100.0;

    await tester.pumpWidget(wrapWithMediaQuery(
      size: const Size(100, 200), // Tiny screen
      child: Builder(
        builder: (context) {
          final result = AppWidthHeight.percentageOfWidth(context, testNum);
          final expected = (100 / 375) * 100;
          expect(result, closeTo(expected, 0.01));
          return const SizedBox();
        },
      ),
    ));
  });
  test('DesignWidthHeight constants are correct', () {
    expect(DesignWidthHeight.width, 375);
    expect(DesignWidthHeight.height, 812);
  });
  group('AppWidthHeight percentageOfHeight', () {
    testWidgets('calculates correct height percentage', (tester) async {
      const testNum = 100.0;

      await tester.pumpWidget(wrapWithMediaQuery(
        size: const Size(375, 812),
        child: Builder(
          builder: (context) {
            final result = AppWidthHeight.percentageOfHeight(context, testNum);
            expect(result, closeTo(100, 0.01));
            return const SizedBox();
          },
        ),
      ));
    });
    testWidgets('throws assertion error for negative height value',
        (tester) async {
      await tester.pumpWidget(wrapWithMediaQuery(
        size: const Size(375, 812),
        child: Builder(
          builder: (context) {
            expect(
              () => AppWidthHeight.percentageOfHeight(context, -100),
              throwsA(isA<AssertionError>()),
            );
            return const SizedBox();
          },
        ),
      ));
    });
    testWidgets('calculates correct height for different screen size',
        (tester) async {
      const testNum = 100.0;

      await tester.pumpWidget(wrapWithMediaQuery(
        size: const Size(750, 1624),
        child: Builder(
          builder: (context) {
            final result = AppWidthHeight.percentageOfHeight(context, testNum);
            expect(result, closeTo(200, 0.01));
            return const SizedBox();
          },
        ),
      ));
    });
  });

  group('DeviceWidthHeight percentageOfWidth', () {
    testWidgets('calculates correct scaled width', (tester) async {
      const testDesignNum = 100.0;

      await tester.pumpWidget(wrapWithMediaQuery(
        size: const Size(375, 812),
        child: Builder(
          builder: (context) {
            final result =
                AppWidthHeight.percentageOfWidth(context, testDesignNum);
            expect(result, closeTo(100, 0.01));
            return const SizedBox();
          },
        ),
      ));
    });

    testWidgets('calculates correct scaled width for larger screen',
        (tester) async {
      const testDesignNum = 100.0;

      await tester.pumpWidget(wrapWithMediaQuery(
        size: const Size(750, 1624),
        child: Builder(
          builder: (context) {
            final result =
                AppWidthHeight.percentageOfWidth(context, testDesignNum);
            expect(result, closeTo(200, 0.01));
            return const SizedBox();
          },
        ),
      ));
    });
  });

  group('DeviceWidthHeight percentageOfHeight', () {
    testWidgets('calculates correct scaled height', (tester) async {
      const testDesignNum = 100.0;

      await tester.pumpWidget(wrapWithMediaQuery(
        size: const Size(375, 812),
        child: Builder(
          builder: (context) {
            final result =
                AppWidthHeight.percentageOfHeight(context, testDesignNum);
            expect(result, closeTo(100, 0.01));
            return const SizedBox();
          },
        ),
      ));
    });

    testWidgets('calculates correct scaled height for larger screen',
        (tester) async {
      const testDesignNum = 100.0;

      await tester.pumpWidget(wrapWithMediaQuery(
        size: const Size(750, 1624),
        child: Builder(
          builder: (context) {
            final result =
                AppWidthHeight.percentageOfHeight(context, testDesignNum);
            expect(result, closeTo(200, 0.01));
            return const SizedBox();
          },
        ),
      ));
    });
  });
}
