import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'package:mobile_drug_use_app/features/activity/models/activity_models.dart';
import 'package:mobile_drug_use_app/features/activity/activity_page.dart';
import 'package:mobile_drug_use_app/features/activity/providers/activity_providers.dart';
import 'package:mobile_drug_use_app/features/activity/services/activity_service.dart';
import 'package:mobile_drug_use_app/core/routes/app_router.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';

class FakeActivityService implements ActivityService {
  FakeActivityService(this._data);

  ActivityData _data;
  int fetchCount = 0;
  final deleted = <({ActivityItemType type, String id})>[];

  @override
  Future<ActivityData> fetchRecentActivity() async {
    fetchCount += 1;
    return _data;
  }

  @override
  Future<void> deleteActivityItem({
    required ActivityItemType type,
    required String id,
  }) async {
    deleted.add((type: type, id: id));
    _data = _data.copyWith(
      entries: _data.entries.where((e) => e.id != id).toList(growable: false),
      cravings: _data.cravings.where((e) => e.id != id).toList(growable: false),
      reflections: _data.reflections
          .where((e) => e.id != id)
          .toList(growable: false),
    );
  }
}

ActivityData _fixtureData() {
  final now = DateTime(2025, 1, 1, 12);
  return ActivityData(
    entries: [
      ActivityDrugUseEntry(
        id: 'u1',
        name: 'Test Substance',
        dose: '10 mg',
        place: 'Home',
        time: now,
        raw: const {'use_id': 'u1'},
      ),
    ],
    cravings: const [],
    reflections: const [],
  );
}

Widget _buildApp({required FakeActivityService fake}) {
  final navigatorKey = GlobalKey<NavigatorState>();
  final nav = NavigationService()..bind(navigatorKey);
  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutePaths.activity,
    routes: [
      GoRoute(
        path: AppRoutePaths.activity,
        builder: (context, state) => const ActivityPage(),
      ),
      GoRoute(
        path: AppRoutePaths.editDrugUse,
        builder: (context, state) =>
            const Scaffold(body: Text('Edit Drug Use')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      activityServiceProvider.overrideWithValue(fake),
      navigationProvider.overrideWithValue(nav),
    ],
    child: AppThemeProvider(
      theme: AppTheme.light(),
      child: MaterialApp.router(routerConfig: router),
    ),
  );
}

void main() {
  group('ActivityPage', () {
    testWidgets('renders entry and can refresh', (tester) async {
      final fake = FakeActivityService(_fixtureData());

      await tester.pumpWidget(_buildApp(fake: fake));
      await tester.pumpAndSettle();

      expect(find.text('Recent Activity'), findsOneWidget);
      expect(find.text('Test Substance'), findsOneWidget);
      expect(fake.fetchCount, 1);

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      expect(fake.fetchCount, 2);
    });

    testWidgets('delete flow removes entry and shows snackbar', (tester) async {
      final fake = FakeActivityService(_fixtureData());

      await tester.pumpWidget(_buildApp(fake: fake));
      await tester.pumpAndSettle();

      // Tap the card to open the detail sheet
      await tester.tap(find.text('Test Substance'));
      await tester.pumpAndSettle();

      // Tap delete, confirm
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Delete'),
        ),
      );
      await tester.pumpAndSettle();

      expect(fake.deleted, hasLength(1));
      expect(fake.deleted.single.type, ActivityItemType.drugUse);
      expect(fake.deleted.single.id, 'u1');

      expect(find.text('Deleted drug use entry'), findsOneWidget);
      expect(find.text('Test Substance'), findsNothing);
    });

    testWidgets('edit button navigates via GoRouter', (tester) async {
      final fake = FakeActivityService(_fixtureData());

      await tester.pumpWidget(_buildApp(fake: fake));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Substance'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit Entry'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Drug Use'), findsOneWidget);
    });
  });
}
