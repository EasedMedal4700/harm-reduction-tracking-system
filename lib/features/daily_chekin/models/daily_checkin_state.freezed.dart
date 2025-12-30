// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_checkin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyCheckinUiEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyCheckinUiEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyCheckinUiEvent()';
}


}

/// @nodoc
class $DailyCheckinUiEventCopyWith<$Res>  {
$DailyCheckinUiEventCopyWith(DailyCheckinUiEvent _, $Res Function(DailyCheckinUiEvent) __);
}


/// Adds pattern-matching-related methods to [DailyCheckinUiEvent].
extension DailyCheckinUiEventPatterns on DailyCheckinUiEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _DailyCheckinSnackbar value)?  snackbar,TResult Function( _DailyCheckinClose value)?  close,TResult Function( _DailyCheckinNone value)?  none,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyCheckinSnackbar() when snackbar != null:
return snackbar(_that);case _DailyCheckinClose() when close != null:
return close(_that);case _DailyCheckinNone() when none != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _DailyCheckinSnackbar value)  snackbar,required TResult Function( _DailyCheckinClose value)  close,required TResult Function( _DailyCheckinNone value)  none,}){
final _that = this;
switch (_that) {
case _DailyCheckinSnackbar():
return snackbar(_that);case _DailyCheckinClose():
return close(_that);case _DailyCheckinNone():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _DailyCheckinSnackbar value)?  snackbar,TResult? Function( _DailyCheckinClose value)?  close,TResult? Function( _DailyCheckinNone value)?  none,}){
final _that = this;
switch (_that) {
case _DailyCheckinSnackbar() when snackbar != null:
return snackbar(_that);case _DailyCheckinClose() when close != null:
return close(_that);case _DailyCheckinNone() when none != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  bool isError)?  snackbar,TResult Function()?  close,TResult Function()?  none,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyCheckinSnackbar() when snackbar != null:
return snackbar(_that.message,_that.isError);case _DailyCheckinClose() when close != null:
return close();case _DailyCheckinNone() when none != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  bool isError)  snackbar,required TResult Function()  close,required TResult Function()  none,}) {final _that = this;
switch (_that) {
case _DailyCheckinSnackbar():
return snackbar(_that.message,_that.isError);case _DailyCheckinClose():
return close();case _DailyCheckinNone():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  bool isError)?  snackbar,TResult? Function()?  close,TResult? Function()?  none,}) {final _that = this;
switch (_that) {
case _DailyCheckinSnackbar() when snackbar != null:
return snackbar(_that.message,_that.isError);case _DailyCheckinClose() when close != null:
return close();case _DailyCheckinNone() when none != null:
return none();case _:
  return null;

}
}

}

/// @nodoc


class _DailyCheckinSnackbar implements DailyCheckinUiEvent {
  const _DailyCheckinSnackbar({required this.message, this.isError = false});
  

 final  String message;
@JsonKey() final  bool isError;

/// Create a copy of DailyCheckinUiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCheckinSnackbarCopyWith<_DailyCheckinSnackbar> get copyWith => __$DailyCheckinSnackbarCopyWithImpl<_DailyCheckinSnackbar>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCheckinSnackbar&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'DailyCheckinUiEvent.snackbar(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class _$DailyCheckinSnackbarCopyWith<$Res> implements $DailyCheckinUiEventCopyWith<$Res> {
  factory _$DailyCheckinSnackbarCopyWith(_DailyCheckinSnackbar value, $Res Function(_DailyCheckinSnackbar) _then) = __$DailyCheckinSnackbarCopyWithImpl;
@useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class __$DailyCheckinSnackbarCopyWithImpl<$Res>
    implements _$DailyCheckinSnackbarCopyWith<$Res> {
  __$DailyCheckinSnackbarCopyWithImpl(this._self, this._then);

  final _DailyCheckinSnackbar _self;
  final $Res Function(_DailyCheckinSnackbar) _then;

/// Create a copy of DailyCheckinUiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_DailyCheckinSnackbar(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _DailyCheckinClose implements DailyCheckinUiEvent {
  const _DailyCheckinClose();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCheckinClose);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyCheckinUiEvent.close()';
}


}




