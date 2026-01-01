// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_cleanup_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ErrorCleanupFilters {

 bool get deleteAll; int? get olderThanDays; String? get platform; String? get screenName;
/// Create a copy of ErrorCleanupFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCleanupFiltersCopyWith<ErrorCleanupFilters> get copyWith => _$ErrorCleanupFiltersCopyWithImpl<ErrorCleanupFilters>(this as ErrorCleanupFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCleanupFilters&&(identical(other.deleteAll, deleteAll) || other.deleteAll == deleteAll)&&(identical(other.olderThanDays, olderThanDays) || other.olderThanDays == olderThanDays)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.screenName, screenName) || other.screenName == screenName));
}


@override
int get hashCode => Object.hash(runtimeType,deleteAll,olderThanDays,platform,screenName);

@override
String toString() {
  return 'ErrorCleanupFilters(deleteAll: $deleteAll, olderThanDays: $olderThanDays, platform: $platform, screenName: $screenName)';
}


}

/// @nodoc
abstract mixin class $ErrorCleanupFiltersCopyWith<$Res>  {
  factory $ErrorCleanupFiltersCopyWith(ErrorCleanupFilters value, $Res Function(ErrorCleanupFilters) _then) = _$ErrorCleanupFiltersCopyWithImpl;
@useResult
$Res call({
 bool deleteAll, int? olderThanDays, String? platform, String? screenName
});




}
/// @nodoc
class _$ErrorCleanupFiltersCopyWithImpl<$Res>
    implements $ErrorCleanupFiltersCopyWith<$Res> {
  _$ErrorCleanupFiltersCopyWithImpl(this._self, this._then);

  final ErrorCleanupFilters _self;
  final $Res Function(ErrorCleanupFilters) _then;

/// Create a copy of ErrorCleanupFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deleteAll = null,Object? olderThanDays = freezed,Object? platform = freezed,Object? screenName = freezed,}) {
  return _then(_self.copyWith(
deleteAll: null == deleteAll ? _self.deleteAll : deleteAll // ignore: cast_nullable_to_non_nullable
as bool,olderThanDays: freezed == olderThanDays ? _self.olderThanDays : olderThanDays // ignore: cast_nullable_to_non_nullable
as int?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ErrorCleanupFilters].
extension ErrorCleanupFiltersPatterns on ErrorCleanupFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ErrorCleanupFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ErrorCleanupFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ErrorCleanupFilters value)  $default,){
final _that = this;
switch (_that) {
case _ErrorCleanupFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ErrorCleanupFilters value)?  $default,){
final _that = this;
switch (_that) {
case _ErrorCleanupFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool deleteAll,  int? olderThanDays,  String? platform,  String? screenName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ErrorCleanupFilters() when $default != null:
return $default(_that.deleteAll,_that.olderThanDays,_that.platform,_that.screenName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool deleteAll,  int? olderThanDays,  String? platform,  String? screenName)  $default,) {final _that = this;
switch (_that) {
case _ErrorCleanupFilters():
return $default(_that.deleteAll,_that.olderThanDays,_that.platform,_that.screenName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool deleteAll,  int? olderThanDays,  String? platform,  String? screenName)?  $default,) {final _that = this;
switch (_that) {
case _ErrorCleanupFilters() when $default != null:
return $default(_that.deleteAll,_that.olderThanDays,_that.platform,_that.screenName);case _:
  return null;

}
}

}

/// @nodoc


class _ErrorCleanupFilters implements ErrorCleanupFilters {
  const _ErrorCleanupFilters({this.deleteAll = false, this.olderThanDays, this.platform, this.screenName});
  

@override@JsonKey() final  bool deleteAll;
@override final  int? olderThanDays;
@override final  String? platform;
@override final  String? screenName;

/// Create a copy of ErrorCleanupFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCleanupFiltersCopyWith<_ErrorCleanupFilters> get copyWith => __$ErrorCleanupFiltersCopyWithImpl<_ErrorCleanupFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorCleanupFilters&&(identical(other.deleteAll, deleteAll) || other.deleteAll == deleteAll)&&(identical(other.olderThanDays, olderThanDays) || other.olderThanDays == olderThanDays)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.screenName, screenName) || other.screenName == screenName));
}


@override
int get hashCode => Object.hash(runtimeType,deleteAll,olderThanDays,platform,screenName);

@override
String toString() {
  return 'ErrorCleanupFilters(deleteAll: $deleteAll, olderThanDays: $olderThanDays, platform: $platform, screenName: $screenName)';
}


}

/// @nodoc
abstract mixin class _$ErrorCleanupFiltersCopyWith<$Res> implements $ErrorCleanupFiltersCopyWith<$Res> {
  factory _$ErrorCleanupFiltersCopyWith(_ErrorCleanupFilters value, $Res Function(_ErrorCleanupFilters) _then) = __$ErrorCleanupFiltersCopyWithImpl;
@override @useResult
$Res call({
 bool deleteAll, int? olderThanDays, String? platform, String? screenName
});




}
/// @nodoc
class __$ErrorCleanupFiltersCopyWithImpl<$Res>
    implements _$ErrorCleanupFiltersCopyWith<$Res> {
  __$ErrorCleanupFiltersCopyWithImpl(this._self, this._then);

  final _ErrorCleanupFilters _self;
  final $Res Function(_ErrorCleanupFilters) _then;

/// Create a copy of ErrorCleanupFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deleteAll = null,Object? olderThanDays = freezed,Object? platform = freezed,Object? screenName = freezed,}) {
  return _then(_ErrorCleanupFilters(
deleteAll: null == deleteAll ? _self.deleteAll : deleteAll // ignore: cast_nullable_to_non_nullable
as bool,olderThanDays: freezed == olderThanDays ? _self.olderThanDays : olderThanDays // ignore: cast_nullable_to_non_nullable
as int?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
