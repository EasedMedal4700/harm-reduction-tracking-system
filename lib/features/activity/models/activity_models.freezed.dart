// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityData _$ActivityDataFromJson(Map<String, dynamic> json) {
  return _ActivityData.fromJson(json);
}

/// @nodoc
mixin _$ActivityData {
  List<ActivityDrugUseEntry> get entries => throw _privateConstructorUsedError;
  List<ActivityCravingEntry> get cravings => throw _privateConstructorUsedError;
  List<ActivityReflectionEntry> get reflections =>
      throw _privateConstructorUsedError;

  /// Serializes this ActivityData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityDataCopyWith<ActivityData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityDataCopyWith<$Res> {
  factory $ActivityDataCopyWith(
    ActivityData value,
    $Res Function(ActivityData) then,
  ) = _$ActivityDataCopyWithImpl<$Res, ActivityData>;
  @useResult
  $Res call({
    List<ActivityDrugUseEntry> entries,
    List<ActivityCravingEntry> cravings,
    List<ActivityReflectionEntry> reflections,
  });
}

/// @nodoc
class _$ActivityDataCopyWithImpl<$Res, $Val extends ActivityData>
    implements $ActivityDataCopyWith<$Res> {
  _$ActivityDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? cravings = null,
    Object? reflections = null,
  }) {
    return _then(
      _value.copyWith(
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<ActivityDrugUseEntry>,
            cravings: null == cravings
                ? _value.cravings
                : cravings // ignore: cast_nullable_to_non_nullable
                      as List<ActivityCravingEntry>,
            reflections: null == reflections
                ? _value.reflections
                : reflections // ignore: cast_nullable_to_non_nullable
                      as List<ActivityReflectionEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityDataImplCopyWith<$Res>
    implements $ActivityDataCopyWith<$Res> {
  factory _$$ActivityDataImplCopyWith(
    _$ActivityDataImpl value,
    $Res Function(_$ActivityDataImpl) then,
  ) = __$$ActivityDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ActivityDrugUseEntry> entries,
    List<ActivityCravingEntry> cravings,
    List<ActivityReflectionEntry> reflections,
  });
}

/// @nodoc
class __$$ActivityDataImplCopyWithImpl<$Res>
    extends _$ActivityDataCopyWithImpl<$Res, _$ActivityDataImpl>
    implements _$$ActivityDataImplCopyWith<$Res> {
  __$$ActivityDataImplCopyWithImpl(
    _$ActivityDataImpl _value,
    $Res Function(_$ActivityDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? cravings = null,
    Object? reflections = null,
  }) {
    return _then(
      _$ActivityDataImpl(
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<ActivityDrugUseEntry>,
        cravings: null == cravings
            ? _value._cravings
            : cravings // ignore: cast_nullable_to_non_nullable
                  as List<ActivityCravingEntry>,
        reflections: null == reflections
            ? _value._reflections
            : reflections // ignore: cast_nullable_to_non_nullable
                  as List<ActivityReflectionEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityDataImpl implements _ActivityData {
  const _$ActivityDataImpl({
    final List<ActivityDrugUseEntry> entries = const <ActivityDrugUseEntry>[],
    final List<ActivityCravingEntry> cravings = const <ActivityCravingEntry>[],
    final List<ActivityReflectionEntry> reflections =
        const <ActivityReflectionEntry>[],
  }) : _entries = entries,
       _cravings = cravings,
       _reflections = reflections;

  factory _$ActivityDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityDataImplFromJson(json);

  final List<ActivityDrugUseEntry> _entries;
  @override
  @JsonKey()
  List<ActivityDrugUseEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  final List<ActivityCravingEntry> _cravings;
  @override
  @JsonKey()
  List<ActivityCravingEntry> get cravings {
    if (_cravings is EqualUnmodifiableListView) return _cravings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cravings);
  }

  final List<ActivityReflectionEntry> _reflections;
  @override
  @JsonKey()
  List<ActivityReflectionEntry> get reflections {
    if (_reflections is EqualUnmodifiableListView) return _reflections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reflections);
  }

  @override
  String toString() {
    return 'ActivityData(entries: $entries, cravings: $cravings, reflections: $reflections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityDataImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            const DeepCollectionEquality().equals(other._cravings, _cravings) &&
            const DeepCollectionEquality().equals(
              other._reflections,
              _reflections,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_entries),
    const DeepCollectionEquality().hash(_cravings),
    const DeepCollectionEquality().hash(_reflections),
  );

  /// Create a copy of ActivityData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityDataImplCopyWith<_$ActivityDataImpl> get copyWith =>
      __$$ActivityDataImplCopyWithImpl<_$ActivityDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityDataImplToJson(this);
  }
}

abstract class _ActivityData implements ActivityData {
  const factory _ActivityData({
    final List<ActivityDrugUseEntry> entries,
    final List<ActivityCravingEntry> cravings,
    final List<ActivityReflectionEntry> reflections,
  }) = _$ActivityDataImpl;

  factory _ActivityData.fromJson(Map<String, dynamic> json) =
      _$ActivityDataImpl.fromJson;

  @override
  List<ActivityDrugUseEntry> get entries;
  @override
  List<ActivityCravingEntry> get cravings;
  @override
  List<ActivityReflectionEntry> get reflections;

  /// Create a copy of ActivityData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityDataImplCopyWith<_$ActivityDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityDrugUseEntry _$ActivityDrugUseEntryFromJson(Map<String, dynamic> json) {
  return _ActivityDrugUseEntry.fromJson(json);
}

/// @nodoc
mixin _$ActivityDrugUseEntry {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get dose => throw _privateConstructorUsedError;
  String get place => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isMedicalPurpose => throw _privateConstructorUsedError;
  Map<String, Object?> get raw => throw _privateConstructorUsedError;

  /// Serializes this ActivityDrugUseEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityDrugUseEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityDrugUseEntryCopyWith<ActivityDrugUseEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityDrugUseEntryCopyWith<$Res> {
  factory $ActivityDrugUseEntryCopyWith(
    ActivityDrugUseEntry value,
    $Res Function(ActivityDrugUseEntry) then,
  ) = _$ActivityDrugUseEntryCopyWithImpl<$Res, ActivityDrugUseEntry>;
  @useResult
  $Res call({
    String id,
    String name,
    String dose,
    String place,
    DateTime time,
    String? notes,
    bool isMedicalPurpose,
    Map<String, Object?> raw,
  });
}

/// @nodoc
class _$ActivityDrugUseEntryCopyWithImpl<
  $Res,
  $Val extends ActivityDrugUseEntry
>
    implements $ActivityDrugUseEntryCopyWith<$Res> {
  _$ActivityDrugUseEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityDrugUseEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dose = null,
    Object? place = null,
    Object? time = null,
    Object? notes = freezed,
    Object? isMedicalPurpose = null,
    Object? raw = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            dose: null == dose
                ? _value.dose
                : dose // ignore: cast_nullable_to_non_nullable
                      as String,
            place: null == place
                ? _value.place
                : place // ignore: cast_nullable_to_non_nullable
                      as String,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isMedicalPurpose: null == isMedicalPurpose
                ? _value.isMedicalPurpose
                : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
                      as bool,
            raw: null == raw
                ? _value.raw
                : raw // ignore: cast_nullable_to_non_nullable
                      as Map<String, Object?>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityDrugUseEntryImplCopyWith<$Res>
    implements $ActivityDrugUseEntryCopyWith<$Res> {
  factory _$$ActivityDrugUseEntryImplCopyWith(
    _$ActivityDrugUseEntryImpl value,
    $Res Function(_$ActivityDrugUseEntryImpl) then,
  ) = __$$ActivityDrugUseEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String dose,
    String place,
    DateTime time,
    String? notes,
    bool isMedicalPurpose,
    Map<String, Object?> raw,
  });
}

/// @nodoc
class __$$ActivityDrugUseEntryImplCopyWithImpl<$Res>
    extends _$ActivityDrugUseEntryCopyWithImpl<$Res, _$ActivityDrugUseEntryImpl>
    implements _$$ActivityDrugUseEntryImplCopyWith<$Res> {
  __$$ActivityDrugUseEntryImplCopyWithImpl(
    _$ActivityDrugUseEntryImpl _value,
    $Res Function(_$ActivityDrugUseEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityDrugUseEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dose = null,
    Object? place = null,
    Object? time = null,
    Object? notes = freezed,
    Object? isMedicalPurpose = null,
    Object? raw = null,
  }) {
    return _then(
      _$ActivityDrugUseEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        dose: null == dose
            ? _value.dose
            : dose // ignore: cast_nullable_to_non_nullable
                  as String,
        place: null == place
            ? _value.place
            : place // ignore: cast_nullable_to_non_nullable
                  as String,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isMedicalPurpose: null == isMedicalPurpose
            ? _value.isMedicalPurpose
            : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
                  as bool,
        raw: null == raw
            ? _value._raw
            : raw // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityDrugUseEntryImpl implements _ActivityDrugUseEntry {
  const _$ActivityDrugUseEntryImpl({
    required this.id,
    required this.name,
    required this.dose,
    required this.place,
    required this.time,
    this.notes,
    this.isMedicalPurpose = false,
    final Map<String, Object?> raw = const <String, Object?>{},
  }) : _raw = raw;

  factory _$ActivityDrugUseEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityDrugUseEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String dose;
  @override
  final String place;
  @override
  final DateTime time;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isMedicalPurpose;
  final Map<String, Object?> _raw;
  @override
  @JsonKey()
  Map<String, Object?> get raw {
    if (_raw is EqualUnmodifiableMapView) return _raw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_raw);
  }

  @override
  String toString() {
    return 'ActivityDrugUseEntry(id: $id, name: $name, dose: $dose, place: $place, time: $time, notes: $notes, isMedicalPurpose: $isMedicalPurpose, raw: $raw)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityDrugUseEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dose, dose) || other.dose == dose) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isMedicalPurpose, isMedicalPurpose) ||
                other.isMedicalPurpose == isMedicalPurpose) &&
            const DeepCollectionEquality().equals(other._raw, _raw));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    dose,
    place,
    time,
    notes,
    isMedicalPurpose,
    const DeepCollectionEquality().hash(_raw),
  );

  /// Create a copy of ActivityDrugUseEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityDrugUseEntryImplCopyWith<_$ActivityDrugUseEntryImpl>
  get copyWith =>
      __$$ActivityDrugUseEntryImplCopyWithImpl<_$ActivityDrugUseEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityDrugUseEntryImplToJson(this);
  }
}

