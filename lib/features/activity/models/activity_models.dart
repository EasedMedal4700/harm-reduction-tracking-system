// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Feature model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_models.freezed.dart';
part 'activity_models.g.dart';

enum ActivityItemType {
  drugUse,
  craving,
  reflection;

  String get tableName {
    switch (this) {
      case ActivityItemType.drugUse:
        return 'drug_use';
      case ActivityItemType.craving:
        return 'cravings';
      case ActivityItemType.reflection:
        return 'reflections';
    }
  }

  String get idColumn {
    switch (this) {
      case ActivityItemType.drugUse:
        return 'use_id';
      case ActivityItemType.craving:
        return 'craving_id';
      case ActivityItemType.reflection:
        return 'reflection_id';
    }
  }

  String get displayName {
    switch (this) {
      case ActivityItemType.drugUse:
        return 'drug use';
      case ActivityItemType.craving:
        return 'craving';
      case ActivityItemType.reflection:
        return 'reflection';
    }
  }
}

@freezed
class ActivityData with _$ActivityData {
  const factory ActivityData({
    @Default(<ActivityDrugUseEntry>[]) List<ActivityDrugUseEntry> entries,
    @Default(<ActivityCravingEntry>[]) List<ActivityCravingEntry> cravings,
    @Default(<ActivityReflectionEntry>[])
    List<ActivityReflectionEntry> reflections,
  }) = _ActivityData;

  factory ActivityData.fromJson(Map<String, Object?> json) =>
      _$ActivityDataFromJson(json);
}

@freezed
class ActivityDrugUseEntry with _$ActivityDrugUseEntry {
  const factory ActivityDrugUseEntry({
    required String id,
    required String name,
    required String dose,
    required String place,
    required DateTime time,
    String? notes,
    @Default(false) bool isMedicalPurpose,
    @Default(<String, Object?>{}) Map<String, Object?> raw,
  }) = _ActivityDrugUseEntry;

  factory ActivityDrugUseEntry.fromJson(Map<String, Object?> json) =>
      _$ActivityDrugUseEntryFromJson(json);

  factory ActivityDrugUseEntry.fromMap(Map<String, dynamic> map) {
    final id = (map['use_id'] ?? map['id'] ?? '').toString();
    final name = (map['name'] ?? 'Unknown Substance').toString();
    final dose = (map['dose'] ?? 'Unknown dose').toString();
    final place = (map['place'] ?? 'No location').toString();

    final rawTime = map['start_time'] ?? map['time'];
    final time = _parseDateTime(rawTime) ?? DateTime.now();

    return ActivityDrugUseEntry(
      id: id,
      name: name,
      dose: dose,
      place: place,
      time: time,
      notes: map['notes']?.toString(),
      isMedicalPurpose: map['is_medical_purpose'] == true,
      raw: Map<String, Object?>.from(map),
    );
  }
}

@freezed
class ActivityCravingEntry with _$ActivityCravingEntry {
  const factory ActivityCravingEntry({
    required String id,
    required String substance,
    required double intensity,
    required String location,
    required DateTime time,
    String? trigger,
    String? action,
    String? notes,
    @Default(<String, Object?>{}) Map<String, Object?> raw,
  }) = _ActivityCravingEntry;

  factory ActivityCravingEntry.fromJson(Map<String, Object?> json) =>
      _$ActivityCravingEntryFromJson(json);

  factory ActivityCravingEntry.fromMap(Map<String, dynamic> map) {
    final id = (map['craving_id'] ?? map['id'] ?? '').toString();
    final substance = (map['substance'] ?? 'Unknown Substance').toString();

    final rawIntensity = map['intensity'];
    final intensity = rawIntensity is num ? rawIntensity.toDouble() : 5.0;

    final location = (map['location'] ?? 'No location').toString();
    final rawTime = map['time'] ?? map['created_at'] ?? map['date'];
    final time = _parseDateTime(rawTime) ?? DateTime.now();

    return ActivityCravingEntry(
      id: id,
      substance: substance,
      intensity: intensity,
      location: location,
      time: time,
      trigger: map['trigger']?.toString(),
      action: map['action']?.toString(),
      notes: map['notes']?.toString(),
      raw: Map<String, Object?>.from(map),
    );
  }
}

@freezed
class ActivityReflectionEntry with _$ActivityReflectionEntry {
  const factory ActivityReflectionEntry({
    required String id,
    required DateTime createdAt,
    int? effectiveness,
    num? sleepHours,
    String? notes,
    @Default(<String, Object?>{}) Map<String, Object?> raw,
  }) = _ActivityReflectionEntry;

  factory ActivityReflectionEntry.fromJson(Map<String, Object?> json) =>
      _$ActivityReflectionEntryFromJson(json);

  factory ActivityReflectionEntry.fromMap(Map<String, dynamic> map) {
    final id = (map['reflection_id'] ?? map['id'] ?? '').toString();
    final rawTime = map['created_at'] ?? map['time'];
    final createdAt = _parseDateTime(rawTime) ?? DateTime.now();

    final effectivenessRaw = map['effectiveness'];
    final effectiveness = effectivenessRaw is int
        ? effectivenessRaw
        : (effectivenessRaw is num ? effectivenessRaw.toInt() : null);

    final sleepRaw = map['sleep_hours'];
    final sleepHours = sleepRaw is num ? sleepRaw : null;

    return ActivityReflectionEntry(
      id: id,
      createdAt: createdAt,
      effectiveness: effectiveness,
      sleepHours: sleepHours,
      notes: map['notes']?.toString(),
      raw: Map<String, Object?>.from(map),
    );
  }
}

DateTime? _parseDateTime(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  try {
    return DateTime.parse(value.toString()).toLocal();
  } catch (_) {
    return null;
  }
}
