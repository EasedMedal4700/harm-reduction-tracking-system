// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curve_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CurvePoint {

/// Time offset in hours relative to "now" (negative = past, positive = future)
 double get hours;/// Amount of drug remaining in mg
 double get remainingMg;
/// Create a copy of CurvePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurvePointCopyWith<CurvePoint> get copyWith => _$CurvePointCopyWithImpl<CurvePoint>(this as CurvePoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurvePoint&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.remainingMg, remainingMg) || other.remainingMg == remainingMg));
}


@override
int get hashCode => Object.hash(runtimeType,hours,remainingMg);

@override
String toString() {
  return 'CurvePoint(hours: $hours, remainingMg: $remainingMg)';
}


}

/// @nodoc
abstract mixin class $CurvePointCopyWith<$Res>  {
  factory $CurvePointCopyWith(CurvePoint value, $Res Function(CurvePoint) _then) = _$CurvePointCopyWithImpl;
@useResult
$Res call({
 double hours, double remainingMg
});




}
/// @nodoc
class _$CurvePointCopyWithImpl<$Res>
    implements $CurvePointCopyWith<$Res> {
  _$CurvePointCopyWithImpl(this._self, this._then);

  final CurvePoint _self;
  final $Res Function(CurvePoint) _then;

/// Create a copy of CurvePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hours = null,Object? remainingMg = null,}) {
  return _then(_self.copyWith(
hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,remainingMg: null == remainingMg ? _self.remainingMg : remainingMg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CurvePoint].
extension CurvePointPatterns on CurvePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurvePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurvePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurvePoint value)  $default,){
final _that = this;
switch (_that) {
case _CurvePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurvePoint value)?  $default,){
final _that = this;
switch (_that) {
case _CurvePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double hours,  double remainingMg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurvePoint() when $default != null:
return $default(_that.hours,_that.remainingMg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double hours,  double remainingMg)  $default,) {final _that = this;
switch (_that) {
case _CurvePoint():
return $default(_that.hours,_that.remainingMg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double hours,  double remainingMg)?  $default,) {final _that = this;
switch (_that) {
case _CurvePoint() when $default != null:
return $default(_that.hours,_that.remainingMg);case _:
  return null;

}
}

}

/// @nodoc


class _CurvePoint extends CurvePoint {
  const _CurvePoint({required this.hours, required this.remainingMg}): super._();
  

/// Time offset in hours relative to "now" (negative = past, positive = future)
@override final  double hours;
/// Amount of drug remaining in mg
@override final  double remainingMg;

/// Create a copy of CurvePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurvePointCopyWith<_CurvePoint> get copyWith => __$CurvePointCopyWithImpl<_CurvePoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurvePoint&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.remainingMg, remainingMg) || other.remainingMg == remainingMg));
}


@override
int get hashCode => Object.hash(runtimeType,hours,remainingMg);

@override
String toString() {
  return 'CurvePoint(hours: $hours, remainingMg: $remainingMg)';
}


}

/// @nodoc
abstract mixin class _$CurvePointCopyWith<$Res> implements $CurvePointCopyWith<$Res> {
  factory _$CurvePointCopyWith(_CurvePoint value, $Res Function(_CurvePoint) _then) = __$CurvePointCopyWithImpl;
@override @useResult
$Res call({
 double hours, double remainingMg
});




}
/// @nodoc
class __$CurvePointCopyWithImpl<$Res>
    implements _$CurvePointCopyWith<$Res> {
  __$CurvePointCopyWithImpl(this._self, this._then);

  final _CurvePoint _self;
  final $Res Function(_CurvePoint) _then;

/// Create a copy of CurvePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hours = null,Object? remainingMg = null,}) {
  return _then(_CurvePoint(
hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,remainingMg: null == remainingMg ? _self.remainingMg : remainingMg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
