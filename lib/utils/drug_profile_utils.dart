/// Utilities for parsing drug profile data
class DrugProfileUtils {
  /// Extract maximum duration from formatted_duration field
  /// 
  /// Handles formats like:
  /// - "4-6 hours"
  /// - "30-60 minutes"
  /// - Single values: "4 hours"
  static double extractMaxDuration(dynamic formattedDuration) {
    if (formattedDuration == null) return 8.0; // Default 8 hours
    
    try {
      if (formattedDuration is num) {
        return formattedDuration.toDouble();
      }
      
      if (formattedDuration is String) {
        return _parseMaxFromString(formattedDuration, defaultHours: 8.0);
      }
      
      // Handle map format (e.g., {"Oral": "4-6 hours", "_unit": "hours"})
      if (formattedDuration is Map) {
        final data = formattedDuration as Map<String, dynamic>;
        
        // Try common routes in order of preference
        const routes = ['Oral', 'Insufflated', 'IV', 'IM', 'Rectal', 'value'];
        for (final route in routes) {
          if (data.containsKey(route)) {
            final value = data[route];
            if (value is num) return value.toDouble();
            if (value is String) {
              return _parseMaxFromString(value, defaultHours: 8.0);
            }
          }
        }
      }
      
      return 8.0;
    } catch (e) {
      return 8.0;
    }
  }
  
  /// Extract maximum aftereffects duration
  static double extractMaxAftereffects(dynamic formattedAftereffects) {
    if (formattedAftereffects == null) return 2.0; // Default 2 hours
    
    try {
      if (formattedAftereffects is num) {
        return formattedAftereffects.toDouble();
      }
      
      if (formattedAftereffects is String) {
        return _parseMaxFromString(formattedAftereffects, defaultHours: 2.0);
      }
      
      if (formattedAftereffects is Map) {
        final data = formattedAftereffects as Map<String, dynamic>;
        
        const routes = ['Oral', 'Insufflated', 'IV', 'IM', 'Rectal', 'value'];
        for (final route in routes) {
          if (data.containsKey(route)) {
            final value = data[route];
            if (value is num) return value.toDouble();
            if (value is String) {
              return _parseMaxFromString(value, defaultHours: 2.0);
            }
          }
        }
      }
      
      return 2.0;
    } catch (e) {
      return 2.0;
    }
  }
  
  /// Parse max value from string like "4-6 hours" or "30-60 minutes"
  static double _parseMaxFromString(String str, {required double defaultHours}) {
    final cleaned = str.toLowerCase().trim();
    
    // Check if it contains time units
    final isMinutes = cleaned.contains('min');
    final isHours = cleaned.contains('hour') || cleaned.contains('hr');
    
    // Extract numbers using regex
    final numbers = RegExp(r'(\d+(?:\.\d+)?)')
        .allMatches(cleaned)
        .map((m) => double.tryParse(m.group(0) ?? '') ?? 0.0)
        .where((n) => n > 0)
        .toList();
    
    if (numbers.isEmpty) return defaultHours;
    
    // Take the maximum value from range
    final maxValue = numbers.reduce((a, b) => a > b ? a : b);
    
    // Convert to hours
    if (isMinutes) {
      return maxValue / 60.0;
    } else if (isHours) {
      return maxValue;
    } else {
      // Assume hours if no unit specified
      return maxValue;
    }
  }
  
  /// Get dosage thresholds for normalization
  /// Returns [threshold, light, common, strong, heavy] in mg
  /// The "strong" value (index 3) is used as 100% baseline for intensity
  static List<double>? getDosageThresholds(Map<String, dynamic>? drugProfile) {
    if (drugProfile == null) return null;
    
    final formattedDose = drugProfile['formatted_dose'] as Map<String, dynamic>?;
    if (formattedDose == null) return null;
    
    // Try different administration routes (Oral preferred)
    final routePreference = [
      'Oral',
      'Insufflated',
      'Rectal',
      'IM',
      'IV',
      'value',
    ];
    
    for (final route in routePreference) {
      if (formattedDose.containsKey(route)) {
        final routeData = formattedDose[route];
        if (routeData is! Map<String, dynamic>) continue;
        
        // Extract threshold values
        final threshold = _parseDoseValue(routeData['threshold']);
        final light = _parseDoseValue(routeData['light']);
        final common = _parseDoseValue(routeData['common']);
        final strong = _parseDoseValue(routeData['strong']);
        final heavy = _parseDoseValue(routeData['heavy']);
        
        if (strong != null && strong > 0) {
          return [
            threshold ?? 0.0,
            light ?? 0.0,
            common ?? 0.0,
            strong,
            heavy ?? (strong * 1.5),
          ];
        }
      }
    }
    
    return null;
  }
  
  /// Parse dose value from various formats (e.g., "10 mg", "5-10 mg", "10")
  static double? _parseDoseValue(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    
    final valueStr = value.toString();
    final doseRegExp = RegExp(r'(\d+(?:\.\d+)?)');
    final match = doseRegExp.firstMatch(valueStr);
    return match != null ? double.tryParse(match.group(1)!) : null;
  }
  
  /// Fallback thresholds for common drugs when profile data unavailable
  static List<double>? getFallbackThresholds(String drugName) {
    const knownThresholds = <String, List<double>>{
      'methylphenidate': [5.0, 10.0, 20.0, 40.0, 60.0],
      'amphetamine': [5.0, 10.0, 20.0, 30.0, 50.0],
      'cocaine': [10.0, 20.0, 40.0, 80.0, 120.0],
      'mdma': [50.0, 75.0, 100.0, 150.0, 200.0],
      'lsd': [0.02, 0.05, 0.1, 0.15, 0.25], // 20-250µg
      'psilocybin': [1.0, 2.0, 3.0, 5.0, 7.0],
      'cannabis': [2.5, 5.0, 10.0, 20.0, 30.0], // THC
      'thc': [2.5, 5.0, 10.0, 20.0, 30.0],
      'alcohol': [5000.0, 10000.0, 15000.0, 20000.0, 30000.0], // ethanol
      'caffeine': [50.0, 100.0, 200.0, 400.0, 600.0],
      'nicotine': [0.5, 1.0, 2.0, 4.0, 6.0],
      'ketamine': [10.0, 30.0, 75.0, 150.0, 250.0],
      'dxm': [100.0, 200.0, 400.0, 700.0, 1000.0],
      'bromazolam': [0.5, 1.0, 2.0, 4.0, 6.0],
      '2-fdck': [10.0, 30.0, 75.0, 150.0, 250.0],
    };
    
    return knownThresholds[drugName.toLowerCase()];
  }
}