/// @nodoc


class _DailyCheckinNone implements DailyCheckinUiEvent {
  const _DailyCheckinNone();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCheckinNone);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyCheckinUiEvent.none()';
}


}




/// @nodoc
mixin _$DailyCheckinState {

 String get mood; List<String> get emotions; String get timeOfDay; String get notes; DateTime? get selectedDate; TimeOfDay? get selectedTime; DailyCheckin? get existingCheckin; List<DailyCheckin> get recentCheckins; bool get isSaving; bool get isLoading; DailyCheckinUiEvent get uiEvent;
/// Create a copy of DailyCheckinState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyCheckinStateCopyWith<DailyCheckinState> get copyWith => _$DailyCheckinStateCopyWithImpl<DailyCheckinState>(this as DailyCheckinState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyCheckinState&&(identical(other.mood, mood) || other.mood == mood)&&const DeepCollectionEquality().equals(other.emotions, emotions)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.selectedTime, selectedTime) || other.selectedTime == selectedTime)&&(identical(other.existingCheckin, existingCheckin) || other.existingCheckin == existingCheckin)&&const DeepCollectionEquality().equals(other.recentCheckins, recentCheckins)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
}


@override
int get hashCode => Object.hash(runtimeType,mood,const DeepCollectionEquality().hash(emotions),timeOfDay,notes,selectedDate,selectedTime,existingCheckin,const DeepCollectionEquality().hash(recentCheckins),isSaving,isLoading,uiEvent);

@override
String toString() {
  return 'DailyCheckinState(mood: $mood, emotions: $emotions, timeOfDay: $timeOfDay, notes: $notes, selectedDate: $selectedDate, selectedTime: $selectedTime, existingCheckin: $existingCheckin, recentCheckins: $recentCheckins, isSaving: $isSaving, isLoading: $isLoading, uiEvent: $uiEvent)';
}


}

/// @nodoc
abstract mixin class $DailyCheckinStateCopyWith<$Res>  {
  factory $DailyCheckinStateCopyWith(DailyCheckinState value, $Res Function(DailyCheckinState) _then) = _$DailyCheckinStateCopyWithImpl;
@useResult
$Res call({
 String mood, List<String> emotions, String timeOfDay, String notes, DateTime? selectedDate, TimeOfDay? selectedTime, DailyCheckin? existingCheckin, List<DailyCheckin> recentCheckins, bool isSaving, bool isLoading, DailyCheckinUiEvent uiEvent
});


$DailyCheckinUiEventCopyWith<$Res> get uiEvent;

}
/// @nodoc
class _$DailyCheckinStateCopyWithImpl<$Res>
    implements $DailyCheckinStateCopyWith<$Res> {
  _$DailyCheckinStateCopyWithImpl(this._self, this._then);

  final DailyCheckinState _self;
  final $Res Function(DailyCheckinState) _then;

/// Create a copy of DailyCheckinState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mood = null,Object? emotions = null,Object? timeOfDay = null,Object? notes = null,Object? selectedDate = freezed,Object? selectedTime = freezed,Object? existingCheckin = freezed,Object? recentCheckins = null,Object? isSaving = null,Object? isLoading = null,Object? uiEvent = null,}) {
  return _then(_self.copyWith(
mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,emotions: null == emotions ? _self.emotions : emotions // ignore: cast_nullable_to_non_nullable
as List<String>,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedTime: freezed == selectedTime ? _self.selectedTime : selectedTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,existingCheckin: freezed == existingCheckin ? _self.existingCheckin : existingCheckin // ignore: cast_nullable_to_non_nullable
as DailyCheckin?,recentCheckins: null == recentCheckins ? _self.recentCheckins : recentCheckins // ignore: cast_nullable_to_non_nullable
as List<DailyCheckin>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,uiEvent: null == uiEvent ? _self.uiEvent : uiEvent // ignore: cast_nullable_to_non_nullable
as DailyCheckinUiEvent,
  ));
}
/// Create a copy of DailyCheckinState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyCheckinUiEventCopyWith<$Res> get uiEvent {
  
  return $DailyCheckinUiEventCopyWith<$Res>(_self.uiEvent, (value) {
    return _then(_self.copyWith(uiEvent: value));
  });
}
}


