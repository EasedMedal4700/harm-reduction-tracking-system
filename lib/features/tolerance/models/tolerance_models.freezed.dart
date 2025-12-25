// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tolerance_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UseLogEntry _$UseLogEntryFromJson(Map<String, dynamic> json) {
  return _UseLogEntry.fromJson(json);
}

/// @nodoc
mixin _$UseLogEntry {
  String get substanceSlug => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get doseUnits => throw _privateConstructorUsedError;

  /// Serializes this UseLogEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UseLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UseLogEntryCopyWith<UseLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UseLogEntryCopyWith<$Res> {
  factory $UseLogEntryCopyWith(
    UseLogEntry value,
    $Res Function(UseLogEntry) then,
  ) = _$UseLogEntryCopyWithImpl<$Res, UseLogEntry>;
  @useResult
  $Res call({String substanceSlug, DateTime timestamp, double doseUnits});
}

/// @nodoc
class _$UseLogEntryCopyWithImpl<$Res, $Val extends UseLogEntry>
    implements $UseLogEntryCopyWith<$Res> {
  _$UseLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UseLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? substanceSlug = null,
    Object? timestamp = null,
    Object? doseUnits = null,
  }) {
    return _then(
      _value.copyWith(
            substanceSlug: null == substanceSlug
                ? _value.substanceSlug
                : substanceSlug // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            doseUnits: null == doseUnits
                ? _value.doseUnits
                : doseUnits // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UseLogEntryImplCopyWith<$Res>
    implements $UseLogEntryCopyWith<$Res> {
  factory _$$UseLogEntryImplCopyWith(
    _$UseLogEntryImpl value,
    $Res Function(_$UseLogEntryImpl) then,
  ) = __$$UseLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String substanceSlug, DateTime timestamp, double doseUnits});
}

/// @nodoc
class __$$UseLogEntryImplCopyWithImpl<$Res>
    extends _$UseLogEntryCopyWithImpl<$Res, _$UseLogEntryImpl>
    implements _$$UseLogEntryImplCopyWith<$Res> {
  __$$UseLogEntryImplCopyWithImpl(
    _$UseLogEntryImpl _value,
    $Res Function(_$UseLogEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UseLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? substanceSlug = null,
    Object? timestamp = null,
    Object? doseUnits = null,
  }) {
    return _then(
      _$UseLogEntryImpl(
        substanceSlug: null == substanceSlug
            ? _value.substanceSlug
            : substanceSlug // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        doseUnits: null == doseUnits
            ? _value.doseUnits
            : doseUnits // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UseLogEntryImpl implements _UseLogEntry {
  const _$UseLogEntryImpl({
    required this.substanceSlug,
    required this.timestamp,
    required this.doseUnits,
  });

  factory _$UseLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$UseLogEntryImplFromJson(json);

  @override
  final String substanceSlug;
  @override
  final DateTime timestamp;
  @override
  final double doseUnits;

  @override
  String toString() {
    return 'UseLogEntry(substanceSlug: $substanceSlug, timestamp: $timestamp, doseUnits: $doseUnits)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UseLogEntryImpl &&
            (identical(other.substanceSlug, substanceSlug) ||
                other.substanceSlug == substanceSlug) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.doseUnits, doseUnits) ||
                other.doseUnits == doseUnits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, substanceSlug, timestamp, doseUnits);

  /// Create a copy of UseLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UseLogEntryImplCopyWith<_$UseLogEntryImpl> get copyWith =>
      __$$UseLogEntryImplCopyWithImpl<_$UseLogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UseLogEntryImplToJson(this);
  }
}

abstract class _UseLogEntry implements UseLogEntry {
  const factory _UseLogEntry({
    required final String substanceSlug,
    required final DateTime timestamp,
    required final double doseUnits,
  }) = _$UseLogEntryImpl;

  factory _UseLogEntry.fromJson(Map<String, dynamic> json) =
      _$UseLogEntryImpl.fromJson;

  @override
  String get substanceSlug;
  @override
  DateTime get timestamp;
  @override
  double get doseUnits;

  /// Create a copy of UseLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UseLogEntryImplCopyWith<_$UseLogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NeuroBucket _$NeuroBucketFromJson(Map<String, dynamic> json) {
  return _NeuroBucket.fromJson(json);
}

/// @nodoc
mixin _$NeuroBucket {
  String get name => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  String? get toleranceType => throw _privateConstructorUsedError;

  /// Serializes this NeuroBucket to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NeuroBucket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NeuroBucketCopyWith<NeuroBucket> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NeuroBucketCopyWith<$Res> {
  factory $NeuroBucketCopyWith(
    NeuroBucket value,
    $Res Function(NeuroBucket) then,
  ) = _$NeuroBucketCopyWithImpl<$Res, NeuroBucket>;
  @useResult
  $Res call({String name, double weight, String? toleranceType});
}

/// @nodoc
class _$NeuroBucketCopyWithImpl<$Res, $Val extends NeuroBucket>
    implements $NeuroBucketCopyWith<$Res> {
  _$NeuroBucketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NeuroBucket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? weight = null,
    Object? toleranceType = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            toleranceType: freezed == toleranceType
                ? _value.toleranceType
                : toleranceType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NeuroBucketImplCopyWith<$Res>
    implements $NeuroBucketCopyWith<$Res> {
  factory _$$NeuroBucketImplCopyWith(
    _$NeuroBucketImpl value,
    $Res Function(_$NeuroBucketImpl) then,
  ) = __$$NeuroBucketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double weight, String? toleranceType});
}

/// @nodoc
class __$$NeuroBucketImplCopyWithImpl<$Res>
    extends _$NeuroBucketCopyWithImpl<$Res, _$NeuroBucketImpl>
    implements _$$NeuroBucketImplCopyWith<$Res> {
  __$$NeuroBucketImplCopyWithImpl(
    _$NeuroBucketImpl _value,
    $Res Function(_$NeuroBucketImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NeuroBucket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? weight = null,
    Object? toleranceType = freezed,
  }) {
    return _then(
      _$NeuroBucketImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        toleranceType: freezed == toleranceType
            ? _value.toleranceType
            : toleranceType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NeuroBucketImpl implements _NeuroBucket {
  const _$NeuroBucketImpl({
    required this.name,
    required this.weight,
    this.toleranceType,
  });

  factory _$NeuroBucketImpl.fromJson(Map<String, dynamic> json) =>
      _$$NeuroBucketImplFromJson(json);

  @override
  final String name;
  @override
  final double weight;
  @override
  final String? toleranceType;

  @override
  String toString() {
    return 'NeuroBucket(name: $name, weight: $weight, toleranceType: $toleranceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NeuroBucketImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.toleranceType, toleranceType) ||
                other.toleranceType == toleranceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, weight, toleranceType);

  /// Create a copy of NeuroBucket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NeuroBucketImplCopyWith<_$NeuroBucketImpl> get copyWith =>
      __$$NeuroBucketImplCopyWithImpl<_$NeuroBucketImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NeuroBucketImplToJson(this);
  }
}

abstract class _NeuroBucket implements NeuroBucket {
  const factory _NeuroBucket({
    required final String name,
    required final double weight,
    final String? toleranceType,
  }) = _$NeuroBucketImpl;

  factory _NeuroBucket.fromJson(Map<String, dynamic> json) =
      _$NeuroBucketImpl.fromJson;

  @override
  String get name;
  @override
  double get weight;
  @override
  String? get toleranceType;

  /// Create a copy of NeuroBucket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NeuroBucketImplCopyWith<_$NeuroBucketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ToleranceModel _$ToleranceModelFromJson(Map<String, dynamic> json) {
  return _ToleranceModel.fromJson(json);
}

/// @nodoc
mixin _$ToleranceModel {
  String get notes => throw _privateConstructorUsedError;
  Map<String, NeuroBucket> get neuroBuckets =>
      throw _privateConstructorUsedError;
  double get halfLifeHours => throw _privateConstructorUsedError;
  double get toleranceDecayDays => throw _privateConstructorUsedError;
  double get standardUnitMg => throw _privateConstructorUsedError;
  double get potencyMultiplier => throw _privateConstructorUsedError;
  double get durationMultiplier => throw _privateConstructorUsedError;
  double get toleranceGainRate => throw _privateConstructorUsedError;
  double get activeThreshold => throw _privateConstructorUsedError;

  /// Serializes this ToleranceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ToleranceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToleranceModelCopyWith<ToleranceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToleranceModelCopyWith<$Res> {
  factory $ToleranceModelCopyWith(
    ToleranceModel value,
    $Res Function(ToleranceModel) then,
  ) = _$ToleranceModelCopyWithImpl<$Res, ToleranceModel>;
  @useResult
  $Res call({
    String notes,
    Map<String, NeuroBucket> neuroBuckets,
    double halfLifeHours,
    double toleranceDecayDays,
    double standardUnitMg,
    double potencyMultiplier,
    double durationMultiplier,
    double toleranceGainRate,
    double activeThreshold,
  });
}

/// @nodoc
class _$ToleranceModelCopyWithImpl<$Res, $Val extends ToleranceModel>
    implements $ToleranceModelCopyWith<$Res> {
  _$ToleranceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToleranceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = null,
    Object? neuroBuckets = null,
    Object? halfLifeHours = null,
    Object? toleranceDecayDays = null,
    Object? standardUnitMg = null,
    Object? potencyMultiplier = null,
    Object? durationMultiplier = null,
    Object? toleranceGainRate = null,
    Object? activeThreshold = null,
  }) {
    return _then(
      _value.copyWith(
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            neuroBuckets: null == neuroBuckets
                ? _value.neuroBuckets
                : neuroBuckets // ignore: cast_nullable_to_non_nullable
                      as Map<String, NeuroBucket>,
            halfLifeHours: null == halfLifeHours
                ? _value.halfLifeHours
                : halfLifeHours // ignore: cast_nullable_to_non_nullable
                      as double,
            toleranceDecayDays: null == toleranceDecayDays
                ? _value.toleranceDecayDays
                : toleranceDecayDays // ignore: cast_nullable_to_non_nullable
                      as double,
            standardUnitMg: null == standardUnitMg
                ? _value.standardUnitMg
                : standardUnitMg // ignore: cast_nullable_to_non_nullable
                      as double,
            potencyMultiplier: null == potencyMultiplier
                ? _value.potencyMultiplier
                : potencyMultiplier // ignore: cast_nullable_to_non_nullable
                      as double,
            durationMultiplier: null == durationMultiplier
                ? _value.durationMultiplier
                : durationMultiplier // ignore: cast_nullable_to_non_nullable
                      as double,
            toleranceGainRate: null == toleranceGainRate
                ? _value.toleranceGainRate
                : toleranceGainRate // ignore: cast_nullable_to_non_nullable
                      as double,
            activeThreshold: null == activeThreshold
                ? _value.activeThreshold
                : activeThreshold // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ToleranceModelImplCopyWith<$Res>
    implements $ToleranceModelCopyWith<$Res> {
  factory _$$ToleranceModelImplCopyWith(
    _$ToleranceModelImpl value,
    $Res Function(_$ToleranceModelImpl) then,
  ) = __$$ToleranceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String notes,
    Map<String, NeuroBucket> neuroBuckets,
    double halfLifeHours,
    double toleranceDecayDays,
    double standardUnitMg,
    double potencyMultiplier,
    double durationMultiplier,
    double toleranceGainRate,
    double activeThreshold,
  });
}

/// @nodoc
class __$$ToleranceModelImplCopyWithImpl<$Res>
    extends _$ToleranceModelCopyWithImpl<$Res, _$ToleranceModelImpl>
    implements _$$ToleranceModelImplCopyWith<$Res> {
  __$$ToleranceModelImplCopyWithImpl(
    _$ToleranceModelImpl _value,
    $Res Function(_$ToleranceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ToleranceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = null,
    Object? neuroBuckets = null,
    Object? halfLifeHours = null,
    Object? toleranceDecayDays = null,
    Object? standardUnitMg = null,
    Object? potencyMultiplier = null,
    Object? durationMultiplier = null,
    Object? toleranceGainRate = null,
    Object? activeThreshold = null,
  }) {
    return _then(
      _$ToleranceModelImpl(
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        neuroBuckets: null == neuroBuckets
            ? _value._neuroBuckets
            : neuroBuckets // ignore: cast_nullable_to_non_nullable
                  as Map<String, NeuroBucket>,
        halfLifeHours: null == halfLifeHours
            ? _value.halfLifeHours
            : halfLifeHours // ignore: cast_nullable_to_non_nullable
                  as double,
        toleranceDecayDays: null == toleranceDecayDays
            ? _value.toleranceDecayDays
            : toleranceDecayDays // ignore: cast_nullable_to_non_nullable
                  as double,
        standardUnitMg: null == standardUnitMg
            ? _value.standardUnitMg
            : standardUnitMg // ignore: cast_nullable_to_non_nullable
                  as double,
        potencyMultiplier: null == potencyMultiplier
            ? _value.potencyMultiplier
            : potencyMultiplier // ignore: cast_nullable_to_non_nullable
                  as double,
        durationMultiplier: null == durationMultiplier
            ? _value.durationMultiplier
            : durationMultiplier // ignore: cast_nullable_to_non_nullable
                  as double,
        toleranceGainRate: null == toleranceGainRate
            ? _value.toleranceGainRate
            : toleranceGainRate // ignore: cast_nullable_to_non_nullable
                  as double,
        activeThreshold: null == activeThreshold
            ? _value.activeThreshold
            : activeThreshold // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ToleranceModelImpl implements _ToleranceModel {
  const _$ToleranceModelImpl({
    this.notes = '',
    required final Map<String, NeuroBucket> neuroBuckets,
    this.halfLifeHours = 6.0,
    this.toleranceDecayDays = 2.0,
    this.standardUnitMg = 10.0,
    this.potencyMultiplier = 1.0,
    this.durationMultiplier = 1.0,
    this.toleranceGainRate = 1.0,
    this.activeThreshold = 0.05,
  }) : _neuroBuckets = neuroBuckets;

  factory _$ToleranceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToleranceModelImplFromJson(json);

  @override
  @JsonKey()
  final String notes;
  final Map<String, NeuroBucket> _neuroBuckets;
  @override
  Map<String, NeuroBucket> get neuroBuckets {
    if (_neuroBuckets is EqualUnmodifiableMapView) return _neuroBuckets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_neuroBuckets);
  }

  @override
  @JsonKey()
  final double halfLifeHours;
  @override
  @JsonKey()
  final double toleranceDecayDays;
  @override
  @JsonKey()
  final double standardUnitMg;
  @override
  @JsonKey()
  final double potencyMultiplier;
  @override
  @JsonKey()
  final double durationMultiplier;
  @override
  @JsonKey()
  final double toleranceGainRate;
  @override
  @JsonKey()
  final double activeThreshold;

  @override
  String toString() {
    return 'ToleranceModel(notes: $notes, neuroBuckets: $neuroBuckets, halfLifeHours: $halfLifeHours, toleranceDecayDays: $toleranceDecayDays, standardUnitMg: $standardUnitMg, potencyMultiplier: $potencyMultiplier, durationMultiplier: $durationMultiplier, toleranceGainRate: $toleranceGainRate, activeThreshold: $activeThreshold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToleranceModelImpl &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._neuroBuckets,
              _neuroBuckets,
            ) &&
            (identical(other.halfLifeHours, halfLifeHours) ||
                other.halfLifeHours == halfLifeHours) &&
            (identical(other.toleranceDecayDays, toleranceDecayDays) ||
                other.toleranceDecayDays == toleranceDecayDays) &&
            (identical(other.standardUnitMg, standardUnitMg) ||
                other.standardUnitMg == standardUnitMg) &&
            (identical(other.potencyMultiplier, potencyMultiplier) ||
                other.potencyMultiplier == potencyMultiplier) &&
            (identical(other.durationMultiplier, durationMultiplier) ||
                other.durationMultiplier == durationMultiplier) &&
            (identical(other.toleranceGainRate, toleranceGainRate) ||
                other.toleranceGainRate == toleranceGainRate) &&
            (identical(other.activeThreshold, activeThreshold) ||
                other.activeThreshold == activeThreshold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    notes,
    const DeepCollectionEquality().hash(_neuroBuckets),
    halfLifeHours,
    toleranceDecayDays,
    standardUnitMg,
    potencyMultiplier,
    durationMultiplier,
    toleranceGainRate,
    activeThreshold,
  );

  /// Create a copy of ToleranceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToleranceModelImplCopyWith<_$ToleranceModelImpl> get copyWith =>
      __$$ToleranceModelImplCopyWithImpl<_$ToleranceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ToleranceModelImplToJson(this);
  }
}

abstract class _ToleranceModel implements ToleranceModel {
  const factory _ToleranceModel({
    final String notes,
    required final Map<String, NeuroBucket> neuroBuckets,
    final double halfLifeHours,
    final double toleranceDecayDays,
    final double standardUnitMg,
    final double potencyMultiplier,
    final double durationMultiplier,
    final double toleranceGainRate,
    final double activeThreshold,
  }) = _$ToleranceModelImpl;

  factory _ToleranceModel.fromJson(Map<String, dynamic> json) =
      _$ToleranceModelImpl.fromJson;

  @override
  String get notes;
  @override
  Map<String, NeuroBucket> get neuroBuckets;
  @override
  double get halfLifeHours;
  @override
  double get toleranceDecayDays;
  @override
  double get standardUnitMg;
  @override
  double get potencyMultiplier;
  @override
  double get durationMultiplier;
  @override
  double get toleranceGainRate;
  @override
  double get activeThreshold;

  /// Create a copy of ToleranceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToleranceModelImplCopyWith<_$ToleranceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ToleranceResult _$ToleranceResultFromJson(Map<String, dynamic> json) {
  return _ToleranceResult.fromJson(json);
}

/// @nodoc
mixin _$ToleranceResult {
  Map<String, double> get bucketPercents => throw _privateConstructorUsedError;
  Map<String, double> get bucketRawLoads => throw _privateConstructorUsedError;
  double get toleranceScore => throw _privateConstructorUsedError;
  Map<String, double> get daysUntilBaseline =>
      throw _privateConstructorUsedError;
  double get overallDaysUntilBaseline => throw _privateConstructorUsedError;
  Map<String, Map<String, double>> get substanceContributions =>
      throw _privateConstructorUsedError;
  Map<String, bool> get substanceActiveStates =>
      throw _privateConstructorUsedError;

  /// Serializes this ToleranceResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ToleranceResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToleranceResultCopyWith<ToleranceResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToleranceResultCopyWith<$Res> {
  factory $ToleranceResultCopyWith(
    ToleranceResult value,
    $Res Function(ToleranceResult) then,
  ) = _$ToleranceResultCopyWithImpl<$Res, ToleranceResult>;
  @useResult
  $Res call({
    Map<String, double> bucketPercents,
    Map<String, double> bucketRawLoads,
    double toleranceScore,
    Map<String, double> daysUntilBaseline,
    double overallDaysUntilBaseline,
    Map<String, Map<String, double>> substanceContributions,
    Map<String, bool> substanceActiveStates,
  });
}

/// @nodoc
class _$ToleranceResultCopyWithImpl<$Res, $Val extends ToleranceResult>
    implements $ToleranceResultCopyWith<$Res> {
  _$ToleranceResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToleranceResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bucketPercents = null,
    Object? bucketRawLoads = null,
    Object? toleranceScore = null,
    Object? daysUntilBaseline = null,
    Object? overallDaysUntilBaseline = null,
    Object? substanceContributions = null,
    Object? substanceActiveStates = null,
  }) {
    return _then(
      _value.copyWith(
            bucketPercents: null == bucketPercents
                ? _value.bucketPercents
                : bucketPercents // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            bucketRawLoads: null == bucketRawLoads
                ? _value.bucketRawLoads
                : bucketRawLoads // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            toleranceScore: null == toleranceScore
                ? _value.toleranceScore
                : toleranceScore // ignore: cast_nullable_to_non_nullable
                      as double,
            daysUntilBaseline: null == daysUntilBaseline
                ? _value.daysUntilBaseline
                : daysUntilBaseline // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            overallDaysUntilBaseline: null == overallDaysUntilBaseline
                ? _value.overallDaysUntilBaseline
                : overallDaysUntilBaseline // ignore: cast_nullable_to_non_nullable
                      as double,
            substanceContributions: null == substanceContributions
                ? _value.substanceContributions
                : substanceContributions // ignore: cast_nullable_to_non_nullable
                      as Map<String, Map<String, double>>,
            substanceActiveStates: null == substanceActiveStates
                ? _value.substanceActiveStates
                : substanceActiveStates // ignore: cast_nullable_to_non_nullable
                      as Map<String, bool>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ToleranceResultImplCopyWith<$Res>
    implements $ToleranceResultCopyWith<$Res> {
  factory _$$ToleranceResultImplCopyWith(
    _$ToleranceResultImpl value,
    $Res Function(_$ToleranceResultImpl) then,
  ) = __$$ToleranceResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, double> bucketPercents,
    Map<String, double> bucketRawLoads,
    double toleranceScore,
    Map<String, double> daysUntilBaseline,
    double overallDaysUntilBaseline,
    Map<String, Map<String, double>> substanceContributions,
    Map<String, bool> substanceActiveStates,
  });
}

/// @nodoc
class __$$ToleranceResultImplCopyWithImpl<$Res>
    extends _$ToleranceResultCopyWithImpl<$Res, _$ToleranceResultImpl>
    implements _$$ToleranceResultImplCopyWith<$Res> {
  __$$ToleranceResultImplCopyWithImpl(
    _$ToleranceResultImpl _value,
    $Res Function(_$ToleranceResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ToleranceResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bucketPercents = null,
    Object? bucketRawLoads = null,
    Object? toleranceScore = null,
    Object? daysUntilBaseline = null,
    Object? overallDaysUntilBaseline = null,
    Object? substanceContributions = null,
    Object? substanceActiveStates = null,
  }) {
    return _then(
      _$ToleranceResultImpl(
        bucketPercents: null == bucketPercents
            ? _value._bucketPercents
            : bucketPercents // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        bucketRawLoads: null == bucketRawLoads
            ? _value._bucketRawLoads
            : bucketRawLoads // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        toleranceScore: null == toleranceScore
            ? _value.toleranceScore
            : toleranceScore // ignore: cast_nullable_to_non_nullable
                  as double,
        daysUntilBaseline: null == daysUntilBaseline
            ? _value._daysUntilBaseline
            : daysUntilBaseline // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        overallDaysUntilBaseline: null == overallDaysUntilBaseline
            ? _value.overallDaysUntilBaseline
            : overallDaysUntilBaseline // ignore: cast_nullable_to_non_nullable
                  as double,
        substanceContributions: null == substanceContributions
            ? _value._substanceContributions
            : substanceContributions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Map<String, double>>,
        substanceActiveStates: null == substanceActiveStates
            ? _value._substanceActiveStates
            : substanceActiveStates // ignore: cast_nullable_to_non_nullable
                  as Map<String, bool>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ToleranceResultImpl implements _ToleranceResult {
  const _$ToleranceResultImpl({
    required final Map<String, double> bucketPercents,
    required final Map<String, double> bucketRawLoads,
    required this.toleranceScore,
    required final Map<String, double> daysUntilBaseline,
    required this.overallDaysUntilBaseline,
    final Map<String, Map<String, double>> substanceContributions = const {},
    final Map<String, bool> substanceActiveStates = const {},
  }) : _bucketPercents = bucketPercents,
       _bucketRawLoads = bucketRawLoads,
       _daysUntilBaseline = daysUntilBaseline,
       _substanceContributions = substanceContributions,
       _substanceActiveStates = substanceActiveStates;

  factory _$ToleranceResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToleranceResultImplFromJson(json);

  final Map<String, double> _bucketPercents;
  @override
  Map<String, double> get bucketPercents {
    if (_bucketPercents is EqualUnmodifiableMapView) return _bucketPercents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bucketPercents);
  }

  final Map<String, double> _bucketRawLoads;
  @override
  Map<String, double> get bucketRawLoads {
    if (_bucketRawLoads is EqualUnmodifiableMapView) return _bucketRawLoads;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bucketRawLoads);
  }

  @override
  final double toleranceScore;
  final Map<String, double> _daysUntilBaseline;
  @override
  Map<String, double> get daysUntilBaseline {
    if (_daysUntilBaseline is EqualUnmodifiableMapView)
      return _daysUntilBaseline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_daysUntilBaseline);
  }

  @override
  final double overallDaysUntilBaseline;
  final Map<String, Map<String, double>> _substanceContributions;
  @override
  @JsonKey()
  Map<String, Map<String, double>> get substanceContributions {
    if (_substanceContributions is EqualUnmodifiableMapView)
      return _substanceContributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_substanceContributions);
  }

  final Map<String, bool> _substanceActiveStates;
  @override
  @JsonKey()
  Map<String, bool> get substanceActiveStates {
    if (_substanceActiveStates is EqualUnmodifiableMapView)
      return _substanceActiveStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_substanceActiveStates);
  }

  @override
  String toString() {
    return 'ToleranceResult(bucketPercents: $bucketPercents, bucketRawLoads: $bucketRawLoads, toleranceScore: $toleranceScore, daysUntilBaseline: $daysUntilBaseline, overallDaysUntilBaseline: $overallDaysUntilBaseline, substanceContributions: $substanceContributions, substanceActiveStates: $substanceActiveStates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToleranceResultImpl &&
            const DeepCollectionEquality().equals(
              other._bucketPercents,
              _bucketPercents,
            ) &&
            const DeepCollectionEquality().equals(
              other._bucketRawLoads,
              _bucketRawLoads,
            ) &&
            (identical(other.toleranceScore, toleranceScore) ||
                other.toleranceScore == toleranceScore) &&
            const DeepCollectionEquality().equals(
              other._daysUntilBaseline,
              _daysUntilBaseline,
            ) &&
            (identical(
                  other.overallDaysUntilBaseline,
                  overallDaysUntilBaseline,
                ) ||
                other.overallDaysUntilBaseline == overallDaysUntilBaseline) &&
            const DeepCollectionEquality().equals(
              other._substanceContributions,
              _substanceContributions,
            ) &&
            const DeepCollectionEquality().equals(
              other._substanceActiveStates,
              _substanceActiveStates,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_bucketPercents),
    const DeepCollectionEquality().hash(_bucketRawLoads),
    toleranceScore,
    const DeepCollectionEquality().hash(_daysUntilBaseline),
    overallDaysUntilBaseline,
    const DeepCollectionEquality().hash(_substanceContributions),
    const DeepCollectionEquality().hash(_substanceActiveStates),
  );

  /// Create a copy of ToleranceResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToleranceResultImplCopyWith<_$ToleranceResultImpl> get copyWith =>
      __$$ToleranceResultImplCopyWithImpl<_$ToleranceResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ToleranceResultImplToJson(this);
  }
}

abstract class _ToleranceResult implements ToleranceResult {
  const factory _ToleranceResult({
    required final Map<String, double> bucketPercents,
    required final Map<String, double> bucketRawLoads,
    required final double toleranceScore,
    required final Map<String, double> daysUntilBaseline,
    required final double overallDaysUntilBaseline,
    final Map<String, Map<String, double>> substanceContributions,
    final Map<String, bool> substanceActiveStates,
  }) = _$ToleranceResultImpl;

  factory _ToleranceResult.fromJson(Map<String, dynamic> json) =
      _$ToleranceResultImpl.fromJson;

  @override
  Map<String, double> get bucketPercents;
  @override
  Map<String, double> get bucketRawLoads;
  @override
  double get toleranceScore;
  @override
  Map<String, double> get daysUntilBaseline;
  @override
  double get overallDaysUntilBaseline;
  @override
  Map<String, Map<String, double>> get substanceContributions;
  @override
  Map<String, bool> get substanceActiveStates;

  /// Create a copy of ToleranceResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToleranceResultImplCopyWith<_$ToleranceResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
