// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reflection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Reflection {

 double get effectiveness; double get sleepHours; String get sleepQuality; String get nextDayMood; String get energyLevel; String get sideEffects; double get postUseCraving; String get copingStrategies; double get copingEffectiveness; double get overallSatisfaction; String get notes;
/// Create a copy of Reflection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReflectionCopyWith<Reflection> get copyWith => _$ReflectionCopyWithImpl<Reflection>(this as Reflection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reflection&&(identical(other.effectiveness, effectiveness) || other.effectiveness == effectiveness)&&(identical(other.sleepHours, sleepHours) || other.sleepHours == sleepHours)&&(identical(other.sleepQuality, sleepQuality) || other.sleepQuality == sleepQuality)&&(identical(other.nextDayMood, nextDayMood) || other.nextDayMood == nextDayMood)&&(identical(other.energyLevel, energyLevel) || other.energyLevel == energyLevel)&&(identical(other.sideEffects, sideEffects) || other.sideEffects == sideEffects)&&(identical(other.postUseCraving, postUseCraving) || other.postUseCraving == postUseCraving)&&(identical(other.copingStrategies, copingStrategies) || other.copingStrategies == copingStrategies)&&(identical(other.copingEffectiveness, copingEffectiveness) || other.copingEffectiveness == copingEffectiveness)&&(identical(other.overallSatisfaction, overallSatisfaction) || other.overallSatisfaction == overallSatisfaction)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,effectiveness,sleepHours,sleepQuality,nextDayMood,energyLevel,sideEffects,postUseCraving,copingStrategies,copingEffectiveness,overallSatisfaction,notes);

