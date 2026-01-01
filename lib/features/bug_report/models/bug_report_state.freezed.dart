// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bug_report_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BugReportUiEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BugReportUiEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BugReportUiEvent()';
}


}

/// @nodoc
class $BugReportUiEventCopyWith<$Res>  {
$BugReportUiEventCopyWith(BugReportUiEvent _, $Res Function(BugReportUiEvent) __);
}


/// Adds pattern-matching-related methods to [BugReportUiEvent].
extension BugReportUiEventPatterns on BugReportUiEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _BugReportSnackbar value)?  snackbar,TResult Function( _BugReportNone value)?  none,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BugReportSnackbar() when snackbar != null:
return snackbar(_that);case _BugReportNone() when none != null:
return none(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _BugReportSnackbar value)  snackbar,required TResult Function( _BugReportNone value)  none,}){
final _that = this;
switch (_that) {
case _BugReportSnackbar():
return snackbar(_that);case _BugReportNone():
return none(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _BugReportSnackbar value)?  snackbar,TResult? Function( _BugReportNone value)?  none,}){
final _that = this;
switch (_that) {
case _BugReportSnackbar() when snackbar != null:
return snackbar(_that);case _BugReportNone() when none != null:
return none(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  bool isError)?  snackbar,TResult Function()?  none,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BugReportSnackbar() when snackbar != null:
return snackbar(_that.message,_that.isError);case _BugReportNone() when none != null:
return none();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  bool isError)  snackbar,required TResult Function()  none,}) {final _that = this;
switch (_that) {
case _BugReportSnackbar():
return snackbar(_that.message,_that.isError);case _BugReportNone():
return none();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  bool isError)?  snackbar,TResult? Function()?  none,}) {final _that = this;
switch (_that) {
case _BugReportSnackbar() when snackbar != null:
return snackbar(_that.message,_that.isError);case _BugReportNone() when none != null:
return none();case _:
  return null;

}
}

}

/// @nodoc


class _BugReportSnackbar implements BugReportUiEvent {
  const _BugReportSnackbar({required this.message, this.isError = false});
  

 final  String message;
@JsonKey() final  bool isError;

/// Create a copy of BugReportUiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BugReportSnackbarCopyWith<_BugReportSnackbar> get copyWith => __$BugReportSnackbarCopyWithImpl<_BugReportSnackbar>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BugReportSnackbar&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'BugReportUiEvent.snackbar(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class _$BugReportSnackbarCopyWith<$Res> implements $BugReportUiEventCopyWith<$Res> {
  factory _$BugReportSnackbarCopyWith(_BugReportSnackbar value, $Res Function(_BugReportSnackbar) _then) = __$BugReportSnackbarCopyWithImpl;
@useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class __$BugReportSnackbarCopyWithImpl<$Res>
    implements _$BugReportSnackbarCopyWith<$Res> {
  __$BugReportSnackbarCopyWithImpl(this._self, this._then);

  final _BugReportSnackbar _self;
  final $Res Function(_BugReportSnackbar) _then;

/// Create a copy of BugReportUiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_BugReportSnackbar(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _BugReportNone implements BugReportUiEvent {
  const _BugReportNone();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BugReportNone);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BugReportUiEvent.none()';
}


}




/// @nodoc
mixin _$BugReportState {

 String get severity; String get category; bool get isSubmitting; BugReportUiEvent get uiEvent;
/// Create a copy of BugReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BugReportStateCopyWith<BugReportState> get copyWith => _$BugReportStateCopyWithImpl<BugReportState>(this as BugReportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BugReportState&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.category, category) || other.category == category)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
}


@override
int get hashCode => Object.hash(runtimeType,severity,category,isSubmitting,uiEvent);

@override
String toString() {
  return 'BugReportState(severity: $severity, category: $category, isSubmitting: $isSubmitting, uiEvent: $uiEvent)';
}


}