abstract class _ActivityDrugUseEntry implements ActivityDrugUseEntry {
  const factory _ActivityDrugUseEntry({
    required final String id,
    required final String name,
    required final String dose,
    required final String place,
    required final DateTime time,
    final String? notes,
    final bool isMedicalPurpose,
    final Map<String, Object?> raw,
  }) = _$ActivityDrugUseEntryImpl;

  factory _ActivityDrugUseEntry.fromJson(Map<String, dynamic> json) =
      _$ActivityDrugUseEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get dose;
  @override
  String get place;
  @override
  DateTime get time;
  @override
  String? get notes;
  @override
  bool get isMedicalPurpose;
  @override
  Map<String, Object?> get raw;

  /// Create a copy of ActivityDrugUseEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityDrugUseEntryImplCopyWith<_$ActivityDrugUseEntryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ActivityCravingEntry _$ActivityCravingEntryFromJson(Map<String, dynamic> json) {
  return _ActivityCravingEntry.fromJson(json);
}

/// @nodoc
mixin _$ActivityCravingEntry {
  String get id => throw _privateConstructorUsedError;
  String get substance => throw _privateConstructorUsedError;
  double get intensity => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;
  String? get trigger => throw _privateConstructorUsedError;
  String? get action => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  Map<String, Object?> get raw => throw _privateConstructorUsedError;

  /// Serializes this ActivityCravingEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityCravingEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityCravingEntryCopyWith<ActivityCravingEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCravingEntryCopyWith<$Res> {
  factory $ActivityCravingEntryCopyWith(
    ActivityCravingEntry value,
    $Res Function(ActivityCravingEntry) then,
  ) = _$ActivityCravingEntryCopyWithImpl<$Res, ActivityCravingEntry>;
  @useResult
  $Res call({
    String id,
    String substance,
    double intensity,
    String location,
    DateTime time,
    String? trigger,
    String? action,
    String? notes,
    Map<String, Object?> raw,
  });
}

