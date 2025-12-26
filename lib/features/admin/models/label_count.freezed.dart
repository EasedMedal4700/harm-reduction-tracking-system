// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LabelCount {
  String get label => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Create a copy of LabelCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabelCountCopyWith<LabelCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabelCountCopyWith<$Res> {
  factory $LabelCountCopyWith(
    LabelCount value,
    $Res Function(LabelCount) then,
  ) = _$LabelCountCopyWithImpl<$Res, LabelCount>;
  @useResult
  $Res call({String label, int count});
}

/// @nodoc
class _$LabelCountCopyWithImpl<$Res, $Val extends LabelCount>
    implements $LabelCountCopyWith<$Res> {
  _$LabelCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabelCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LabelCountImplCopyWith<$Res>
    implements $LabelCountCopyWith<$Res> {
  factory _$$LabelCountImplCopyWith(
    _$LabelCountImpl value,
    $Res Function(_$LabelCountImpl) then,
  ) = __$$LabelCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, int count});
}

/// @nodoc
class __$$LabelCountImplCopyWithImpl<$Res>
    extends _$LabelCountCopyWithImpl<$Res, _$LabelCountImpl>
    implements _$$LabelCountImplCopyWith<$Res> {
  __$$LabelCountImplCopyWithImpl(
    _$LabelCountImpl _value,
    $Res Function(_$LabelCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LabelCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? count = null}) {
    return _then(
      _$LabelCountImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$LabelCountImpl implements _LabelCount {
  const _$LabelCountImpl({required this.label, this.count = 0});

  @override
  final String label;
  @override
  @JsonKey()
  final int count;

  @override
  String toString() {
    return 'LabelCount(label: $label, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabelCountImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, count);

  /// Create a copy of LabelCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabelCountImplCopyWith<_$LabelCountImpl> get copyWith =>
      __$$LabelCountImplCopyWithImpl<_$LabelCountImpl>(this, _$identity);
}

abstract class _LabelCount implements LabelCount {
  const factory _LabelCount({required final String label, final int count}) =
      _$LabelCountImpl;

  @override
  String get label;
  @override
  int get count;

  /// Create a copy of LabelCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabelCountImplCopyWith<_$LabelCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
