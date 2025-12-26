import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/features/stockpile/widgets/day_usage_sheet.dart';
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/day_usage_models.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/day_usage_service.dart';
import '../../../helpers/test_app_wrapper.dart';

class _DummyDayUsageApi implements DayUsageApi {
  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String substanceName,
  }) async {
    return const <Map<String, dynamic>>[];
  }
}

class _OkDayUsageService extends DayUsageService {
  _OkDayUsageService() : super(api: _DummyDayUsageApi());

  @override
  Future<List<DayUsageEntry>> fetchForWeekday({
    required String substanceName,
    required int weekdayIndex,
  }) async {
    return [
      DayUsageEntry(
        startTime: DateTime(2025, 1, 1, 12),
        dose: '10 mg',
        route: 'oral',
        isMedical: false,
      ),
    ];
  }
}

class _ManyDayUsageService extends DayUsageService {
  _ManyDayUsageService() : super(api: _DummyDayUsageApi());

  @override
  Future<List<DayUsageEntry>> fetchForWeekday({
    required String substanceName,
    required int weekdayIndex,
  }) async {
    return List.generate(
      11,
      (i) => DayUsageEntry(
        startTime: DateTime(2025, 1, 1, 12, i),
        dose: 'dose $i',
        route: 'oral',
        isMedical: i == 0,
      ),
    );
  }
}

class _SingleDayUsageService extends DayUsageService {
  _SingleDayUsageService() : super(api: _DummyDayUsageApi());

  @override
  Future<List<DayUsageEntry>> fetchForWeekday({
    required String substanceName,
    required int weekdayIndex,
  }) async {
    return [
      DayUsageEntry(
        startTime: DateTime(2025, 1, 1, 12),
        dose: '1 mg',
        route: 'oral',
        isMedical: false,
      ),
    ];
  }
}

class _ThrowingDayUsageService extends DayUsageService {
  _ThrowingDayUsageService() : super(api: _DummyDayUsageApi());

  @override
  Future<List<DayUsageEntry>> fetchForWeekday({
    required String substanceName,
    required int weekdayIndex,
  }) async {
    throw StateError('nope');
  }
}

void main() {
  testWidgets('DayUsageSheet renders entries', (tester) async {
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        providerOverrides: [
          dayUsageServiceProvider.overrideWithValue(_OkDayUsageService()),
        ],
        child: const DayUsageSheet(
          substanceName: 'X',
          weekdayIndex: 1,
          dayName: 'Mon',
          accentColor: Colors.blue,
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('X'), findsOneWidget);
    expect(find.textContaining('Usage History'), findsOneWidget);
    expect(find.text('10 mg'), findsOneWidget);
  });

  testWidgets('DayUsageSheet shows SnackBar on error', (tester) async {
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        providerOverrides: [
          dayUsageServiceProvider.overrideWithValue(_ThrowingDayUsageService()),
        ],
        child: const DayUsageSheet(
          substanceName: 'X',
          weekdayIndex: 1,
          dayName: 'Mon',
          accentColor: Colors.blue,
        ),
      ),
    );

    // allow async + post frame callback
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Failed to load usage data'), findsOneWidget);
  });

  testWidgets('DayUsageSheet shows singular/plural correctly', (tester) async {
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        providerOverrides: [
          dayUsageServiceProvider.overrideWithValue(_SingleDayUsageService()),
        ],
        child: const DayUsageSheet(
          substanceName: 'X',
          weekdayIndex: 1,
          dayName: 'Mon',
          accentColor: Colors.blue,
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.textContaining('1 use'), findsOneWidget);
  });

  testWidgets('DayUsageSheet supports Show All when more than 10 entries', (
    tester,
  ) async {
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        providerOverrides: [
          dayUsageServiceProvider.overrideWithValue(_ManyDayUsageService()),
        ],
        child: const DayUsageSheet(
          substanceName: 'X',
          weekdayIndex: 1,
          dayName: 'Mon',
          accentColor: Colors.blue,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Initial view only shows first 10
    expect(find.text('dose 10'), findsNothing);
    expect(find.textContaining('Show All 11 Uses'), findsOneWidget);

    await tester.tap(find.textContaining('Show All 11 Uses'));
    await tester.pumpAndSettle();

    // medical icon should be shown for the first entry
    expect(find.byIcon(Icons.medical_services), findsWidgets);

    // 11th item may be offscreen; scroll to it
    await tester.scrollUntilVisible(
      find.text('dose 10'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('dose 10'), findsOneWidget);
  });

  testWidgets('DayUsageSheet covers dark-theme color branches', (tester) async {
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        themeMode: ThemeMode.dark,
        providerOverrides: [
          dayUsageServiceProvider.overrideWithValue(_ManyDayUsageService()),
        ],
        child: const DayUsageSheet(
          substanceName: 'X',
          weekdayIndex: 1,
          dayName: 'Mon',
          accentColor: Colors.blue,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Both of these exercise th.isDark branches in the widget.
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    expect(find.textContaining('Show All'), findsOneWidget);
  });
}
