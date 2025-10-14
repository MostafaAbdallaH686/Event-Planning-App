import 'package:event_planning_app/core/utils/function/app_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSvgImage', () {
    testWidgets('renders an SvgPicture with correct path, size and fit',
        (WidgetTester tester) async {
      // arrange
      const testPath = 'assets/icons/test.svg';

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSvgImage.showSvgImage(
              path: testPath,
              width: 50,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      // assert
      final svgFinder = find.byType(SvgPicture);
      expect(svgFinder, findsOneWidget);

      final SvgPicture svgWidget = tester.widget<SvgPicture>(svgFinder);

      expect(svgWidget.width, 50);
      expect(svgWidget.height, 60);
      expect(svgWidget.fit, BoxFit.cover);
    });
  });
}
