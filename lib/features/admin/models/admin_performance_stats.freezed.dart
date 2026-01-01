// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_performance_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminPerformanceStats {

 double get avgResponseTimeMs; double get avgCachedResponseMs; double get avgUncachedResponseMs; int get totalSamples; double get cacheHitRate; int get cacheHits; int get cacheMisses; int get cacheTotalRequests; DateTime? get lastUpdated; String? get error;
/// Create a copy of AdminPerformanceStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminPerformanceStatsCopyWith<AdminPerformanceStats> get copyWith => _$AdminPerformanceStatsCopyWithImpl<AdminPerformanceStats>(this as AdminPerformanceStats, _$identity);

  /// Serializes this AdminPerformanceStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminPerformanceStats&&(identical(other.avgResponseTimeMs, avgResponseTimeMs) || other.avgResponseTimeMs == avgResponseTimeMs)&&(identical(other.avgCachedResponseMs, avgCachedResponseMs) || other.avgCachedResponseMs == avgCachedResponseMs)&&(identical(other.avgUncachedResponseMs, avgUncachedResponseMs) || other.avgUncachedResponseMs == avgUncachedResponseMs)&&(identical(other.totalSamples, totalSamples) || other.totalSamples == totalSamples)&&(identical(other.cacheHitRate, cacheHitRate) || other.cacheHitRate == cacheHitRate)&&(identical(other.cacheHits, cacheHits) || other.cacheHits == cacheHits)&&(identical(other.cacheMisses, cacheMisses) || other.cacheMisses == cacheMisses)&&(identical(other.cacheTotalRequests, cacheTotalRequests) || other.cacheTotalRequests == cacheTotalRequests)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,avgResponseTimeMs,avgCachedResponseMs,avgUncachedResponseMs,totalSamples,cacheHitRate,cacheHits,cacheMisses,cacheTotalRequests,lastUpdated,error);

@override
String toString() {
  return 'AdminPerformanceStats(avgResponseTimeMs: $avgResponseTimeMs, avgCachedResponseMs: $avgCachedResponseMs, avgUncachedResponseMs: $avgUncachedResponseMs, totalSamples: $totalSamples, cacheHitRate: $cacheHitRate, cacheHits: $cacheHits, cacheMisses: $cacheMisses, cacheTotalRequests: $cacheTotalRequests, lastUpdated: $lastUpdated, error: $error)';
}


}

