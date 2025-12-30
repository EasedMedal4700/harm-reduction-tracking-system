// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityData _$ActivityDataFromJson(
  Map<String, dynamic> json,
) => _ActivityData(
  entries:
      (json['entries'] as List<dynamic>?)
          ?.map((e) => ActivityDrugUseEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ActivityDrugUseEntry>[],
  cravings:
      (json['cravings'] as List<dynamic>?)
          ?.map((e) => ActivityCravingEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ActivityCravingEntry>[],
  reflections:
      (json['reflections'] as List<dynamic>?)
          ?.map(
            (e) => ActivityReflectionEntry.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <ActivityReflectionEntry>[],
);

Map<String, dynamic> _$ActivityDataToJson(_ActivityData instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'cravings': instance.cravings,
      'reflections': instance.reflections,
    };

_ActivityDrugUseEntry _$ActivityDrugUseEntryFromJson(
  Map<String, dynamic> json,
) => _ActivityDrugUseEntry(
  id: json['id'] as String,
  name: json['name'] as String,
  dose: json['dose'] as String,
  place: json['place'] as String,
  time: DateTime.parse(json['time'] as String),
  notes: json['notes'] as String?,
  isMedicalPurpose: json['isMedicalPurpose'] as bool? ?? false,
  raw: json['raw'] as Map<String, dynamic>? ?? const <String, Object?>{},
);

Map<String, dynamic> _$ActivityDrugUseEntryToJson(
  _ActivityDrugUseEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dose': instance.dose,
  'place': instance.place,
  'time': instance.time.toIso8601String(),
  'notes': instance.notes,
  'isMedicalPurpose': instance.isMedicalPurpose,
  'raw': instance.raw,
};

_ActivityCravingEntry _$ActivityCravingEntryFromJson(
  Map<String, dynamic> json,
) => _ActivityCravingEntry(
  id: json['id'] as String,
  substance: json['substance'] as String,
  intensity: (json['intensity'] as num).toDouble(),
  location: json['location'] as String,
  time: DateTime.parse(json['time'] as String),
  trigger: json['trigger'] as String?,
  action: json['action'] as String?,
  notes: json['notes'] as String?,
  raw: json['raw'] as Map<String, dynamic>? ?? const <String, Object?>{},
);

Map<String, dynamic> _$ActivityCravingEntryToJson(
  _ActivityCravingEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'substance': instance.substance,
  'intensity': instance.intensity,
  'location': instance.location,
  'time': instance.time.toIso8601String(),
  'trigger': instance.trigger,
  'action': instance.action,
  'notes': instance.notes,
  'raw': instance.raw,
};

_ActivityReflectionEntry _$ActivityReflectionEntryFromJson(
  Map<String, dynamic> json,
) => _ActivityReflectionEntry(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  effectiveness: (json['effectiveness'] as num?)?.toInt(),
  sleepHours: json['sleepHours'] as num?,
  notes: json['notes'] as String?,
  raw: json['raw'] as Map<String, dynamic>? ?? const <String, Object?>{},
);

Map<String, dynamic> _$ActivityReflectionEntryToJson(
  _ActivityReflectionEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'effectiveness': instance.effectiveness,
  'sleepHours': instance.sleepHours,
  'notes': instance.notes,
  'raw': instance.raw,
};