/// Adds pattern-matching-related methods to [DailyCheckinState].
extension DailyCheckinStatePatterns on DailyCheckinState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyCheckinState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyCheckinState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyCheckinState value)  $default,){
final _that = this;
switch (_that) {
case _DailyCheckinState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyCheckinState value)?  $default,){
final _that = this;
switch (_that) {
case _DailyCheckinState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mood,  List<String> emotions,  String timeOfDay,  String notes,  DateTime? selectedDate,  TimeOfDay? selectedTime,  DailyCheckin? existingCheckin,  List<DailyCheckin> recentCheckins,  bool isSaving,  bool isLoading,  DailyCheckinUiEvent uiEvent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyCheckinState() when $default != null:
return $default(_that.mood,_that.emotions,_that.timeOfDay,_that.notes,_that.selectedDate,_that.selectedTime,_that.existingCheckin,_that.recentCheckins,_that.isSaving,_that.isLoading,_that.uiEvent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mood,  List<String> emotions,  String timeOfDay,  String notes,  DateTime? selectedDate,  TimeOfDay? selectedTime,  DailyCheckin? existingCheckin,  List<DailyCheckin> recentCheckins,  bool isSaving,  bool isLoading,  DailyCheckinUiEvent uiEvent)  $default,) {final _that = this;
switch (_that) {
case _DailyCheckinState():
return $default(_that.mood,_that.emotions,_that.timeOfDay,_that.notes,_that.selectedDate,_that.selectedTime,_that.existingCheckin,_that.recentCheckins,_that.isSaving,_that.isLoading,_that.uiEvent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mood,  List<String> emotions,  String timeOfDay,  String notes,  DateTime? selectedDate,  TimeOfDay? selectedTime,  DailyCheckin? existingCheckin,  List<DailyCheckin> recentCheckins,  bool isSaving,  bool isLoading,  DailyCheckinUiEvent uiEvent)?  $default,) {final _that = this;
switch (_that) {
case _DailyCheckinState() when $default != null:
return $default(_that.mood,_that.emotions,_that.timeOfDay,_that.notes,_that.selectedDate,_that.selectedTime,_that.existingCheckin,_that.recentCheckins,_that.isSaving,_that.isLoading,_that.uiEvent);case _:
  return null;

}
}

}

/// @nodoc


class _DailyCheckinState implements DailyCheckinState {
  const _DailyCheckinState({this.mood = 'Neutral', final  List<String> emotions = const <String>[], this.timeOfDay = 'morning', this.notes = '', this.selectedDate, this.selectedTime, this.existingCheckin, final  List<DailyCheckin> recentCheckins = const <DailyCheckin>[], this.isSaving = false, this.isLoading = false, this.uiEvent = const DailyCheckinUiEvent.none()}): _emotions = emotions,_recentCheckins = recentCheckins;
  

@override@JsonKey() final  String mood;
 final  List<String> _emotions;
@override@JsonKey() List<String> get emotions {
  if (_emotions is EqualUnmodifiableListView) return _emotions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_emotions);
}

@override@JsonKey() final  String timeOfDay;
@override@JsonKey() final  String notes;
@override final  DateTime? selectedDate;
@override final  TimeOfDay? selectedTime;
@override final  DailyCheckin? existingCheckin;
 final  List<DailyCheckin> _recentCheckins;
@override@JsonKey() List<DailyCheckin> get recentCheckins {
  if (_recentCheckins is EqualUnmodifiableListView) return _recentCheckins;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentCheckins);
}

