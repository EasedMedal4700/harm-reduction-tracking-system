class LogEntry {
  final String? id; // use_id or id
  final String substance;
  final double dosage;
  final String unit;
  final String route;
  final DateTime datetime;
  final String? notes;
  final int timeDifferenceMinutes;
  final String? timezone; // raw tz value if present
  final List<String> feelings;
  final Map<String, List<String>> secondaryFeelings;
  final List<String> triggers;
  final List<String> bodySignals;
  final String location;
  final bool isMedicalPurpose;
  final double cravingIntensity;
  final String? intention;
  final double timezoneOffset; // parsed offset (e.g., hours)
  final List<String> people;

  LogEntry({
    this.id,
    required this.substance,
    required this.dosage,
    required this.unit,
    required this.route,
    required this.datetime,
    this.notes,
    this.timeDifferenceMinutes = 0,
    this.timezone,
    this.feelings = const [],
    this.secondaryFeelings = const {},
    this.triggers = const [],
    this.bodySignals = const [],
    this.location = '',
    this.isMedicalPurpose = false,
    this.cravingIntensity = 0.0,
    this.intention,
    this.timezoneOffset = 0.0,
    this.people = const [],
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    double _parseDouble(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0.0;
    int _parseInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;
    List<String> _toList(dynamic v, {bool splitBySpace = false}) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      if (v is String && v.isNotEmpty) {
        try {
          // For people field, split by space; for others, use comma or semicolon
          if (splitBySpace) {
            return v.split(RegExp(r'\s+')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
          }
          // try comma or semicolon separated
          return v.split(RegExp(r'[;,]')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        } catch (_) {}
      }
      return [];
    }
    Map<String, List<String>> _toMap(dynamic v) {
      if (v == null) return {};
      if (v is Map) {
        return v.map((k, val) => MapEntry(k.toString(), (val is List) ? val.map((e) => e.toString()).toList() : [val.toString()]));
      }
      // fallback: treat as single-key list if string/list
      final list = _toList(v);
      return list.isEmpty ? {} : {'default': list};
    }
    double _parseTimezone(dynamic v) {
      if (v == null) return 0.0;
      final str = v.toString();
      final match = RegExp(r'([+-])(\d{1,2}):?(\d{2})').firstMatch(str);
      if (match != null) {
        final sign = match.group(1) == '-' ? -1 : 1;
        final hours = int.parse(match.group(2)!);
        final minutes = int.parse(match.group(3)!);
        return sign * (hours + minutes / 60.0);
      }
      return double.tryParse(str) ?? 0.0;
    }

    // flexible dose parsing
    double dosage = 0.0;
    String unit = '';
    if (json['dosage'] != null) {
      dosage = _parseDouble(json['dosage']);
      unit = json['unit']?.toString() ?? unit;
    } else if (json['dose'] != null) {
      // dose might be "10 mg" or numeric
      final d = json['dose'];
      final dStr = d.toString();
      final parts = dStr.split(RegExp(r'\s+'));
      dosage = _parseDouble(parts.isNotEmpty ? parts[0] : dStr);
      if (parts.length > 1) unit = parts.sublist(1).join(' ');
      unit = unit.isEmpty ? (json['unit']?.toString() ?? '') : unit;
    }

    // parse datetime and apply offsets
    DateTime dt = DateTime.now();
    final startRaw = json['start_time'] ?? json['time'] ?? json['created_at'];
    if (startRaw != null) {
      try {
        dt = DateTime.parse(startRaw.toString());
      } catch (_) {}
    }
    final diffMin = _parseInt(json['time_difference'] ?? json['time_diff'] ?? json['tz_offset_minutes']);
    if (diffMin != 0) dt = dt.add(Duration(minutes: diffMin));

    final tzOffset = _parseTimezone(json['timezone'] ?? json['tz'] ?? json['time_zone']);
    if (tzOffset != 0.0) dt = dt.add(Duration(minutes: (tzOffset * 60).round()));

    return LogEntry(
      id: json['use_id']?.toString() ?? json['id']?.toString(),
      substance: json['name']?.toString() ?? json['substance']?.toString() ?? '',
      dosage: dosage,
      unit: unit,
      route: json['route']?.toString() ?? json['consumption']?.toString() ?? '',
      datetime: dt,
      notes: json['notes']?.toString(),
      timeDifferenceMinutes: diffMin,
      timezone: json['timezone']?.toString(), // Ensure .toString()
      feelings: _toList(json['feelings'] ?? json['primary_emotions']),
      secondaryFeelings: _toMap(json['secondary_feelings']),
      triggers: _toList(json['triggers']),
      bodySignals: _toList(json['body_signals']),
      location: json['place']?.toString() ?? json['location']?.toString() ?? '',
      isMedicalPurpose: (json['medical_purpose'] == true || json['medical_purpose']?.toString() == 'true' || json['medical'] == true || json['medical']?.toString() == 'true'),
      cravingIntensity: _parseDouble(json['craving_intensity'] ?? json['intensity'] ?? json['craving_0_10']),
      intention: json['intention']?.toString(),
      people: _toList(json['people'], splitBySpace: true), // Split by space for people
      timezoneOffset: tzOffset,
    );
  }

  Map<String, dynamic> toJson() => {
        'use_id': id,
        'name': substance,
        'substance': substance, // Add for test compatibility
        'dosage': dosage,
        'unit': unit,
        'route': route,
        'start_time': datetime.toIso8601String(),
        'datetime': datetime.toIso8601String(), // Add for test compatibility
        'time_difference': timeDifferenceMinutes,
        'timezone': timezone,
        'feelings': feelings,
        'secondary_feelings': secondaryFeelings,
        'secondaryFeelings': secondaryFeelings, // Add for test compatibility
        'triggers': triggers,
        'body_signals': bodySignals,
        'bodySignals': bodySignals, // Add for test compatibility
        'place': location,
        'location': location, // Add for test compatibility
        'notes': notes,
        'medical_purpose': isMedicalPurpose,
        'isMedicalPurpose': isMedicalPurpose, // Add for test compatibility
        'craving_intensity': cravingIntensity,
        'cravingIntensity': cravingIntensity, // Add for test compatibility
        'intention': intention,
        'timezone_offset': timezoneOffset,
        'timezoneOffset': timezoneOffset, // Add for test compatibility
        'people': people,
      };
}