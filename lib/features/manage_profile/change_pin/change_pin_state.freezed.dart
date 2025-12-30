// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_pin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChangePinState {

 bool get isLoading; bool get success; String? get errorMessage;
/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePinStateCopyWith<ChangePinState> get copyWith => _$ChangePinStateCopyWithImpl<ChangePinState>(this as ChangePinState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePinState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.success, success) || other.success == success)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,success,errorMessage);

@override
String toString() {
  return 'ChangePinState(isLoading: $isLoading, success: $success, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ChangePinStateCopyWith<$Res>  {
  factory $ChangePinStateCopyWith(ChangePinState value, $Res Function(ChangePinState) _then) = _$ChangePinStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool success, String? errorMessage
});




}
/// @nodoc
class _$ChangePinStateCopyWithImpl<$Res>
    implements $ChangePinStateCopyWith<$Res> {
  _$ChangePinStateCopyWithImpl(this._self, this._then);

  final ChangePinState _self;
  final $Res Function(ChangePinState) _then;

/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? success = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangePinState].
extension ChangePinStatePatterns on ChangePinState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangePinState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangePinState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangePinState value)  $default,){
final _that = this;
switch (_that) {
case _ChangePinState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangePinState value)?  $default,){
final _that = this;
switch (_that) {
case _ChangePinState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool success,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangePinState() when $default != null:
return $default(_that.isLoading,_that.success,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool success,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ChangePinState():
return $default(_that.isLoading,_that.success,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool success,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ChangePinState() when $default != null:
return $default(_that.isLoading,_that.success,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ChangePinState implements ChangePinState {
  const _ChangePinState({this.isLoading = false, this.success = false, this.errorMessage});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool success;
@override final  String? errorMessage;

/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangePinStateCopyWith<_ChangePinState> get copyWith => __$ChangePinStateCopyWithImpl<_ChangePinState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangePinState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.success, success) || other.success == success)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,success,errorMessage);

@override
String toString() {
  return 'ChangePinState(isLoading: $isLoading, success: $success, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ChangePinStateCopyWith<$Res> implements $ChangePinStateCopyWith<$Res> {
  factory _$ChangePinStateCopyWith(_ChangePinState value, $Res Function(_ChangePinState) _then) = __$ChangePinStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool success, String? errorMessage
});




}
/// @nodoc
class __$ChangePinStateCopyWithImpl<$Res>
    implements _$ChangePinStateCopyWith<$Res> {
  __$ChangePinStateCopyWithImpl(this._self, this._then);

  final _ChangePinState _self;
  final $Res Function(_ChangePinState) _then;

/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? success = null,Object? errorMessage = freezed,}) {
  return _then(_ChangePinState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
