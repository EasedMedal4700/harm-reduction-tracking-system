// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blood_levels_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DoseEntry {
  double get dose => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  double get remaining => throw _privateConstructorUsedError;
  double get hoursElapsed => throw _privateConstructorUsedError;
  double get percentRemaining => throw _privateConstructorUsedError;

  /// Create a copy of DoseEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DoseEntryCopyWith<DoseEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoseEntryCopyWith<$Res> {
  factory $DoseEntryCopyWith(DoseEntry value, $Res Function(DoseEntry) then) =
      _$DoseEntryCopyWithImpl<$Res, DoseEntry>;
  @useResult
  $Res call({
    double dose,
    DateTime startTime,
    double remaining,
    double hoursElapsed,
    double percentRemaining,
  });
}

/// @nodoc
class _$DoseEntryCopyWithImpl<$Res, $Val extends DoseEntry>
    implements $DoseEntryCopyWith<$Res> {
  _$DoseEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DoseEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dose = null,
    Object? startTime = null,
    Object? remaining = null,
    Object? hoursElapsed = null,
    Object? percentRemaining = null,
  }) {
    return _then(
      _value.copyWith(
            dose: null == dose
                ? _value.dose
                : dose // ignore: cast_nullable_to_non_nullable
                      as double,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            remaining: null == remaining
                ? _value.remaining
                : remaining // ignore: cast_nullable_to_non_nullable
                      as double,
            hoursElapsed: null == hoursElapsed
                ? _value.hoursElapsed
                : hoursElapsed // ignore: cast_nullable_to_non_nullable
                      as double,
            percentRemaining: null == percentRemaining
                ? _value.percentRemaining
                : percentRemaining // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DoseEntryImplCopyWith<$Res>
    implements $DoseEntryCopyWith<$Res> {
  factory _$$DoseEntryImplCopyWith(
    _$DoseEntryImpl value,
    $Res Function(_$DoseEntryImpl) then,
  ) = __$$DoseEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double dose,
    DateTime startTime,
    double remaining,
    double hoursElapsed,
    double percentRemaining,
  });
}

/// @nodoc
class __$$DoseEntryImplCopyWithImpl<$Res>
    extends _$DoseEntryCopyWithImpl<$Res, _$DoseEntryImpl>
    implements _$$DoseEntryImplCopyWith<$Res> {
  __$$DoseEntryImplCopyWithImpl(
    _$DoseEntryImpl _value,
    $Res Function(_$DoseEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoseEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dose = null,
    Object? startTime = null,
    Object? remaining = null,
    Object? hoursElapsed = null,
    Object? percentRemaining = null,
  }) {
    return _then(
      _$DoseEntryImpl(
        dose: null == dose
            ? _value.dose
            : dose // ignore: cast_nullable_to_non_nullable
                  as double,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        remaining: null == remaining
            ? _value.remaining
            : remaining // ignore: cast_nullable_to_non_nullable
                  as double,
        hoursElapsed: null == hoursElapsed
            ? _value.hoursElapsed
            : hoursElapsed // ignore: cast_nullable_to_non_nullable
                  as double,
        percentRemaining: null == percentRemaining
            ? _value.percentRemaining
            : percentRemaining // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$DoseEntryImpl implements _DoseEntry {
  const _$DoseEntryImpl({
    required this.dose,
    required this.startTime,
    required this.remaining,
    required this.hoursElapsed,
    this.percentRemaining = 0.0,
  });

  @override
  final double dose;
  @override
  final DateTime startTime;
  @override
  final double remaining;
  @override
  final double hoursElapsed;
  @override
  @JsonKey()
  final double percentRemaining;

  @override
  String toString() {
    return 'DoseEntry(dose: $dose, startTime: $startTime, remaining: $remaining, hoursElapsed: $hoursElapsed, percentRemaining: $percentRemaining)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoseEntryImpl &&
            (identical(other.dose, dose) || other.dose == dose) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.hoursElapsed, hoursElapsed) ||
                other.hoursElapsed == hoursElapsed) &&
            (identical(other.percentRemaining, percentRemaining) ||
                other.percentRemaining == percentRemaining));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    dose,
    startTime,
    remaining,
    hoursElapsed,
    percentRemaining,
  );

  /// Create a copy of DoseEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoseEntryImplCopyWith<_$DoseEntryImpl> get copyWith =>
      __$$DoseEntryImplCopyWithImpl<_$DoseEntryImpl>(this, _$identity);
}

abstract class _DoseEntry implements DoseEntry {
  const factory _DoseEntry({
    required final double dose,
    required final DateTime startTime,
    required final double remaining,
    required final double hoursElapsed,
    final double percentRemaining,
  }) = _$DoseEntryImpl;

  @override
  double get dose;
  @override
  DateTime get startTime;
  @override
  double get remaining;
  @override
  double get hoursElapsed;
  @override
  double get percentRemaining;

  /// Create a copy of DoseEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoseEntryImplCopyWith<_$DoseEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DrugLevel {
  String get drugName => throw _privateConstructorUsedError;
  double get totalDose => throw _privateConstructorUsedError;
  double get totalRemaining => throw _privateConstructorUsedError;
  double get lastDose => throw _privateConstructorUsedError;
  DateTime get lastUse => throw _privateConstructorUsedError;
  double get halfLife => throw _privateConstructorUsedError;
  List<DoseEntry> get doses => throw _privateConstructorUsedError;
  double get activeWindow => throw _privateConstructorUsedError;
  double get maxDuration => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  Map<String, dynamic>? get formattedDose => throw _privateConstructorUsedError;

  /// Create a copy of DrugLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DrugLevelCopyWith<DrugLevel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrugLevelCopyWith<$Res> {
  factory $DrugLevelCopyWith(DrugLevel value, $Res Function(DrugLevel) then) =
      _$DrugLevelCopyWithImpl<$Res, DrugLevel>;
  @useResult
  $Res call({
    String drugName,
    double totalDose,
    double totalRemaining,
    double lastDose,
    DateTime lastUse,
    double halfLife,
    List<DoseEntry> doses,
    double activeWindow,
    double maxDuration,
    List<String> categories,
    Map<String, dynamic>? formattedDose,
  });
}

/// @nodoc
class _$DrugLevelCopyWithImpl<$Res, $Val extends DrugLevel>
    implements $DrugLevelCopyWith<$Res> {
  _$DrugLevelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DrugLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drugName = null,
    Object? totalDose = null,
    Object? totalRemaining = null,
    Object? lastDose = null,
    Object? lastUse = null,
    Object? halfLife = null,
    Object? doses = null,
    Object? activeWindow = null,
    Object? maxDuration = null,
    Object? categories = null,
    Object? formattedDose = freezed,
  }) {
    return _then(
      _value.copyWith(
            drugName: null == drugName
                ? _value.drugName
                : drugName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalDose: null == totalDose
                ? _value.totalDose
                : totalDose // ignore: cast_nullable_to_non_nullable
                      as double,
            totalRemaining: null == totalRemaining
                ? _value.totalRemaining
                : totalRemaining // ignore: cast_nullable_to_non_nullable
                      as double,
            lastDose: null == lastDose
                ? _value.lastDose
                : lastDose // ignore: cast_nullable_to_non_nullable
                      as double,
            lastUse: null == lastUse
                ? _value.lastUse
                : lastUse // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            halfLife: null == halfLife
                ? _value.halfLife
                : halfLife // ignore: cast_nullable_to_non_nullable
                      as double,
            doses: null == doses
                ? _value.doses
                : doses // ignore: cast_nullable_to_non_nullable
                      as List<DoseEntry>,
            activeWindow: null == activeWindow
                ? _value.activeWindow
                : activeWindow // ignore: cast_nullable_to_non_nullable
                      as double,
            maxDuration: null == maxDuration
                ? _value.maxDuration
                : maxDuration // ignore: cast_nullable_to_non_nullable
                      as double,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            formattedDose: freezed == formattedDose
                ? _value.formattedDose
                : formattedDose // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DrugLevelImplCopyWith<$Res>
    implements $DrugLevelCopyWith<$Res> {
  factory _$$DrugLevelImplCopyWith(
    _$DrugLevelImpl value,
    $Res Function(_$DrugLevelImpl) then,
  ) = __$$DrugLevelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String drugName,
    double totalDose,
    double totalRemaining,
    double lastDose,
    DateTime lastUse,
    double halfLife,
    List<DoseEntry> doses,
    double activeWindow,
    double maxDuration,
    List<String> categories,
    Map<String, dynamic>? formattedDose,
  });
}

/// @nodoc
class __$$DrugLevelImplCopyWithImpl<$Res>
    extends _$DrugLevelCopyWithImpl<$Res, _$DrugLevelImpl>
    implements _$$DrugLevelImplCopyWith<$Res> {
  __$$DrugLevelImplCopyWithImpl(
    _$DrugLevelImpl _value,
    $Res Function(_$DrugLevelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DrugLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drugName = null,
    Object? totalDose = null,
    Object? totalRemaining = null,
    Object? lastDose = null,
    Object? lastUse = null,
    Object? halfLife = null,
    Object? doses = null,
    Object? activeWindow = null,
    Object? maxDuration = null,
    Object? categories = null,
    Object? formattedDose = freezed,
  }) {
    return _then(
      _$DrugLevelImpl(
        drugName: null == drugName
            ? _value.drugName
            : drugName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalDose: null == totalDose
            ? _value.totalDose
            : totalDose // ignore: cast_nullable_to_non_nullable
                  as double,
        totalRemaining: null == totalRemaining
            ? _value.totalRemaining
            : totalRemaining // ignore: cast_nullable_to_non_nullable
                  as double,
        lastDose: null == lastDose
            ? _value.lastDose
            : lastDose // ignore: cast_nullable_to_non_nullable
                  as double,
        lastUse: null == lastUse
            ? _value.lastUse
            : lastUse // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        halfLife: null == halfLife
            ? _value.halfLife
            : halfLife // ignore: cast_nullable_to_non_nullable
                  as double,
        doses: null == doses
            ? _value._doses
            : doses // ignore: cast_nullable_to_non_nullable
                  as List<DoseEntry>,
        activeWindow: null == activeWindow
            ? _value.activeWindow
            : activeWindow // ignore: cast_nullable_to_non_nullable
                  as double,
        maxDuration: null == maxDuration
            ? _value.maxDuration
            : maxDuration // ignore: cast_nullable_to_non_nullable
                  as double,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        formattedDose: freezed == formattedDose
            ? _value._formattedDose
            : formattedDose // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$DrugLevelImpl extends _DrugLevel {
  const _$DrugLevelImpl({
    required this.drugName,
    required this.totalDose,
    required this.totalRemaining,
    required this.lastDose,
    required this.lastUse,
    required this.halfLife,
    required final List<DoseEntry> doses,
    this.activeWindow = 8.0,
    this.maxDuration = 6.0,
    final List<String> categories = const <String>[],
    final Map<String, dynamic>? formattedDose,
  }) : _doses = doses,
       _categories = categories,
       _formattedDose = formattedDose,
       super._();

  @override
  final String drugName;
  @override
  final double totalDose;
  @override
  final double totalRemaining;
  @override
  final double lastDose;
  @override
  final DateTime lastUse;
  @override
  final double halfLife;
  final List<DoseEntry> _doses;
  @override
  List<DoseEntry> get doses {
    if (_doses is EqualUnmodifiableListView) return _doses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_doses);
  }

  @override
  @JsonKey()
  final double activeWindow;
  @override
  @JsonKey()
  final double maxDuration;
  final List<String> _categories;
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final Map<String, dynamic>? _formattedDose;
  @override
  Map<String, dynamic>? get formattedDose {
    final value = _formattedDose;
    if (value == null) return null;
    if (_formattedDose is EqualUnmodifiableMapView) return _formattedDose;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'DrugLevel(drugName: $drugName, totalDose: $totalDose, totalRemaining: $totalRemaining, lastDose: $lastDose, lastUse: $lastUse, halfLife: $halfLife, doses: $doses, activeWindow: $activeWindow, maxDuration: $maxDuration, categories: $categories, formattedDose: $formattedDose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrugLevelImpl &&
            (identical(other.drugName, drugName) ||
                other.drugName == drugName) &&
            (identical(other.totalDose, totalDose) ||
                other.totalDose == totalDose) &&
            (identical(other.totalRemaining, totalRemaining) ||
                other.totalRemaining == totalRemaining) &&
            (identical(other.lastDose, lastDose) ||
                other.lastDose == lastDose) &&
            (identical(other.lastUse, lastUse) || other.lastUse == lastUse) &&
            (identical(other.halfLife, halfLife) ||
                other.halfLife == halfLife) &&
            const DeepCollectionEquality().equals(other._doses, _doses) &&
            (identical(other.activeWindow, activeWindow) ||
                other.activeWindow == activeWindow) &&
            (identical(other.maxDuration, maxDuration) ||
                other.maxDuration == maxDuration) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(
              other._formattedDose,
              _formattedDose,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    drugName,
    totalDose,
    totalRemaining,
    lastDose,
    lastUse,
    halfLife,
    const DeepCollectionEquality().hash(_doses),
    activeWindow,
    maxDuration,
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_formattedDose),
  );

  /// Create a copy of DrugLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DrugLevelImplCopyWith<_$DrugLevelImpl> get copyWith =>
      __$$DrugLevelImplCopyWithImpl<_$DrugLevelImpl>(this, _$identity);
}

abstract class _DrugLevel extends DrugLevel {
  const factory _DrugLevel({
    required final String drugName,
    required final double totalDose,
    required final double totalRemaining,
    required final double lastDose,
    required final DateTime lastUse,
    required final double halfLife,
    required final List<DoseEntry> doses,
    final double activeWindow,
    final double maxDuration,
    final List<String> categories,
    final Map<String, dynamic>? formattedDose,
  }) = _$DrugLevelImpl;
  const _DrugLevel._() : super._();

  @override
  String get drugName;
  @override
  double get totalDose;
  @override
  double get totalRemaining;
  @override
  double get lastDose;
  @override
  DateTime get lastUse;
  @override
  double get halfLife;
  @override
  List<DoseEntry> get doses;
  @override
  double get activeWindow;
  @override
  double get maxDuration;
  @override
  List<String> get categories;
  @override
  Map<String, dynamic>? get formattedDose;

  /// Create a copy of DrugLevel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DrugLevelImplCopyWith<_$DrugLevelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