/// @nodoc
class _$ActivityCravingEntryCopyWithImpl<
  $Res,
  $Val extends ActivityCravingEntry
>
    implements $ActivityCravingEntryCopyWith<$Res> {
  _$ActivityCravingEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityCravingEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? substance = null,
    Object? intensity = null,
    Object? location = null,
    Object? time = null,
    Object? trigger = freezed,
    Object? action = freezed,
    Object? notes = freezed,
    Object? raw = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            substance: null == substance
                ? _value.substance
                : substance // ignore: cast_nullable_to_non_nullable
                      as String,
            intensity: null == intensity
                ? _value.intensity
                : intensity // ignore: cast_nullable_to_non_nullable
                      as double,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            trigger: freezed == trigger
                ? _value.trigger
                : trigger // ignore: cast_nullable_to_non_nullable
                      as String?,
            action: freezed == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            raw: null == raw
                ? _value.raw
                : raw // ignore: cast_nullable_to_non_nullable
                      as Map<String, Object?>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityCravingEntryImplCopyWith<$Res>
    implements $ActivityCravingEntryCopyWith<$Res> {
  factory _$$ActivityCravingEntryImplCopyWith(
    _$ActivityCravingEntryImpl value,
    $Res Function(_$ActivityCravingEntryImpl) then,
  ) = __$$ActivityCravingEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String substance,
    double intensity,
    String location,
    DateTime time,
    String? trigger,
    String? action,
    String? notes,
    Map<String, Object?> raw,
  });
}

