// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:wear_companion_app/main.dart';

void main() {
  testWidgets('Dashboard renders key copy', (tester) async {
    await tester.pumpWidget(const WearCompanionApp());

    expect(find.text('Vitals & Movement'), findsOneWidget);
    expect(find.text('Live metrics from your Galaxy Watch'), findsOneWidget);
  });
}
