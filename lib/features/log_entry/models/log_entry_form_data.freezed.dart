// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_entry_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LogEntryFormData {
  bool get isSimpleMode => throw _privateConstructorUsedError;
  double get dose => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get substance => throw _privateConstructorUsedError;
  String get route => throw _privateConstructorUsedError;
  List<String> get feelings => throw _privateConstructorUsedError;
  Map<String, List<String>> get secondaryFeelings =>
      throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  bool get isMedicalPurpose => throw _privateConstructorUsedError;
  double get cravingIntensity => throw _privateConstructorUsedError;
  String? get intention => throw _privateConstructorUsedError;
  List<String> get triggers => throw _privateConstructorUsedError;
  List<String> get bodySignals => throw _privateConstructorUsedError;
  String get entryId =>
      throw _privateConstructorUsedError; // Substance details for ROA validation (loaded from DB)
  Map<String, dynamic>? get substanceDetails =>
      throw _privateConstructorUsedError;

  /// Create a copy of LogEntryFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogEntryFormDataCopyWith<LogEntryFormData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogEntryFormDataCopyWith<$Res> {
  factory $LogEntryFormDataCopyWith(
    LogEntryFormData value,
    $Res Function(LogEntryFormData) then,
  ) = _$LogEntryFormDataCopyWithImpl<$Res, LogEntryFormData>;
  @useResult
  $Res call({
    bool isSimpleMode,
    double dose,
    String unit,
    String substance,
    String route,
    List<String> feelings,
    Map<String, List<String>> secondaryFeelings,
    String location,
    DateTime date,
    int hour,
    int minute,
    String notes,
    bool isMedicalPurpose,
    double cravingIntensity,
    String? intention,
    List<String> triggers,
    List<String> bodySignals,
    String entryId,
    Map<String, dynamic>? substanceDetails,
  });
}

