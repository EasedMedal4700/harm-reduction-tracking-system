// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_pin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChangePinState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ChangePinState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangePinStateCopyWith<ChangePinState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePinStateCopyWith<$Res> {
  factory $ChangePinStateCopyWith(
    ChangePinState value,
    $Res Function(ChangePinState) then,
  ) = _$ChangePinStateCopyWithImpl<$Res, ChangePinState>;
  @useResult
  $Res call({bool isLoading, bool success, String? errorMessage});
}

/// @nodoc
class _$ChangePinStateCopyWithImpl<$Res, $Val extends ChangePinState>
    implements $ChangePinStateCopyWith<$Res> {
  _$ChangePinStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangePinState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? success = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChangePinStateImplCopyWith<$Res>
    implements $ChangePinStateCopyWith<$Res> {
  factory _$$ChangePinStateImplCopyWith(
    _$ChangePinStateImpl value,
    $Res Function(_$ChangePinStateImpl) then,
  ) = __$$ChangePinStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, bool success, String? errorMessage});
}

/// @nodoc
class __$$ChangePinStateImplCopyWithImpl<$Res>
    extends _$ChangePinStateCopyWithImpl<$Res, _$ChangePinStateImpl>
    implements _$$ChangePinStateImplCopyWith<$Res> {
  __$$ChangePinStateImplCopyWithImpl(
    _$ChangePinStateImpl _value,
    $Res Function(_$ChangePinStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChangePinState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? success = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$ChangePinStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ChangePinStateImpl implements _ChangePinState {
  const _$ChangePinStateImpl({
    this.isLoading = false,
    this.success = false,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool success;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ChangePinState(isLoading: $isLoading, success: $success, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePinStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, success, errorMessage);

  /// Create a copy of ChangePinState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePinStateImplCopyWith<_$ChangePinStateImpl> get copyWith =>
      __$$ChangePinStateImplCopyWithImpl<_$ChangePinStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ChangePinState implements ChangePinState {
  const factory _ChangePinState({
    final bool isLoading,
    final bool success,
    final String? errorMessage,
  }) = _$ChangePinStateImpl;

  @override
  bool get isLoading;
  @override
  bool get success;
  @override
  String? get errorMessage;

  /// Create a copy of ChangePinState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangePinStateImplCopyWith<_$ChangePinStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
