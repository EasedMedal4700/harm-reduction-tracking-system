/// Utility class for calculating drug usage statistics
class DrugStatsCalculator {
  /// Calculate average dose from list of drug use entries
  static double calculateAverageDose(List<Map<String, dynamic>> entries) {
    final doseRegex = RegExp(r'([0-9]+(?:\.[0-9]+)?)');
    final doses = <double>[];
    
    for (final entry in entries) {
      final match = doseRegex.firstMatch(entry['dose']?.toString() ?? '');
      if (match != null) {
        final value = double.tryParse(match.group(1) ?? '');
        if (value != null) {
          doses.add(value);
        }
      }
    }
    
    if (doses.isEmpty) return 0;
    final total = doses.reduce((a, b) => a + b);
    return total / doses.length;
  }

  /// Find the most recent usage date from entries
  static DateTime? findLatestUsage(List<Map<String, dynamic>> entries) {
    DateTime? latest;
    
    for (final entry in entries) {
      final raw = entry['start_time']?.toString();
      if (raw == null) continue;
      
      final parsed = DateTime.tryParse(raw);
      if (parsed == null) continue;
      
      if (latest == null || parsed.isAfter(latest)) {
        latest = parsed;
      }
    }
    
    return latest;
  }

  /// Calculate weekday usage statistics
  /// Returns a map with 'counts', 'mostActive', and 'leastActive'
  static Map<String, dynamic> calculateWeekdayUsage(
    List<Map<String, dynamic>> entries,
  ) {
    final counts = List<int>.filled(7, 0);
    
    for (final entry in entries) {
      final raw = entry['start_time']?.toString();
      if (raw == null) continue;
      
      final parsed = DateTime.tryParse(raw);
      if (parsed == null) continue;
      
      counts[parsed.weekday % 7] += 1;
    }
    
    int most = 0;
    int least = 0;
    for (var i = 0; i < counts.length; i++) {
      if (counts[i] > counts[most]) most = i;
      if (counts[i] < counts[least]) least = i;
    }
    
    return {
      'counts': counts,
      'mostActive': most,
      'leastActive': least,
    };
  }
}