@override
String toString() {
  return 'Reflection(effectiveness: $effectiveness, sleepHours: $sleepHours, sleepQuality: $sleepQuality, nextDayMood: $nextDayMood, energyLevel: $energyLevel, sideEffects: $sideEffects, postUseCraving: $postUseCraving, copingStrategies: $copingStrategies, copingEffectiveness: $copingEffectiveness, overallSatisfaction: $overallSatisfaction, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ReflectionCopyWith<$Res>  {
  factory $ReflectionCopyWith(Reflection value, $Res Function(Reflection) _then) = _$ReflectionCopyWithImpl;
@useResult
$Res call({
 double effectiveness, double sleepHours, String sleepQuality, String nextDayMood, String energyLevel, String sideEffects, double postUseCraving, String copingStrategies, double copingEffectiveness, double overallSatisfaction, String notes
});




}
/// @nodoc
class _$ReflectionCopyWithImpl<$Res>
    implements $ReflectionCopyWith<$Res> {
  _$ReflectionCopyWithImpl(this._self, this._then);

  final Reflection _self;
  final $Res Function(Reflection) _then;

/// Create a copy of Reflection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? effectiveness = null,Object? sleepHours = null,Object? sleepQuality = null,Object? nextDayMood = null,Object? energyLevel = null,Object? sideEffects = null,Object? postUseCraving = null,Object? copingStrategies = null,Object? copingEffectiveness = null,Object? overallSatisfaction = null,Object? notes = null,}) {
  return _then(_self.copyWith(
effectiveness: null == effectiveness ? _self.effectiveness : effectiveness // ignore: cast_nullable_to_non_nullable
as double,sleepHours: null == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as double,sleepQuality: null == sleepQuality ? _self.sleepQuality : sleepQuality // ignore: cast_nullable_to_non_nullable
as String,nextDayMood: null == nextDayMood ? _self.nextDayMood : nextDayMood // ignore: cast_nullable_to_non_nullable
as String,energyLevel: null == energyLevel ? _self.energyLevel : energyLevel // ignore: cast_nullable_to_non_nullable
as String,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as String,postUseCraving: null == postUseCraving ? _self.postUseCraving : postUseCraving // ignore: cast_nullable_to_non_nullable
as double,copingStrategies: null == copingStrategies ? _self.copingStrategies : copingStrategies // ignore: cast_nullable_to_non_nullable
as String,copingEffectiveness: null == copingEffectiveness ? _self.copingEffectiveness : copingEffectiveness // ignore: cast_nullable_to_non_nullable
as double,overallSatisfaction: null == overallSatisfaction ? _self.overallSatisfaction : overallSatisfaction // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Reflection].
extension ReflectionPatterns on Reflection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reflection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reflection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reflection value)  $default,){
final _that = this;
switch (_that) {
case _Reflection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reflection value)?  $default,){
final _that = this;
switch (_that) {
case _Reflection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double effectiveness,  double sleepHours,  String sleepQuality,  String nextDayMood,  String energyLevel,  String sideEffects,  double postUseCraving,  String copingStrategies,  double copingEffectiveness,  double overallSatisfaction,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reflection() when $default != null:
return $default(_that.effectiveness,_that.sleepHours,_that.sleepQuality,_that.nextDayMood,_that.energyLevel,_that.sideEffects,_that.postUseCraving,_that.copingStrategies,_that.copingEffectiveness,_that.overallSatisfaction,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double effectiveness,  double sleepHours,  String sleepQuality,  String nextDayMood,  String energyLevel,  String sideEffects,  double postUseCraving,  String copingStrategies,  double copingEffectiveness,  double overallSatisfaction,  String notes)  $default,) {final _that = this;
switch (_that) {
case _Reflection():
return $default(_that.effectiveness,_that.sleepHours,_that.sleepQuality,_that.nextDayMood,_that.energyLevel,_that.sideEffects,_that.postUseCraving,_that.copingStrategies,_that.copingEffectiveness,_that.overallSatisfaction,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double effectiveness,  double sleepHours,  String sleepQuality,  String nextDayMood,  String energyLevel,  String sideEffects,  double postUseCraving,  String copingStrategies,  double copingEffectiveness,  double overallSatisfaction,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _Reflection() when $default != null:
return $default(_that.effectiveness,_that.sleepHours,_that.sleepQuality,_that.nextDayMood,_that.energyLevel,_that.sideEffects,_that.postUseCraving,_that.copingStrategies,_that.copingEffectiveness,_that.overallSatisfaction,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _Reflection extends Reflection {
  const _Reflection({this.effectiveness = 5.0, this.sleepHours = 8.0, this.sleepQuality = 'Good', this.nextDayMood = '', this.energyLevel = 'Neutral', this.sideEffects = '', this.postUseCraving = 5.0, this.copingStrategies = '', this.copingEffectiveness = 5.0, this.overallSatisfaction = 5.0, this.notes = ''}): super._();
  

@override@JsonKey() final  double effectiveness;
@override@JsonKey() final  double sleepHours;
@override@JsonKey() final  String sleepQuality;
@override@JsonKey() final  String nextDayMood;
@override@JsonKey() final  String energyLevel;
@override@JsonKey() final  String sideEffects;
@override@JsonKey() final  double postUseCraving;
@override@JsonKey() final  String copingStrategies;
@override@JsonKey() final  double copingEffectiveness;
@override@JsonKey() final  double overallSatisfaction;
@override@JsonKey() final  String notes;

/// Create a copy of Reflection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReflectionCopyWith<_Reflection> get copyWith => __$ReflectionCopyWithImpl<_Reflection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reflection&&(identical(other.effectiveness, effectiveness) || other.effectiveness == effectiveness)&&(identical(other.sleepHours, sleepHours) || other.sleepHours == sleepHours)&&(identical(other.sleepQuality, sleepQuality) || other.sleepQuality == sleepQuality)&&(identical(other.nextDayMood, nextDayMood) || other.nextDayMood == nextDayMood)&&(identical(other.energyLevel, energyLevel) || other.energyLevel == energyLevel)&&(identical(other.sideEffects, sideEffects) || other.sideEffects == sideEffects)&&(identical(other.postUseCraving, postUseCraving) || other.postUseCraving == postUseCraving)&&(identical(other.copingStrategies, copingStrategies) || other.copingStrategies == copingStrategies)&&(identical(other.copingEffectiveness, copingEffectiveness) || other.copingEffectiveness == copingEffectiveness)&&(identical(other.overallSatisfaction, overallSatisfaction) || other.overallSatisfaction == overallSatisfaction)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,effectiveness,sleepHours,sleepQuality,nextDayMood,energyLevel,sideEffects,postUseCraving,copingStrategies,copingEffectiveness,overallSatisfaction,notes);

@override
String toString() {
  return 'Reflection(effectiveness: $effectiveness, sleepHours: $sleepHours, sleepQuality: $sleepQuality, nextDayMood: $nextDayMood, energyLevel: $energyLevel, sideEffects: $sideEffects, postUseCraving: $postUseCraving, copingStrategies: $copingStrategies, copingEffectiveness: $copingEffectiveness, overallSatisfaction: $overallSatisfaction, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ReflectionCopyWith<$Res> implements $ReflectionCopyWith<$Res> {
  factory _$ReflectionCopyWith(_Reflection value, $Res Function(_Reflection) _then) = __$ReflectionCopyWithImpl;
@override @useResult
$Res call({
 double effectiveness, double sleepHours, String sleepQuality, String nextDayMood, String energyLevel, String sideEffects, double postUseCraving, String copingStrategies, double copingEffectiveness, double overallSatisfaction, String notes
});




}
/// @nodoc
class __$ReflectionCopyWithImpl<$Res>
    implements _$ReflectionCopyWith<$Res> {
  __$ReflectionCopyWithImpl(this._self, this._then);

  final _Reflection _self;
  final $Res Function(_Reflection) _then;

/// Create a copy of Reflection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? effectiveness = null,Object? sleepHours = null,Object? sleepQuality = null,Object? nextDayMood = null,Object? energyLevel = null,Object? sideEffects = null,Object? postUseCraving = null,Object? copingStrategies = null,Object? copingEffectiveness = null,Object? overallSatisfaction = null,Object? notes = null,}) {
  return _then(_Reflection(
effectiveness: null == effectiveness ? _self.effectiveness : effectiveness // ignore: cast_nullable_to_non_nullable
as double,sleepHours: null == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as double,sleepQuality: null == sleepQuality ? _self.sleepQuality : sleepQuality // ignore: cast_nullable_to_non_nullable
as String,nextDayMood: null == nextDayMood ? _self.nextDayMood : nextDayMood // ignore: cast_nullable_to_non_nullable
as String,energyLevel: null == energyLevel ? _self.energyLevel : energyLevel // ignore: cast_nullable_to_non_nullable
as String,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as String,postUseCraving: null == postUseCraving ? _self.postUseCraving : postUseCraving // ignore: cast_nullable_to_non_nullable
as double,copingStrategies: null == copingStrategies ? _self.copingStrategies : copingStrategies // ignore: cast_nullable_to_non_nullable
as String,copingEffectiveness: null == copingEffectiveness ? _self.copingEffectiveness : copingEffectiveness // ignore: cast_nullable_to_non_nullable
as double,overallSatisfaction: null == overallSatisfaction ? _self.overallSatisfaction : overallSatisfaction // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ReflectionModel {

 List<String> get selectedReflections; String? get id; String? get notes; DateTime get date; int get hour; int get minute; double get effectiveness; double get sleepHours; String get sleepQuality; String get nextDayMood; String get energyLevel; String get sideEffects; double get postUseCraving; String get copingStrategies; double get copingEffectiveness; double get overallSatisfaction;
/// Create a copy of ReflectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReflectionModelCopyWith<ReflectionModel> get copyWith => _$ReflectionModelCopyWithImpl<ReflectionModel>(this as ReflectionModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReflectionModel&&const DeepCollectionEquality().equals(other.selectedReflections, selectedReflections)&&(identical(other.id, id) || other.id == id)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.date, date) || other.date == date)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.effectiveness, effectiveness) || other.effectiveness == effectiveness)&&(identical(other.sleepHours, sleepHours) || other.sleepHours == sleepHours)&&(identical(other.sleepQuality, sleepQuality) || other.sleepQuality == sleepQuality)&&(identical(other.nextDayMood, nextDayMood) || other.nextDayMood == nextDayMood)&&(identical(other.energyLevel, energyLevel) || other.energyLevel == energyLevel)&&(identical(other.sideEffects, sideEffects) || other.sideEffects == sideEffects)&&(identical(other.postUseCraving, postUseCraving) || other.postUseCraving == postUseCraving)&&(identical(other.copingStrategies, copingStrategies) || other.copingStrategies == copingStrategies)&&(identical(other.copingEffectiveness, copingEffectiveness) || other.copingEffectiveness == copingEffectiveness)&&(identical(other.overallSatisfaction, overallSatisfaction) || other.overallSatisfaction == overallSatisfaction));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(selectedReflections),id,notes,date,hour,minute,effectiveness,sleepHours,sleepQuality,nextDayMood,energyLevel,sideEffects,postUseCraving,copingStrategies,copingEffectiveness,overallSatisfaction);

@override
String toString() {
  return 'ReflectionModel(selectedReflections: $selectedReflections, id: $id, notes: $notes, date: $date, hour: $hour, minute: $minute, effectiveness: $effectiveness, sleepHours: $sleepHours, sleepQuality: $sleepQuality, nextDayMood: $nextDayMood, energyLevel: $energyLevel, sideEffects: $sideEffects, postUseCraving: $postUseCraving, copingStrategies: $copingStrategies, copingEffectiveness: $copingEffectiveness, overallSatisfaction: $overallSatisfaction)';
}


}

/// @nodoc
abstract mixin class $ReflectionModelCopyWith<$Res>  {
  factory $ReflectionModelCopyWith(ReflectionModel value, $Res Function(ReflectionModel) _then) = _$ReflectionModelCopyWithImpl;
@useResult
$Res call({
 List<String> selectedReflections, String? id, String? notes, DateTime date, int hour, int minute, double effectiveness, double sleepHours, String sleepQuality, String nextDayMood, String energyLevel, String sideEffects, double postUseCraving, String copingStrategies, double copingEffectiveness, double overallSatisfaction
});




}
/// @nodoc
class _$ReflectionModelCopyWithImpl<$Res>
    implements $ReflectionModelCopyWith<$Res> {
  _$ReflectionModelCopyWithImpl(this._self, this._then);

  final ReflectionModel _self;
  final $Res Function(ReflectionModel) _then;

/// Create a copy of ReflectionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedReflections = null,Object? id = freezed,Object? notes = freezed,Object? date = null,Object? hour = null,Object? minute = null,Object? effectiveness = null,Object? sleepHours = null,Object? sleepQuality = null,Object? nextDayMood = null,Object? energyLevel = null,Object? sideEffects = null,Object? postUseCraving = null,Object? copingStrategies = null,Object? copingEffectiveness = null,Object? overallSatisfaction = null,}) {
  return _then(_self.copyWith(
selectedReflections: null == selectedReflections ? _self.selectedReflections : selectedReflections // ignore: cast_nullable_to_non_nullable
as List<String>,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,effectiveness: null == effectiveness ? _self.effectiveness : effectiveness // ignore: cast_nullable_to_non_nullable
as double,sleepHours: null == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as double,sleepQuality: null == sleepQuality ? _self.sleepQuality : sleepQuality // ignore: cast_nullable_to_non_nullable
as String,nextDayMood: null == nextDayMood ? _self.nextDayMood : nextDayMood // ignore: cast_nullable_to_non_nullable
as String,energyLevel: null == energyLevel ? _self.energyLevel : energyLevel // ignore: cast_nullable_to_non_nullable
as String,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as String,postUseCraving: null == postUseCraving ? _self.postUseCraving : postUseCraving // ignore: cast_nullable_to_non_nullable
as double,copingStrategies: null == copingStrategies ? _self.copingStrategies : copingStrategies // ignore: cast_nullable_to_non_nullable
as String,copingEffectiveness: null == copingEffectiveness ? _self.copingEffectiveness : copingEffectiveness // ignore: cast_nullable_to_non_nullable
as double,overallSatisfaction: null == overallSatisfaction ? _self.overallSatisfaction : overallSatisfaction // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ReflectionModel].
extension ReflectionModelPatterns on ReflectionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReflectionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReflectionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReflectionModel value)  $default,){
final _that = this;
switch (_that) {
case _ReflectionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReflectionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReflectionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> selectedReflections,  String? id,  String? notes,  DateTime date,  int hour,  int minute,  double effectiveness,  double sleepHours,  String sleepQuality,  String nextDayMood,  String energyLevel,  String sideEffects,  double postUseCraving,  String copingStrategies,  double copingEffectiveness,  double overallSatisfaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReflectionModel() when $default != null:
return $default(_that.selectedReflections,_that.id,_that.notes,_that.date,_that.hour,_that.minute,_that.effectiveness,_that.sleepHours,_that.sleepQuality,_that.nextDayMood,_that.energyLevel,_that.sideEffects,_that.postUseCraving,_that.copingStrategies,_that.copingEffectiveness,_that.overallSatisfaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> selectedReflections,  String? id,  String? notes,  DateTime date,  int hour,  int minute,  double effectiveness,  double sleepHours,  String sleepQuality,  String nextDayMood,  String energyLevel,  String sideEffects,  double postUseCraving,  String copingStrategies,  double copingEffectiveness,  double overallSatisfaction)  $default,) {final _that = this;
switch (_that) {
case _ReflectionModel():
return $default(_that.selectedReflections,_that.id,_that.notes,_that.date,_that.hour,_that.minute,_that.effectiveness,_that.sleepHours,_that.sleepQuality,_that.nextDayMood,_that.energyLevel,_that.sideEffects,_that.postUseCraving,_that.copingStrategies,_that.copingEffectiveness,_that.overallSatisfaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> selectedReflections,  String? id,  String? notes,  DateTime date,  int hour,  int minute,  double effectiveness,  double sleepHours,  String sleepQuality,  String nextDayMood,  String energyLevel,  String sideEffects,  double postUseCraving,  String copingStrategies,  double copingEffectiveness,  double overallSatisfaction)?  $default,) {final _that = this;
switch (_that) {
case _ReflectionModel() when $default != null:
return $default(_that.selectedReflections,_that.id,_that.notes,_that.date,_that.hour,_that.minute,_that.effectiveness,_that.sleepHours,_that.sleepQuality,_that.nextDayMood,_that.energyLevel,_that.sideEffects,_that.postUseCraving,_that.copingStrategies,_that.copingEffectiveness,_that.overallSatisfaction);case _:
  return null;

}
}

}

/// @nodoc


class _ReflectionModel extends ReflectionModel {
  const _ReflectionModel({final  List<String> selectedReflections = const [], this.id, this.notes, required this.date, required this.hour, required this.minute, this.effectiveness = 0.0, this.sleepHours = 0.0, this.sleepQuality = '', this.nextDayMood = '', this.energyLevel = '', this.sideEffects = '', this.postUseCraving = 0.0, this.copingStrategies = '', this.copingEffectiveness = 0.0, this.overallSatisfaction = 0.0}): _selectedReflections = selectedReflections,super._();
  

 final  List<String> _selectedReflections;
@override@JsonKey() List<String> get selectedReflections {
  if (_selectedReflections is EqualUnmodifiableListView) return _selectedReflections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedReflections);
}

@override final  String? id;
@override final  String? notes;
@override final  DateTime date;
@override final  int hour;
@override final  int minute;
@override@JsonKey() final  double effectiveness;
@override@JsonKey() final  double sleepHours;
@override@JsonKey() final  String sleepQuality;
@override@JsonKey() final  String nextDayMood;
@override@JsonKey() final  String energyLevel;
@override@JsonKey() final  String sideEffects;
@override@JsonKey() final  double postUseCraving;
@override@JsonKey() final  String copingStrategies;
@override@JsonKey() final  double copingEffectiveness;
@override@JsonKey() final  double overallSatisfaction;

/// Create a copy of ReflectionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReflectionModelCopyWith<_ReflectionModel> get copyWith => __$ReflectionModelCopyWithImpl<_ReflectionModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReflectionModel&&const DeepCollectionEquality().equals(other._selectedReflections, _selectedReflections)&&(identical(other.id, id) || other.id == id)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.date, date) || other.date == date)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.effectiveness, effectiveness) || other.effectiveness == effectiveness)&&(identical(other.sleepHours, sleepHours) || other.sleepHours == sleepHours)&&(identical(other.sleepQuality, sleepQuality) || other.sleepQuality == sleepQuality)&&(identical(other.nextDayMood, nextDayMood) || other.nextDayMood == nextDayMood)&&(identical(other.energyLevel, energyLevel) || other.energyLevel == energyLevel)&&(identical(other.sideEffects, sideEffects) || other.sideEffects == sideEffects)&&(identical(other.postUseCraving, postUseCraving) || other.postUseCraving == postUseCraving)&&(identical(other.copingStrategies, copingStrategies) || other.copingStrategies == copingStrategies)&&(identical(other.copingEffectiveness, copingEffectiveness) || other.copingEffectiveness == copingEffectiveness)&&(identical(other.overallSatisfaction, overallSatisfaction) || other.overallSatisfaction == overallSatisfaction));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_selectedReflections),id,notes,date,hour,minute,effectiveness,sleepHours,sleepQuality,nextDayMood,energyLevel,sideEffects,postUseCraving,copingStrategies,copingEffectiveness,overallSatisfaction);

@override
String toString() {
  return 'ReflectionModel(selectedReflections: $selectedReflections, id: $id, notes: $notes, date: $date, hour: $hour, minute: $minute, effectiveness: $effectiveness, sleepHours: $sleepHours, sleepQuality: $sleepQuality, nextDayMood: $nextDayMood, energyLevel: $energyLevel, sideEffects: $sideEffects, postUseCraving: $postUseCraving, copingStrategies: $copingStrategies, copingEffectiveness: $copingEffectiveness, overallSatisfaction: $overallSatisfaction)';
}


}

/// @nodoc
abstract mixin class _$ReflectionModelCopyWith<$Res> implements $ReflectionModelCopyWith<$Res> {
  factory _$ReflectionModelCopyWith(_ReflectionModel value, $Res Function(_ReflectionModel) _then) = __$ReflectionModelCopyWithImpl;
@override @useResult
$Res call({
 List<String> selectedReflections, String? id, String? notes, DateTime date, int hour, int minute, double effectiveness, double sleepHours, String sleepQuality, String nextDayMood, String energyLevel, String sideEffects, double postUseCraving, String copingStrategies, double copingEffectiveness, double overallSatisfaction
});




}
/// @nodoc
class __$ReflectionModelCopyWithImpl<$Res>
    implements _$ReflectionModelCopyWith<$Res> {
  __$ReflectionModelCopyWithImpl(this._self, this._then);

  final _ReflectionModel _self;
  final $Res Function(_ReflectionModel) _then;

/// Create a copy of ReflectionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedReflections = null,Object? id = freezed,Object? notes = freezed,Object? date = null,Object? hour = null,Object? minute = null,Object? effectiveness = null,Object? sleepHours = null,Object? sleepQuality = null,Object? nextDayMood = null,Object? energyLevel = null,Object? sideEffects = null,Object? postUseCraving = null,Object? copingStrategies = null,Object? copingEffectiveness = null,Object? overallSatisfaction = null,}) {
  return _then(_ReflectionModel(
selectedReflections: null == selectedReflections ? _self._selectedReflections : selectedReflections // ignore: cast_nullable_to_non_nullable
as List<String>,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,effectiveness: null == effectiveness ? _self.effectiveness : effectiveness // ignore: cast_nullable_to_non_nullable
as double,sleepHours: null == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as double,sleepQuality: null == sleepQuality ? _self.sleepQuality : sleepQuality // ignore: cast_nullable_to_non_nullable
as String,nextDayMood: null == nextDayMood ? _self.nextDayMood : nextDayMood // ignore: cast_nullable_to_non_nullable
as String,energyLevel: null == energyLevel ? _self.energyLevel : energyLevel // ignore: cast_nullable_to_non_nullable
as String,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as String,postUseCraving: null == postUseCraving ? _self.postUseCraving : postUseCraving // ignore: cast_nullable_to_non_nullable
as double,copingStrategies: null == copingStrategies ? _self.copingStrategies : copingStrategies // ignore: cast_nullable_to_non_nullable
as String,copingEffectiveness: null == copingEffectiveness ? _self.copingEffectiveness : copingEffectiveness // ignore: cast_nullable_to_non_nullable
as double,overallSatisfaction: null == overallSatisfaction ? _self.overallSatisfaction : overallSatisfaction // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
