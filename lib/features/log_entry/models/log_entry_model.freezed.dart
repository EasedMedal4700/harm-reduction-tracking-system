// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LogEntry _$LogEntryFromJson(Map<String, dynamic> json) {
  return _LogEntry.fromJson(json);
}

/// @nodoc
mixin _$LogEntry {
  String? get id => throw _privateConstructorUsedError; // use_id or id
  String get substance => throw _privateConstructorUsedError;
  double get dosage => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get route => throw _privateConstructorUsedError;
  DateTime get datetime => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int get timeDifferenceMinutes => throw _privateConstructorUsedError;
  String? get timezone =>
      throw _privateConstructorUsedError; // raw tz value if present
  List<String> get feelings => throw _privateConstructorUsedError;
  Map<String, List<String>> get secondaryFeelings =>
      throw _privateConstructorUsedError;
  List<String> get triggers => throw _privateConstructorUsedError;
  List<String> get bodySignals => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  bool get isMedicalPurpose => throw _privateConstructorUsedError;
  double get cravingIntensity => throw _privateConstructorUsedError;
  String? get intention => throw _privateConstructorUsedError;
  double get timezoneOffset =>
      throw _privateConstructorUsedError; // parsed offset (e.g., hours)
  List<String> get people => throw _privateConstructorUsedError;

  /// Serializes this LogEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogEntryCopyWith<LogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogEntryCopyWith<$Res> {
  factory $LogEntryCopyWith(LogEntry value, $Res Function(LogEntry) then) =
      _$LogEntryCopyWithImpl<$Res, LogEntry>;
  @useResult
  $Res call({
    String? id,
    String substance,
    double dosage,
    String unit,
    String route,
    DateTime datetime,
    String? notes,
    int timeDifferenceMinutes,
    String? timezone,
    List<String> feelings,
    Map<String, List<String>> secondaryFeelings,
    List<String> triggers,
    List<String> bodySignals,
    String location,
    bool isMedicalPurpose,
    double cravingIntensity,
    String? intention,
    double timezoneOffset,
    List<String> people,
  });
}

/// @nodoc
class _$LogEntryCopyWithImpl<$Res, $Val extends LogEntry>
    implements $LogEntryCopyWith<$Res> {
  _$LogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? substance = null,
    Object? dosage = null,
    Object? unit = null,
    Object? route = null,
    Object? datetime = null,
    Object? notes = freezed,
    Object? timeDifferenceMinutes = null,
    Object? timezone = freezed,
    Object? feelings = null,
    Object? secondaryFeelings = null,
    Object? triggers = null,
    Object? bodySignals = null,
    Object? location = null,
    Object? isMedicalPurpose = null,
    Object? cravingIntensity = null,
    Object? intention = freezed,
    Object? timezoneOffset = null,
    Object? people = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            substance: null == substance
                ? _value.substance
                : substance // ignore: cast_nullable_to_non_nullable
                      as String,
            dosage: null == dosage
                ? _value.dosage
                : dosage // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            route: null == route
                ? _value.route
                : route // ignore: cast_nullable_to_non_nullable
                      as String,
            datetime: null == datetime
                ? _value.datetime
                : datetime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            timeDifferenceMinutes: null == timeDifferenceMinutes
                ? _value.timeDifferenceMinutes
                : timeDifferenceMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            timezone: freezed == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String?,
            feelings: null == feelings
                ? _value.feelings
                : feelings // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            secondaryFeelings: null == secondaryFeelings
                ? _value.secondaryFeelings
                : secondaryFeelings // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<String>>,
            triggers: null == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            bodySignals: null == bodySignals
                ? _value.bodySignals
                : bodySignals // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            isMedicalPurpose: null == isMedicalPurpose
                ? _value.isMedicalPurpose
                : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
                      as bool,
            cravingIntensity: null == cravingIntensity
                ? _value.cravingIntensity
                : cravingIntensity // ignore: cast_nullable_to_non_nullable
                      as double,
            intention: freezed == intention
                ? _value.intention
                : intention // ignore: cast_nullable_to_non_nullable
                      as String?,
            timezoneOffset: null == timezoneOffset
                ? _value.timezoneOffset
                : timezoneOffset // ignore: cast_nullable_to_non_nullable
                      as double,
            people: null == people
                ? _value.people
                : people // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogEntryImplCopyWith<$Res>
    implements $LogEntryCopyWith<$Res> {
  factory _$$LogEntryImplCopyWith(
    _$LogEntryImpl value,
    $Res Function(_$LogEntryImpl) then,
  ) = __$$LogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String substance,
    double dosage,
    String unit,
    String route,
    DateTime datetime,
    String? notes,
    int timeDifferenceMinutes,
    String? timezone,
    List<String> feelings,
    Map<String, List<String>> secondaryFeelings,
    List<String> triggers,
    List<String> bodySignals,
    String location,
    bool isMedicalPurpose,
    double cravingIntensity,
    String? intention,
    double timezoneOffset,
    List<String> people,
  });
}

