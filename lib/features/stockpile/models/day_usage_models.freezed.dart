// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_usage_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DayUsageEntry {
  DateTime get startTime => throw _privateConstructorUsedError;
  String get dose => throw _privateConstructorUsedError;
  String get route => throw _privateConstructorUsedError;
  bool get isMedical => throw _privateConstructorUsedError;

  /// Create a copy of DayUsageEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayUsageEntryCopyWith<DayUsageEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayUsageEntryCopyWith<$Res> {
  factory $DayUsageEntryCopyWith(
    DayUsageEntry value,
    $Res Function(DayUsageEntry) then,
  ) = _$DayUsageEntryCopyWithImpl<$Res, DayUsageEntry>;
  @useResult
  $Res call({DateTime startTime, String dose, String route, bool isMedical});
}

/// @nodoc
class _$DayUsageEntryCopyWithImpl<$Res, $Val extends DayUsageEntry>
    implements $DayUsageEntryCopyWith<$Res> {
  _$DayUsageEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayUsageEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? dose = null,
    Object? route = null,
    Object? isMedical = null,
  }) {
    return _then(
      _value.copyWith(
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dose: null == dose
                ? _value.dose
                : dose // ignore: cast_nullable_to_non_nullable
                      as String,
            route: null == route
                ? _value.route
                : route // ignore: cast_nullable_to_non_nullable
                      as String,
            isMedical: null == isMedical
                ? _value.isMedical
                : isMedical // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DayUsageEntryImplCopyWith<$Res>
    implements $DayUsageEntryCopyWith<$Res> {
  factory _$$DayUsageEntryImplCopyWith(
    _$DayUsageEntryImpl value,
    $Res Function(_$DayUsageEntryImpl) then,
  ) = __$$DayUsageEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime startTime, String dose, String route, bool isMedical});
}

/// @nodoc
class __$$DayUsageEntryImplCopyWithImpl<$Res>
    extends _$DayUsageEntryCopyWithImpl<$Res, _$DayUsageEntryImpl>
    implements _$$DayUsageEntryImplCopyWith<$Res> {
  __$$DayUsageEntryImplCopyWithImpl(
    _$DayUsageEntryImpl _value,
    $Res Function(_$DayUsageEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DayUsageEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? dose = null,
    Object? route = null,
    Object? isMedical = null,
  }) {
    return _then(
      _$DayUsageEntryImpl(
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dose: null == dose
            ? _value.dose
            : dose // ignore: cast_nullable_to_non_nullable
                  as String,
        route: null == route
            ? _value.route
            : route // ignore: cast_nullable_to_non_nullable
                  as String,
        isMedical: null == isMedical
            ? _value.isMedical
            : isMedical // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$DayUsageEntryImpl extends _DayUsageEntry {
  const _$DayUsageEntryImpl({
    required this.startTime,
    required this.dose,
    required this.route,
    required this.isMedical,
  }) : super._();

  @override
  final DateTime startTime;
  @override
  final String dose;
  @override
  final String route;
  @override
  final bool isMedical;

  @override
  String toString() {
    return 'DayUsageEntry(startTime: $startTime, dose: $dose, route: $route, isMedical: $isMedical)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayUsageEntryImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.dose, dose) || other.dose == dose) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.isMedical, isMedical) ||
                other.isMedical == isMedical));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, startTime, dose, route, isMedical);

  /// Create a copy of DayUsageEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayUsageEntryImplCopyWith<_$DayUsageEntryImpl> get copyWith =>
      __$$DayUsageEntryImplCopyWithImpl<_$DayUsageEntryImpl>(this, _$identity);
}

abstract class _DayUsageEntry extends DayUsageEntry {
  const factory _DayUsageEntry({
    required final DateTime startTime,
    required final String dose,
    required final String route,
    required final bool isMedical,
  }) = _$DayUsageEntryImpl;
  const _DayUsageEntry._() : super._();

  @override
  DateTime get startTime;
  @override
  String get dose;
  @override
  String get route;
  @override
  bool get isMedical;

  /// Create a copy of DayUsageEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayUsageEntryImplCopyWith<_$DayUsageEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
