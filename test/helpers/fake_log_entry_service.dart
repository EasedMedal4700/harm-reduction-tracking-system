import 'package:mobile_drug_use_app/features/log_entry/log_entry_service.dart';
import 'package:mobile_drug_use_app/features/log_entry/models/log_entry_model.dart';

class FakeLogEntryService implements LogEntryService {
  final List<LogEntry> _entries = [];

  @override
  Future<void> updateLogEntry(String id, Map<String, dynamic> data) async {
    // Simulate update
  }

  @override
  Future<void> deleteLogEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
  }

  Future<void> createLogEntry(Map<String, dynamic> data) async {
    // Simulate create
    _entries.add(
      LogEntry(
        id: 'test-id-${_entries.length}',
        substance: data['substance'] ?? 'Unknown',
        dosage: double.tryParse(data['dosage']?.toString() ?? '0') ?? 0.0,
        unit: data['unit'] ?? 'mg',
        route: data['route'] ?? 'Oral',
        datetime: DateTime.now(),
        location: data['location'] ?? 'Home',
        feelings: [],
        secondaryFeelings: {},
        triggers: [],
        bodySignals: [],
        isMedicalPurpose: false,
        cravingIntensity: 0.0,
        timeDifferenceMinutes: 0,
      ),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecentEntriesRaw() async {
    if (_entries.isEmpty) {
      return [
        {
          'use_id': '1',
          'name': 'Dexedrine',
          'dose': '10 mg',
          'start_time': DateTime.now().toIso8601String(),
          'place': 'Home',
        },
      ];
    }
    return _entries
        .map(
          (e) => {
            'use_id': e.id,
            'name': e.substance,
            'dose': '${e.dosage} ${e.unit}',
            'start_time': e.datetime.toIso8601String(),
            'place': e.location,
          },
        )
        .toList();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
