// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recovery_key_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecoveryKeyState {

 bool get isLoading; String? get errorMessage;// UI
 bool get keyObscure; bool get pinObscure; bool get confirmPinObscure;// Two-step flow
 bool get recoveryKeyValidated; String? get validatedRecoveryKey;
/// Create a copy of RecoveryKeyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecoveryKeyStateCopyWith<RecoveryKeyState> get copyWith => _$RecoveryKeyStateCopyWithImpl<RecoveryKeyState>(this as RecoveryKeyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecoveryKeyState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.keyObscure, keyObscure) || other.keyObscure == keyObscure)&&(identical(other.pinObscure, pinObscure) || other.pinObscure == pinObscure)&&(identical(other.confirmPinObscure, confirmPinObscure) || other.confirmPinObscure == confirmPinObscure)&&(identical(other.recoveryKeyValidated, recoveryKeyValidated) || other.recoveryKeyValidated == recoveryKeyValidated)&&(identical(other.validatedRecoveryKey, validatedRecoveryKey) || other.validatedRecoveryKey == validatedRecoveryKey));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,keyObscure,pinObscure,confirmPinObscure,recoveryKeyValidated,validatedRecoveryKey);

@override
String toString() {
  return 'RecoveryKeyState(isLoading: $isLoading, errorMessage: $errorMessage, keyObscure: $keyObscure, pinObscure: $pinObscure, confirmPinObscure: $confirmPinObscure, recoveryKeyValidated: $recoveryKeyValidated, validatedRecoveryKey: $validatedRecoveryKey)';
}


}

/// @nodoc
abstract mixin class $RecoveryKeyStateCopyWith<$Res>  {
  factory $RecoveryKeyStateCopyWith(RecoveryKeyState value, $Res Function(RecoveryKeyState) _then) = _$RecoveryKeyStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? errorMessage, bool keyObscure, bool pinObscure, bool confirmPinObscure, bool recoveryKeyValidated, String? validatedRecoveryKey
});




}
/// @nodoc
class _$RecoveryKeyStateCopyWithImpl<$Res>
    implements $RecoveryKeyStateCopyWith<$Res> {
  _$RecoveryKeyStateCopyWithImpl(this._self, this._then);

  final RecoveryKeyState _self;
  final $Res Function(RecoveryKeyState) _then;

/// Create a copy of RecoveryKeyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? keyObscure = null,Object? pinObscure = null,Object? confirmPinObscure = null,Object? recoveryKeyValidated = null,Object? validatedRecoveryKey = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,keyObscure: null == keyObscure ? _self.keyObscure : keyObscure // ignore: cast_nullable_to_non_nullable
as bool,pinObscure: null == pinObscure ? _self.pinObscure : pinObscure // ignore: cast_nullable_to_non_nullable
as bool,confirmPinObscure: null == confirmPinObscure ? _self.confirmPinObscure : confirmPinObscure // ignore: cast_nullable_to_non_nullable
as bool,recoveryKeyValidated: null == recoveryKeyValidated ? _self.recoveryKeyValidated : recoveryKeyValidated // ignore: cast_nullable_to_non_nullable
as bool,validatedRecoveryKey: freezed == validatedRecoveryKey ? _self.validatedRecoveryKey : validatedRecoveryKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecoveryKeyState].
extension RecoveryKeyStatePatterns on RecoveryKeyState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecoveryKeyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecoveryKeyState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecoveryKeyState value)  $default,){
final _that = this;
switch (_that) {
case _RecoveryKeyState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecoveryKeyState value)?  $default,){
final _that = this;
switch (_that) {
case _RecoveryKeyState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  bool keyObscure,  bool pinObscure,  bool confirmPinObscure,  bool recoveryKeyValidated,  String? validatedRecoveryKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecoveryKeyState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.keyObscure,_that.pinObscure,_that.confirmPinObscure,_that.recoveryKeyValidated,_that.validatedRecoveryKey);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  bool keyObscure,  bool pinObscure,  bool confirmPinObscure,  bool recoveryKeyValidated,  String? validatedRecoveryKey)  $default,) {final _that = this;
switch (_that) {
case _RecoveryKeyState():
return $default(_that.isLoading,_that.errorMessage,_that.keyObscure,_that.pinObscure,_that.confirmPinObscure,_that.recoveryKeyValidated,_that.validatedRecoveryKey);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String? errorMessage,  bool keyObscure,  bool pinObscure,  bool confirmPinObscure,  bool recoveryKeyValidated,  String? validatedRecoveryKey)?  $default,) {final _that = this;
switch (_that) {
case _RecoveryKeyState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.keyObscure,_that.pinObscure,_that.confirmPinObscure,_that.recoveryKeyValidated,_that.validatedRecoveryKey);case _:
  return null;

}
}

}

