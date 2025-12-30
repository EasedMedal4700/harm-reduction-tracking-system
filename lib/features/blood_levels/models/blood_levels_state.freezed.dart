// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blood_levels_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BloodLevelsState {

 Map<String, DrugLevel> get levels; DateTime get selectedTime; Set<String> get includedDrugs; Set<String> get excludedDrugs; bool get showFilters; bool get showTimeline; int get chartHoursBack; int get chartHoursForward; bool get chartAdaptiveScale;
/// Create a copy of BloodLevelsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BloodLevelsStateCopyWith<BloodLevelsState> get copyWith => _$BloodLevelsStateCopyWithImpl<BloodLevelsState>(this as BloodLevelsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BloodLevelsState&&const DeepCollectionEquality().equals(other.levels, levels)&&(identical(other.selectedTime, selectedTime) || other.selectedTime == selectedTime)&&const DeepCollectionEquality().equals(other.includedDrugs, includedDrugs)&&const DeepCollectionEquality().equals(other.excludedDrugs, excludedDrugs)&&(identical(other.showFilters, showFilters) || other.showFilters == showFilters)&&(identical(other.showTimeline, showTimeline) || other.showTimeline == showTimeline)&&(identical(other.chartHoursBack, chartHoursBack) || other.chartHoursBack == chartHoursBack)&&(identical(other.chartHoursForward, chartHoursForward) || other.chartHoursForward == chartHoursForward)&&(identical(other.chartAdaptiveScale, chartAdaptiveScale) || other.chartAdaptiveScale == chartAdaptiveScale));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(levels),selectedTime,const DeepCollectionEquality().hash(includedDrugs),const DeepCollectionEquality().hash(excludedDrugs),showFilters,showTimeline,chartHoursBack,chartHoursForward,chartAdaptiveScale);

@override
String toString() {
  return 'BloodLevelsState(levels: $levels, selectedTime: $selectedTime, includedDrugs: $includedDrugs, excludedDrugs: $excludedDrugs, showFilters: $showFilters, showTimeline: $showTimeline, chartHoursBack: $chartHoursBack, chartHoursForward: $chartHoursForward, chartAdaptiveScale: $chartAdaptiveScale)';
}


}

