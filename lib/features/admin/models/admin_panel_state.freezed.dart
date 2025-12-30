// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_panel_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminPanelState {

 bool get isLoading; List<AdminUser> get users; AdminSystemStats get systemStats; AdminCacheStats get cacheStats; AdminPerformanceStats get performanceStats; String? get errorMessage;
/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminPanelStateCopyWith<AdminPanelState> get copyWith => _$AdminPanelStateCopyWithImpl<AdminPanelState>(this as AdminPanelState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminPanelState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.systemStats, systemStats) || other.systemStats == systemStats)&&(identical(other.cacheStats, cacheStats) || other.cacheStats == cacheStats)&&(identical(other.performanceStats, performanceStats) || other.performanceStats == performanceStats)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(users),systemStats,cacheStats,performanceStats,errorMessage);

@override
String toString() {
  return 'AdminPanelState(isLoading: $isLoading, users: $users, systemStats: $systemStats, cacheStats: $cacheStats, performanceStats: $performanceStats, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AdminPanelStateCopyWith<$Res>  {
  factory $AdminPanelStateCopyWith(AdminPanelState value, $Res Function(AdminPanelState) _then) = _$AdminPanelStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<AdminUser> users, AdminSystemStats systemStats, AdminCacheStats cacheStats, AdminPerformanceStats performanceStats, String? errorMessage
});