/// @nodoc
class _$LogEntryFormDataCopyWithImpl<$Res, $Val extends LogEntryFormData>
    implements $LogEntryFormDataCopyWith<$Res> {
  _$LogEntryFormDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogEntryFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSimpleMode = null,
    Object? dose = null,
    Object? unit = null,
    Object? substance = null,
    Object? route = null,
    Object? feelings = null,
    Object? secondaryFeelings = null,
    Object? location = null,
    Object? date = null,
    Object? hour = null,
    Object? minute = null,
    Object? notes = null,
    Object? isMedicalPurpose = null,
    Object? cravingIntensity = null,
    Object? intention = freezed,
    Object? triggers = null,
    Object? bodySignals = null,
    Object? entryId = null,
    Object? substanceDetails = freezed,
  }) {
    return _then(
      _value.copyWith(
            isSimpleMode: null == isSimpleMode
                ? _value.isSimpleMode
                : isSimpleMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            dose: null == dose
                ? _value.dose
                : dose // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            substance: null == substance
                ? _value.substance
                : substance // ignore: cast_nullable_to_non_nullable
                      as String,
            route: null == route
                ? _value.route
                : route // ignore: cast_nullable_to_non_nullable
                      as String,
            feelings: null == feelings
                ? _value.feelings
                : feelings // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            secondaryFeelings: null == secondaryFeelings
                ? _value.secondaryFeelings
                : secondaryFeelings // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<String>>,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            hour: null == hour
                ? _value.hour
                : hour // ignore: cast_nullable_to_non_nullable
                      as int,
            minute: null == minute
                ? _value.minute
                : minute // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
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
            triggers: null == triggers
                ? _value.triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            bodySignals: null == bodySignals
                ? _value.bodySignals
                : bodySignals // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            entryId: null == entryId
                ? _value.entryId
                : entryId // ignore: cast_nullable_to_non_nullable
                      as String,
            substanceDetails: freezed == substanceDetails
                ? _value.substanceDetails
                : substanceDetails // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogEntryFormDataImplCopyWith<$Res>
    implements $LogEntryFormDataCopyWith<$Res> {
  factory _$$LogEntryFormDataImplCopyWith(
    _$LogEntryFormDataImpl value,
    $Res Function(_$LogEntryFormDataImpl) then,
  ) = __$$LogEntryFormDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isSimpleMode,
    double dose,
    String unit,
    String substance,
    String route,
    List<String> feelings,
    Map<String, List<String>> secondaryFeelings,
    String location,
    DateTime date,
    int hour,
    int minute,
    String notes,
    bool isMedicalPurpose,
    double cravingIntensity,
    String? intention,
    List<String> triggers,
    List<String> bodySignals,
    String entryId,
    Map<String, dynamic>? substanceDetails,
  });
}

/// @nodoc
class __$$LogEntryFormDataImplCopyWithImpl<$Res>
    extends _$LogEntryFormDataCopyWithImpl<$Res, _$LogEntryFormDataImpl>
    implements _$$LogEntryFormDataImplCopyWith<$Res> {
  __$$LogEntryFormDataImplCopyWithImpl(
    _$LogEntryFormDataImpl _value,
    $Res Function(_$LogEntryFormDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogEntryFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSimpleMode = null,
    Object? dose = null,
    Object? unit = null,
    Object? substance = null,
    Object? route = null,
    Object? feelings = null,
    Object? secondaryFeelings = null,
    Object? location = null,
    Object? date = null,
    Object? hour = null,
    Object? minute = null,
    Object? notes = null,
    Object? isMedicalPurpose = null,
    Object? cravingIntensity = null,
    Object? intention = freezed,
    Object? triggers = null,
    Object? bodySignals = null,
    Object? entryId = null,
    Object? substanceDetails = freezed,
  }) {
    return _then(
      _$LogEntryFormDataImpl(
        isSimpleMode: null == isSimpleMode
            ? _value.isSimpleMode
            : isSimpleMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        dose: null == dose
            ? _value.dose
            : dose // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        substance: null == substance
            ? _value.substance
            : substance // ignore: cast_nullable_to_non_nullable
                  as String,
        route: null == route
            ? _value.route
            : route // ignore: cast_nullable_to_non_nullable
                  as String,
        feelings: null == feelings
            ? _value._feelings
            : feelings // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        secondaryFeelings: null == secondaryFeelings
            ? _value._secondaryFeelings
            : secondaryFeelings // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        hour: null == hour
            ? _value.hour
            : hour // ignore: cast_nullable_to_non_nullable
                  as int,
        minute: null == minute
            ? _value.minute
            : minute // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
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
        triggers: null == triggers
            ? _value._triggers
            : triggers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        bodySignals: null == bodySignals
            ? _value._bodySignals
            : bodySignals // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        entryId: null == entryId
            ? _value.entryId
            : entryId // ignore: cast_nullable_to_non_nullable
                  as String,
        substanceDetails: freezed == substanceDetails
            ? _value._substanceDetails
            : substanceDetails // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$LogEntryFormDataImpl extends _LogEntryFormData {
  const _$LogEntryFormDataImpl({
    this.isSimpleMode = true,
    this.dose = 0,
    this.unit = 'mg',
    this.substance = '',
    this.route = 'oral',
    final List<String> feelings = const [],
    final Map<String, List<String>> secondaryFeelings = const {},
    this.location = '',
    required this.date,
    required this.hour,
    required this.minute,
    this.notes = '',
    this.isMedicalPurpose = false,
    this.cravingIntensity = 0,
    this.intention,
    final List<String> triggers = const [],
    final List<String> bodySignals = const [],
    this.entryId = '',
    final Map<String, dynamic>? substanceDetails,
  }) : _feelings = feelings,
       _secondaryFeelings = secondaryFeelings,
       _triggers = triggers,
       _bodySignals = bodySignals,
       _substanceDetails = substanceDetails,
       super._();

  @override
  @JsonKey()
  final bool isSimpleMode;
  @override
  @JsonKey()
  final double dose;
  @override
  @JsonKey()
  final String unit;
  @override
  @JsonKey()
  final String substance;
  @override
  @JsonKey()
  final String route;
  final List<String> _feelings;
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

  @override
  @JsonKey()
  final String location;
  @override
  final DateTime date;
  @override
  final int hour;
  @override
  final int minute;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final bool isMedicalPurpose;
  @override
  @JsonKey()
  final double cravingIntensity;
  @override
  final String? intention;
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
  final String entryId;
  // Substance details for ROA validation (loaded from DB)
  final Map<String, dynamic>? _substanceDetails;
  // Substance details for ROA validation (loaded from DB)
  @override
  Map<String, dynamic>? get substanceDetails {
    final value = _substanceDetails;
    if (value == null) return null;
    if (_substanceDetails is EqualUnmodifiableMapView) return _substanceDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'LogEntryFormData(isSimpleMode: $isSimpleMode, dose: $dose, unit: $unit, substance: $substance, route: $route, feelings: $feelings, secondaryFeelings: $secondaryFeelings, location: $location, date: $date, hour: $hour, minute: $minute, notes: $notes, isMedicalPurpose: $isMedicalPurpose, cravingIntensity: $cravingIntensity, intention: $intention, triggers: $triggers, bodySignals: $bodySignals, entryId: $entryId, substanceDetails: $substanceDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogEntryFormDataImpl &&
            (identical(other.isSimpleMode, isSimpleMode) ||
                other.isSimpleMode == isSimpleMode) &&
            (identical(other.dose, dose) || other.dose == dose) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.substance, substance) ||
                other.substance == substance) &&
            (identical(other.route, route) || other.route == route) &&
            const DeepCollectionEquality().equals(other._feelings, _feelings) &&
            const DeepCollectionEquality().equals(
              other._secondaryFeelings,
              _secondaryFeelings,
            ) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isMedicalPurpose, isMedicalPurpose) ||
                other.isMedicalPurpose == isMedicalPurpose) &&
            (identical(other.cravingIntensity, cravingIntensity) ||
                other.cravingIntensity == cravingIntensity) &&
            (identical(other.intention, intention) ||
                other.intention == intention) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            const DeepCollectionEquality().equals(
              other._bodySignals,
              _bodySignals,
            ) &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            const DeepCollectionEquality().equals(
              other._substanceDetails,
              _substanceDetails,
            ));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    isSimpleMode,
    dose,
    unit,
    substance,
    route,
    const DeepCollectionEquality().hash(_feelings),
    const DeepCollectionEquality().hash(_secondaryFeelings),
    location,
    date,
    hour,
    minute,
    notes,
    isMedicalPurpose,
    cravingIntensity,
    intention,
    const DeepCollectionEquality().hash(_triggers),
    const DeepCollectionEquality().hash(_bodySignals),
    entryId,
    const DeepCollectionEquality().hash(_substanceDetails),
  ]);

  /// Create a copy of LogEntryFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogEntryFormDataImplCopyWith<_$LogEntryFormDataImpl> get copyWith =>
      __$$LogEntryFormDataImplCopyWithImpl<_$LogEntryFormDataImpl>(
        this,
        _$identity,
      );
}

