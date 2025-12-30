// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_usage_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DayUsageEntry {

 DateTime get startTime; String get dose; String get route; bool get isMedical;
/// Create a copy of DayUsageEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayUsageEntryCopyWith<DayUsageEntry> get copyWith => _$DayUsageEntryCopyWithImpl<DayUsageEntry>(this as DayUsageEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayUsageEntry&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.route, route) || other.route == route)&&(identical(other.isMedical, isMedical) || other.isMedical == isMedical));
}


@override
int get hashCode => Object.hash(runtimeType,startTime,dose,route,isMedical);

@override
String toString() {
  return 'DayUsageEntry(startTime: $startTime, dose: $dose, route: $route, isMedical: $isMedical)';
}


}

/// @nodoc
abstract mixin class $DayUsageEntryCopyWith<$Res>  {
  factory $DayUsageEntryCopyWith(DayUsageEntry value, $Res Function(DayUsageEntry) _then) = _$DayUsageEntryCopyWithImpl;
@useResult
$Res call({
 DateTime startTime, String dose, String route, bool isMedical
});




}
/// @nodoc
class _$DayUsageEntryCopyWithImpl<$Res>
    implements $DayUsageEntryCopyWith<$Res> {
  _$DayUsageEntryCopyWithImpl(this._self, this._then);

  final DayUsageEntry _self;
  final $Res Function(DayUsageEntry) _then;

/// Create a copy of DayUsageEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startTime = null,Object? dose = null,Object? route = null,Object? isMedical = null,}) {
  return _then(_self.copyWith(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,isMedical: null == isMedical ? _self.isMedical : isMedical // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DayUsageEntry].
extension DayUsageEntryPatterns on DayUsageEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayUsageEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayUsageEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayUsageEntry value)  $default,){
final _that = this;
switch (_that) {
case _DayUsageEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayUsageEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DayUsageEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startTime,  String dose,  String route,  bool isMedical)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayUsageEntry() when $default != null:
return $default(_that.startTime,_that.dose,_that.route,_that.isMedical);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startTime,  String dose,  String route,  bool isMedical)  $default,) {final _that = this;
switch (_that) {
case _DayUsageEntry():
return $default(_that.startTime,_that.dose,_that.route,_that.isMedical);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startTime,  String dose,  String route,  bool isMedical)?  $default,) {final _that = this;
switch (_that) {
case _DayUsageEntry() when $default != null:
return $default(_that.startTime,_that.dose,_that.route,_that.isMedical);case _:
  return null;

}
}

}

/// @nodoc


class _DayUsageEntry extends DayUsageEntry {
  const _DayUsageEntry({required this.startTime, required this.dose, required this.route, required this.isMedical}): super._();
  

@override final  DateTime startTime;
@override final  String dose;
@override final  String route;
@override final  bool isMedical;

/// Create a copy of DayUsageEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayUsageEntryCopyWith<_DayUsageEntry> get copyWith => __$DayUsageEntryCopyWithImpl<_DayUsageEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayUsageEntry&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.route, route) || other.route == route)&&(identical(other.isMedical, isMedical) || other.isMedical == isMedical));
}


@override
int get hashCode => Object.hash(runtimeType,startTime,dose,route,isMedical);

@override
String toString() {
  return 'DayUsageEntry(startTime: $startTime, dose: $dose, route: $route, isMedical: $isMedical)';
}


}

/// @nodoc
abstract mixin class _$DayUsageEntryCopyWith<$Res> implements $DayUsageEntryCopyWith<$Res> {
  factory _$DayUsageEntryCopyWith(_DayUsageEntry value, $Res Function(_DayUsageEntry) _then) = __$DayUsageEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime startTime, String dose, String route, bool isMedical
});




}
/// @nodoc
class __$DayUsageEntryCopyWithImpl<$Res>
    implements _$DayUsageEntryCopyWith<$Res> {
  __$DayUsageEntryCopyWithImpl(this._self, this._then);

  final _DayUsageEntry _self;
  final $Res Function(_DayUsageEntry) _then;

/// Create a copy of DayUsageEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startTime = null,Object? dose = null,Object? route = null,Object? isMedical = null,}) {
  return _then(_DayUsageEntry(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,isMedical: null == isMedical ? _self.isMedical : isMedical // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
