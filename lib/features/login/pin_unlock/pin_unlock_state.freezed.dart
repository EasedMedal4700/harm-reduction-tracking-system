// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark
part of 'pin_unlock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************
T _$identity<T>(T value) => value;
final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PinUnlockState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isCheckingAuth => throw _privateConstructorUsedError;
  bool get biometricsAvailable => throw _privateConstructorUsedError;
  bool get pinObscured => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of PinUnlockState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PinUnlockStateCopyWith<PinUnlockState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PinUnlockStateCopyWith<$Res> {
  factory $PinUnlockStateCopyWith(
    PinUnlockState value,
    $Res Function(PinUnlockState) then,
  ) = _$PinUnlockStateCopyWithImpl<$Res, PinUnlockState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isCheckingAuth,
    bool biometricsAvailable,
    bool pinObscured,
    String? errorMessage,
  });
}

/// @nodoc
class _$PinUnlockStateCopyWithImpl<$Res, $Val extends PinUnlockState>
    implements $PinUnlockStateCopyWith<$Res> {
  _$PinUnlockStateCopyWithImpl(this._value, this._then);
  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PinUnlockState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isCheckingAuth = null,
    Object? biometricsAvailable = null,
    Object? pinObscured = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCheckingAuth: null == isCheckingAuth
                ? _value.isCheckingAuth
                : isCheckingAuth // ignore: cast_nullable_to_non_nullable
                      as bool,
            biometricsAvailable: null == biometricsAvailable
                ? _value.biometricsAvailable
                : biometricsAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            pinObscured: null == pinObscured
                ? _value.pinObscured
                : pinObscured // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PinUnlockStateImplCopyWith<$Res>
    implements $PinUnlockStateCopyWith<$Res> {
  factory _$$PinUnlockStateImplCopyWith(
    _$PinUnlockStateImpl value,
    $Res Function(_$PinUnlockStateImpl) then,
  ) = __$$PinUnlockStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isCheckingAuth,
    bool biometricsAvailable,
    bool pinObscured,
    String? errorMessage,
  });
}

/// @nodoc
class __$$PinUnlockStateImplCopyWithImpl<$Res>
    extends _$PinUnlockStateCopyWithImpl<$Res, _$PinUnlockStateImpl>
    implements _$$PinUnlockStateImplCopyWith<$Res> {
  __$$PinUnlockStateImplCopyWithImpl(
    _$PinUnlockStateImpl _value,
    $Res Function(_$PinUnlockStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PinUnlockState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isCheckingAuth = null,
    Object? biometricsAvailable = null,
    Object? pinObscured = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$PinUnlockStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCheckingAuth: null == isCheckingAuth
            ? _value.isCheckingAuth
            : isCheckingAuth // ignore: cast_nullable_to_non_nullable
                  as bool,
        biometricsAvailable: null == biometricsAvailable
            ? _value.biometricsAvailable
            : biometricsAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        pinObscured: null == pinObscured
            ? _value.pinObscured
            : pinObscured // ignore: cast_nullable_to_non_nullable
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
class _$PinUnlockStateImpl implements _PinUnlockState {
  const _$PinUnlockStateImpl({
    this.isLoading = false,
    this.isCheckingAuth = true,
    this.biometricsAvailable = false,
    this.pinObscured = true,
    this.errorMessage,
  });
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCheckingAuth;
  @override
  @JsonKey()
  final bool biometricsAvailable;
  @override
  @JsonKey()
  final bool pinObscured;
  @override
  final String? errorMessage;
  @override
  String toString() {
    return 'PinUnlockState(isLoading: $isLoading, isCheckingAuth: $isCheckingAuth, biometricsAvailable: $biometricsAvailable, pinObscured: $pinObscured, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinUnlockStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCheckingAuth, isCheckingAuth) ||
                other.isCheckingAuth == isCheckingAuth) &&
            (identical(other.biometricsAvailable, biometricsAvailable) ||
                other.biometricsAvailable == biometricsAvailable) &&
            (identical(other.pinObscured, pinObscured) ||
                other.pinObscured == pinObscured) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    isCheckingAuth,
    biometricsAvailable,
    pinObscured,
    errorMessage,
  );

  /// Create a copy of PinUnlockState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PinUnlockStateImplCopyWith<_$PinUnlockStateImpl> get copyWith =>
      __$$PinUnlockStateImplCopyWithImpl<_$PinUnlockStateImpl>(
        this,
        _$identity,
      );
}

abstract class _PinUnlockState implements PinUnlockState {
  const factory _PinUnlockState({
    final bool isLoading,
    final bool isCheckingAuth,
    final bool biometricsAvailable,
    final bool pinObscured,
    final String? errorMessage,
  }) = _$PinUnlockStateImpl;
  @override
  bool get isLoading;
  @override
  bool get isCheckingAuth;
  @override
  bool get biometricsAvailable;
  @override
  bool get pinObscured;
  @override
  String? get errorMessage;

  /// Create a copy of PinUnlockState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PinUnlockStateImplCopyWith<_$PinUnlockStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