/// @nodoc
class __$$LogEntryImplCopyWithImpl<$Res>
    extends _$LogEntryCopyWithImpl<$Res, _$LogEntryImpl>
    implements _$$LogEntryImplCopyWith<$Res> {
  __$$LogEntryImplCopyWithImpl(
    _$LogEntryImpl _value,
    $Res Function(_$LogEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? substance = null,
    Object? dosage = null,
    Object? unit = null,
    Object? route = null,
    Object? datetime = null,
    Object? notes = freezed,
    Object? timeDifferenceMinutes = null,
    Object? timezone = freezed,
    Object? feelings = null,
    Object? secondaryFeelings = null,
    Object? triggers = null,
    Object? bodySignals = null,
    Object? location = null,
    Object? isMedicalPurpose = null,
    Object? cravingIntensity = null,
    Object? intention = freezed,
    Object? timezoneOffset = null,
    Object? people = null,
  }) {
    return _then(
      _$LogEntryImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        substance: null == substance
            ? _value.substance
            : substance // ignore: cast_nullable_to_non_nullable
                  as String,
        dosage: null == dosage
            ? _value.dosage
            : dosage // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        route: null == route
            ? _value.route
            : route // ignore: cast_nullable_to_non_nullable
                  as String,
        datetime: null == datetime
            ? _value.datetime
            : datetime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        timeDifferenceMinutes: null == timeDifferenceMinutes
            ? _value.timeDifferenceMinutes
            : timeDifferenceMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        timezone: freezed == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String?,
        feelings: null == feelings
            ? _value._feelings
            : feelings // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        secondaryFeelings: null == secondaryFeelings
            ? _value._secondaryFeelings
            : secondaryFeelings // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>,
        triggers: null == triggers
            ? _value._triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        bodySignals: null == bodySignals
            ? _value._bodySignals
            : bodySignals // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        isMedicalPurpose: null == isMedicalPurpose
            ? _value.isMedicalPurpose
            : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
                  as bool,
        cravingIntensity: null == cravingIntensity
            ? _value.cravingIntensity
            : cravingIntensity // ignore: cast_nullable_to_non_nullable
                  as double,
        intention: freezed == intention
            ? _value.intention
            : intention // ignore: cast_nullable_to_non_nullable
                  as String?,
        timezoneOffset: null == timezoneOffset
            ? _value.timezoneOffset
            : timezoneOffset // ignore: cast_nullable_to_non_nullable
                  as double,
        people: null == people
            ? _value._people
            : people // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LogEntryImpl extends _LogEntry {
  const _$LogEntryImpl({
    this.id,
    required this.substance,
    required this.dosage,
    required this.unit,
    required this.route,
    required this.datetime,
    this.notes,
    this.timeDifferenceMinutes = 0,
    this.timezone,
    final List<String> feelings = const [],
    final Map<String, List<String>> secondaryFeelings = const {},
    final List<String> triggers = const [],
    final List<String> bodySignals = const [],
    this.location = '',
    this.isMedicalPurpose = false,
    this.cravingIntensity = 0.0,
    this.intention,
    this.timezoneOffset = 0.0,
    final List<String> people = const [],
  }) : _feelings = feelings,
       _secondaryFeelings = secondaryFeelings,
       _triggers = triggers,
       _bodySignals = bodySignals,
       _people = people,
       super._();

  factory _$LogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogEntryImplFromJson(json);

  @override
  final String? id;
  // use_id or id
  @override
  final String substance;
  @override
  final double dosage;
  @override
  final String unit;
  @override
  final String route;
  @override
  final DateTime datetime;
  @override
  final String? notes;
  @override
  @JsonKey()
  final int timeDifferenceMinutes;
  @override
  final String? timezone;
  // raw tz value if present
  final List<String> _feelings;
  // raw tz value if present
  @override
  @JsonKey()
  List<String> get feelings {
    if (_feelings is EqualUnmodifiableListView) return _feelings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feelings);
  }

  final Map<String, List<String>> _secondaryFeelings;
  @override
  @JsonKey()
  Map<String, List<String>> get secondaryFeelings {
    if (_secondaryFeelings is EqualUnmodifiableMapView)
      return _secondaryFeelings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_secondaryFeelings);
  }

  final List<String> _triggers;
  @override
  @JsonKey()
  List<String> get triggers {
    if (_triggers is EqualUnmodifiableListView) return _triggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggers);
  }

  final List<String> _bodySignals;
  @override
  @JsonKey()
  List<String> get bodySignals {
    if (_bodySignals is EqualUnmodifiableListView) return _bodySignals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bodySignals);
  }

  @override
  @JsonKey()
  final String location;
  @override
  @JsonKey()
  final bool isMedicalPurpose;
  @override
  @JsonKey()
  final double cravingIntensity;
  @override
  final String? intention;
  @override
  @JsonKey()
  final double timezoneOffset;
  // parsed offset (e.g., hours)
  final List<String> _people;
  // parsed offset (e.g., hours)
  @override
  @JsonKey()
  List<String> get people {
    if (_people is EqualUnmodifiableListView) return _people;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_people);
  }

  @override
  String toString() {
    return 'LogEntry(id: $id, substance: $substance, dosage: $dosage, unit: $unit, route: $route, datetime: $datetime, notes: $notes, timeDifferenceMinutes: $timeDifferenceMinutes, timezone: $timezone, feelings: $feelings, secondaryFeelings: $secondaryFeelings, triggers: $triggers, bodySignals: $bodySignals, location: $location, isMedicalPurpose: $isMedicalPurpose, cravingIntensity: $cravingIntensity, intention: $intention, timezoneOffset: $timezoneOffset, people: $people)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.substance, substance) ||
                other.substance == substance) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.timeDifferenceMinutes, timeDifferenceMinutes) ||
                other.timeDifferenceMinutes == timeDifferenceMinutes) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            const DeepCollectionEquality().equals(other._feelings, _feelings) &&
            const DeepCollectionEquality().equals(
              other._secondaryFeelings,
              _secondaryFeelings,
            ) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            const DeepCollectionEquality().equals(
              other._bodySignals,
              _bodySignals,
            ) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.isMedicalPurpose, isMedicalPurpose) ||
                other.isMedicalPurpose == isMedicalPurpose) &&
            (identical(other.cravingIntensity, cravingIntensity) ||
                other.cravingIntensity == cravingIntensity) &&
            (identical(other.intention, intention) ||
                other.intention == intention) &&
            (identical(other.timezoneOffset, timezoneOffset) ||
                other.timezoneOffset == timezoneOffset) &&
            const DeepCollectionEquality().equals(other._people, _people));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    substance,
    dosage,
    unit,
    route,
    datetime,
    notes,
    timeDifferenceMinutes,
    timezone,
    const DeepCollectionEquality().hash(_feelings),
    const DeepCollectionEquality().hash(_secondaryFeelings),
    const DeepCollectionEquality().hash(_triggers),
    const DeepCollectionEquality().hash(_bodySignals),
    location,
    isMedicalPurpose,
    cravingIntensity,
    intention,
    timezoneOffset,
    const DeepCollectionEquality().hash(_people),
  ]);

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogEntryImplCopyWith<_$LogEntryImpl> get copyWith =>
      __$$LogEntryImplCopyWithImpl<_$LogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogEntryImplToJson(this);
  }
}

