// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tolerance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UseLogEntry _$UseLogEntryFromJson(Map<String, dynamic> json) => _UseLogEntry(
  substanceSlug: json['substanceSlug'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  doseUnits: (json['doseUnits'] as num).toDouble(),
);

Map<String, dynamic> _$UseLogEntryToJson(_UseLogEntry instance) =>
    <String, dynamic>{
      'substanceSlug': instance.substanceSlug,
      'timestamp': instance.timestamp.toIso8601String(),
      'doseUnits': instance.doseUnits,
    };

_ToleranceResult _$ToleranceResultFromJson(Map<String, dynamic> json) =>
    _ToleranceResult(
      bucketPercents: (json['bucketPercents'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      bucketRawLoads: (json['bucketRawLoads'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      toleranceScore: (json['toleranceScore'] as num).toDouble(),
      daysUntilBaseline: (json['daysUntilBaseline'] as Map<String, dynamic>)
          .map((k, e) => MapEntry(k, (e as num).toDouble())),
      overallDaysUntilBaseline: (json['overallDaysUntilBaseline'] as num)
          .toDouble(),
      substanceContributions:
          (json['substanceContributions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ),
            ),
          ) ??
          const {},
      logImpacts:
          (json['logImpacts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ),
            ),
          ) ??
          const {},
      substanceActiveStates:
          (json['substanceActiveStates'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      relevantLogs:
          (json['relevantLogs'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>)
                  .map((e) => UseLogEntry.fromJson(e as Map<String, dynamic>))
                  .toList(),
            ),
          ) ??
          const {},
    );

Map<String, dynamic> _$ToleranceResultToJson(_ToleranceResult instance) =>
    <String, dynamic>{
      'bucketPercents': instance.bucketPercents,
      'bucketRawLoads': instance.bucketRawLoads,
      'toleranceScore': instance.toleranceScore,
      'daysUntilBaseline': instance.daysUntilBaseline,
      'overallDaysUntilBaseline': instance.overallDaysUntilBaseline,
      'substanceContributions': instance.substanceContributions,
      'logImpacts': instance.logImpacts,
      'substanceActiveStates': instance.substanceActiveStates,
      'relevantLogs': instance.relevantLogs,
    };
