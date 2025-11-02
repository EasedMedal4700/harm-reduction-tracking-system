import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/log_entry_model.dart';
import '../constants/drug_categories.dart';

class AnalyticsService {
  final String userId;
  Map<String, String> substanceToCategory = {}; // Ensure this is added

  AnalyticsService(this.userId);

  Future<List<LogEntry>> fetchEntries() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('drug_use')
        .select('*')
        .eq('user_id', userId);
    final data = response as List<dynamic>;
    return data.map((json) {
      try {
        return LogEntry.fromJson(json);
      } catch (e) {
        print('Error parsing entry: $json, error: $e');
        return null;
      }
    }).where((entry) => entry != null).cast<LogEntry>().toList();
  }

  double calculateAvgPerWeek(List<LogEntry> entries) {
    if (entries.isEmpty) return 0.0;
    final dates = entries.map((e) => e.datetime).toList();
    dates.sort();
    final start = dates.first;
    final end = dates.last;
    final daysDiff = end.difference(start).inDays;
    final weeks = daysDiff > 0 ? daysDiff / 7.0 : 1.0;
    return entries.length / weeks;
  }

  // Updated to use the DB-fetched map
  Map<String, int> getCategoryCounts(List<LogEntry> entries) {
    final counts = <String, int>{};
    for (final entry in entries) {
      final category = substanceToCategory[entry.substance.toLowerCase()] ?? 'Placeholder'; // Use lowercase lookup
      counts[category] = (counts[category] ?? 0) + 1;
    }
    return counts;
  }

  MapEntry<String, int> getMostUsedCategory(Map<String, int> counts) {
    if (counts.isEmpty) return const MapEntry('None', 0);
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b);
  }

  void setSubstanceToCategory(Map<String, String> map) { // Add this method
    substanceToCategory = map;
  }
}