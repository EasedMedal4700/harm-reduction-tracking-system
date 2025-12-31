// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_checkin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyCheckin {

 String? get id; String get userId; DateTime get checkinDate; String get mood; List<String> get emotions; String get timeOfDay; String? get notes; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of DailyCheckin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyCheckinCopyWith<DailyCheckin> get copyWith => _$DailyCheckinCopyWithImpl<DailyCheckin>(this as DailyCheckin, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyCheckin&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.checkinDate, checkinDate) || other.checkinDate == checkinDate)&&(identical(other.mood, mood) || other.mood == mood)&&const DeepCollectionEquality().equals(other.emotions, emotions)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,checkinDate,mood,const DeepCollectionEquality().hash(emotions),timeOfDay,notes,createdAt,updatedAt);

@override
String toString() {
  return 'DailyCheckin(id: $id, userId: $userId, checkinDate: $checkinDate, mood: $mood, emotions: $emotions, timeOfDay: $timeOfDay, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DailyCheckinCopyWith<$Res>  {
  factory $DailyCheckinCopyWith(DailyCheckin value, $Res Function(DailyCheckin) _then) = _$DailyCheckinCopyWithImpl;
@useResult
$Res call({
 String? id, String userId, DateTime checkinDate, String mood, List<String> emotions, String timeOfDay, String? notes, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$DailyCheckinCopyWithImpl<$Res>
    implements $DailyCheckinCopyWith<$Res> {
  _$DailyCheckinCopyWithImpl(this._self, this._then);

  final DailyCheckin _self;
  final $Res Function(DailyCheckin) _then;

/// Create a copy of DailyCheckin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? checkinDate = null,Object? mood = null,Object? emotions = null,Object? timeOfDay = null,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,checkinDate: null == checkinDate ? _self.checkinDate : checkinDate // ignore: cast_nullable_to_non_nullable
as DateTime,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,emotions: null == emotions ? _self.emotions : emotions // ignore: cast_nullable_to_non_nullable
as List<String>,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyCheckin].
extension DailyCheckinPatterns on DailyCheckin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyCheckin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyCheckin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyCheckin value)  $default,){
final _that = this;
switch (_that) {
case _DailyCheckin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyCheckin value)?  $default,){
final _that = this;
switch (_that) {
case _DailyCheckin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String userId,  DateTime checkinDate,  String mood,  List<String> emotions,  String timeOfDay,  String? notes,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyCheckin() when $default != null:
return $default(_that.id,_that.userId,_that.checkinDate,_that.mood,_that.emotions,_that.timeOfDay,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String userId,  DateTime checkinDate,  String mood,  List<String> emotions,  String timeOfDay,  String? notes,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DailyCheckin():
return $default(_that.id,_that.userId,_that.checkinDate,_that.mood,_that.emotions,_that.timeOfDay,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String userId,  DateTime checkinDate,  String mood,  List<String> emotions,  String timeOfDay,  String? notes,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DailyCheckin() when $default != null:
return $default(_that.id,_that.userId,_that.checkinDate,_that.mood,_that.emotions,_that.timeOfDay,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DailyCheckin extends DailyCheckin {
  const _DailyCheckin({this.id, required this.userId, required this.checkinDate, required this.mood, final  List<String> emotions = const [], required this.timeOfDay, this.notes, this.createdAt, this.updatedAt}): _emotions = emotions,super._();
  

@override final  String? id;
@override final  String userId;
@override final  DateTime checkinDate;
@override final  String mood;
 final  List<String> _emotions;
@override@JsonKey() List<String> get emotions {
  if (_emotions is EqualUnmodifiableListView) return _emotions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_emotions);
}

@override final  String timeOfDay;
@override final  String? notes;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of DailyCheckin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCheckinCopyWith<_DailyCheckin> get copyWith => __$DailyCheckinCopyWithImpl<_DailyCheckin>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCheckin&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.checkinDate, checkinDate) || other.checkinDate == checkinDate)&&(identical(other.mood, mood) || other.mood == mood)&&const DeepCollectionEquality().equals(other._emotions, _emotions)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,checkinDate,mood,const DeepCollectionEquality().hash(_emotions),timeOfDay,notes,createdAt,updatedAt);

@override
String toString() {
  return 'DailyCheckin(id: $id, userId: $userId, checkinDate: $checkinDate, mood: $mood, emotions: $emotions, timeOfDay: $timeOfDay, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DailyCheckinCopyWith<$Res> implements $DailyCheckinCopyWith<$Res> {
  factory _$DailyCheckinCopyWith(_DailyCheckin value, $Res Function(_DailyCheckin) _then) = __$DailyCheckinCopyWithImpl;
@override @useResult
$Res call({
 String? id, String userId, DateTime checkinDate, String mood, List<String> emotions, String timeOfDay, String? notes, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$DailyCheckinCopyWithImpl<$Res>
    implements _$DailyCheckinCopyWith<$Res> {
  __$DailyCheckinCopyWithImpl(this._self, this._then);

  final _DailyCheckin _self;
  final $Res Function(_DailyCheckin) _then;

/// Create a copy of DailyCheckin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? checkinDate = null,Object? mood = null,Object? emotions = null,Object? timeOfDay = null,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_DailyCheckin(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,checkinDate: null == checkinDate ? _self.checkinDate : checkinDate // ignore: cast_nullable_to_non_nullable
as DateTime,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,emotions: null == emotions ? _self._emotions : emotions // ignore: cast_nullable_to_non_nullable
as List<String>,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
