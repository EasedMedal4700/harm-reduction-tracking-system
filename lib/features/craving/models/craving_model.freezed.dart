// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'craving_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Craving {

 String? get cravingId; String get userId; String get substance; double get intensity; DateTime get date; String get time; String get location; String get people; String get activity; String get thoughts; List<String> get triggers; List<String> get bodySensations; String get primaryEmotion; String? get secondaryEmotion; String get action; double get timezone;
/// Create a copy of Craving
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CravingCopyWith<Craving> get copyWith => _$CravingCopyWithImpl<Craving>(this as Craving, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Craving&&(identical(other.cravingId, cravingId) || other.cravingId == cravingId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.substance, substance) || other.substance == substance)&&(identical(other.intensity, intensity) || other.intensity == intensity)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.location, location) || other.location == location)&&(identical(other.people, people) || other.people == people)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.thoughts, thoughts) || other.thoughts == thoughts)&&const DeepCollectionEquality().equals(other.triggers, triggers)&&const DeepCollectionEquality().equals(other.bodySensations, bodySensations)&&(identical(other.primaryEmotion, primaryEmotion) || other.primaryEmotion == primaryEmotion)&&(identical(other.secondaryEmotion, secondaryEmotion) || other.secondaryEmotion == secondaryEmotion)&&(identical(other.action, action) || other.action == action)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}


@override
int get hashCode => Object.hash(runtimeType,cravingId,userId,substance,intensity,date,time,location,people,activity,thoughts,const DeepCollectionEquality().hash(triggers),const DeepCollectionEquality().hash(bodySensations),primaryEmotion,secondaryEmotion,action,timezone);

@override
String toString() {
  return 'Craving(cravingId: $cravingId, userId: $userId, substance: $substance, intensity: $intensity, date: $date, time: $time, location: $location, people: $people, activity: $activity, thoughts: $thoughts, triggers: $triggers, bodySensations: $bodySensations, primaryEmotion: $primaryEmotion, secondaryEmotion: $secondaryEmotion, action: $action, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $CravingCopyWith<$Res>  {
  factory $CravingCopyWith(Craving value, $Res Function(Craving) _then) = _$CravingCopyWithImpl;
@useResult
$Res call({
 String? cravingId, String userId, String substance, double intensity, DateTime date, String time, String location, String people, String activity, String thoughts, List<String> triggers, List<String> bodySensations, String primaryEmotion, String? secondaryEmotion, String action, double timezone
});




}
/// @nodoc
class _$CravingCopyWithImpl<$Res>
    implements $CravingCopyWith<$Res> {
  _$CravingCopyWithImpl(this._self, this._then);

  final Craving _self;
  final $Res Function(Craving) _then;

/// Create a copy of Craving
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cravingId = freezed,Object? userId = null,Object? substance = null,Object? intensity = null,Object? date = null,Object? time = null,Object? location = null,Object? people = null,Object? activity = null,Object? thoughts = null,Object? triggers = null,Object? bodySensations = null,Object? primaryEmotion = null,Object? secondaryEmotion = freezed,Object? action = null,Object? timezone = null,}) {
  return _then(_self.copyWith(
cravingId: freezed == cravingId ? _self.cravingId : cravingId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,substance: null == substance ? _self.substance : substance // ignore: cast_nullable_to_non_nullable
as String,intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,thoughts: null == thoughts ? _self.thoughts : thoughts // ignore: cast_nullable_to_non_nullable
as String,triggers: null == triggers ? _self.triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<String>,bodySensations: null == bodySensations ? _self.bodySensations : bodySensations // ignore: cast_nullable_to_non_nullable
as List<String>,primaryEmotion: null == primaryEmotion ? _self.primaryEmotion : primaryEmotion // ignore: cast_nullable_to_non_nullable
as String,secondaryEmotion: freezed == secondaryEmotion ? _self.secondaryEmotion : secondaryEmotion // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Craving].
extension CravingPatterns on Craving {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Craving value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Craving() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Craving value)  $default,){
final _that = this;
switch (_that) {
case _Craving():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Craving value)?  $default,){
final _that = this;
switch (_that) {
case _Craving() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? cravingId,  String userId,  String substance,  double intensity,  DateTime date,  String time,  String location,  String people,  String activity,  String thoughts,  List<String> triggers,  List<String> bodySensations,  String primaryEmotion,  String? secondaryEmotion,  String action,  double timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Craving() when $default != null:
return $default(_that.cravingId,_that.userId,_that.substance,_that.intensity,_that.date,_that.time,_that.location,_that.people,_that.activity,_that.thoughts,_that.triggers,_that.bodySensations,_that.primaryEmotion,_that.secondaryEmotion,_that.action,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? cravingId,  String userId,  String substance,  double intensity,  DateTime date,  String time,  String location,  String people,  String activity,  String thoughts,  List<String> triggers,  List<String> bodySensations,  String primaryEmotion,  String? secondaryEmotion,  String action,  double timezone)  $default,) {final _that = this;
switch (_that) {
case _Craving():
return $default(_that.cravingId,_that.userId,_that.substance,_that.intensity,_that.date,_that.time,_that.location,_that.people,_that.activity,_that.thoughts,_that.triggers,_that.bodySensations,_that.primaryEmotion,_that.secondaryEmotion,_that.action,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? cravingId,  String userId,  String substance,  double intensity,  DateTime date,  String time,  String location,  String people,  String activity,  String thoughts,  List<String> triggers,  List<String> bodySensations,  String primaryEmotion,  String? secondaryEmotion,  String action,  double timezone)?  $default,) {final _that = this;
switch (_that) {
case _Craving() when $default != null:
return $default(_that.cravingId,_that.userId,_that.substance,_that.intensity,_that.date,_that.time,_that.location,_that.people,_that.activity,_that.thoughts,_that.triggers,_that.bodySensations,_that.primaryEmotion,_that.secondaryEmotion,_that.action,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc


class _Craving extends Craving {
  const _Craving({this.cravingId, required this.userId, required this.substance, required this.intensity, required this.date, required this.time, required this.location, required this.people, required this.activity, required this.thoughts, required final  List<String> triggers, required final  List<String> bodySensations, required this.primaryEmotion, this.secondaryEmotion, required this.action, required this.timezone}): _triggers = triggers,_bodySensations = bodySensations,super._();
  

@override final  String? cravingId;
@override final  String userId;
@override final  String substance;
@override final  double intensity;
@override final  DateTime date;
@override final  String time;
@override final  String location;
@override final  String people;
@override final  String activity;
@override final  String thoughts;
 final  List<String> _triggers;
@override List<String> get triggers {
  if (_triggers is EqualUnmodifiableListView) return _triggers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_triggers);
}

 final  List<String> _bodySensations;
@override List<String> get bodySensations {
  if (_bodySensations is EqualUnmodifiableListView) return _bodySensations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bodySensations);
}

@override final  String primaryEmotion;
@override final  String? secondaryEmotion;
@override final  String action;
@override final  double timezone;

/// Create a copy of Craving
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CravingCopyWith<_Craving> get copyWith => __$CravingCopyWithImpl<_Craving>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Craving&&(identical(other.cravingId, cravingId) || other.cravingId == cravingId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.substance, substance) || other.substance == substance)&&(identical(other.intensity, intensity) || other.intensity == intensity)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.location, location) || other.location == location)&&(identical(other.people, people) || other.people == people)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.thoughts, thoughts) || other.thoughts == thoughts)&&const DeepCollectionEquality().equals(other._triggers, _triggers)&&const DeepCollectionEquality().equals(other._bodySensations, _bodySensations)&&(identical(other.primaryEmotion, primaryEmotion) || other.primaryEmotion == primaryEmotion)&&(identical(other.secondaryEmotion, secondaryEmotion) || other.secondaryEmotion == secondaryEmotion)&&(identical(other.action, action) || other.action == action)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}


