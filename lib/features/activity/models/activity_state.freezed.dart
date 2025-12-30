// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityUiEvent {

 String get message; ActivityUiEventTone get tone;
/// Create a copy of ActivityUiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityUiEventCopyWith<ActivityUiEvent> get copyWith => _$ActivityUiEventCopyWithImpl<ActivityUiEvent>(this as ActivityUiEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityUiEvent&&(identical(other.message, message) || other.message == message)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,message,tone);

@override
String toString() {
  return 'ActivityUiEvent(message: $message, tone: $tone)';
}


}

/// @nodoc
abstract mixin class $ActivityUiEventCopyWith<$Res>  {
  factory $ActivityUiEventCopyWith(ActivityUiEvent value, $Res Function(ActivityUiEvent) _then) = _$ActivityUiEventCopyWithImpl;
@useResult
$Res call({
 String message, ActivityUiEventTone tone
});




}
/// @nodoc
class _$ActivityUiEventCopyWithImpl<$Res>
    implements $ActivityUiEventCopyWith<$Res> {
  _$ActivityUiEventCopyWithImpl(this._self, this._then);

  final ActivityUiEvent _self;
  final $Res Function(ActivityUiEvent) _then;

/// Create a copy of ActivityUiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? tone = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as ActivityUiEventTone,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityUiEvent].
extension ActivityUiEventPatterns on ActivityUiEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SnackBar value)?  snackBar,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnackBar() when snackBar != null:
return snackBar(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SnackBar value)  snackBar,}){
final _that = this;
switch (_that) {
case _SnackBar():
return snackBar(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SnackBar value)?  snackBar,}){
final _that = this;
switch (_that) {
case _SnackBar() when snackBar != null:
return snackBar(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  ActivityUiEventTone tone)?  snackBar,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnackBar() when snackBar != null:
return snackBar(_that.message,_that.tone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  ActivityUiEventTone tone)  snackBar,}) {final _that = this;
switch (_that) {
case _SnackBar():
return snackBar(_that.message,_that.tone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  ActivityUiEventTone tone)?  snackBar,}) {final _that = this;
switch (_that) {
case _SnackBar() when snackBar != null:
return snackBar(_that.message,_that.tone);case _:
  return null;

}
}

}

/// @nodoc


class _SnackBar implements ActivityUiEvent {
  const _SnackBar({required this.message, this.tone = ActivityUiEventTone.neutral});
  

@override final  String message;
@override@JsonKey() final  ActivityUiEventTone tone;

/// Create a copy of ActivityUiEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnackBarCopyWith<_SnackBar> get copyWith => __$SnackBarCopyWithImpl<_SnackBar>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnackBar&&(identical(other.message, message) || other.message == message)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,message,tone);

@override
String toString() {
  return 'ActivityUiEvent.snackBar(message: $message, tone: $tone)';
}


}

/// @nodoc
abstract mixin class _$SnackBarCopyWith<$Res> implements $ActivityUiEventCopyWith<$Res> {
  factory _$SnackBarCopyWith(_SnackBar value, $Res Function(_SnackBar) _then) = __$SnackBarCopyWithImpl;
@override @useResult
$Res call({
 String message, ActivityUiEventTone tone
});




}
/// @nodoc
class __$SnackBarCopyWithImpl<$Res>
    implements _$SnackBarCopyWith<$Res> {
  __$SnackBarCopyWithImpl(this._self, this._then);

  final _SnackBar _self;
  final $Res Function(_SnackBar) _then;

/// Create a copy of ActivityUiEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? tone = null,}) {
  return _then(_SnackBar(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as ActivityUiEventTone,
  ));
}


}

