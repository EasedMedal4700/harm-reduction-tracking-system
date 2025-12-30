// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_cache_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminCacheStats {

 int get totalEntries; int get activeEntries; int get expiredEntries;
/// Create a copy of AdminCacheStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCacheStatsCopyWith<AdminCacheStats> get copyWith => _$AdminCacheStatsCopyWithImpl<AdminCacheStats>(this as AdminCacheStats, _$identity);

  /// Serializes this AdminCacheStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCacheStats&&(identical(other.totalEntries, totalEntries) || other.totalEntries == totalEntries)&&(identical(other.activeEntries, activeEntries) || other.activeEntries == activeEntries)&&(identical(other.expiredEntries, expiredEntries) || other.expiredEntries == expiredEntries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEntries,activeEntries,expiredEntries);

@override
String toString() {
  return 'AdminCacheStats(totalEntries: $totalEntries, activeEntries: $activeEntries, expiredEntries: $expiredEntries)';
}


}

/// @nodoc
abstract mixin class $AdminCacheStatsCopyWith<$Res>  {
  factory $AdminCacheStatsCopyWith(AdminCacheStats value, $Res Function(AdminCacheStats) _then) = _$AdminCacheStatsCopyWithImpl;
@useResult
$Res call({
 int totalEntries, int activeEntries, int expiredEntries
});




}
/// @nodoc
class _$AdminCacheStatsCopyWithImpl<$Res>
    implements $AdminCacheStatsCopyWith<$Res> {
  _$AdminCacheStatsCopyWithImpl(this._self, this._then);

  final AdminCacheStats _self;
  final $Res Function(AdminCacheStats) _then;

/// Create a copy of AdminCacheStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalEntries = null,Object? activeEntries = null,Object? expiredEntries = null,}) {
  return _then(_self.copyWith(
totalEntries: null == totalEntries ? _self.totalEntries : totalEntries // ignore: cast_nullable_to_non_nullable
as int,activeEntries: null == activeEntries ? _self.activeEntries : activeEntries // ignore: cast_nullable_to_non_nullable
as int,expiredEntries: null == expiredEntries ? _self.expiredEntries : expiredEntries // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminCacheStats].
extension AdminCacheStatsPatterns on AdminCacheStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminCacheStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminCacheStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminCacheStats value)  $default,){
final _that = this;
switch (_that) {
case _AdminCacheStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminCacheStats value)?  $default,){
final _that = this;
switch (_that) {
case _AdminCacheStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalEntries,  int activeEntries,  int expiredEntries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminCacheStats() when $default != null:
return $default(_that.totalEntries,_that.activeEntries,_that.expiredEntries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalEntries,  int activeEntries,  int expiredEntries)  $default,) {final _that = this;
switch (_that) {
case _AdminCacheStats():
return $default(_that.totalEntries,_that.activeEntries,_that.expiredEntries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalEntries,  int activeEntries,  int expiredEntries)?  $default,) {final _that = this;
switch (_that) {
case _AdminCacheStats() when $default != null:
return $default(_that.totalEntries,_that.activeEntries,_that.expiredEntries);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminCacheStats implements AdminCacheStats {
  const _AdminCacheStats({this.totalEntries = 0, this.activeEntries = 0, this.expiredEntries = 0});
  factory _AdminCacheStats.fromJson(Map<String, dynamic> json) => _$AdminCacheStatsFromJson(json);

@override@JsonKey() final  int totalEntries;
@override@JsonKey() final  int activeEntries;
@override@JsonKey() final  int expiredEntries;

/// Create a copy of AdminCacheStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCacheStatsCopyWith<_AdminCacheStats> get copyWith => __$AdminCacheStatsCopyWithImpl<_AdminCacheStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminCacheStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCacheStats&&(identical(other.totalEntries, totalEntries) || other.totalEntries == totalEntries)&&(identical(other.activeEntries, activeEntries) || other.activeEntries == activeEntries)&&(identical(other.expiredEntries, expiredEntries) || other.expiredEntries == expiredEntries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEntries,activeEntries,expiredEntries);

@override
String toString() {
  return 'AdminCacheStats(totalEntries: $totalEntries, activeEntries: $activeEntries, expiredEntries: $expiredEntries)';
}


}

/// @nodoc
abstract mixin class _$AdminCacheStatsCopyWith<$Res> implements $AdminCacheStatsCopyWith<$Res> {
  factory _$AdminCacheStatsCopyWith(_AdminCacheStats value, $Res Function(_AdminCacheStats) _then) = __$AdminCacheStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalEntries, int activeEntries, int expiredEntries
});




}
/// @nodoc
class __$AdminCacheStatsCopyWithImpl<$Res>
    implements _$AdminCacheStatsCopyWith<$Res> {
  __$AdminCacheStatsCopyWithImpl(this._self, this._then);

  final _AdminCacheStats _self;
  final $Res Function(_AdminCacheStats) _then;

/// Create a copy of AdminCacheStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalEntries = null,Object? activeEntries = null,Object? expiredEntries = null,}) {
  return _then(_AdminCacheStats(
totalEntries: null == totalEntries ? _self.totalEntries : totalEntries // ignore: cast_nullable_to_non_nullable
as int,activeEntries: null == activeEntries ? _self.activeEntries : activeEntries // ignore: cast_nullable_to_non_nullable
as int,expiredEntries: null == expiredEntries ? _self.expiredEntries : expiredEntries // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