/// @nodoc
class __$$ActivityCravingEntryImplCopyWithImpl<$Res>
    extends _$ActivityCravingEntryCopyWithImpl<$Res, _$ActivityCravingEntryImpl>
    implements _$$ActivityCravingEntryImplCopyWith<$Res> {
  __$$ActivityCravingEntryImplCopyWithImpl(
    _$ActivityCravingEntryImpl _value,
    $Res Function(_$ActivityCravingEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityCravingEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? substance = null,
    Object? intensity = null,
    Object? location = null,
    Object? time = null,
    Object? trigger = freezed,
    Object? action = freezed,
    Object? notes = freezed,
    Object? raw = null,
  }) {
    return _then(
      _$ActivityCravingEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        substance: null == substance
            ? _value.substance
            : substance // ignore: cast_nullable_to_non_nullable
                  as String,
        intensity: null == intensity
            ? _value.intensity
            : intensity // ignore: cast_nullable_to_non_nullable
                  as double,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        trigger: freezed == trigger
            ? _value.trigger
            : trigger // ignore: cast_nullable_to_non_nullable
                  as String?,
        action: freezed == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        raw: null == raw
            ? _value._raw
            : raw // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityCravingEntryImpl implements _ActivityCravingEntry {
  const _$ActivityCravingEntryImpl({
    required this.id,
    required this.substance,
    required this.intensity,
    required this.location,
    required this.time,
    this.trigger,
    this.action,
    this.notes,
    final Map<String, Object?> raw = const <String, Object?>{},
  }) : _raw = raw;

  factory _$ActivityCravingEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityCravingEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String substance;
  @override
  final double intensity;
  @override
  final String location;
  @override
  final DateTime time;
  @override
  final String? trigger;
  @override
  final String? action;
  @override
  final String? notes;
  final Map<String, Object?> _raw;
  @override
  @JsonKey()
  Map<String, Object?> get raw {
    if (_raw is EqualUnmodifiableMapView) return _raw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_raw);
  }

  @override
  String toString() {
    return 'ActivityCravingEntry(id: $id, substance: $substance, intensity: $intensity, location: $location, time: $time, trigger: $trigger, action: $action, notes: $notes, raw: $raw)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityCravingEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.substance, substance) ||
                other.substance == substance) &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.trigger, trigger) || other.trigger == trigger) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._raw, _raw));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    substance,
    intensity,
    location,
    time,
    trigger,
    action,
    notes,
    const DeepCollectionEquality().hash(_raw),
  );

  /// Create a copy of ActivityCravingEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityCravingEntryImplCopyWith<_$ActivityCravingEntryImpl>
  get copyWith =>
      __$$ActivityCravingEntryImplCopyWithImpl<_$ActivityCravingEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityCravingEntryImplToJson(this);
  }
}