@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  DailyCheckinUiEvent uiEvent;

/// Create a copy of DailyCheckinState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCheckinStateCopyWith<_DailyCheckinState> get copyWith => __$DailyCheckinStateCopyWithImpl<_DailyCheckinState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCheckinState&&(identical(other.mood, mood) || other.mood == mood)&&const DeepCollectionEquality().equals(other._emotions, _emotions)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.selectedTime, selectedTime) || other.selectedTime == selectedTime)&&(identical(other.existingCheckin, existingCheckin) || other.existingCheckin == existingCheckin)&&const DeepCollectionEquality().equals(other._recentCheckins, _recentCheckins)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
}


@override
int get hashCode => Object.hash(runtimeType,mood,const DeepCollectionEquality().hash(_emotions),timeOfDay,notes,selectedDate,selectedTime,existingCheckin,const DeepCollectionEquality().hash(_recentCheckins),isSaving,isLoading,uiEvent);

@override
String toString() {
  return 'DailyCheckinState(mood: $mood, emotions: $emotions, timeOfDay: $timeOfDay, notes: $notes, selectedDate: $selectedDate, selectedTime: $selectedTime, existingCheckin: $existingCheckin, recentCheckins: $recentCheckins, isSaving: $isSaving, isLoading: $isLoading, uiEvent: $uiEvent)';
}


}

/// @nodoc
abstract mixin class _$DailyCheckinStateCopyWith<$Res> implements $DailyCheckinStateCopyWith<$Res> {
  factory _$DailyCheckinStateCopyWith(_DailyCheckinState value, $Res Function(_DailyCheckinState) _then) = __$DailyCheckinStateCopyWithImpl;
@override @useResult
$Res call({
 String mood, List<String> emotions, String timeOfDay, String notes, DateTime? selectedDate, TimeOfDay? selectedTime, DailyCheckin? existingCheckin, List<DailyCheckin> recentCheckins, bool isSaving, bool isLoading, DailyCheckinUiEvent uiEvent
});


@override $DailyCheckinUiEventCopyWith<$Res> get uiEvent;

}
/// @nodoc
class __$DailyCheckinStateCopyWithImpl<$Res>
    implements _$DailyCheckinStateCopyWith<$Res> {
  __$DailyCheckinStateCopyWithImpl(this._self, this._then);

  final _DailyCheckinState _self;
  final $Res Function(_DailyCheckinState) _then;

/// Create a copy of DailyCheckinState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mood = null,Object? emotions = null,Object? timeOfDay = null,Object? notes = null,Object? selectedDate = freezed,Object? selectedTime = freezed,Object? existingCheckin = freezed,Object? recentCheckins = null,Object? isSaving = null,Object? isLoading = null,Object? uiEvent = null,}) {
  return _then(_DailyCheckinState(
mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,emotions: null == emotions ? _self._emotions : emotions // ignore: cast_nullable_to_non_nullable
as List<String>,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,selectedTime: freezed == selectedTime ? _self.selectedTime : selectedTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,existingCheckin: freezed == existingCheckin ? _self.existingCheckin : existingCheckin // ignore: cast_nullable_to_non_nullable
as DailyCheckin?,recentCheckins: null == recentCheckins ? _self._recentCheckins : recentCheckins // ignore: cast_nullable_to_non_nullable
as List<DailyCheckin>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,uiEvent: null == uiEvent ? _self.uiEvent : uiEvent // ignore: cast_nullable_to_non_nullable
as DailyCheckinUiEvent,
  ));
}

/// Create a copy of DailyCheckinState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyCheckinUiEventCopyWith<$Res> get uiEvent {
  
  return $DailyCheckinUiEventCopyWith<$Res>(_self.uiEvent, (value) {
    return _then(_self.copyWith(uiEvent: value));
  });
}
}

// dart format on
