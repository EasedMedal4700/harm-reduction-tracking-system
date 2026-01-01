// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_unlock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinUnlockState {

 bool get isLoading; bool get isCheckingAuth; bool get biometricsAvailable; bool get pinObscured; String? get errorMessage;
/// Create a copy of PinUnlockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinUnlockStateCopyWith<PinUnlockState> get copyWith => _$PinUnlockStateCopyWithImpl<PinUnlockState>(this as PinUnlockState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinUnlockState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isCheckingAuth, isCheckingAuth) || other.isCheckingAuth == isCheckingAuth)&&(identical(other.biometricsAvailable, biometricsAvailable) || other.biometricsAvailable == biometricsAvailable)&&(identical(other.pinObscured, pinObscured) || other.pinObscured == pinObscured)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isCheckingAuth,biometricsAvailable,pinObscured,errorMessage);

@override
String toString() {
  return 'PinUnlockState(isLoading: $isLoading, isCheckingAuth: $isCheckingAuth, biometricsAvailable: $biometricsAvailable, pinObscured: $pinObscured, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PinUnlockStateCopyWith<$Res>  {
  factory $PinUnlockStateCopyWith(PinUnlockState value, $Res Function(PinUnlockState) _then) = _$PinUnlockStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isCheckingAuth, bool biometricsAvailable, bool pinObscured, String? errorMessage
});




}
/// @nodoc
class _$PinUnlockStateCopyWithImpl<$Res>
    implements $PinUnlockStateCopyWith<$Res> {
  _$PinUnlockStateCopyWithImpl(this._self, this._then);

  final PinUnlockState _self;
  final $Res Function(PinUnlockState) _then;

/// Create a copy of PinUnlockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isCheckingAuth = null,Object? biometricsAvailable = null,Object? pinObscured = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isCheckingAuth: null == isCheckingAuth ? _self.isCheckingAuth : isCheckingAuth // ignore: cast_nullable_to_non_nullable
as bool,biometricsAvailable: null == biometricsAvailable ? _self.biometricsAvailable : biometricsAvailable // ignore: cast_nullable_to_non_nullable
as bool,pinObscured: null == pinObscured ? _self.pinObscured : pinObscured // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PinUnlockState].
extension PinUnlockStatePatterns on PinUnlockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinUnlockState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinUnlockState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinUnlockState value)  $default,){
final _that = this;
switch (_that) {
case _PinUnlockState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinUnlockState value)?  $default,){
final _that = this;
switch (_that) {
case _PinUnlockState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isCheckingAuth,  bool biometricsAvailable,  bool pinObscured,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinUnlockState() when $default != null:
return $default(_that.isLoading,_that.isCheckingAuth,_that.biometricsAvailable,_that.pinObscured,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isCheckingAuth,  bool biometricsAvailable,  bool pinObscured,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PinUnlockState():
return $default(_that.isLoading,_that.isCheckingAuth,_that.biometricsAvailable,_that.pinObscured,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isCheckingAuth,  bool biometricsAvailable,  bool pinObscured,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PinUnlockState() when $default != null:
return $default(_that.isLoading,_that.isCheckingAuth,_that.biometricsAvailable,_that.pinObscured,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PinUnlockState implements PinUnlockState {
  const _PinUnlockState({this.isLoading = false, this.isCheckingAuth = true, this.biometricsAvailable = false, this.pinObscured = true, this.errorMessage});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isCheckingAuth;
@override@JsonKey() final  bool biometricsAvailable;
@override@JsonKey() final  bool pinObscured;
@override final  String? errorMessage;

/// Create a copy of PinUnlockState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinUnlockStateCopyWith<_PinUnlockState> get copyWith => __$PinUnlockStateCopyWithImpl<_PinUnlockState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinUnlockState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isCheckingAuth, isCheckingAuth) || other.isCheckingAuth == isCheckingAuth)&&(identical(other.biometricsAvailable, biometricsAvailable) || other.biometricsAvailable == biometricsAvailable)&&(identical(other.pinObscured, pinObscured) || other.pinObscured == pinObscured)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isCheckingAuth,biometricsAvailable,pinObscured,errorMessage);

@override
String toString() {
  return 'PinUnlockState(isLoading: $isLoading, isCheckingAuth: $isCheckingAuth, biometricsAvailable: $biometricsAvailable, pinObscured: $pinObscured, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PinUnlockStateCopyWith<$Res> implements $PinUnlockStateCopyWith<$Res> {
  factory _$PinUnlockStateCopyWith(_PinUnlockState value, $Res Function(_PinUnlockState) _then) = __$PinUnlockStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isCheckingAuth, bool biometricsAvailable, bool pinObscured, String? errorMessage
});




}
/// @nodoc
class __$PinUnlockStateCopyWithImpl<$Res>
    implements _$PinUnlockStateCopyWith<$Res> {
  __$PinUnlockStateCopyWithImpl(this._self, this._then);

  final _PinUnlockState _self;
  final $Res Function(_PinUnlockState) _then;

/// Create a copy of PinUnlockState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isCheckingAuth = null,Object? biometricsAvailable = null,Object? pinObscured = null,Object? errorMessage = freezed,}) {
  return _then(_PinUnlockState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isCheckingAuth: null == isCheckingAuth ? _self.isCheckingAuth : isCheckingAuth // ignore: cast_nullable_to_non_nullable
as bool,biometricsAvailable: null == biometricsAvailable ? _self.biometricsAvailable : biometricsAvailable // ignore: cast_nullable_to_non_nullable
as bool,pinObscured: null == pinObscured ? _self.pinObscured : pinObscured // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