$AdminSystemStatsCopyWith<$Res> get systemStats;$AdminCacheStatsCopyWith<$Res> get cacheStats;$AdminPerformanceStatsCopyWith<$Res> get performanceStats;

}
/// @nodoc
class _$AdminPanelStateCopyWithImpl<$Res>
    implements $AdminPanelStateCopyWith<$Res> {
  _$AdminPanelStateCopyWithImpl(this._self, this._then);

  final AdminPanelState _self;
  final $Res Function(AdminPanelState) _then;

/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? users = null,Object? systemStats = null,Object? cacheStats = null,Object? performanceStats = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<AdminUser>,systemStats: null == systemStats ? _self.systemStats : systemStats // ignore: cast_nullable_to_non_nullable
as AdminSystemStats,cacheStats: null == cacheStats ? _self.cacheStats : cacheStats // ignore: cast_nullable_to_non_nullable
as AdminCacheStats,performanceStats: null == performanceStats ? _self.performanceStats : performanceStats // ignore: cast_nullable_to_non_nullable
as AdminPerformanceStats,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminSystemStatsCopyWith<$Res> get systemStats {
  
  return $AdminSystemStatsCopyWith<$Res>(_self.systemStats, (value) {
    return _then(_self.copyWith(systemStats: value));
  });
}/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminCacheStatsCopyWith<$Res> get cacheStats {
  
  return $AdminCacheStatsCopyWith<$Res>(_self.cacheStats, (value) {
    return _then(_self.copyWith(cacheStats: value));
  });
}/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminPerformanceStatsCopyWith<$Res> get performanceStats {
  
  return $AdminPerformanceStatsCopyWith<$Res>(_self.performanceStats, (value) {
    return _then(_self.copyWith(performanceStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminPanelState].
extension AdminPanelStatePatterns on AdminPanelState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminPanelState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminPanelState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminPanelState value)  $default,){
final _that = this;
switch (_that) {
case _AdminPanelState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminPanelState value)?  $default,){
final _that = this;
switch (_that) {
case _AdminPanelState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<AdminUser> users,  AdminSystemStats systemStats,  AdminCacheStats cacheStats,  AdminPerformanceStats performanceStats,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminPanelState() when $default != null:
return $default(_that.isLoading,_that.users,_that.systemStats,_that.cacheStats,_that.performanceStats,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<AdminUser> users,  AdminSystemStats systemStats,  AdminCacheStats cacheStats,  AdminPerformanceStats performanceStats,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AdminPanelState():
return $default(_that.isLoading,_that.users,_that.systemStats,_that.cacheStats,_that.performanceStats,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<AdminUser> users,  AdminSystemStats systemStats,  AdminCacheStats cacheStats,  AdminPerformanceStats performanceStats,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AdminPanelState() when $default != null:
return $default(_that.isLoading,_that.users,_that.systemStats,_that.cacheStats,_that.performanceStats,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AdminPanelState implements AdminPanelState {
  const _AdminPanelState({this.isLoading = true, final  List<AdminUser> users = const <AdminUser>[], this.systemStats = const AdminSystemStats(), this.cacheStats = const AdminCacheStats(), this.performanceStats = const AdminPerformanceStats(), this.errorMessage}): _users = users;
  

@override@JsonKey() final  bool isLoading;
 final  List<AdminUser> _users;
@override@JsonKey() List<AdminUser> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

@override@JsonKey() final  AdminSystemStats systemStats;
@override@JsonKey() final  AdminCacheStats cacheStats;
@override@JsonKey() final  AdminPerformanceStats performanceStats;
@override final  String? errorMessage;

/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminPanelStateCopyWith<_AdminPanelState> get copyWith => __$AdminPanelStateCopyWithImpl<_AdminPanelState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminPanelState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._users, _users)&&(identical(other.systemStats, systemStats) || other.systemStats == systemStats)&&(identical(other.cacheStats, cacheStats) || other.cacheStats == cacheStats)&&(identical(other.performanceStats, performanceStats) || other.performanceStats == performanceStats)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_users),systemStats,cacheStats,performanceStats,errorMessage);

@override
String toString() {
  return 'AdminPanelState(isLoading: $isLoading, users: $users, systemStats: $systemStats, cacheStats: $cacheStats, performanceStats: $performanceStats, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AdminPanelStateCopyWith<$Res> implements $AdminPanelStateCopyWith<$Res> {
  factory _$AdminPanelStateCopyWith(_AdminPanelState value, $Res Function(_AdminPanelState) _then) = __$AdminPanelStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<AdminUser> users, AdminSystemStats systemStats, AdminCacheStats cacheStats, AdminPerformanceStats performanceStats, String? errorMessage
});


@override $AdminSystemStatsCopyWith<$Res> get systemStats;@override $AdminCacheStatsCopyWith<$Res> get cacheStats;@override $AdminPerformanceStatsCopyWith<$Res> get performanceStats;

}
/// @nodoc
class __$AdminPanelStateCopyWithImpl<$Res>
    implements _$AdminPanelStateCopyWith<$Res> {
  __$AdminPanelStateCopyWithImpl(this._self, this._then);

  final _AdminPanelState _self;
  final $Res Function(_AdminPanelState) _then;

/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? users = null,Object? systemStats = null,Object? cacheStats = null,Object? performanceStats = null,Object? errorMessage = freezed,}) {
  return _then(_AdminPanelState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<AdminUser>,systemStats: null == systemStats ? _self.systemStats : systemStats // ignore: cast_nullable_to_non_nullable
as AdminSystemStats,cacheStats: null == cacheStats ? _self.cacheStats : cacheStats // ignore: cast_nullable_to_non_nullable
as AdminCacheStats,performanceStats: null == performanceStats ? _self.performanceStats : performanceStats // ignore: cast_nullable_to_non_nullable
as AdminPerformanceStats,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminSystemStatsCopyWith<$Res> get systemStats {
  
  return $AdminSystemStatsCopyWith<$Res>(_self.systemStats, (value) {
    return _then(_self.copyWith(systemStats: value));
  });
}/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminCacheStatsCopyWith<$Res> get cacheStats {
  
  return $AdminCacheStatsCopyWith<$Res>(_self.cacheStats, (value) {
    return _then(_self.copyWith(cacheStats: value));
  });
}/// Create a copy of AdminPanelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminPerformanceStatsCopyWith<$Res> get performanceStats {
  
  return $AdminPerformanceStatsCopyWith<$Res>(_self.performanceStats, (value) {
    return _then(_self.copyWith(performanceStats: value));
  });
}
}

// dart format on