@override
int get hashCode => Object.hash(runtimeType,cravingId,userId,substance,intensity,date,time,location,people,activity,thoughts,const DeepCollectionEquality().hash(_triggers),const DeepCollectionEquality().hash(_bodySensations),primaryEmotion,secondaryEmotion,action,timezone);

@override
String toString() {
  return 'Craving(cravingId: $cravingId, userId: $userId, substance: $substance, intensity: $intensity, date: $date, time: $time, location: $location, people: $people, activity: $activity, thoughts: $thoughts, triggers: $triggers, bodySensations: $bodySensations, primaryEmotion: $primaryEmotion, secondaryEmotion: $secondaryEmotion, action: $action, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$CravingCopyWith<$Res> implements $CravingCopyWith<$Res> {
  factory _$CravingCopyWith(_Craving value, $Res Function(_Craving) _then) = __$CravingCopyWithImpl;
@override @useResult
$Res call({
 String? cravingId, String userId, String substance, double intensity, DateTime date, String time, String location, String people, String activity, String thoughts, List<String> triggers, List<String> bodySensations, String primaryEmotion, String? secondaryEmotion, String action, double timezone
});




}
/// @nodoc
class __$CravingCopyWithImpl<$Res>
    implements _$CravingCopyWith<$Res> {
  __$CravingCopyWithImpl(this._self, this._then);

  final _Craving _self;
  final $Res Function(_Craving) _then;

/// Create a copy of Craving
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cravingId = freezed,Object? userId = null,Object? substance = null,Object? intensity = null,Object? date = null,Object? time = null,Object? location = null,Object? people = null,Object? activity = null,Object? thoughts = null,Object? triggers = null,Object? bodySensations = null,Object? primaryEmotion = null,Object? secondaryEmotion = freezed,Object? action = null,Object? timezone = null,}) {
  return _then(_Craving(
cravingId: freezed == cravingId ? _self.cravingId : cravingId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,substance: null == substance ? _self.substance : substance // ignore: cast_nullable_to_non_nullable
as String,intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,thoughts: null == thoughts ? _self.thoughts : thoughts // ignore: cast_nullable_to_non_nullable
as String,triggers: null == triggers ? _self._triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<String>,bodySensations: null == bodySensations ? _self._bodySensations : bodySensations // ignore: cast_nullable_to_non_nullable
as List<String>,primaryEmotion: null == primaryEmotion ? _self.primaryEmotion : primaryEmotion // ignore: cast_nullable_to_non_nullable
as String,secondaryEmotion: freezed == secondaryEmotion ? _self.secondaryEmotion : secondaryEmotion // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
