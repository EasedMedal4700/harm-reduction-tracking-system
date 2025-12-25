// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bucket_details_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BucketDetailsState {
  /// Canonical bucket identifier (e.g. "gaba", "stimulant")
  String get bucketType => throw _privateConstructorUsedError;

  /// Tolerance percentage (0–100)
  double get tolerancePercent => throw _privateConstructorUsedError;

  /// Raw accumulated load for this bucket
  double get rawLoad => throw _privateConstructorUsedError;

  /// Estimated days until baseline recovery
  double get daysToBaseline => throw _privateConstructorUsedError;

  /// Substances contributing to this bucket
  List<ToleranceContribution> get contributingSubstances =>
      throw _privateConstructorUsedError;

  /// Optional educational / harm-reduction notes
  String? get substanceNotes => throw _privateConstructorUsedError;

  /// Create a copy of BucketDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BucketDetailsStateCopyWith<BucketDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BucketDetailsStateCopyWith<$Res> {
  factory $BucketDetailsStateCopyWith(
    BucketDetailsState value,
    $Res Function(BucketDetailsState) then,
  ) = _$BucketDetailsStateCopyWithImpl<$Res, BucketDetailsState>;
  @useResult
  $Res call({
    String bucketType,
    double tolerancePercent,
    double rawLoad,
    double daysToBaseline,
    List<ToleranceContribution> contributingSubstances,
    String? substanceNotes,
  });
}