abstract class _ActivityCravingEntry implements ActivityCravingEntry {
  const factory _ActivityCravingEntry({
    required final String id,
    required final String substance,
    required final double intensity,
    required final String location,
    required final DateTime time,
    final String? trigger,
    final String? action,
    final String? notes,
    final Map<String, Object?> raw,
  }) = _$ActivityCravingEntryImpl;

  factory _ActivityCravingEntry.fromJson(Map<String, dynamic> json) =
      _$ActivityCravingEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get substance;
  @override
  double get intensity;
  @override
  String get location;
  @override
  DateTime get time;
  @override
  String? get trigger;
  @override
  String? get action;
  @override
  String? get notes;
  @override
  Map<String, Object?> get raw;

  /// Create a copy of ActivityCravingEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityCravingEntryImplCopyWith<_$ActivityCravingEntryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ActivityReflectionEntry _$ActivityReflectionEntryFromJson(
  Map<String, dynamic> json,
) {
  return _ActivityReflectionEntry.fromJson(json);
}

/// @nodoc
mixin _$ActivityReflectionEntry {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get effectiveness => throw _privateConstructorUsedError;
  num? get sleepHours => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  Map<String, Object?> get raw => throw _privateConstructorUsedError;

  /// Serializes this ActivityReflectionEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityReflectionEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityReflectionEntryCopyWith<ActivityReflectionEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityReflectionEntryCopyWith<$Res> {
  factory $ActivityReflectionEntryCopyWith(
    ActivityReflectionEntry value,
    $Res Function(ActivityReflectionEntry) then,
  ) = _$ActivityReflectionEntryCopyWithImpl<$Res, ActivityReflectionEntry>;
  @useResult
  $Res call({
    String id,
    DateTime createdAt,
    int? effectiveness,
    num? sleepHours,
    String? notes,
    Map<String, Object?> raw,
  });
}

/// @nodoc
class _$ActivityReflectionEntryCopyWithImpl<
  $Res,
  $Val extends ActivityReflectionEntry
>
    implements $ActivityReflectionEntryCopyWith<$Res> {
  _$ActivityReflectionEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityReflectionEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? effectiveness = freezed,
    Object? sleepHours = freezed,
    Object? notes = freezed,
    Object? raw = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            effectiveness: freezed == effectiveness
                ? _value.effectiveness
                : effectiveness // ignore: cast_nullable_to_non_nullable
                      as int?,
            sleepHours: freezed == sleepHours
                ? _value.sleepHours
                : sleepHours // ignore: cast_nullable_to_non_nullable
                      as num?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            raw: null == raw
                ? _value.raw
                : raw // ignore: cast_nullable_to_non_nullable
                      as Map<String, Object?>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityReflectionEntryImplCopyWith<$Res>
    implements $ActivityReflectionEntryCopyWith<$Res> {
  factory _$$ActivityReflectionEntryImplCopyWith(
    _$ActivityReflectionEntryImpl value,
    $Res Function(_$ActivityReflectionEntryImpl) then,
  ) = __$$ActivityReflectionEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime createdAt,
    int? effectiveness,
    num? sleepHours,
    String? notes,
    Map<String, Object?> raw,
  });
}

