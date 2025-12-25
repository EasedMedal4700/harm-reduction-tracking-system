// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tolerance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UseLogEntryImpl _$$UseLogEntryImplFromJson(Map<String, dynamic> json) =>
    _$UseLogEntryImpl(
      substanceSlug: json['substanceSlug'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      doseUnits: (json['doseUnits'] as num).toDouble(),
    );

Map<String, dynamic> _$$UseLogEntryImplToJson(_$UseLogEntryImpl instance) =>
    <String, dynamic>{
      'substanceSlug': instance.substanceSlug,
      'timestamp': instance.timestamp.toIso8601String(),
      'doseUnits': instance.doseUnits,
    };

_$NeuroBucketImpl _$$NeuroBucketImplFromJson(Map<String, dynamic> json) =>
    _$NeuroBucketImpl(
      name: json['name'] as String,
      weight: (json['weight'] as num).toDouble(),
      toleranceType: json['toleranceType'] as String?,
    );

Map<String, dynamic> _$$NeuroBucketImplToJson(_$NeuroBucketImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'weight': instance.weight,
      'toleranceType': instance.toleranceType,
    };

_$ToleranceModelImpl _$$ToleranceModelImplFromJson(
  Map<String, dynamic> json,
) => _$ToleranceModelImpl(
  notes: json['notes'] as String? ?? '',
  neuroBuckets: (json['neuroBuckets'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, NeuroBucket.fromJson(e as Map<String, dynamic>)),
  ),
  halfLifeHours: (json['halfLifeHours'] as num?)?.toDouble() ?? 6.0,
  toleranceDecayDays: (json['toleranceDecayDays'] as num?)?.toDouble() ?? 2.0,
  standardUnitMg: (json['standardUnitMg'] as num?)?.toDouble() ?? 10.0,
  potencyMultiplier: (json['potencyMultiplier'] as num?)?.toDouble() ?? 1.0,
  durationMultiplier: (json['durationMultiplier'] as num?)?.toDouble() ?? 1.0,
  toleranceGainRate: (json['toleranceGainRate'] as num?)?.toDouble() ?? 1.0,
  activeThreshold: (json['activeThreshold'] as num?)?.toDouble() ?? 0.05,
);

Map<String, dynamic> _$$ToleranceModelImplToJson(
  _$ToleranceModelImpl instance,
) => <String, dynamic>{
  'notes': instance.notes,
  'neuroBuckets': instance.neuroBuckets,
  'halfLifeHours': instance.halfLifeHours,
  'toleranceDecayDays': instance.toleranceDecayDays,
  'standardUnitMg': instance.standardUnitMg,
  'potencyMultiplier': instance.potencyMultiplier,
  'durationMultiplier': instance.durationMultiplier,
  'toleranceGainRate': instance.toleranceGainRate,
  'activeThreshold': instance.activeThreshold,
};

_$ToleranceResultImpl _$$ToleranceResultImplFromJson(
  Map<String, dynamic> json,
) => _$ToleranceResultImpl(
  bucketPercents: (json['bucketPercents'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  bucketRawLoads: (json['bucketRawLoads'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  toleranceScore: (json['toleranceScore'] as num).toDouble(),
  daysUntilBaseline: (json['daysUntilBaseline'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
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
  substanceActiveStates:
      (json['substanceActiveStates'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const {},
);

Map<String, dynamic> _$$ToleranceResultImplToJson(
  _$ToleranceResultImpl instance,
) => <String, dynamic>{
  'bucketPercents': instance.bucketPercents,
  'bucketRawLoads': instance.bucketRawLoads,
  'toleranceScore': instance.toleranceScore,
  'daysUntilBaseline': instance.daysUntilBaseline,
  'overallDaysUntilBaseline': instance.overallDaysUntilBaseline,
  'substanceContributions': instance.substanceContributions,
  'substanceActiveStates': instance.substanceActiveStates,
};
