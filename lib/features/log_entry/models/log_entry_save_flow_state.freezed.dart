// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_entry_save_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LogEntryConfirmationRequest {

 LogEntryConfirmationType get type; String get title; String get message;
/// Create a copy of LogEntryConfirmationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogEntryConfirmationRequestCopyWith<LogEntryConfirmationRequest> get copyWith => _$LogEntryConfirmationRequestCopyWithImpl<LogEntryConfirmationRequest>(this as LogEntryConfirmationRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogEntryConfirmationRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,message);

@override
String toString() {
  return 'LogEntryConfirmationRequest(type: $type, title: $title, message: $message)';
}


}

/// @nodoc
abstract mixin class $LogEntryConfirmationRequestCopyWith<$Res>  {
  factory $LogEntryConfirmationRequestCopyWith(LogEntryConfirmationRequest value, $Res Function(LogEntryConfirmationRequest) _then) = _$LogEntryConfirmationRequestCopyWithImpl;
@useResult
$Res call({
 LogEntryConfirmationType type, String title, String message
});




}
/// @nodoc
class _$LogEntryConfirmationRequestCopyWithImpl<$Res>
    implements $LogEntryConfirmationRequestCopyWith<$Res> {
  _$LogEntryConfirmationRequestCopyWithImpl(this._self, this._then);

  final LogEntryConfirmationRequest _self;
  final $Res Function(LogEntryConfirmationRequest) _then;

/// Create a copy of LogEntryConfirmationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,Object? message = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LogEntryConfirmationType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LogEntryConfirmationRequest].
extension LogEntryConfirmationRequestPatterns on LogEntryConfirmationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogEntryConfirmationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogEntryConfirmationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogEntryConfirmationRequest value)  $default,){
final _that = this;
switch (_that) {
case _LogEntryConfirmationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogEntryConfirmationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LogEntryConfirmationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LogEntryConfirmationType type,  String title,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogEntryConfirmationRequest() when $default != null:
return $default(_that.type,_that.title,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LogEntryConfirmationType type,  String title,  String message)  $default,) {final _that = this;
switch (_that) {
case _LogEntryConfirmationRequest():
return $default(_that.type,_that.title,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LogEntryConfirmationType type,  String title,  String message)?  $default,) {final _that = this;
switch (_that) {
case _LogEntryConfirmationRequest() when $default != null:
return $default(_that.type,_that.title,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _LogEntryConfirmationRequest implements LogEntryConfirmationRequest {
  const _LogEntryConfirmationRequest({required this.type, required this.title, required this.message});
  

@override final  LogEntryConfirmationType type;
@override final  String title;
@override final  String message;

/// Create a copy of LogEntryConfirmationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogEntryConfirmationRequestCopyWith<_LogEntryConfirmationRequest> get copyWith => __$LogEntryConfirmationRequestCopyWithImpl<_LogEntryConfirmationRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogEntryConfirmationRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,message);

@override
String toString() {
  return 'LogEntryConfirmationRequest(type: $type, title: $title, message: $message)';
}


}

/// @nodoc
abstract mixin class _$LogEntryConfirmationRequestCopyWith<$Res> implements $LogEntryConfirmationRequestCopyWith<$Res> {
  factory _$LogEntryConfirmationRequestCopyWith(_LogEntryConfirmationRequest value, $Res Function(_LogEntryConfirmationRequest) _then) = __$LogEntryConfirmationRequestCopyWithImpl;
@override @useResult
$Res call({
 LogEntryConfirmationType type, String title, String message
});




}
/// @nodoc
class __$LogEntryConfirmationRequestCopyWithImpl<$Res>
    implements _$LogEntryConfirmationRequestCopyWith<$Res> {
  __$LogEntryConfirmationRequestCopyWithImpl(this._self, this._then);

  final _LogEntryConfirmationRequest _self;
  final $Res Function(_LogEntryConfirmationRequest) _then;

/// Create a copy of LogEntryConfirmationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,Object? message = null,}) {
  return _then(_LogEntryConfirmationRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LogEntryConfirmationType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LogEntrySaveFlowState {

 bool get isSaving; LogEntryConfirmationRequest? get pendingConfirmation; bool get roaConfirmed; bool get emotionsConfirmed; bool get cravingConfirmed; SaveResult? get lastResult; String? get errorTitle; String? get errorMessage;
/// Create a copy of LogEntrySaveFlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogEntrySaveFlowStateCopyWith<LogEntrySaveFlowState> get copyWith => _$LogEntrySaveFlowStateCopyWithImpl<LogEntrySaveFlowState>(this as LogEntrySaveFlowState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogEntrySaveFlowState&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.pendingConfirmation, pendingConfirmation) || other.pendingConfirmation == pendingConfirmation)&&(identical(other.roaConfirmed, roaConfirmed) || other.roaConfirmed == roaConfirmed)&&(identical(other.emotionsConfirmed, emotionsConfirmed) || other.emotionsConfirmed == emotionsConfirmed)&&(identical(other.cravingConfirmed, cravingConfirmed) || other.cravingConfirmed == cravingConfirmed)&&(identical(other.lastResult, lastResult) || other.lastResult == lastResult)&&(identical(other.errorTitle, errorTitle) || other.errorTitle == errorTitle)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isSaving,pendingConfirmation,roaConfirmed,emotionsConfirmed,cravingConfirmed,lastResult,errorTitle,errorMessage);

@override
String toString() {
  return 'LogEntrySaveFlowState(isSaving: $isSaving, pendingConfirmation: $pendingConfirmation, roaConfirmed: $roaConfirmed, emotionsConfirmed: $emotionsConfirmed, cravingConfirmed: $cravingConfirmed, lastResult: $lastResult, errorTitle: $errorTitle, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $LogEntrySaveFlowStateCopyWith<$Res>  {
  factory $LogEntrySaveFlowStateCopyWith(LogEntrySaveFlowState value, $Res Function(LogEntrySaveFlowState) _then) = _$LogEntrySaveFlowStateCopyWithImpl;
@useResult
$Res call({
 bool isSaving, LogEntryConfirmationRequest? pendingConfirmation, bool roaConfirmed, bool emotionsConfirmed, bool cravingConfirmed, SaveResult? lastResult, String? errorTitle, String? errorMessage
});


$LogEntryConfirmationRequestCopyWith<$Res>? get pendingConfirmation;

}
/// @nodoc
class _$LogEntrySaveFlowStateCopyWithImpl<$Res>
    implements $LogEntrySaveFlowStateCopyWith<$Res> {
  _$LogEntrySaveFlowStateCopyWithImpl(this._self, this._then);

  final LogEntrySaveFlowState _self;
  final $Res Function(LogEntrySaveFlowState) _then;

/// Create a copy of LogEntrySaveFlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSaving = null,Object? pendingConfirmation = freezed,Object? roaConfirmed = null,Object? emotionsConfirmed = null,Object? cravingConfirmed = null,Object? lastResult = freezed,Object? errorTitle = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,pendingConfirmation: freezed == pendingConfirmation ? _self.pendingConfirmation : pendingConfirmation // ignore: cast_nullable_to_non_nullable
as LogEntryConfirmationRequest?,roaConfirmed: null == roaConfirmed ? _self.roaConfirmed : roaConfirmed // ignore: cast_nullable_to_non_nullable
as bool,emotionsConfirmed: null == emotionsConfirmed ? _self.emotionsConfirmed : emotionsConfirmed // ignore: cast_nullable_to_non_nullable
as bool,cravingConfirmed: null == cravingConfirmed ? _self.cravingConfirmed : cravingConfirmed // ignore: cast_nullable_to_non_nullable
as bool,lastResult: freezed == lastResult ? _self.lastResult : lastResult // ignore: cast_nullable_to_non_nullable
as SaveResult?,errorTitle: freezed == errorTitle ? _self.errorTitle : errorTitle // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LogEntrySaveFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogEntryConfirmationRequestCopyWith<$Res>? get pendingConfirmation {
    if (_self.pendingConfirmation == null) {
    return null;
  }

  return $LogEntryConfirmationRequestCopyWith<$Res>(_self.pendingConfirmation!, (value) {
    return _then(_self.copyWith(pendingConfirmation: value));
  });
}
}


/// Adds pattern-matching-related methods to [LogEntrySaveFlowState].
extension LogEntrySaveFlowStatePatterns on LogEntrySaveFlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogEntrySaveFlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogEntrySaveFlowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogEntrySaveFlowState value)  $default,){
final _that = this;
switch (_that) {
case _LogEntrySaveFlowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogEntrySaveFlowState value)?  $default,){
final _that = this;
switch (_that) {
case _LogEntrySaveFlowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSaving,  LogEntryConfirmationRequest? pendingConfirmation,  bool roaConfirmed,  bool emotionsConfirmed,  bool cravingConfirmed,  SaveResult? lastResult,  String? errorTitle,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogEntrySaveFlowState() when $default != null:
return $default(_that.isSaving,_that.pendingConfirmation,_that.roaConfirmed,_that.emotionsConfirmed,_that.cravingConfirmed,_that.lastResult,_that.errorTitle,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSaving,  LogEntryConfirmationRequest? pendingConfirmation,  bool roaConfirmed,  bool emotionsConfirmed,  bool cravingConfirmed,  SaveResult? lastResult,  String? errorTitle,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _LogEntrySaveFlowState():
return $default(_that.isSaving,_that.pendingConfirmation,_that.roaConfirmed,_that.emotionsConfirmed,_that.cravingConfirmed,_that.lastResult,_that.errorTitle,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSaving,  LogEntryConfirmationRequest? pendingConfirmation,  bool roaConfirmed,  bool emotionsConfirmed,  bool cravingConfirmed,  SaveResult? lastResult,  String? errorTitle,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _LogEntrySaveFlowState() when $default != null:
return $default(_that.isSaving,_that.pendingConfirmation,_that.roaConfirmed,_that.emotionsConfirmed,_that.cravingConfirmed,_that.lastResult,_that.errorTitle,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LogEntrySaveFlowState extends LogEntrySaveFlowState {
  const _LogEntrySaveFlowState({this.isSaving = false, this.pendingConfirmation, this.roaConfirmed = false, this.emotionsConfirmed = false, this.cravingConfirmed = false, this.lastResult, this.errorTitle, this.errorMessage}): super._();
  

@override@JsonKey() final  bool isSaving;
@override final  LogEntryConfirmationRequest? pendingConfirmation;
@override@JsonKey() final  bool roaConfirmed;
@override@JsonKey() final  bool emotionsConfirmed;
@override@JsonKey() final  bool cravingConfirmed;
@override final  SaveResult? lastResult;
@override final  String? errorTitle;
@override final  String? errorMessage;

/// Create a copy of LogEntrySaveFlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogEntrySaveFlowStateCopyWith<_LogEntrySaveFlowState> get copyWith => __$LogEntrySaveFlowStateCopyWithImpl<_LogEntrySaveFlowState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogEntrySaveFlowState&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.pendingConfirmation, pendingConfirmation) || other.pendingConfirmation == pendingConfirmation)&&(identical(other.roaConfirmed, roaConfirmed) || other.roaConfirmed == roaConfirmed)&&(identical(other.emotionsConfirmed, emotionsConfirmed) || other.emotionsConfirmed == emotionsConfirmed)&&(identical(other.cravingConfirmed, cravingConfirmed) || other.cravingConfirmed == cravingConfirmed)&&(identical(other.lastResult, lastResult) || other.lastResult == lastResult)&&(identical(other.errorTitle, errorTitle) || other.errorTitle == errorTitle)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isSaving,pendingConfirmation,roaConfirmed,emotionsConfirmed,cravingConfirmed,lastResult,errorTitle,errorMessage);

@override
String toString() {
  return 'LogEntrySaveFlowState(isSaving: $isSaving, pendingConfirmation: $pendingConfirmation, roaConfirmed: $roaConfirmed, emotionsConfirmed: $emotionsConfirmed, cravingConfirmed: $cravingConfirmed, lastResult: $lastResult, errorTitle: $errorTitle, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$LogEntrySaveFlowStateCopyWith<$Res> implements $LogEntrySaveFlowStateCopyWith<$Res> {
  factory _$LogEntrySaveFlowStateCopyWith(_LogEntrySaveFlowState value, $Res Function(_LogEntrySaveFlowState) _then) = __$LogEntrySaveFlowStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSaving, LogEntryConfirmationRequest? pendingConfirmation, bool roaConfirmed, bool emotionsConfirmed, bool cravingConfirmed, SaveResult? lastResult, String? errorTitle, String? errorMessage
});


@override $LogEntryConfirmationRequestCopyWith<$Res>? get pendingConfirmation;

}
/// @nodoc
class __$LogEntrySaveFlowStateCopyWithImpl<$Res>
    implements _$LogEntrySaveFlowStateCopyWith<$Res> {
  __$LogEntrySaveFlowStateCopyWithImpl(this._self, this._then);

  final _LogEntrySaveFlowState _self;
  final $Res Function(_LogEntrySaveFlowState) _then;

/// Create a copy of LogEntrySaveFlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSaving = null,Object? pendingConfirmation = freezed,Object? roaConfirmed = null,Object? emotionsConfirmed = null,Object? cravingConfirmed = null,Object? lastResult = freezed,Object? errorTitle = freezed,Object? errorMessage = freezed,}) {
  return _then(_LogEntrySaveFlowState(
isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,pendingConfirmation: freezed == pendingConfirmation ? _self.pendingConfirmation : pendingConfirmation // ignore: cast_nullable_to_non_nullable
as LogEntryConfirmationRequest?,roaConfirmed: null == roaConfirmed ? _self.roaConfirmed : roaConfirmed // ignore: cast_nullable_to_non_nullable
as bool,emotionsConfirmed: null == emotionsConfirmed ? _self.emotionsConfirmed : emotionsConfirmed // ignore: cast_nullable_to_non_nullable
as bool,cravingConfirmed: null == cravingConfirmed ? _self.cravingConfirmed : cravingConfirmed // ignore: cast_nullable_to_non_nullable
as bool,lastResult: freezed == lastResult ? _self.lastResult : lastResult // ignore: cast_nullable_to_non_nullable
as SaveResult?,errorTitle: freezed == errorTitle ? _self.errorTitle : errorTitle // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LogEntrySaveFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogEntryConfirmationRequestCopyWith<$Res>? get pendingConfirmation {
    if (_self.pendingConfirmation == null) {
    return null;
  }

  return $LogEntryConfirmationRequestCopyWith<$Res>(_self.pendingConfirmation!, (value) {
    return _then(_self.copyWith(pendingConfirmation: value));
  });
}
}

// dart format on
