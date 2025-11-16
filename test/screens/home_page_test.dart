import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/screens/home_page.dart';
import '../helpers/fake_daily_checkin_repository.dart';

class _TestNavigatorObserver extends NavigatorObserver {
  int pushCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushCount++;
    super.didPush(route, previousRoute);
  }
}

void main() {
  Widget buildHome({NavigatorObserver? observer}) {
    final fakeRepository = FakeDailyCheckinRepository();
    return MaterialApp(
      home: HomePage(dailyCheckinRepository: fakeRepository),
      navigatorObservers:
          observer == null ? const <NavigatorObserver>[] : <NavigatorObserver>[observer],
    );
  }

  testWidgets('renders every quick action button', (tester) async {
    await tester.pumpWidget(buildHome());

    const labels = [
      'Log Entry',
      'Reflection',
      'Analytics',
      'Cravings',
      'Activity',
      'Library',
      'Catalog',
      'Blood Levels',
    ];

    for (final label in labels) {
      expect(find.text(label), findsOneWidget, reason: 'Missing quick action $label');
    }
  });

  testWidgets('floating action button triggers navigation push', (tester) async {
    final observer = _TestNavigatorObserver();
    await tester.pumpWidget(buildHome(observer: observer));
    final initialPushes = observer.pushCount;

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(observer.pushCount, initialPushes + 1);
  });
}
