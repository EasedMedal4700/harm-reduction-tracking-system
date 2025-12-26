// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_new_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SetNewPasswordState {
  bool get isSubmitting => throw _privateConstructorUsedError;
  bool get hasValidSession => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get obscurePassword => throw _privateConstructorUsedError;
  bool get obscureConfirmPassword => throw _privateConstructorUsedError;

  /// Create a copy of SetNewPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetNewPasswordStateCopyWith<SetNewPasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetNewPasswordStateCopyWith<$Res> {
  factory $SetNewPasswordStateCopyWith(
    SetNewPasswordState value,
    $Res Function(SetNewPasswordState) then,
  ) = _$SetNewPasswordStateCopyWithImpl<$Res, SetNewPasswordState>;
  @useResult
  $Res call({
    bool isSubmitting,
    bool hasValidSession,
    String? errorMessage,
    bool obscurePassword,
    bool obscureConfirmPassword,
  });
}

/// @nodoc
class _$SetNewPasswordStateCopyWithImpl<$Res, $Val extends SetNewPasswordState>
    implements $SetNewPasswordStateCopyWith<$Res> {
  _$SetNewPasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetNewPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? hasValidSession = null,
    Object? errorMessage = freezed,
    Object? obscurePassword = null,
    Object? obscureConfirmPassword = null,
  }) {
    return _then(
      _value.copyWith(
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasValidSession: null == hasValidSession
                ? _value.hasValidSession
                : hasValidSession // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            obscurePassword: null == obscurePassword
                ? _value.obscurePassword
                : obscurePassword // ignore: cast_nullable_to_non_nullable
                      as bool,
            obscureConfirmPassword: null == obscureConfirmPassword
                ? _value.obscureConfirmPassword
                : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SetNewPasswordStateImplCopyWith<$Res>
    implements $SetNewPasswordStateCopyWith<$Res> {
  factory _$$SetNewPasswordStateImplCopyWith(
    _$SetNewPasswordStateImpl value,
    $Res Function(_$SetNewPasswordStateImpl) then,
  ) = __$$SetNewPasswordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isSubmitting,
    bool hasValidSession,
    String? errorMessage,
    bool obscurePassword,
    bool obscureConfirmPassword,
  });
}

/// @nodoc
class __$$SetNewPasswordStateImplCopyWithImpl<$Res>
    extends _$SetNewPasswordStateCopyWithImpl<$Res, _$SetNewPasswordStateImpl>
    implements _$$SetNewPasswordStateImplCopyWith<$Res> {
  __$$SetNewPasswordStateImplCopyWithImpl(
    _$SetNewPasswordStateImpl _value,
    $Res Function(_$SetNewPasswordStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SetNewPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? hasValidSession = null,
    Object? errorMessage = freezed,
    Object? obscurePassword = null,
    Object? obscureConfirmPassword = null,
  }) {
    return _then(
      _$SetNewPasswordStateImpl(
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasValidSession: null == hasValidSession
            ? _value.hasValidSession
            : hasValidSession // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        obscurePassword: null == obscurePassword
            ? _value.obscurePassword
            : obscurePassword // ignore: cast_nullable_to_non_nullable
                  as bool,
        obscureConfirmPassword: null == obscureConfirmPassword
            ? _value.obscureConfirmPassword
            : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SetNewPasswordStateImpl extends _SetNewPasswordState {
  const _$SetNewPasswordStateImpl({
    this.isSubmitting = false,
    this.hasValidSession = true,
    this.errorMessage,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  }) : super._();

  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  @JsonKey()
  final bool hasValidSession;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool obscurePassword;
  @override
  @JsonKey()
  final bool obscureConfirmPassword;

  @override
  String toString() {
    return 'SetNewPasswordState(isSubmitting: $isSubmitting, hasValidSession: $hasValidSession, errorMessage: $errorMessage, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetNewPasswordStateImpl &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.hasValidSession, hasValidSession) ||
                other.hasValidSession == hasValidSession) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.obscurePassword, obscurePassword) ||
                other.obscurePassword == obscurePassword) &&
            (identical(other.obscureConfirmPassword, obscureConfirmPassword) ||
                other.obscureConfirmPassword == obscureConfirmPassword));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isSubmitting,
    hasValidSession,
    errorMessage,
    obscurePassword,
    obscureConfirmPassword,
  );

  /// Create a copy of SetNewPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetNewPasswordStateImplCopyWith<_$SetNewPasswordStateImpl> get copyWith =>
      __$$SetNewPasswordStateImplCopyWithImpl<_$SetNewPasswordStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SetNewPasswordState extends SetNewPasswordState {
  const factory _SetNewPasswordState({
    final bool isSubmitting,
    final bool hasValidSession,
    final String? errorMessage,
    final bool obscurePassword,
    final bool obscureConfirmPassword,
  }) = _$SetNewPasswordStateImpl;
  const _SetNewPasswordState._() : super._();

  @override
  bool get isSubmitting;
  @override
  bool get hasValidSession;
  @override
  String? get errorMessage;
  @override
  bool get obscurePassword;
  @override
  bool get obscureConfirmPassword;

  /// Create a copy of SetNewPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetNewPasswordStateImplCopyWith<_$SetNewPasswordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
