// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_setup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinSetupState {

 bool get isLoading; bool get showRecoveryKey; String? get recoveryKey; String? get errorMessage; bool get pin1Obscure; bool get pin2Obscure;
/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinSetupStateCopyWith<PinSetupState> get copyWith => _$PinSetupStateCopyWithImpl<PinSetupState>(this as PinSetupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.showRecoveryKey, showRecoveryKey) || other.showRecoveryKey == showRecoveryKey)&&(identical(other.recoveryKey, recoveryKey) || other.recoveryKey == recoveryKey)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.pin1Obscure, pin1Obscure) || other.pin1Obscure == pin1Obscure)&&(identical(other.pin2Obscure, pin2Obscure) || other.pin2Obscure == pin2Obscure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,showRecoveryKey,recoveryKey,errorMessage,pin1Obscure,pin2Obscure);

@override
String toString() {
  return 'PinSetupState(isLoading: $isLoading, showRecoveryKey: $showRecoveryKey, recoveryKey: $recoveryKey, errorMessage: $errorMessage, pin1Obscure: $pin1Obscure, pin2Obscure: $pin2Obscure)';
}


}

/// @nodoc
abstract mixin class $PinSetupStateCopyWith<$Res>  {
  factory $PinSetupStateCopyWith(PinSetupState value, $Res Function(PinSetupState) _then) = _$PinSetupStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool showRecoveryKey, String? recoveryKey, String? errorMessage, bool pin1Obscure, bool pin2Obscure
});




}
/// @nodoc
class _$PinSetupStateCopyWithImpl<$Res>
    implements $PinSetupStateCopyWith<$Res> {
  _$PinSetupStateCopyWithImpl(this._self, this._then);

  final PinSetupState _self;
  final $Res Function(PinSetupState) _then;

/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? showRecoveryKey = null,Object? recoveryKey = freezed,Object? errorMessage = freezed,Object? pin1Obscure = null,Object? pin2Obscure = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,showRecoveryKey: null == showRecoveryKey ? _self.showRecoveryKey : showRecoveryKey // ignore: cast_nullable_to_non_nullable
as bool,recoveryKey: freezed == recoveryKey ? _self.recoveryKey : recoveryKey // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,pin1Obscure: null == pin1Obscure ? _self.pin1Obscure : pin1Obscure // ignore: cast_nullable_to_non_nullable
as bool,pin2Obscure: null == pin2Obscure ? _self.pin2Obscure : pin2Obscure // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PinSetupState].
extension PinSetupStatePatterns on PinSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinSetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinSetupState value)  $default,){
final _that = this;
switch (_that) {
case _PinSetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _PinSetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool showRecoveryKey,  String? recoveryKey,  String? errorMessage,  bool pin1Obscure,  bool pin2Obscure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinSetupState() when $default != null:
return $default(_that.isLoading,_that.showRecoveryKey,_that.recoveryKey,_that.errorMessage,_that.pin1Obscure,_that.pin2Obscure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool showRecoveryKey,  String? recoveryKey,  String? errorMessage,  bool pin1Obscure,  bool pin2Obscure)  $default,) {final _that = this;
switch (_that) {
case _PinSetupState():
return $default(_that.isLoading,_that.showRecoveryKey,_that.recoveryKey,_that.errorMessage,_that.pin1Obscure,_that.pin2Obscure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool showRecoveryKey,  String? recoveryKey,  String? errorMessage,  bool pin1Obscure,  bool pin2Obscure)?  $default,) {final _that = this;
switch (_that) {
case _PinSetupState() when $default != null:
return $default(_that.isLoading,_that.showRecoveryKey,_that.recoveryKey,_that.errorMessage,_that.pin1Obscure,_that.pin2Obscure);case _:
  return null;

}
}

}

/// @nodoc


class _PinSetupState extends PinSetupState {
  const _PinSetupState({this.isLoading = false, this.showRecoveryKey = false, this.recoveryKey, this.errorMessage, this.pin1Obscure = true, this.pin2Obscure = true}): super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool showRecoveryKey;
@override final  String? recoveryKey;
@override final  String? errorMessage;
@override@JsonKey() final  bool pin1Obscure;
@override@JsonKey() final  bool pin2Obscure;

/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinSetupStateCopyWith<_PinSetupState> get copyWith => __$PinSetupStateCopyWithImpl<_PinSetupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinSetupState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.showRecoveryKey, showRecoveryKey) || other.showRecoveryKey == showRecoveryKey)&&(identical(other.recoveryKey, recoveryKey) || other.recoveryKey == recoveryKey)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.pin1Obscure, pin1Obscure) || other.pin1Obscure == pin1Obscure)&&(identical(other.pin2Obscure, pin2Obscure) || other.pin2Obscure == pin2Obscure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,showRecoveryKey,recoveryKey,errorMessage,pin1Obscure,pin2Obscure);

@override
String toString() {
  return 'PinSetupState(isLoading: $isLoading, showRecoveryKey: $showRecoveryKey, recoveryKey: $recoveryKey, errorMessage: $errorMessage, pin1Obscure: $pin1Obscure, pin2Obscure: $pin2Obscure)';
}


}

/// @nodoc
abstract mixin class _$PinSetupStateCopyWith<$Res> implements $PinSetupStateCopyWith<$Res> {
  factory _$PinSetupStateCopyWith(_PinSetupState value, $Res Function(_PinSetupState) _then) = __$PinSetupStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool showRecoveryKey, String? recoveryKey, String? errorMessage, bool pin1Obscure, bool pin2Obscure
});




}
/// @nodoc
class __$PinSetupStateCopyWithImpl<$Res>
    implements _$PinSetupStateCopyWith<$Res> {
  __$PinSetupStateCopyWithImpl(this._self, this._then);

  final _PinSetupState _self;
  final $Res Function(_PinSetupState) _then;

/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? showRecoveryKey = null,Object? recoveryKey = freezed,Object? errorMessage = freezed,Object? pin1Obscure = null,Object? pin2Obscure = null,}) {
  return _then(_PinSetupState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,showRecoveryKey: null == showRecoveryKey ? _self.showRecoveryKey : showRecoveryKey // ignore: cast_nullable_to_non_nullable
as bool,recoveryKey: freezed == recoveryKey ? _self.recoveryKey : recoveryKey // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,pin1Obscure: null == pin1Obscure ? _self.pin1Obscure : pin1Obscure // ignore: cast_nullable_to_non_nullable
as bool,pin2Obscure: null == pin2Obscure ? _self.pin2Obscure : pin2Obscure // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
