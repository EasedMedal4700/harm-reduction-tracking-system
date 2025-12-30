// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminUser {

 String get authUserId; String get displayName; String get email; bool get isAdmin; DateTime? get createdAt; DateTime? get updatedAt; DateTime? get lastActivity; int get entryCount; int get cravingCount; int get reflectionCount;
/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserCopyWith<AdminUser> get copyWith => _$AdminUserCopyWithImpl<AdminUser>(this as AdminUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUser&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastActivity, lastActivity) || other.lastActivity == lastActivity)&&(identical(other.entryCount, entryCount) || other.entryCount == entryCount)&&(identical(other.cravingCount, cravingCount) || other.cravingCount == cravingCount)&&(identical(other.reflectionCount, reflectionCount) || other.reflectionCount == reflectionCount));
}


@override
int get hashCode => Object.hash(runtimeType,authUserId,displayName,email,isAdmin,createdAt,updatedAt,lastActivity,entryCount,cravingCount,reflectionCount);

@override
String toString() {
  return 'AdminUser(authUserId: $authUserId, displayName: $displayName, email: $email, isAdmin: $isAdmin, createdAt: $createdAt, updatedAt: $updatedAt, lastActivity: $lastActivity, entryCount: $entryCount, cravingCount: $cravingCount, reflectionCount: $reflectionCount)';
}


}

/// @nodoc
abstract mixin class $AdminUserCopyWith<$Res>  {
  factory $AdminUserCopyWith(AdminUser value, $Res Function(AdminUser) _then) = _$AdminUserCopyWithImpl;
@useResult
$Res call({
 String authUserId, String displayName, String email, bool isAdmin, DateTime? createdAt, DateTime? updatedAt, DateTime? lastActivity, int entryCount, int cravingCount, int reflectionCount
});




}
/// @nodoc
class _$AdminUserCopyWithImpl<$Res>
    implements $AdminUserCopyWith<$Res> {
  _$AdminUserCopyWithImpl(this._self, this._then);

  final AdminUser _self;
  final $Res Function(AdminUser) _then;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authUserId = null,Object? displayName = null,Object? email = null,Object? isAdmin = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? lastActivity = freezed,Object? entryCount = null,Object? cravingCount = null,Object? reflectionCount = null,}) {
  return _then(_self.copyWith(
authUserId: null == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastActivity: freezed == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as DateTime?,entryCount: null == entryCount ? _self.entryCount : entryCount // ignore: cast_nullable_to_non_nullable
as int,cravingCount: null == cravingCount ? _self.cravingCount : cravingCount // ignore: cast_nullable_to_non_nullable
as int,reflectionCount: null == reflectionCount ? _self.reflectionCount : reflectionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUser].
extension AdminUserPatterns on AdminUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUser value)  $default,){
final _that = this;
switch (_that) {
case _AdminUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUser value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String authUserId,  String displayName,  String email,  bool isAdmin,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? lastActivity,  int entryCount,  int cravingCount,  int reflectionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
return $default(_that.authUserId,_that.displayName,_that.email,_that.isAdmin,_that.createdAt,_that.updatedAt,_that.lastActivity,_that.entryCount,_that.cravingCount,_that.reflectionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String authUserId,  String displayName,  String email,  bool isAdmin,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? lastActivity,  int entryCount,  int cravingCount,  int reflectionCount)  $default,) {final _that = this;
switch (_that) {
case _AdminUser():
return $default(_that.authUserId,_that.displayName,_that.email,_that.isAdmin,_that.createdAt,_that.updatedAt,_that.lastActivity,_that.entryCount,_that.cravingCount,_that.reflectionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String authUserId,  String displayName,  String email,  bool isAdmin,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? lastActivity,  int entryCount,  int cravingCount,  int reflectionCount)?  $default,) {final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
return $default(_that.authUserId,_that.displayName,_that.email,_that.isAdmin,_that.createdAt,_that.updatedAt,_that.lastActivity,_that.entryCount,_that.cravingCount,_that.reflectionCount);case _:
  return null;

}
}

}

/// @nodoc


class _AdminUser extends AdminUser {
  const _AdminUser({required this.authUserId, this.displayName = 'Unknown', this.email = 'N/A', this.isAdmin = false, this.createdAt, this.updatedAt, this.lastActivity, this.entryCount = 0, this.cravingCount = 0, this.reflectionCount = 0}): super._();
  

@override final  String authUserId;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  String email;
@override@JsonKey() final  bool isAdmin;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  DateTime? lastActivity;
@override@JsonKey() final  int entryCount;
@override@JsonKey() final  int cravingCount;
@override@JsonKey() final  int reflectionCount;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserCopyWith<_AdminUser> get copyWith => __$AdminUserCopyWithImpl<_AdminUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUser&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastActivity, lastActivity) || other.lastActivity == lastActivity)&&(identical(other.entryCount, entryCount) || other.entryCount == entryCount)&&(identical(other.cravingCount, cravingCount) || other.cravingCount == cravingCount)&&(identical(other.reflectionCount, reflectionCount) || other.reflectionCount == reflectionCount));
}


@override
int get hashCode => Object.hash(runtimeType,authUserId,displayName,email,isAdmin,createdAt,updatedAt,lastActivity,entryCount,cravingCount,reflectionCount);

@override
String toString() {
  return 'AdminUser(authUserId: $authUserId, displayName: $displayName, email: $email, isAdmin: $isAdmin, createdAt: $createdAt, updatedAt: $updatedAt, lastActivity: $lastActivity, entryCount: $entryCount, cravingCount: $cravingCount, reflectionCount: $reflectionCount)';
}


}

/// @nodoc
abstract mixin class _$AdminUserCopyWith<$Res> implements $AdminUserCopyWith<$Res> {
  factory _$AdminUserCopyWith(_AdminUser value, $Res Function(_AdminUser) _then) = __$AdminUserCopyWithImpl;
@override @useResult
$Res call({
 String authUserId, String displayName, String email, bool isAdmin, DateTime? createdAt, DateTime? updatedAt, DateTime? lastActivity, int entryCount, int cravingCount, int reflectionCount
});




}
/// @nodoc
class __$AdminUserCopyWithImpl<$Res>
    implements _$AdminUserCopyWith<$Res> {
  __$AdminUserCopyWithImpl(this._self, this._then);

  final _AdminUser _self;
  final $Res Function(_AdminUser) _then;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authUserId = null,Object? displayName = null,Object? email = null,Object? isAdmin = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? lastActivity = freezed,Object? entryCount = null,Object? cravingCount = null,Object? reflectionCount = null,}) {
  return _then(_AdminUser(
authUserId: null == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastActivity: freezed == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as DateTime?,entryCount: null == entryCount ? _self.entryCount : entryCount // ignore: cast_nullable_to_non_nullable
as int,cravingCount: null == cravingCount ? _self.cravingCount : cravingCount // ignore: cast_nullable_to_non_nullable
as int,reflectionCount: null == reflectionCount ? _self.reflectionCount : reflectionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