/// @nodoc
class __$$ActivityReflectionEntryImplCopyWithImpl<$Res>
    extends
        _$ActivityReflectionEntryCopyWithImpl<
          $Res,
          _$ActivityReflectionEntryImpl
        >
    implements _$$ActivityReflectionEntryImplCopyWith<$Res> {
  __$$ActivityReflectionEntryImplCopyWithImpl(
    _$ActivityReflectionEntryImpl _value,
    $Res Function(_$ActivityReflectionEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityReflectionEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? effectiveness = freezed,
    Object? sleepHours = freezed,
    Object? notes = freezed,
    Object? raw = null,
  }) {
    return _then(
      _$ActivityReflectionEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        effectiveness: freezed == effectiveness
            ? _value.effectiveness
            : effectiveness // ignore: cast_nullable_to_non_nullable
                  as int?,
        sleepHours: freezed == sleepHours
            ? _value.sleepHours
            : sleepHours // ignore: cast_nullable_to_non_nullable
                  as num?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        raw: null == raw
            ? _value._raw
            : raw // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityReflectionEntryImpl implements _ActivityReflectionEntry {
  const _$ActivityReflectionEntryImpl({
    required this.id,
    required this.createdAt,
    this.effectiveness,
    this.sleepHours,
    this.notes,
    final Map<String, Object?> raw = const <String, Object?>{},
  }) : _raw = raw;

  factory _$ActivityReflectionEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityReflectionEntryImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final int? effectiveness;
  @override
  final num? sleepHours;
  @override
  final String? notes;
  final Map<String, Object?> _raw;
  @override
  @JsonKey()
  Map<String, Object?> get raw {
    if (_raw is EqualUnmodifiableMapView) return _raw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_raw);
  }

  @override
  String toString() {
    return 'ActivityReflectionEntry(id: $id, createdAt: $createdAt, effectiveness: $effectiveness, sleepHours: $sleepHours, notes: $notes, raw: $raw)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityReflectionEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.effectiveness, effectiveness) ||
                other.effectiveness == effectiveness) &&
            (identical(other.sleepHours, sleepHours) ||
                other.sleepHours == sleepHours) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._raw, _raw));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    createdAt,
    effectiveness,
    sleepHours,
    notes,
    const DeepCollectionEquality().hash(_raw),
  );

  /// Create a copy of ActivityReflectionEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityReflectionEntryImplCopyWith<_$ActivityReflectionEntryImpl>
  get copyWith =>
      __$$ActivityReflectionEntryImplCopyWithImpl<
        _$ActivityReflectionEntryImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityReflectionEntryImplToJson(this);
  }
}

abstract class _ActivityReflectionEntry implements ActivityReflectionEntry {
  const factory _ActivityReflectionEntry({
    required final String id,
    required final DateTime createdAt,
    final int? effectiveness,
    final num? sleepHours,
    final String? notes,
    final Map<String, Object?> raw,
  }) = _$ActivityReflectionEntryImpl;

  factory _ActivityReflectionEntry.fromJson(Map<String, dynamic> json) =
      _$ActivityReflectionEntryImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  int? get effectiveness;
  @override
  num? get sleepHours;
  @override
  String? get notes;
  @override
  Map<String, Object?> get raw;

  /// Create a copy of ActivityReflectionEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityReflectionEntryImplCopyWith<_$ActivityReflectionEntryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
