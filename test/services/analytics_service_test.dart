import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/constants/enums/time_period.dart';
import 'package:mobile_drug_use_app/models/log_entry_model.dart';
import 'package:mobile_drug_use_app/services/analytics_service.dart';

void main() {
  LogEntry buildEntry({
    String substance = 'Cannabis',
    bool isMedical = false,
    DateTime? dateTime,
    String location = 'Home',
    String route = 'oral',
    List<String> feelings = const ['Calm'],
    double craving = 5,
  }) {
    return LogEntry(
      substance: substance,
      dosage: 1,
      unit: 'mg',
      route: route,
      feelings: feelings,
      secondaryFeelings: const {},
      datetime: dateTime ?? DateTime.now(),
      location: location,
      notes: '',
      timezoneOffset: 0,
      isMedicalPurpose: isMedical,
      cravingIntensity: craving,
      intention: 'Relax',
      triggers: const [],
      bodySignals: const [],
      people: const [],
    );
  }

  group('AnalyticsService helpers', () {
    late AnalyticsService service;

    setUp(() {
      service = AnalyticsService();
      service.setSubstanceToCategory({
        'cannabis': 'Depressant',
        'mdma': 'Empathogen',
      });
    });

    test('calculateAvgPerWeek derives rate across time span', () {
      final entries = [
        buildEntry(dateTime: DateTime(2025, 1, 1)),
        buildEntry(dateTime: DateTime(2025, 1, 8)),
        buildEntry(dateTime: DateTime(2025, 1, 15)),
      ];

      final avg = service.calculateAvgPerWeek(entries);

      expect(avg, closeTo(1.5, 0.0001));
    });

    test('filterEntriesByPeriod filters relative to now', () {
      final now = DateTime.now();
      final entries = [
        buildEntry(substance: 'Recent', dateTime: now.subtract(const Duration(days: 3))),
        buildEntry(substance: 'Old', dateTime: now.subtract(const Duration(days: 20))),
      ];

      final filtered = service.filterEntriesByPeriod(entries, TimePeriod.last7Days);

      expect(filtered.length, 1);
      expect(filtered.first.substance, 'Recent');
    });

    test('getCategoryCounts groups using substanceToCategory map', () {
      final entries = [
        buildEntry(substance: 'Cannabis'),
        buildEntry(substance: 'MDMA'),
        buildEntry(substance: 'Unknown'),
      ];

      final counts = service.getCategoryCounts(entries);

      expect(counts['Depressant'], 1);
      expect(counts['Empathogen'], 1);
      expect(counts['Placeholder'], 1);
    });

    test('getMostUsedCategory returns highest count', () {
      final counts = {'A': 2, 'B': 5, 'C': 1};

      final result = service.getMostUsedCategory(counts);

      expect(result.key, 'B');
      expect(result.value, 5);
    });

    test('getSubstanceCounts tallies per substance', () {
      final entries = [
        buildEntry(substance: 'Cannabis'),
        buildEntry(substance: 'MDMA'),
        buildEntry(substance: 'Cannabis'),
      ];

      final counts = service.getSubstanceCounts(entries);

      expect(counts['Cannabis'], 2);
      expect(counts['MDMA'], 1);
    });

    test('getMostUsedSubstance returns most frequent entry', () {
      final counts = {'Cannabis': 3, 'MDMA': 1};

      final result = service.getMostUsedSubstance(counts);

      expect(result.key, 'Cannabis');
      expect(result.value, 3);
    });

    test('getTopCategoryPercent converts to integer percent', () {
      expect(service.getTopCategoryPercent(3, 4), 75);
      expect(service.getTopCategoryPercent(0, 0), 0);
    });
  });
}
