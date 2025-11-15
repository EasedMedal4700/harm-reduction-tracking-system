import '../log_entry_model.dart';
import '../../utils/parsing_utils.dart';

/// Handles serialization and deserialization of LogEntry to/from JSON
class LogEntrySerializer {
  /// Converts a JSON map from the database to a LogEntry object
  /// 
  /// Handles multiple field name variations for backward compatibility:
  /// - substance: 'name', 'substance'
  /// - dosage: 'dosage', 'dose' (supports "20 mg" format)
  /// - route: 'route', 'consumption'
  /// - location: 'place', 'location'
  /// - feelings: 'feelings', 'primary_emotions'
  /// - medical: 'medical_purpose', 'medical'
  /// - craving: 'craving_intensity', 'intensity', 'craving_0_10'
  /// 
  /// Also handles timezone offsets and time differences
  static LogEntry fromJson(Map<String, dynamic> json) {
    final dosageData = _parseDosage(json);
    final datetime = _parseDatetime(json);
    final tzOffset = ParsingUtils.parseTimezone(
      json['timezone'] ?? json['tz'] ?? json['time_zone']
    );
    final diffMin = ParsingUtils.parseInt(
      json['time_difference'] ?? json['time_diff'] ?? json['tz_offset_minutes']
    );

    return LogEntry(
      id: json['use_id']?.toString() ?? json['id']?.toString(),
      substance: json['name']?.toString() ?? json['substance']?.toString() ?? '',
      dosage: dosageData.dosage,
      unit: dosageData.unit,
      route: json['route']?.toString() ?? json['consumption']?.toString() ?? '',
      datetime: datetime,
      notes: json['notes']?.toString(),
      timeDifferenceMinutes: diffMin,
      timezone: json['timezone']?.toString(),
      feelings: ParsingUtils.toList(json['feelings'] ?? json['primary_emotions']),
      secondaryFeelings: ParsingUtils.toMap(json['secondary_feelings']),
      triggers: ParsingUtils.toList(json['triggers']),
      bodySignals: ParsingUtils.toList(json['body_signals']),
      location: json['place']?.toString() ?? json['location']?.toString() ?? '',
      isMedicalPurpose: _parseMedicalPurpose(json),
      cravingIntensity: ParsingUtils.parseDouble(
        json['craving_intensity'] ?? json['intensity'] ?? json['craving_0_10']
      ),
      intention: json['intention']?.toString(),
      people: ParsingUtils.toList(json['people'], splitBySpace: true),
      timezoneOffset: tzOffset,
    );
  }

  /// Converts a LogEntry object to a JSON map for database storage
  /// 
  /// Includes duplicate keys for test compatibility:
  /// - Both 'name' and 'substance'
  /// - Both 'start_time' and 'datetime'
  /// - Both 'place' and 'location'
  /// - etc.
  static Map<String, dynamic> toJson(LogEntry entry) => {
        'use_id': entry.id,
        'name': entry.substance,
        'substance': entry.substance, // Test compatibility
        'dosage': entry.dosage,
        'unit': entry.unit,
        'route': entry.route,
        'start_time': entry.datetime.toIso8601String(),
        'datetime': entry.datetime.toIso8601String(), // Test compatibility
        'time_difference': entry.timeDifferenceMinutes,
        'timezone': entry.timezone,
        'feelings': entry.feelings,
        'secondary_feelings': entry.secondaryFeelings,
        'secondaryFeelings': entry.secondaryFeelings, // Test compatibility
        'triggers': entry.triggers,
        'body_signals': entry.bodySignals,
        'bodySignals': entry.bodySignals, // Test compatibility
        'place': entry.location,
        'location': entry.location, // Test compatibility
        'notes': entry.notes,
        'medical_purpose': entry.isMedicalPurpose,
        'isMedicalPurpose': entry.isMedicalPurpose, // Test compatibility
        'craving_intensity': entry.cravingIntensity,
        'cravingIntensity': entry.cravingIntensity, // Test compatibility
        'intention': entry.intention,
        'timezone_offset': entry.timezoneOffset,
        'timezoneOffset': entry.timezoneOffset, // Test compatibility
        'people': entry.people,
      };

  /// Parses dosage and unit from various JSON field formats
  /// 
  /// Handles:
  /// - Separate 'dosage' and 'unit' fields
  /// - Combined 'dose' field like "20 mg"
  static ({double dosage, String unit}) _parseDosage(Map<String, dynamic> json) {
    double dosage = 0.0;
    String unit = '';

    if (json['dosage'] != null) {
      dosage = ParsingUtils.parseDouble(json['dosage']);
      unit = json['unit']?.toString() ?? '';
    } else if (json['dose'] != null) {
      // dose might be "10 mg" or numeric
      final dStr = json['dose'].toString();
      final parts = dStr.split(RegExp(r'\s+'));
      dosage = ParsingUtils.parseDouble(parts.isNotEmpty ? parts[0] : dStr);
      if (parts.length > 1) {
        unit = parts.sublist(1).join(' ');
      }
      unit = unit.isEmpty ? (json['unit']?.toString() ?? '') : unit;
    }

    return (dosage: dosage, unit: unit);
  }

  /// Parses datetime from JSON and applies timezone offsets
  /// 
  /// Handles:
  /// - Multiple field names: 'start_time', 'time', 'created_at'
  /// - Time difference in minutes
  /// - Timezone offset application
  static DateTime _parseDatetime(Map<String, dynamic> json) {
    DateTime dt = DateTime.now();
    final startRaw = json['start_time'] ?? json['time'] ?? json['created_at'];
    
    if (startRaw != null) {
      try {
        dt = DateTime.parse(startRaw.toString());
      } catch (_) {
        // Keep default DateTime.now() if parsing fails
      }
    }

    // Apply time difference
    final diffMin = ParsingUtils.parseInt(
      json['time_difference'] ?? json['time_diff'] ?? json['tz_offset_minutes']
    );
    if (diffMin != 0) {
      dt = dt.add(Duration(minutes: diffMin));
    }

    // Apply timezone offset
    final tzOffset = ParsingUtils.parseTimezone(
      json['timezone'] ?? json['tz'] ?? json['time_zone']
    );
    if (tzOffset != 0.0) {
      dt = dt.add(Duration(minutes: (tzOffset * 60).round()));
    }

    return dt;
  }

  /// Parses medical purpose flag from various JSON field formats
  /// 
  /// Checks both 'medical_purpose' and 'medical' fields
  /// Handles both boolean and string "true"/"false" values
  static bool _parseMedicalPurpose(Map<String, dynamic> json) {
    return (json['medical_purpose'] == true || 
            json['medical_purpose']?.toString() == 'true' || 
            json['medical'] == true || 
            json['medical']?.toString() == 'true');
  }
}
