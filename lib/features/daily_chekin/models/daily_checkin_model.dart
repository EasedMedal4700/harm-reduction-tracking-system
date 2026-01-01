// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
// Represents a daily check-in entry
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_checkin_model.freezed.dart';

DateTime _dateFromAny(Object? v) {
  if (v is DateTime) return v;
  if (v is String && v.isNotEmpty) {
    return DateTime.tryParse(v) ?? DateTime.now();
  }
  return DateTime.now();
}

String _dateToSqlDate(DateTime v) => v.toIso8601String().split('T')[0];

DateTime? _dateTimeNullableFromAny(Object? v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
  return null;
}

String? _dateTimeNullableToIsoString(DateTime? v) => v?.toIso8601String();

@freezed
abstract class DailyCheckin with _$DailyCheckin {
  const factory DailyCheckin({
    String? id,
    required String userId,
    required DateTime checkinDate,
    required String mood,
    @Default([]) List<String> emotions,
    required String timeOfDay,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DailyCheckin;

  const DailyCheckin._();

  factory DailyCheckin.fromJson(Map<String, dynamic> json) {
    return DailyCheckin(
      id: json['id']?.toString(),
      userId: json['uuid_user_id']?.toString() ?? '',
      checkinDate: _dateFromAny(json['checkin_date']),
      mood: json['mood']?.toString() ?? '',
      emotions: json['emotions'] is List
          ? (json['emotions'] as List).map((e) => e.toString()).toList()
          : const [],
      timeOfDay: json['time_of_day']?.toString() ?? '',
      notes: json['notes']?.toString(),
      createdAt: _dateTimeNullableFromAny(json['created_at']),
      updatedAt: _dateTimeNullableFromAny(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuid_user_id': userId,
      'checkin_date': _dateToSqlDate(checkinDate),
      'mood': mood,
      'emotions': emotions,
      'time_of_day': timeOfDay,
      'notes': notes,
      if (createdAt != null)
        'created_at': _dateTimeNullableToIsoString(createdAt),
      if (updatedAt != null)
        'updated_at': _dateTimeNullableToIsoString(updatedAt),
    };
  }
}
