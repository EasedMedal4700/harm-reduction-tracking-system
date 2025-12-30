// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_new_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SetNewPasswordState {

 bool get isSubmitting; bool get hasValidSession; String? get errorMessage; bool get obscurePassword; bool get obscureConfirmPassword;
/// Create a copy of SetNewPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetNewPasswordStateCopyWith<SetNewPasswordState> get copyWith => _$SetNewPasswordStateCopyWithImpl<SetNewPasswordState>(this as SetNewPasswordState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetNewPasswordState&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.hasValidSession, hasValidSession) || other.hasValidSession == hasValidSession)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.obscureConfirmPassword, obscureConfirmPassword) || other.obscureConfirmPassword == obscureConfirmPassword));
}


@override
int get hashCode => Object.hash(runtimeType,isSubmitting,hasValidSession,errorMessage,obscurePassword,obscureConfirmPassword);

@override
String toString() {
  return 'SetNewPasswordState(isSubmitting: $isSubmitting, hasValidSession: $hasValidSession, errorMessage: $errorMessage, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword)';
}


}

/// @nodoc
abstract mixin class $SetNewPasswordStateCopyWith<$Res>  {
  factory $SetNewPasswordStateCopyWith(SetNewPasswordState value, $Res Function(SetNewPasswordState) _then) = _$SetNewPasswordStateCopyWithImpl;
@useResult
$Res call({
 bool isSubmitting, bool hasValidSession, String? errorMessage, bool obscurePassword, bool obscureConfirmPassword
});




}
/// @nodoc
class _$SetNewPasswordStateCopyWithImpl<$Res>
    implements $SetNewPasswordStateCopyWith<$Res> {
  _$SetNewPasswordStateCopyWithImpl(this._self, this._then);

  final SetNewPasswordState _self;
  final $Res Function(SetNewPasswordState) _then;

/// Create a copy of SetNewPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSubmitting = null,Object? hasValidSession = null,Object? errorMessage = freezed,Object? obscurePassword = null,Object? obscureConfirmPassword = null,}) {
  return _then(_self.copyWith(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,hasValidSession: null == hasValidSession ? _self.hasValidSession : hasValidSession // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,obscureConfirmPassword: null == obscureConfirmPassword ? _self.obscureConfirmPassword : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SetNewPasswordState].
extension SetNewPasswordStatePatterns on SetNewPasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetNewPasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetNewPasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetNewPasswordState value)  $default,){
final _that = this;
switch (_that) {
case _SetNewPasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetNewPasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _SetNewPasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSubmitting,  bool hasValidSession,  String? errorMessage,  bool obscurePassword,  bool obscureConfirmPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetNewPasswordState() when $default != null:
return $default(_that.isSubmitting,_that.hasValidSession,_that.errorMessage,_that.obscurePassword,_that.obscureConfirmPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSubmitting,  bool hasValidSession,  String? errorMessage,  bool obscurePassword,  bool obscureConfirmPassword)  $default,) {final _that = this;
switch (_that) {
case _SetNewPasswordState():
return $default(_that.isSubmitting,_that.hasValidSession,_that.errorMessage,_that.obscurePassword,_that.obscureConfirmPassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSubmitting,  bool hasValidSession,  String? errorMessage,  bool obscurePassword,  bool obscureConfirmPassword)?  $default,) {final _that = this;
switch (_that) {
case _SetNewPasswordState() when $default != null:
return $default(_that.isSubmitting,_that.hasValidSession,_that.errorMessage,_that.obscurePassword,_that.obscureConfirmPassword);case _:
  return null;

}
}

}

/// @nodoc


class _SetNewPasswordState extends SetNewPasswordState {
  const _SetNewPasswordState({this.isSubmitting = false, this.hasValidSession = true, this.errorMessage, this.obscurePassword = true, this.obscureConfirmPassword = true}): super._();
  

@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool hasValidSession;
@override final  String? errorMessage;
@override@JsonKey() final  bool obscurePassword;
@override@JsonKey() final  bool obscureConfirmPassword;

/// Create a copy of SetNewPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetNewPasswordStateCopyWith<_SetNewPasswordState> get copyWith => __$SetNewPasswordStateCopyWithImpl<_SetNewPasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetNewPasswordState&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.hasValidSession, hasValidSession) || other.hasValidSession == hasValidSession)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.obscureConfirmPassword, obscureConfirmPassword) || other.obscureConfirmPassword == obscureConfirmPassword));
}


@override
int get hashCode => Object.hash(runtimeType,isSubmitting,hasValidSession,errorMessage,obscurePassword,obscureConfirmPassword);

@override
String toString() {
  return 'SetNewPasswordState(isSubmitting: $isSubmitting, hasValidSession: $hasValidSession, errorMessage: $errorMessage, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword)';
}


}

/// @nodoc
abstract mixin class _$SetNewPasswordStateCopyWith<$Res> implements $SetNewPasswordStateCopyWith<$Res> {
  factory _$SetNewPasswordStateCopyWith(_SetNewPasswordState value, $Res Function(_SetNewPasswordState) _then) = __$SetNewPasswordStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSubmitting, bool hasValidSession, String? errorMessage, bool obscurePassword, bool obscureConfirmPassword
});




}
/// @nodoc
class __$SetNewPasswordStateCopyWithImpl<$Res>
    implements _$SetNewPasswordStateCopyWith<$Res> {
  __$SetNewPasswordStateCopyWithImpl(this._self, this._then);

  final _SetNewPasswordState _self;
  final $Res Function(_SetNewPasswordState) _then;

/// Create a copy of SetNewPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSubmitting = null,Object? hasValidSession = null,Object? errorMessage = freezed,Object? obscurePassword = null,Object? obscureConfirmPassword = null,}) {
  return _then(_SetNewPasswordState(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,hasValidSession: null == hasValidSession ? _self.hasValidSession : hasValidSession // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,obscureConfirmPassword: null == obscureConfirmPassword ? _self.obscureConfirmPassword : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
