// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_system_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminSystemStats {

 int get totalEntries; int get activeUsers; double get cacheHitRate; double get avgResponseTimeMs;
/// Create a copy of AdminSystemStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminSystemStatsCopyWith<AdminSystemStats> get copyWith => _$AdminSystemStatsCopyWithImpl<AdminSystemStats>(this as AdminSystemStats, _$identity);

  /// Serializes this AdminSystemStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminSystemStats&&(identical(other.totalEntries, totalEntries) || other.totalEntries == totalEntries)&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers)&&(identical(other.cacheHitRate, cacheHitRate) || other.cacheHitRate == cacheHitRate)&&(identical(other.avgResponseTimeMs, avgResponseTimeMs) || other.avgResponseTimeMs == avgResponseTimeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEntries,activeUsers,cacheHitRate,avgResponseTimeMs);

@override
String toString() {
  return 'AdminSystemStats(totalEntries: $totalEntries, activeUsers: $activeUsers, cacheHitRate: $cacheHitRate, avgResponseTimeMs: $avgResponseTimeMs)';
}


}

/// @nodoc
abstract mixin class $AdminSystemStatsCopyWith<$Res>  {
  factory $AdminSystemStatsCopyWith(AdminSystemStats value, $Res Function(AdminSystemStats) _then) = _$AdminSystemStatsCopyWithImpl;
@useResult
$Res call({
 int totalEntries, int activeUsers, double cacheHitRate, double avgResponseTimeMs
});




}
/// @nodoc
class _$AdminSystemStatsCopyWithImpl<$Res>
    implements $AdminSystemStatsCopyWith<$Res> {
  _$AdminSystemStatsCopyWithImpl(this._self, this._then);

  final AdminSystemStats _self;
  final $Res Function(AdminSystemStats) _then;

/// Create a copy of AdminSystemStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalEntries = null,Object? activeUsers = null,Object? cacheHitRate = null,Object? avgResponseTimeMs = null,}) {
  return _then(_self.copyWith(
totalEntries: null == totalEntries ? _self.totalEntries : totalEntries // ignore: cast_nullable_to_non_nullable
as int,activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as int,cacheHitRate: null == cacheHitRate ? _self.cacheHitRate : cacheHitRate // ignore: cast_nullable_to_non_nullable
as double,avgResponseTimeMs: null == avgResponseTimeMs ? _self.avgResponseTimeMs : avgResponseTimeMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminSystemStats].
extension AdminSystemStatsPatterns on AdminSystemStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminSystemStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminSystemStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminSystemStats value)  $default,){
final _that = this;
switch (_that) {
case _AdminSystemStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminSystemStats value)?  $default,){
final _that = this;
switch (_that) {
case _AdminSystemStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalEntries,  int activeUsers,  double cacheHitRate,  double avgResponseTimeMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminSystemStats() when $default != null:
return $default(_that.totalEntries,_that.activeUsers,_that.cacheHitRate,_that.avgResponseTimeMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalEntries,  int activeUsers,  double cacheHitRate,  double avgResponseTimeMs)  $default,) {final _that = this;
switch (_that) {
case _AdminSystemStats():
return $default(_that.totalEntries,_that.activeUsers,_that.cacheHitRate,_that.avgResponseTimeMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalEntries,  int activeUsers,  double cacheHitRate,  double avgResponseTimeMs)?  $default,) {final _that = this;
switch (_that) {
case _AdminSystemStats() when $default != null:
return $default(_that.totalEntries,_that.activeUsers,_that.cacheHitRate,_that.avgResponseTimeMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminSystemStats implements AdminSystemStats {
  const _AdminSystemStats({this.totalEntries = 0, this.activeUsers = 0, this.cacheHitRate = 0.0, this.avgResponseTimeMs = 0.0});
  factory _AdminSystemStats.fromJson(Map<String, dynamic> json) => _$AdminSystemStatsFromJson(json);

@override@JsonKey() final  int totalEntries;
@override@JsonKey() final  int activeUsers;
@override@JsonKey() final  double cacheHitRate;
@override@JsonKey() final  double avgResponseTimeMs;

/// Create a copy of AdminSystemStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminSystemStatsCopyWith<_AdminSystemStats> get copyWith => __$AdminSystemStatsCopyWithImpl<_AdminSystemStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminSystemStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminSystemStats&&(identical(other.totalEntries, totalEntries) || other.totalEntries == totalEntries)&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers)&&(identical(other.cacheHitRate, cacheHitRate) || other.cacheHitRate == cacheHitRate)&&(identical(other.avgResponseTimeMs, avgResponseTimeMs) || other.avgResponseTimeMs == avgResponseTimeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEntries,activeUsers,cacheHitRate,avgResponseTimeMs);

@override
String toString() {
  return 'AdminSystemStats(totalEntries: $totalEntries, activeUsers: $activeUsers, cacheHitRate: $cacheHitRate, avgResponseTimeMs: $avgResponseTimeMs)';
}


}

/// @nodoc
abstract mixin class _$AdminSystemStatsCopyWith<$Res> implements $AdminSystemStatsCopyWith<$Res> {
  factory _$AdminSystemStatsCopyWith(_AdminSystemStats value, $Res Function(_AdminSystemStats) _then) = __$AdminSystemStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalEntries, int activeUsers, double cacheHitRate, double avgResponseTimeMs
});




}
/// @nodoc
class __$AdminSystemStatsCopyWithImpl<$Res>
    implements _$AdminSystemStatsCopyWith<$Res> {
  __$AdminSystemStatsCopyWithImpl(this._self, this._then);

  final _AdminSystemStats _self;
  final $Res Function(_AdminSystemStats) _then;

/// Create a copy of AdminSystemStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalEntries = null,Object? activeUsers = null,Object? cacheHitRate = null,Object? avgResponseTimeMs = null,}) {
  return _then(_AdminSystemStats(
totalEntries: null == totalEntries ? _self.totalEntries : totalEntries // ignore: cast_nullable_to_non_nullable
as int,activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as int,cacheHitRate: null == cacheHitRate ? _self.cacheHitRate : cacheHitRate // ignore: cast_nullable_to_non_nullable
as double,avgResponseTimeMs: null == avgResponseTimeMs ? _self.avgResponseTimeMs : avgResponseTimeMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
