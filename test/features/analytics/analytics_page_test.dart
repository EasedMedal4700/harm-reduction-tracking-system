import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_drug_use_app/features/analytics/analytics_page.dart';
import 'package:mobile_drug_use_app/features/analytics/providers/analytics_providers.dart';
import 'package:mobile_drug_use_app/features/analytics/services/analytics_service.dart';
import 'package:mobile_drug_use_app/features/log_entry/models/log_entry_model.dart';
import 'package:mobile_drug_use_app/features/stockpile/repo/substance_repository.dart';

import '../../helpers/test_app_wrapper.dart';

class _FakeAnalyticsService extends AnalyticsService {
  _FakeAnalyticsService({required this.entries, this.throwOnFetch = false});

  final List<LogEntry> entries;
  final bool throwOnFetch;

  @override
  Future<List<LogEntry>> fetchEntries() async {
    if (throwOnFetch) throw Exception('fetchEntries failed');
    return entries;
  }
}

class _FakeSubstanceRepository extends SubstanceRepository {
  _FakeSubstanceRepository(this.catalog);

  final List<Map<String, dynamic>> catalog;

  @override
  Future<List<Map<String, dynamic>>> fetchSubstancesCatalog() async => catalog;
}

LogEntry _entry({required String substance, required DateTime datetime}) {
  return LogEntry(
    substance: substance,
    dosage: 1,
    unit: 'mg',
    route: 'Oral',
    datetime: datetime,
    location: 'Home',
    cravingIntensity: 0,
  );
}

void main() {
  testWidgets('renders error state when refresh fails', (tester) async {
    final fakeService = _FakeAnalyticsService(
      entries: const [],
      throwOnFetch: true,
    );
    final fakeRepo = _FakeSubstanceRepository(const []);

    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: const AnalyticsPage(),
        providerOverrides: [
          analyticsServiceProvider.overrideWithValue(fakeService),
          substanceRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('renders main analytics layout on success', (tester) async {
    final fakeService = _FakeAnalyticsService(
      entries: [
        _entry(substance: 'Caffeine', datetime: DateTime(2025, 1, 10)),
        _entry(substance: 'THC', datetime: DateTime(2025, 1, 11)),
      ],
    );
    final fakeRepo = _FakeSubstanceRepository([
      {
        'name': 'Caffeine',
        'categories': ['Stimulant'],
      },
      {
        'name': 'THC',
        'categories': ['Cannabinoid'],
      },
    ]);

    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: const AnalyticsPage(),
        providerOverrides: [
          analyticsServiceProvider.overrideWithValue(fakeService),
          substanceRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Use distribution'), findsOneWidget);
    expect(find.text('Insight Summary'), findsOneWidget);
  });
}