/// @nodoc
abstract mixin class $BloodLevelsStateCopyWith<$Res>  {
  factory $BloodLevelsStateCopyWith(BloodLevelsState value, $Res Function(BloodLevelsState) _then) = _$BloodLevelsStateCopyWithImpl;
@useResult
$Res call({
 Map<String, DrugLevel> levels, DateTime selectedTime, Set<String> includedDrugs, Set<String> excludedDrugs, bool showFilters, bool showTimeline, int chartHoursBack, int chartHoursForward, bool chartAdaptiveScale
});




}
/// @nodoc
class _$BloodLevelsStateCopyWithImpl<$Res>
    implements $BloodLevelsStateCopyWith<$Res> {
  _$BloodLevelsStateCopyWithImpl(this._self, this._then);

  final BloodLevelsState _self;
  final $Res Function(BloodLevelsState) _then;

/// Create a copy of BloodLevelsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? levels = null,Object? selectedTime = null,Object? includedDrugs = null,Object? excludedDrugs = null,Object? showFilters = null,Object? showTimeline = null,Object? chartHoursBack = null,Object? chartHoursForward = null,Object? chartAdaptiveScale = null,}) {
  return _then(_self.copyWith(
levels: null == levels ? _self.levels : levels // ignore: cast_nullable_to_non_nullable
as Map<String, DrugLevel>,selectedTime: null == selectedTime ? _self.selectedTime : selectedTime // ignore: cast_nullable_to_non_nullable
as DateTime,includedDrugs: null == includedDrugs ? _self.includedDrugs : includedDrugs // ignore: cast_nullable_to_non_nullable
as Set<String>,excludedDrugs: null == excludedDrugs ? _self.excludedDrugs : excludedDrugs // ignore: cast_nullable_to_non_nullable
as Set<String>,showFilters: null == showFilters ? _self.showFilters : showFilters // ignore: cast_nullable_to_non_nullable
as bool,showTimeline: null == showTimeline ? _self.showTimeline : showTimeline // ignore: cast_nullable_to_non_nullable
as bool,chartHoursBack: null == chartHoursBack ? _self.chartHoursBack : chartHoursBack // ignore: cast_nullable_to_non_nullable
as int,chartHoursForward: null == chartHoursForward ? _self.chartHoursForward : chartHoursForward // ignore: cast_nullable_to_non_nullable
as int,chartAdaptiveScale: null == chartAdaptiveScale ? _self.chartAdaptiveScale : chartAdaptiveScale // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BloodLevelsState].
extension BloodLevelsStatePatterns on BloodLevelsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BloodLevelsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BloodLevelsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BloodLevelsState value)  $default,){
final _that = this;
switch (_that) {
case _BloodLevelsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BloodLevelsState value)?  $default,){
final _that = this;
switch (_that) {
case _BloodLevelsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, DrugLevel> levels,  DateTime selectedTime,  Set<String> includedDrugs,  Set<String> excludedDrugs,  bool showFilters,  bool showTimeline,  int chartHoursBack,  int chartHoursForward,  bool chartAdaptiveScale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BloodLevelsState() when $default != null:
return $default(_that.levels,_that.selectedTime,_that.includedDrugs,_that.excludedDrugs,_that.showFilters,_that.showTimeline,_that.chartHoursBack,_that.chartHoursForward,_that.chartAdaptiveScale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, DrugLevel> levels,  DateTime selectedTime,  Set<String> includedDrugs,  Set<String> excludedDrugs,  bool showFilters,  bool showTimeline,  int chartHoursBack,  int chartHoursForward,  bool chartAdaptiveScale)  $default,) {final _that = this;
switch (_that) {
case _BloodLevelsState():
return $default(_that.levels,_that.selectedTime,_that.includedDrugs,_that.excludedDrugs,_that.showFilters,_that.showTimeline,_that.chartHoursBack,_that.chartHoursForward,_that.chartAdaptiveScale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, DrugLevel> levels,  DateTime selectedTime,  Set<String> includedDrugs,  Set<String> excludedDrugs,  bool showFilters,  bool showTimeline,  int chartHoursBack,  int chartHoursForward,  bool chartAdaptiveScale)?  $default,) {final _that = this;
switch (_that) {
case _BloodLevelsState() when $default != null:
return $default(_that.levels,_that.selectedTime,_that.includedDrugs,_that.excludedDrugs,_that.showFilters,_that.showTimeline,_that.chartHoursBack,_that.chartHoursForward,_that.chartAdaptiveScale);case _:
  return null;

}
}

}

/// @nodoc


class _BloodLevelsState implements BloodLevelsState {
  const _BloodLevelsState({final  Map<String, DrugLevel> levels = const <String, DrugLevel>{}, required this.selectedTime, final  Set<String> includedDrugs = const <String>{}, final  Set<String> excludedDrugs = const <String>{}, this.showFilters = false, this.showTimeline = BloodLevelsConstants.defaultShowTimeline, this.chartHoursBack = BloodLevelsConstants.defaultChartHoursBack, this.chartHoursForward = BloodLevelsConstants.defaultChartHoursForward, this.chartAdaptiveScale = BloodLevelsConstants.defaultAdaptiveScale}): _levels = levels,_includedDrugs = includedDrugs,_excludedDrugs = excludedDrugs;
  

 final  Map<String, DrugLevel> _levels;
@override@JsonKey() Map<String, DrugLevel> get levels {
  if (_levels is EqualUnmodifiableMapView) return _levels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_levels);
}

@override final  DateTime selectedTime;
 final  Set<String> _includedDrugs;
@override@JsonKey() Set<String> get includedDrugs {
  if (_includedDrugs is EqualUnmodifiableSetView) return _includedDrugs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_includedDrugs);
}

 final  Set<String> _excludedDrugs;
@override@JsonKey() Set<String> get excludedDrugs {
  if (_excludedDrugs is EqualUnmodifiableSetView) return _excludedDrugs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_excludedDrugs);
}

@override@JsonKey() final  bool showFilters;
@override@JsonKey() final  bool showTimeline;
@override@JsonKey() final  int chartHoursBack;
@override@JsonKey() final  int chartHoursForward;
@override@JsonKey() final  bool chartAdaptiveScale;

