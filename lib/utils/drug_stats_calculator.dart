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
  /// For non-medical use, day ends at 5am (e.g., 4am Sunday counts as Saturday)
  /// For medical use, day ends at midnight (24:00)
  static Map<String, dynamic> calculateWeekdayUsage(
    List<Map<String, dynamic>> entries,
  ) {
    final counts = List<int>.filled(7, 0);
    
    for (final entry in entries) {
      final raw = entry['start_time']?.toString();
      if (raw == null) continue;
      
      final parsed = DateTime.tryParse(raw);
      if (parsed == null) continue;
      
      // Check if this is medical use
      final isMedical = entry['is_medical_purpose'] == true ||
                        entry['is_medical_purpose'] == 1 ||
                        entry['isMedicalPurpose'] == true ||
                        entry['isMedicalPurpose'] == 1;
      
      DateTime adjustedTime = parsed;
      
      // For non-medical use, shift the day cutoff to 5am
      // If time is before 5am, count it as the previous day
      if (!isMedical && parsed.hour < 5) {
        adjustedTime = parsed.subtract(const Duration(hours: 5));
      }
      
      counts[adjustedTime.weekday % 7] += 1;
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