/// @nodoc
mixin _$ActivityState {

 ActivityData get data; bool get isDeleting; ActivityUiEvent? get event;
/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityStateCopyWith<ActivityState> get copyWith => _$ActivityStateCopyWithImpl<ActivityState>(this as ActivityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityState&&(identical(other.data, data) || other.data == data)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode => Object.hash(runtimeType,data,isDeleting,event);

@override
String toString() {
  return 'ActivityState(data: $data, isDeleting: $isDeleting, event: $event)';
}


}

/// @nodoc
abstract mixin class $ActivityStateCopyWith<$Res>  {
  factory $ActivityStateCopyWith(ActivityState value, $Res Function(ActivityState) _then) = _$ActivityStateCopyWithImpl;
@useResult
$Res call({
 ActivityData data, bool isDeleting, ActivityUiEvent? event
});


$ActivityDataCopyWith<$Res> get data;$ActivityUiEventCopyWith<$Res>? get event;

}
/// @nodoc
class _$ActivityStateCopyWithImpl<$Res>
    implements $ActivityStateCopyWith<$Res> {
  _$ActivityStateCopyWithImpl(this._self, this._then);

  final ActivityState _self;
  final $Res Function(ActivityState) _then;

/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? isDeleting = null,Object? event = freezed,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ActivityData,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as ActivityUiEvent?,
  ));
}
/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityDataCopyWith<$Res> get data {
  
  return $ActivityDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityUiEventCopyWith<$Res>? get event {
    if (_self.event == null) {
    return null;
  }

  return $ActivityUiEventCopyWith<$Res>(_self.event!, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivityState].
extension ActivityStatePatterns on ActivityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityState value)  $default,){
final _that = this;
switch (_that) {
case _ActivityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityState value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActivityData data,  bool isDeleting,  ActivityUiEvent? event)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityState() when $default != null:
return $default(_that.data,_that.isDeleting,_that.event);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActivityData data,  bool isDeleting,  ActivityUiEvent? event)  $default,) {final _that = this;
switch (_that) {
case _ActivityState():
return $default(_that.data,_that.isDeleting,_that.event);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActivityData data,  bool isDeleting,  ActivityUiEvent? event)?  $default,) {final _that = this;
switch (_that) {
case _ActivityState() when $default != null:
return $default(_that.data,_that.isDeleting,_that.event);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityState implements ActivityState {
  const _ActivityState({this.data = const ActivityData(), this.isDeleting = false, this.event});
  

@override@JsonKey() final  ActivityData data;
@override@JsonKey() final  bool isDeleting;
@override final  ActivityUiEvent? event;

/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityStateCopyWith<_ActivityState> get copyWith => __$ActivityStateCopyWithImpl<_ActivityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityState&&(identical(other.data, data) || other.data == data)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode => Object.hash(runtimeType,data,isDeleting,event);

@override
String toString() {
  return 'ActivityState(data: $data, isDeleting: $isDeleting, event: $event)';
}


}

/// @nodoc
abstract mixin class _$ActivityStateCopyWith<$Res> implements $ActivityStateCopyWith<$Res> {
  factory _$ActivityStateCopyWith(_ActivityState value, $Res Function(_ActivityState) _then) = __$ActivityStateCopyWithImpl;
@override @useResult
$Res call({
 ActivityData data, bool isDeleting, ActivityUiEvent? event
});


@override $ActivityDataCopyWith<$Res> get data;@override $ActivityUiEventCopyWith<$Res>? get event;

}
/// @nodoc
class __$ActivityStateCopyWithImpl<$Res>
    implements _$ActivityStateCopyWith<$Res> {
  __$ActivityStateCopyWithImpl(this._self, this._then);

  final _ActivityState _self;
  final $Res Function(_ActivityState) _then;

/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? isDeleting = null,Object? event = freezed,}) {
  return _then(_ActivityState(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ActivityData,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as ActivityUiEvent?,
  ));
}

/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityDataCopyWith<$Res> get data {
  
  return $ActivityDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityUiEventCopyWith<$Res>? get event {
    if (_self.event == null) {
    return null;
  }

  return $ActivityUiEventCopyWith<$Res>(_self.event!, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
