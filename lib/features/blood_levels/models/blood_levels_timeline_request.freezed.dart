// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blood_levels_timeline_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BloodLevelsTimelineRequest {
  List<String> get drugNames => throw _privateConstructorUsedError;
  DateTime get referenceTime => throw _privateConstructorUsedError;
  int get hoursBack => throw _privateConstructorUsedError;
  int get hoursForward => throw _privateConstructorUsedError;

  /// Create a copy of BloodLevelsTimelineRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BloodLevelsTimelineRequestCopyWith<BloodLevelsTimelineRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BloodLevelsTimelineRequestCopyWith<$Res> {
  factory $BloodLevelsTimelineRequestCopyWith(
    BloodLevelsTimelineRequest value,
    $Res Function(BloodLevelsTimelineRequest) then,
  ) =
      _$BloodLevelsTimelineRequestCopyWithImpl<
        $Res,
        BloodLevelsTimelineRequest
      >;
  @useResult
  $Res call({
    List<String> drugNames,
    DateTime referenceTime,
    int hoursBack,
    int hoursForward,
  });
}

/// @nodoc
class _$BloodLevelsTimelineRequestCopyWithImpl<
  $Res,
  $Val extends BloodLevelsTimelineRequest
>
    implements $BloodLevelsTimelineRequestCopyWith<$Res> {
  _$BloodLevelsTimelineRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BloodLevelsTimelineRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drugNames = null,
    Object? referenceTime = null,
    Object? hoursBack = null,
    Object? hoursForward = null,
  }) {
    return _then(
      _value.copyWith(
            drugNames: null == drugNames
                ? _value.drugNames
                : drugNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            referenceTime: null == referenceTime
                ? _value.referenceTime
                : referenceTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            hoursBack: null == hoursBack
                ? _value.hoursBack
                : hoursBack // ignore: cast_nullable_to_non_nullable
                      as int,
            hoursForward: null == hoursForward
                ? _value.hoursForward
                : hoursForward // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BloodLevelsTimelineRequestImplCopyWith<$Res>
    implements $BloodLevelsTimelineRequestCopyWith<$Res> {
  factory _$$BloodLevelsTimelineRequestImplCopyWith(
    _$BloodLevelsTimelineRequestImpl value,
    $Res Function(_$BloodLevelsTimelineRequestImpl) then,
  ) = __$$BloodLevelsTimelineRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> drugNames,
    DateTime referenceTime,
    int hoursBack,
    int hoursForward,
  });
}

/// @nodoc
class __$$BloodLevelsTimelineRequestImplCopyWithImpl<$Res>
    extends
        _$BloodLevelsTimelineRequestCopyWithImpl<
          $Res,
          _$BloodLevelsTimelineRequestImpl
        >
    implements _$$BloodLevelsTimelineRequestImplCopyWith<$Res> {
  __$$BloodLevelsTimelineRequestImplCopyWithImpl(
    _$BloodLevelsTimelineRequestImpl _value,
    $Res Function(_$BloodLevelsTimelineRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BloodLevelsTimelineRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drugNames = null,
    Object? referenceTime = null,
    Object? hoursBack = null,
    Object? hoursForward = null,
  }) {
    return _then(
      _$BloodLevelsTimelineRequestImpl(
        drugNames: null == drugNames
            ? _value._drugNames
            : drugNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        referenceTime: null == referenceTime
            ? _value.referenceTime
            : referenceTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        hoursBack: null == hoursBack
            ? _value.hoursBack
            : hoursBack // ignore: cast_nullable_to_non_nullable
                  as int,
        hoursForward: null == hoursForward
            ? _value.hoursForward
            : hoursForward // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$BloodLevelsTimelineRequestImpl implements _BloodLevelsTimelineRequest {
  const _$BloodLevelsTimelineRequestImpl({
    required final List<String> drugNames,
    required this.referenceTime,
    required this.hoursBack,
    required this.hoursForward,
  }) : _drugNames = drugNames;

  final List<String> _drugNames;
  @override
  List<String> get drugNames {
    if (_drugNames is EqualUnmodifiableListView) return _drugNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_drugNames);
  }

  @override
  final DateTime referenceTime;
  @override
  final int hoursBack;
  @override
  final int hoursForward;

  @override
  String toString() {
    return 'BloodLevelsTimelineRequest(drugNames: $drugNames, referenceTime: $referenceTime, hoursBack: $hoursBack, hoursForward: $hoursForward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BloodLevelsTimelineRequestImpl &&
            const DeepCollectionEquality().equals(
              other._drugNames,
              _drugNames,
            ) &&
            (identical(other.referenceTime, referenceTime) ||
                other.referenceTime == referenceTime) &&
            (identical(other.hoursBack, hoursBack) ||
                other.hoursBack == hoursBack) &&
            (identical(other.hoursForward, hoursForward) ||
                other.hoursForward == hoursForward));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_drugNames),
    referenceTime,
    hoursBack,
    hoursForward,
  );

  /// Create a copy of BloodLevelsTimelineRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BloodLevelsTimelineRequestImplCopyWith<_$BloodLevelsTimelineRequestImpl>
  get copyWith =>
      __$$BloodLevelsTimelineRequestImplCopyWithImpl<
        _$BloodLevelsTimelineRequestImpl
      >(this, _$identity);
}

abstract class _BloodLevelsTimelineRequest
    implements BloodLevelsTimelineRequest {
  const factory _BloodLevelsTimelineRequest({
    required final List<String> drugNames,
    required final DateTime referenceTime,
    required final int hoursBack,
    required final int hoursForward,
  }) = _$BloodLevelsTimelineRequestImpl;

  @override
  List<String> get drugNames;
  @override
  DateTime get referenceTime;
  @override
  int get hoursBack;
  @override
  int get hoursForward;

  /// Create a copy of BloodLevelsTimelineRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BloodLevelsTimelineRequestImplCopyWith<_$BloodLevelsTimelineRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