/// @nodoc
abstract mixin class $AdminPerformanceStatsCopyWith<$Res>  {
  factory $AdminPerformanceStatsCopyWith(AdminPerformanceStats value, $Res Function(AdminPerformanceStats) _then) = _$AdminPerformanceStatsCopyWithImpl;
@useResult
$Res call({
 double avgResponseTimeMs, double avgCachedResponseMs, double avgUncachedResponseMs, int totalSamples, double cacheHitRate, int cacheHits, int cacheMisses, int cacheTotalRequests, DateTime? lastUpdated, String? error
});




}
/// @nodoc
class _$AdminPerformanceStatsCopyWithImpl<$Res>
    implements $AdminPerformanceStatsCopyWith<$Res> {
  _$AdminPerformanceStatsCopyWithImpl(this._self, this._then);

  final AdminPerformanceStats _self;
  final $Res Function(AdminPerformanceStats) _then;

/// Create a copy of AdminPerformanceStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? avgResponseTimeMs = null,Object? avgCachedResponseMs = null,Object? avgUncachedResponseMs = null,Object? totalSamples = null,Object? cacheHitRate = null,Object? cacheHits = null,Object? cacheMisses = null,Object? cacheTotalRequests = null,Object? lastUpdated = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
avgResponseTimeMs: null == avgResponseTimeMs ? _self.avgResponseTimeMs : avgResponseTimeMs // ignore: cast_nullable_to_non_nullable
as double,avgCachedResponseMs: null == avgCachedResponseMs ? _self.avgCachedResponseMs : avgCachedResponseMs // ignore: cast_nullable_to_non_nullable
as double,avgUncachedResponseMs: null == avgUncachedResponseMs ? _self.avgUncachedResponseMs : avgUncachedResponseMs // ignore: cast_nullable_to_non_nullable
as double,totalSamples: null == totalSamples ? _self.totalSamples : totalSamples // ignore: cast_nullable_to_non_nullable
as int,cacheHitRate: null == cacheHitRate ? _self.cacheHitRate : cacheHitRate // ignore: cast_nullable_to_non_nullable
as double,cacheHits: null == cacheHits ? _self.cacheHits : cacheHits // ignore: cast_nullable_to_non_nullable
as int,cacheMisses: null == cacheMisses ? _self.cacheMisses : cacheMisses // ignore: cast_nullable_to_non_nullable
as int,cacheTotalRequests: null == cacheTotalRequests ? _self.cacheTotalRequests : cacheTotalRequests // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminPerformanceStats].
extension AdminPerformanceStatsPatterns on AdminPerformanceStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminPerformanceStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminPerformanceStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminPerformanceStats value)  $default,){
final _that = this;
switch (_that) {
case _AdminPerformanceStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminPerformanceStats value)?  $default,){
final _that = this;
switch (_that) {
case _AdminPerformanceStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double avgResponseTimeMs,  double avgCachedResponseMs,  double avgUncachedResponseMs,  int totalSamples,  double cacheHitRate,  int cacheHits,  int cacheMisses,  int cacheTotalRequests,  DateTime? lastUpdated,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminPerformanceStats() when $default != null:
return $default(_that.avgResponseTimeMs,_that.avgCachedResponseMs,_that.avgUncachedResponseMs,_that.totalSamples,_that.cacheHitRate,_that.cacheHits,_that.cacheMisses,_that.cacheTotalRequests,_that.lastUpdated,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double avgResponseTimeMs,  double avgCachedResponseMs,  double avgUncachedResponseMs,  int totalSamples,  double cacheHitRate,  int cacheHits,  int cacheMisses,  int cacheTotalRequests,  DateTime? lastUpdated,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AdminPerformanceStats():
return $default(_that.avgResponseTimeMs,_that.avgCachedResponseMs,_that.avgUncachedResponseMs,_that.totalSamples,_that.cacheHitRate,_that.cacheHits,_that.cacheMisses,_that.cacheTotalRequests,_that.lastUpdated,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double avgResponseTimeMs,  double avgCachedResponseMs,  double avgUncachedResponseMs,  int totalSamples,  double cacheHitRate,  int cacheHits,  int cacheMisses,  int cacheTotalRequests,  DateTime? lastUpdated,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AdminPerformanceStats() when $default != null:
return $default(_that.avgResponseTimeMs,_that.avgCachedResponseMs,_that.avgUncachedResponseMs,_that.totalSamples,_that.cacheHitRate,_that.cacheHits,_that.cacheMisses,_that.cacheTotalRequests,_that.lastUpdated,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminPerformanceStats implements AdminPerformanceStats {
  const _AdminPerformanceStats({this.avgResponseTimeMs = 0.0, this.avgCachedResponseMs = 0.0, this.avgUncachedResponseMs = 0.0, this.totalSamples = 0, this.cacheHitRate = 0.0, this.cacheHits = 0, this.cacheMisses = 0, this.cacheTotalRequests = 0, this.lastUpdated, this.error});
  factory _AdminPerformanceStats.fromJson(Map<String, dynamic> json) => _$AdminPerformanceStatsFromJson(json);

@override@JsonKey() final  double avgResponseTimeMs;
@override@JsonKey() final  double avgCachedResponseMs;
@override@JsonKey() final  double avgUncachedResponseMs;
@override@JsonKey() final  int totalSamples;
@override@JsonKey() final  double cacheHitRate;
@override@JsonKey() final  int cacheHits;
@override@JsonKey() final  int cacheMisses;
@override@JsonKey() final  int cacheTotalRequests;
@override final  DateTime? lastUpdated;
@override final  String? error;

/// Create a copy of AdminPerformanceStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminPerformanceStatsCopyWith<_AdminPerformanceStats> get copyWith => __$AdminPerformanceStatsCopyWithImpl<_AdminPerformanceStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminPerformanceStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminPerformanceStats&&(identical(other.avgResponseTimeMs, avgResponseTimeMs) || other.avgResponseTimeMs == avgResponseTimeMs)&&(identical(other.avgCachedResponseMs, avgCachedResponseMs) || other.avgCachedResponseMs == avgCachedResponseMs)&&(identical(other.avgUncachedResponseMs, avgUncachedResponseMs) || other.avgUncachedResponseMs == avgUncachedResponseMs)&&(identical(other.totalSamples, totalSamples) || other.totalSamples == totalSamples)&&(identical(other.cacheHitRate, cacheHitRate) || other.cacheHitRate == cacheHitRate)&&(identical(other.cacheHits, cacheHits) || other.cacheHits == cacheHits)&&(identical(other.cacheMisses, cacheMisses) || other.cacheMisses == cacheMisses)&&(identical(other.cacheTotalRequests, cacheTotalRequests) || other.cacheTotalRequests == cacheTotalRequests)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,avgResponseTimeMs,avgCachedResponseMs,avgUncachedResponseMs,totalSamples,cacheHitRate,cacheHits,cacheMisses,cacheTotalRequests,lastUpdated,error);

@override
String toString() {
  return 'AdminPerformanceStats(avgResponseTimeMs: $avgResponseTimeMs, avgCachedResponseMs: $avgCachedResponseMs, avgUncachedResponseMs: $avgUncachedResponseMs, totalSamples: $totalSamples, cacheHitRate: $cacheHitRate, cacheHits: $cacheHits, cacheMisses: $cacheMisses, cacheTotalRequests: $cacheTotalRequests, lastUpdated: $lastUpdated, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AdminPerformanceStatsCopyWith<$Res> implements $AdminPerformanceStatsCopyWith<$Res> {
  factory _$AdminPerformanceStatsCopyWith(_AdminPerformanceStats value, $Res Function(_AdminPerformanceStats) _then) = __$AdminPerformanceStatsCopyWithImpl;
@override @useResult
$Res call({
 double avgResponseTimeMs, double avgCachedResponseMs, double avgUncachedResponseMs, int totalSamples, double cacheHitRate, int cacheHits, int cacheMisses, int cacheTotalRequests, DateTime? lastUpdated, String? error
});




}
/// @nodoc
class __$AdminPerformanceStatsCopyWithImpl<$Res>
    implements _$AdminPerformanceStatsCopyWith<$Res> {
  __$AdminPerformanceStatsCopyWithImpl(this._self, this._then);

  final _AdminPerformanceStats _self;
  final $Res Function(_AdminPerformanceStats) _then;

/// Create a copy of AdminPerformanceStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? avgResponseTimeMs = null,Object? avgCachedResponseMs = null,Object? avgUncachedResponseMs = null,Object? totalSamples = null,Object? cacheHitRate = null,Object? cacheHits = null,Object? cacheMisses = null,Object? cacheTotalRequests = null,Object? lastUpdated = freezed,Object? error = freezed,}) {
  return _then(_AdminPerformanceStats(
avgResponseTimeMs: null == avgResponseTimeMs ? _self.avgResponseTimeMs : avgResponseTimeMs // ignore: cast_nullable_to_non_nullable
as double,avgCachedResponseMs: null == avgCachedResponseMs ? _self.avgCachedResponseMs : avgCachedResponseMs // ignore: cast_nullable_to_non_nullable
as double,avgUncachedResponseMs: null == avgUncachedResponseMs ? _self.avgUncachedResponseMs : avgUncachedResponseMs // ignore: cast_nullable_to_non_nullable
as double,totalSamples: null == totalSamples ? _self.totalSamples : totalSamples // ignore: cast_nullable_to_non_nullable
as int,cacheHitRate: null == cacheHitRate ? _self.cacheHitRate : cacheHitRate // ignore: cast_nullable_to_non_nullable
as double,cacheHits: null == cacheHits ? _self.cacheHits : cacheHits // ignore: cast_nullable_to_non_nullable
as int,cacheMisses: null == cacheMisses ? _self.cacheMisses : cacheMisses // ignore: cast_nullable_to_non_nullable
as int,cacheTotalRequests: null == cacheTotalRequests ? _self.cacheTotalRequests : cacheTotalRequests // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