/// @nodoc
abstract mixin class $BugReportStateCopyWith<$Res>  {
  factory $BugReportStateCopyWith(BugReportState value, $Res Function(BugReportState) _then) = _$BugReportStateCopyWithImpl;
@useResult
$Res call({
 String severity, String category, bool isSubmitting, BugReportUiEvent uiEvent
});


$BugReportUiEventCopyWith<$Res> get uiEvent;

}
/// @nodoc
class _$BugReportStateCopyWithImpl<$Res>
    implements $BugReportStateCopyWith<$Res> {
  _$BugReportStateCopyWithImpl(this._self, this._then);

  final BugReportState _self;
  final $Res Function(BugReportState) _then;

/// Create a copy of BugReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? severity = null,Object? category = null,Object? isSubmitting = null,Object? uiEvent = null,}) {
  return _then(_self.copyWith(
severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,uiEvent: null == uiEvent ? _self.uiEvent : uiEvent // ignore: cast_nullable_to_non_nullable
as BugReportUiEvent,
  ));
}
/// Create a copy of BugReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BugReportUiEventCopyWith<$Res> get uiEvent {
  
  return $BugReportUiEventCopyWith<$Res>(_self.uiEvent, (value) {
    return _then(_self.copyWith(uiEvent: value));
  });
}
}


/// Adds pattern-matching-related methods to [BugReportState].
extension BugReportStatePatterns on BugReportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BugReportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BugReportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BugReportState value)  $default,){
final _that = this;
switch (_that) {
case _BugReportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BugReportState value)?  $default,){
final _that = this;
switch (_that) {
case _BugReportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String severity,  String category,  bool isSubmitting,  BugReportUiEvent uiEvent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BugReportState() when $default != null:
return $default(_that.severity,_that.category,_that.isSubmitting,_that.uiEvent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String severity,  String category,  bool isSubmitting,  BugReportUiEvent uiEvent)  $default,) {final _that = this;
switch (_that) {
case _BugReportState():
return $default(_that.severity,_that.category,_that.isSubmitting,_that.uiEvent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String severity,  String category,  bool isSubmitting,  BugReportUiEvent uiEvent)?  $default,) {final _that = this;
switch (_that) {
case _BugReportState() when $default != null:
return $default(_that.severity,_that.category,_that.isSubmitting,_that.uiEvent);case _:
  return null;

}
}

}

/// @nodoc


class _BugReportState implements BugReportState {
  const _BugReportState({this.severity = 'Medium', this.category = 'General', this.isSubmitting = false, this.uiEvent = const BugReportUiEvent.none()});
  

@override@JsonKey() final  String severity;
@override@JsonKey() final  String category;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  BugReportUiEvent uiEvent;

/// Create a copy of BugReportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BugReportStateCopyWith<_BugReportState> get copyWith => __$BugReportStateCopyWithImpl<_BugReportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BugReportState&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.category, category) || other.category == category)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
}


@override
int get hashCode => Object.hash(runtimeType,severity,category,isSubmitting,uiEvent);

@override
String toString() {
  return 'BugReportState(severity: $severity, category: $category, isSubmitting: $isSubmitting, uiEvent: $uiEvent)';
}


}

/// @nodoc
abstract mixin class _$BugReportStateCopyWith<$Res> implements $BugReportStateCopyWith<$Res> {
  factory _$BugReportStateCopyWith(_BugReportState value, $Res Function(_BugReportState) _then) = __$BugReportStateCopyWithImpl;
@override @useResult
$Res call({
 String severity, String category, bool isSubmitting, BugReportUiEvent uiEvent
});


@override $BugReportUiEventCopyWith<$Res> get uiEvent;

}
/// @nodoc
class __$BugReportStateCopyWithImpl<$Res>
    implements _$BugReportStateCopyWith<$Res> {
  __$BugReportStateCopyWithImpl(this._self, this._then);

  final _BugReportState _self;
  final $Res Function(_BugReportState) _then;

/// Create a copy of BugReportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? severity = null,Object? category = null,Object? isSubmitting = null,Object? uiEvent = null,}) {
  return _then(_BugReportState(
severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,uiEvent: null == uiEvent ? _self.uiEvent : uiEvent // ignore: cast_nullable_to_non_nullable
as BugReportUiEvent,
  ));
}

/// Create a copy of BugReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BugReportUiEventCopyWith<$Res> get uiEvent {
  
  return $BugReportUiEventCopyWith<$Res>(_self.uiEvent, (value) {
    return _then(_self.copyWith(uiEvent: value));
  });
}
}

// dart format on
