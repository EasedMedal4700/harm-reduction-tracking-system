import 'package:mobile_drug_use_app/features/analytics/services/analytics_service.dart';
import 'package:mobile_drug_use_app/models/log_entry_model.dart';
import 'package:mobile_drug_use_app/constants/enums/time_period.dart';

class FakeAnalyticsService implements AnalyticsService {
  @override
  Future<List<LogEntry>> fetchEntries() async {
    return [
      LogEntry(
        id: '1',
        substance: 'Dexedrine',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        datetime: DateTime.now(),
        location: 'Home',
        feelings: [],
        secondaryFeelings: {},
        triggers: [],
        bodySignals: [],
        isMedicalPurpose: false,
        cravingIntensity: 0.0,
        timeDifferenceMinutes: 0,
      ),
    ];
  }

  @override
  List<LogEntry> filterEntriesByPeriod(
    List<LogEntry> entries,
    TimePeriod period,
  ) {
    return entries;
  }

  @override
  Map<String, String> get substanceToCategory => {};

  @override
  void setSubstanceToCategory(Map<String, String> map) {
    // No-op
  }

  @override
  double calculateAvgPerWeek(List<LogEntry> entries) {
    return 1.0;
  }

  @override
  Map<String, int> getCategoryCounts(List<LogEntry> entries) {
    return {'Stimulants': 5, 'Depressants': 3};
  }

  @override
  MapEntry<String, int> getMostUsedCategory(Map<String, int> categoryCounts) {
    return const MapEntry('Stimulants', 5);
  }

  @override
  Map<String, int> getSubstanceCounts(List<LogEntry> entries) {
    return {'Dexedrine': 5};
  }

  @override
  MapEntry<String, int> getMostUsedSubstance(Map<String, int> substanceCounts) {
    return const MapEntry('Dexedrine', 5);
  }

  @override
  int getTopCategoryPercent(int topCount, int totalCount) {
    return 50;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