/// @nodoc
class _$BucketDetailsStateCopyWithImpl<$Res, $Val extends BucketDetailsState>
    implements $BucketDetailsStateCopyWith<$Res> {
  _$BucketDetailsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BucketDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bucketType = null,
    Object? tolerancePercent = null,
    Object? rawLoad = null,
    Object? daysToBaseline = null,
    Object? contributingSubstances = null,
    Object? substanceNotes = freezed,
  }) {
    return _then(
      _value.copyWith(
            bucketType: null == bucketType
                ? _value.bucketType
                : bucketType // ignore: cast_nullable_to_non_nullable
                      as String,
            tolerancePercent: null == tolerancePercent
                ? _value.tolerancePercent
                : tolerancePercent // ignore: cast_nullable_to_non_nullable
                      as double,
            rawLoad: null == rawLoad
                ? _value.rawLoad
                : rawLoad // ignore: cast_nullable_to_non_nullable
                      as double,
            daysToBaseline: null == daysToBaseline
                ? _value.daysToBaseline
                : daysToBaseline // ignore: cast_nullable_to_non_nullable
                      as double,
            contributingSubstances: null == contributingSubstances
                ? _value.contributingSubstances
                : contributingSubstances // ignore: cast_nullable_to_non_nullable
                      as List<ToleranceContribution>,
            substanceNotes: freezed == substanceNotes
                ? _value.substanceNotes
                : substanceNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BucketDetailsStateImplCopyWith<$Res>
    implements $BucketDetailsStateCopyWith<$Res> {
  factory _$$BucketDetailsStateImplCopyWith(
    _$BucketDetailsStateImpl value,
    $Res Function(_$BucketDetailsStateImpl) then,
  ) = __$$BucketDetailsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String bucketType,
    double tolerancePercent,
    double rawLoad,
    double daysToBaseline,
    List<ToleranceContribution> contributingSubstances,
    String? substanceNotes,
  });
}

/// @nodoc
class __$$BucketDetailsStateImplCopyWithImpl<$Res>
    extends _$BucketDetailsStateCopyWithImpl<$Res, _$BucketDetailsStateImpl>
    implements _$$BucketDetailsStateImplCopyWith<$Res> {
  __$$BucketDetailsStateImplCopyWithImpl(
    _$BucketDetailsStateImpl _value,
    $Res Function(_$BucketDetailsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BucketDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bucketType = null,
    Object? tolerancePercent = null,
    Object? rawLoad = null,
    Object? daysToBaseline = null,
    Object? contributingSubstances = null,
    Object? substanceNotes = freezed,
  }) {
    return _then(
      _$BucketDetailsStateImpl(
        bucketType: null == bucketType
            ? _value.bucketType
            : bucketType // ignore: cast_nullable_to_non_nullable
                  as String,
        tolerancePercent: null == tolerancePercent
            ? _value.tolerancePercent
            : tolerancePercent // ignore: cast_nullable_to_non_nullable
                  as double,
        rawLoad: null == rawLoad
            ? _value.rawLoad
            : rawLoad // ignore: cast_nullable_to_non_nullable
                  as double,
        daysToBaseline: null == daysToBaseline
            ? _value.daysToBaseline
            : daysToBaseline // ignore: cast_nullable_to_non_nullable
                  as double,
        contributingSubstances: null == contributingSubstances
            ? _value._contributingSubstances
            : contributingSubstances // ignore: cast_nullable_to_non_nullable
                  as List<ToleranceContribution>,
        substanceNotes: freezed == substanceNotes
            ? _value.substanceNotes
            : substanceNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BucketDetailsStateImpl implements _BucketDetailsState {
  const _$BucketDetailsStateImpl({
    required this.bucketType,
    required this.tolerancePercent,
    required this.rawLoad,
    required this.daysToBaseline,
    required final List<ToleranceContribution> contributingSubstances,
    this.substanceNotes,
  }) : _contributingSubstances = contributingSubstances;

  /// Canonical bucket identifier (e.g. "gaba", "stimulant")
  @override
  final String bucketType;

  /// Tolerance percentage (0–100)
  @override
  final double tolerancePercent;

  /// Raw accumulated load for this bucket
  @override
  final double rawLoad;

  /// Estimated days until baseline recovery
  @override
  final double daysToBaseline;

  /// Substances contributing to this bucket
  final List<ToleranceContribution> _contributingSubstances;

  /// Substances contributing to this bucket
  @override
  List<ToleranceContribution> get contributingSubstances {
    if (_contributingSubstances is EqualUnmodifiableListView)
      return _contributingSubstances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contributingSubstances);
  }

  /// Optional educational / harm-reduction notes
  @override
  final String? substanceNotes;

  @override
  String toString() {
    return 'BucketDetailsState(bucketType: $bucketType, tolerancePercent: $tolerancePercent, rawLoad: $rawLoad, daysToBaseline: $daysToBaseline, contributingSubstances: $contributingSubstances, substanceNotes: $substanceNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BucketDetailsStateImpl &&
            (identical(other.bucketType, bucketType) ||
                other.bucketType == bucketType) &&
            (identical(other.tolerancePercent, tolerancePercent) ||
                other.tolerancePercent == tolerancePercent) &&
            (identical(other.rawLoad, rawLoad) || other.rawLoad == rawLoad) &&
            (identical(other.daysToBaseline, daysToBaseline) ||
                other.daysToBaseline == daysToBaseline) &&
            const DeepCollectionEquality().equals(
              other._contributingSubstances,
              _contributingSubstances,
            ) &&
            (identical(other.substanceNotes, substanceNotes) ||
                other.substanceNotes == substanceNotes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    bucketType,
    tolerancePercent,
    rawLoad,
    daysToBaseline,
    const DeepCollectionEquality().hash(_contributingSubstances),
    substanceNotes,
  );

  /// Create a copy of BucketDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BucketDetailsStateImplCopyWith<_$BucketDetailsStateImpl> get copyWith =>
      __$$BucketDetailsStateImplCopyWithImpl<_$BucketDetailsStateImpl>(
        this,
        _$identity,
      );
}

abstract class _BucketDetailsState implements BucketDetailsState {
  const factory _BucketDetailsState({
    required final String bucketType,
    required final double tolerancePercent,
    required final double rawLoad,
    required final double daysToBaseline,
    required final List<ToleranceContribution> contributingSubstances,
    final String? substanceNotes,
  }) = _$BucketDetailsStateImpl;

  /// Canonical bucket identifier (e.g. "gaba", "stimulant")
  @override
  String get bucketType;

  /// Tolerance percentage (0–100)
  @override
  double get tolerancePercent;

  /// Raw accumulated load for this bucket
  @override
  double get rawLoad;

  /// Estimated days until baseline recovery
  @override
  double get daysToBaseline;

  /// Substances contributing to this bucket
  @override
  List<ToleranceContribution> get contributingSubstances;

  /// Optional educational / harm-reduction notes
  @override
  String? get substanceNotes;

  /// Create a copy of BucketDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BucketDetailsStateImplCopyWith<_$BucketDetailsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