/// @nodoc


class _RecoveryKeyState extends RecoveryKeyState {
  const _RecoveryKeyState({this.isLoading = false, this.errorMessage, this.keyObscure = true, this.pinObscure = true, this.confirmPinObscure = true, this.recoveryKeyValidated = false, this.validatedRecoveryKey}): super._();
  

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
// UI
@override@JsonKey() final  bool keyObscure;
@override@JsonKey() final  bool pinObscure;
@override@JsonKey() final  bool confirmPinObscure;
// Two-step flow
@override@JsonKey() final  bool recoveryKeyValidated;
@override final  String? validatedRecoveryKey;

/// Create a copy of RecoveryKeyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecoveryKeyStateCopyWith<_RecoveryKeyState> get copyWith => __$RecoveryKeyStateCopyWithImpl<_RecoveryKeyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecoveryKeyState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.keyObscure, keyObscure) || other.keyObscure == keyObscure)&&(identical(other.pinObscure, pinObscure) || other.pinObscure == pinObscure)&&(identical(other.confirmPinObscure, confirmPinObscure) || other.confirmPinObscure == confirmPinObscure)&&(identical(other.recoveryKeyValidated, recoveryKeyValidated) || other.recoveryKeyValidated == recoveryKeyValidated)&&(identical(other.validatedRecoveryKey, validatedRecoveryKey) || other.validatedRecoveryKey == validatedRecoveryKey));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,keyObscure,pinObscure,confirmPinObscure,recoveryKeyValidated,validatedRecoveryKey);

@override
String toString() {
  return 'RecoveryKeyState(isLoading: $isLoading, errorMessage: $errorMessage, keyObscure: $keyObscure, pinObscure: $pinObscure, confirmPinObscure: $confirmPinObscure, recoveryKeyValidated: $recoveryKeyValidated, validatedRecoveryKey: $validatedRecoveryKey)';
}


}

/// @nodoc
abstract mixin class _$RecoveryKeyStateCopyWith<$Res> implements $RecoveryKeyStateCopyWith<$Res> {
  factory _$RecoveryKeyStateCopyWith(_RecoveryKeyState value, $Res Function(_RecoveryKeyState) _then) = __$RecoveryKeyStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? errorMessage, bool keyObscure, bool pinObscure, bool confirmPinObscure, bool recoveryKeyValidated, String? validatedRecoveryKey
});




}
/// @nodoc
class __$RecoveryKeyStateCopyWithImpl<$Res>
    implements _$RecoveryKeyStateCopyWith<$Res> {
  __$RecoveryKeyStateCopyWithImpl(this._self, this._then);

  final _RecoveryKeyState _self;
  final $Res Function(_RecoveryKeyState) _then;

/// Create a copy of RecoveryKeyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? keyObscure = null,Object? pinObscure = null,Object? confirmPinObscure = null,Object? recoveryKeyValidated = null,Object? validatedRecoveryKey = freezed,}) {
  return _then(_RecoveryKeyState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,keyObscure: null == keyObscure ? _self.keyObscure : keyObscure // ignore: cast_nullable_to_non_nullable
as bool,pinObscure: null == pinObscure ? _self.pinObscure : pinObscure // ignore: cast_nullable_to_non_nullable
as bool,confirmPinObscure: null == confirmPinObscure ? _self.confirmPinObscure : confirmPinObscure // ignore: cast_nullable_to_non_nullable
as bool,recoveryKeyValidated: null == recoveryKeyValidated ? _self.recoveryKeyValidated : recoveryKeyValidated // ignore: cast_nullable_to_non_nullable
as bool,validatedRecoveryKey: freezed == validatedRecoveryKey ? _self.validatedRecoveryKey : validatedRecoveryKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