abstract class _LogEntry extends LogEntry {
  const factory _LogEntry({
    final String? id,
    required final String substance,
    required final double dosage,
    required final String unit,
    required final String route,
    required final DateTime datetime,
    final String? notes,
    final int timeDifferenceMinutes,
    final String? timezone,
    final List<String> feelings,
    final Map<String, List<String>> secondaryFeelings,
    final List<String> triggers,
    final List<String> bodySignals,
    final String location,
    final bool isMedicalPurpose,
    final double cravingIntensity,
    final String? intention,
    final double timezoneOffset,
    final List<String> people,
  }) = _$LogEntryImpl;
  const _LogEntry._() : super._();

  factory _LogEntry.fromJson(Map<String, dynamic> json) =
      _$LogEntryImpl.fromJson;

  @override
  String? get id; // use_id or id
  @override
  String get substance;
  @override
  double get dosage;
  @override
  String get unit;
  @override
  String get route;
  @override
  DateTime get datetime;
  @override
  String? get notes;
  @override
  int get timeDifferenceMinutes;
  @override
  String? get timezone; // raw tz value if present
  @override
  List<String> get feelings;
  @override
  Map<String, List<String>> get secondaryFeelings;
  @override
  List<String> get triggers;
  @override
  List<String> get bodySignals;
  @override
  String get location;
  @override
  bool get isMedicalPurpose;
  @override
  double get cravingIntensity;
  @override
  String? get intention;
  @override
  double get timezoneOffset; // parsed offset (e.g., hours)
  @override
  List<String> get people;

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogEntryImplCopyWith<_$LogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
