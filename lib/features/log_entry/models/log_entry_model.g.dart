// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LogEntry _$LogEntryFromJson(Map<String, dynamic> json) => _LogEntry(
  id: json['id'] as String?,
  substance: json['substance'] as String,
  dosage: (json['dosage'] as num).toDouble(),
  unit: json['unit'] as String,
  route: json['route'] as String,
  datetime: DateTime.parse(json['datetime'] as String),
  notes: json['notes'] as String?,
  timeDifferenceMinutes: (json['timeDifferenceMinutes'] as num?)?.toInt() ?? 0,
  timezone: json['timezone'] as String?,
  feelings:
      (json['feelings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  secondaryFeelings:
      (json['secondaryFeelings'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ) ??
      const {},
  triggers:
      (json['triggers'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  bodySignals:
      (json['bodySignals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  location: json['location'] as String? ?? '',
  isMedicalPurpose: json['isMedicalPurpose'] as bool? ?? false,
  cravingIntensity: (json['cravingIntensity'] as num?)?.toDouble() ?? 0.0,
  intention: json['intention'] as String?,
  timezoneOffset: (json['timezoneOffset'] as num?)?.toDouble() ?? 0.0,
  people:
      (json['people'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$LogEntryToJson(_LogEntry instance) => <String, dynamic>{
  'id': instance.id,
  'substance': instance.substance,
  'dosage': instance.dosage,
  'unit': instance.unit,
  'route': instance.route,
  'datetime': instance.datetime.toIso8601String(),
  'notes': instance.notes,
  'timeDifferenceMinutes': instance.timeDifferenceMinutes,
  'timezone': instance.timezone,
  'feelings': instance.feelings,
  'secondaryFeelings': instance.secondaryFeelings,
  'triggers': instance.triggers,
  'bodySignals': instance.bodySignals,
  'location': instance.location,
  'isMedicalPurpose': instance.isMedicalPurpose,
  'cravingIntensity': instance.cravingIntensity,
  'intention': instance.intention,
  'timezoneOffset': instance.timezoneOffset,
  'people': instance.people,
};