/// Create a copy of BloodLevelsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BloodLevelsStateCopyWith<_BloodLevelsState> get copyWith => __$BloodLevelsStateCopyWithImpl<_BloodLevelsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BloodLevelsState&&const DeepCollectionEquality().equals(other._levels, _levels)&&(identical(other.selectedTime, selectedTime) || other.selectedTime == selectedTime)&&const DeepCollectionEquality().equals(other._includedDrugs, _includedDrugs)&&const DeepCollectionEquality().equals(other._excludedDrugs, _excludedDrugs)&&(identical(other.showFilters, showFilters) || other.showFilters == showFilters)&&(identical(other.showTimeline, showTimeline) || other.showTimeline == showTimeline)&&(identical(other.chartHoursBack, chartHoursBack) || other.chartHoursBack == chartHoursBack)&&(identical(other.chartHoursForward, chartHoursForward) || other.chartHoursForward == chartHoursForward)&&(identical(other.chartAdaptiveScale, chartAdaptiveScale) || other.chartAdaptiveScale == chartAdaptiveScale));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_levels),selectedTime,const DeepCollectionEquality().hash(_includedDrugs),const DeepCollectionEquality().hash(_excludedDrugs),showFilters,showTimeline,chartHoursBack,chartHoursForward,chartAdaptiveScale);

@override
String toString() {
  return 'BloodLevelsState(levels: $levels, selectedTime: $selectedTime, includedDrugs: $includedDrugs, excludedDrugs: $excludedDrugs, showFilters: $showFilters, showTimeline: $showTimeline, chartHoursBack: $chartHoursBack, chartHoursForward: $chartHoursForward, chartAdaptiveScale: $chartAdaptiveScale)';
}


}

/// @nodoc
abstract mixin class _$BloodLevelsStateCopyWith<$Res> implements $BloodLevelsStateCopyWith<$Res> {
  factory _$BloodLevelsStateCopyWith(_BloodLevelsState value, $Res Function(_BloodLevelsState) _then) = __$BloodLevelsStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, DrugLevel> levels, DateTime selectedTime, Set<String> includedDrugs, Set<String> excludedDrugs, bool showFilters, bool showTimeline, int chartHoursBack, int chartHoursForward, bool chartAdaptiveScale
});




}
/// @nodoc
class __$BloodLevelsStateCopyWithImpl<$Res>
    implements _$BloodLevelsStateCopyWith<$Res> {
  __$BloodLevelsStateCopyWithImpl(this._self, this._then);

  final _BloodLevelsState _self;
  final $Res Function(_BloodLevelsState) _then;

/// Create a copy of BloodLevelsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? levels = null,Object? selectedTime = null,Object? includedDrugs = null,Object? excludedDrugs = null,Object? showFilters = null,Object? showTimeline = null,Object? chartHoursBack = null,Object? chartHoursForward = null,Object? chartAdaptiveScale = null,}) {
  return _then(_BloodLevelsState(
levels: null == levels ? _self._levels : levels // ignore: cast_nullable_to_non_nullable
as Map<String, DrugLevel>,selectedTime: null == selectedTime ? _self.selectedTime : selectedTime // ignore: cast_nullable_to_non_nullable
as DateTime,includedDrugs: null == includedDrugs ? _self._includedDrugs : includedDrugs // ignore: cast_nullable_to_non_nullable
as Set<String>,excludedDrugs: null == excludedDrugs ? _self._excludedDrugs : excludedDrugs // ignore: cast_nullable_to_non_nullable
as Set<String>,showFilters: null == showFilters ? _self.showFilters : showFilters // ignore: cast_nullable_to_non_nullable
as bool,showTimeline: null == showTimeline ? _self.showTimeline : showTimeline // ignore: cast_nullable_to_non_nullable
as bool,chartHoursBack: null == chartHoursBack ? _self.chartHoursBack : chartHoursBack // ignore: cast_nullable_to_non_nullable
as int,chartHoursForward: null == chartHoursForward ? _self.chartHoursForward : chartHoursForward // ignore: cast_nullable_to_non_nullable
as int,chartAdaptiveScale: null == chartAdaptiveScale ? _self.chartAdaptiveScale : chartAdaptiveScale // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