abstract class _LogEntryFormData extends LogEntryFormData {
  const factory _LogEntryFormData({
    final bool isSimpleMode,
    final double dose,
    final String unit,
    final String substance,
    final String route,
    final List<String> feelings,
    final Map<String, List<String>> secondaryFeelings,
    final String location,
    required final DateTime date,
    required final int hour,
    required final int minute,
    final String notes,
    final bool isMedicalPurpose,
    final double cravingIntensity,
    final String? intention,
    final List<String> triggers,
    final List<String> bodySignals,
    final String entryId,
    final Map<String, dynamic>? substanceDetails,
  }) = _$LogEntryFormDataImpl;
  const _LogEntryFormData._() : super._();

  @override
  bool get isSimpleMode;
  @override
  double get dose;
  @override
  String get unit;
  @override
  String get substance;
  @override
  String get route;
  @override
  List<String> get feelings;
  @override
  Map<String, List<String>> get secondaryFeelings;
  @override
  String get location;
  @override
  DateTime get date;
  @override
  int get hour;
  @override
  int get minute;
  @override
  String get notes;
  @override
  bool get isMedicalPurpose;
  @override
  double get cravingIntensity;
  @override
  String? get intention;
  @override
  List<String> get triggers;
  @override
  List<String> get bodySignals;
  @override
  String get entryId; // Substance details for ROA validation (loaded from DB)
  @override
  Map<String, dynamic>? get substanceDetails;

  /// Create a copy of LogEntryFormData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogEntryFormDataImplCopyWith<_$LogEntryFormDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
