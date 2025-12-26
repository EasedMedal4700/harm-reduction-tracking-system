// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_setup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PinSetupState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get showRecoveryKey => throw _privateConstructorUsedError;
  String? get recoveryKey => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get pin1Obscure => throw _privateConstructorUsedError;
  bool get pin2Obscure => throw _privateConstructorUsedError;

  /// Create a copy of PinSetupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PinSetupStateCopyWith<PinSetupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PinSetupStateCopyWith<$Res> {
  factory $PinSetupStateCopyWith(
    PinSetupState value,
    $Res Function(PinSetupState) then,
  ) = _$PinSetupStateCopyWithImpl<$Res, PinSetupState>;
  @useResult
  $Res call({
    bool isLoading,
    bool showRecoveryKey,
    String? recoveryKey,
    String? errorMessage,
    bool pin1Obscure,
    bool pin2Obscure,
  });
}

/// @nodoc
class _$PinSetupStateCopyWithImpl<$Res, $Val extends PinSetupState>
    implements $PinSetupStateCopyWith<$Res> {
  _$PinSetupStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PinSetupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? showRecoveryKey = null,
    Object? recoveryKey = freezed,
    Object? errorMessage = freezed,
    Object? pin1Obscure = null,
    Object? pin2Obscure = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            showRecoveryKey: null == showRecoveryKey
                ? _value.showRecoveryKey
                : showRecoveryKey // ignore: cast_nullable_to_non_nullable
                      as bool,
            recoveryKey: freezed == recoveryKey
                ? _value.recoveryKey
                : recoveryKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            pin1Obscure: null == pin1Obscure
                ? _value.pin1Obscure
                : pin1Obscure // ignore: cast_nullable_to_non_nullable
                      as bool,
            pin2Obscure: null == pin2Obscure
                ? _value.pin2Obscure
                : pin2Obscure // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PinSetupStateImplCopyWith<$Res>
    implements $PinSetupStateCopyWith<$Res> {
  factory _$$PinSetupStateImplCopyWith(
    _$PinSetupStateImpl value,
    $Res Function(_$PinSetupStateImpl) then,
  ) = __$$PinSetupStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool showRecoveryKey,
    String? recoveryKey,
    String? errorMessage,
    bool pin1Obscure,
    bool pin2Obscure,
  });
}

/// @nodoc
class __$$PinSetupStateImplCopyWithImpl<$Res>
    extends _$PinSetupStateCopyWithImpl<$Res, _$PinSetupStateImpl>
    implements _$$PinSetupStateImplCopyWith<$Res> {
  __$$PinSetupStateImplCopyWithImpl(
    _$PinSetupStateImpl _value,
    $Res Function(_$PinSetupStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PinSetupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? showRecoveryKey = null,
    Object? recoveryKey = freezed,
    Object? errorMessage = freezed,
    Object? pin1Obscure = null,
    Object? pin2Obscure = null,
  }) {
    return _then(
      _$PinSetupStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        showRecoveryKey: null == showRecoveryKey
            ? _value.showRecoveryKey
            : showRecoveryKey // ignore: cast_nullable_to_non_nullable
                  as bool,
        recoveryKey: freezed == recoveryKey
            ? _value.recoveryKey
            : recoveryKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        pin1Obscure: null == pin1Obscure
            ? _value.pin1Obscure
            : pin1Obscure // ignore: cast_nullable_to_non_nullable
                  as bool,
        pin2Obscure: null == pin2Obscure
            ? _value.pin2Obscure
            : pin2Obscure // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PinSetupStateImpl extends _PinSetupState {
  const _$PinSetupStateImpl({
    this.isLoading = false,
    this.showRecoveryKey = false,
    this.recoveryKey,
    this.errorMessage,
    this.pin1Obscure = true,
    this.pin2Obscure = true,
  }) : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool showRecoveryKey;
  @override
  final String? recoveryKey;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool pin1Obscure;
  @override
  @JsonKey()
  final bool pin2Obscure;

  @override
  String toString() {
    return 'PinSetupState(isLoading: $isLoading, showRecoveryKey: $showRecoveryKey, recoveryKey: $recoveryKey, errorMessage: $errorMessage, pin1Obscure: $pin1Obscure, pin2Obscure: $pin2Obscure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinSetupStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.showRecoveryKey, showRecoveryKey) ||
                other.showRecoveryKey == showRecoveryKey) &&
            (identical(other.recoveryKey, recoveryKey) ||
                other.recoveryKey == recoveryKey) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.pin1Obscure, pin1Obscure) ||
                other.pin1Obscure == pin1Obscure) &&
            (identical(other.pin2Obscure, pin2Obscure) ||
                other.pin2Obscure == pin2Obscure));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    showRecoveryKey,
    recoveryKey,
    errorMessage,
    pin1Obscure,
    pin2Obscure,
  );

  /// Create a copy of PinSetupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PinSetupStateImplCopyWith<_$PinSetupStateImpl> get copyWith =>
      __$$PinSetupStateImplCopyWithImpl<_$PinSetupStateImpl>(this, _$identity);
}

abstract class _PinSetupState extends PinSetupState {
  const factory _PinSetupState({
    final bool isLoading,
    final bool showRecoveryKey,
    final String? recoveryKey,
    final String? errorMessage,
    final bool pin1Obscure,
    final bool pin2Obscure,
  }) = _$PinSetupStateImpl;
  const _PinSetupState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get showRecoveryKey;
  @override
  String? get recoveryKey;
  @override
  String? get errorMessage;
  @override
  bool get pin1Obscure;
  @override
  bool get pin2Obscure;

  /// Create a copy of PinSetupState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PinSetupStateImplCopyWith<_$PinSetupStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
