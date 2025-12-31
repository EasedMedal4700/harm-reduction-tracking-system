// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfile {

/// The auth user ID (UUID) - primary key, references auth.users(id)
 String get authUserId;/// The user's display name
 String get displayName;/// Whether the user has admin privileges
 bool get isAdmin;/// Email from auth.users (not stored in public.users)
 String? get email;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,authUserId,displayName,isAdmin,email);

@override
String toString() {
  return 'UserProfile(authUserId: $authUserId, displayName: $displayName, isAdmin: $isAdmin, email: $email)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String authUserId, String displayName, bool isAdmin, String? email
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authUserId = null,Object? displayName = null,Object? isAdmin = null,Object? email = freezed,}) {
  return _then(_self.copyWith(
authUserId: null == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String authUserId,  String displayName,  bool isAdmin,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.authUserId,_that.displayName,_that.isAdmin,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String authUserId,  String displayName,  bool isAdmin,  String? email)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.authUserId,_that.displayName,_that.isAdmin,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String authUserId,  String displayName,  bool isAdmin,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.authUserId,_that.displayName,_that.isAdmin,_that.email);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile extends UserProfile {
  const _UserProfile({required this.authUserId, this.displayName = 'User', this.isAdmin = false, this.email}): super._();
  

/// The auth user ID (UUID) - primary key, references auth.users(id)
@override final  String authUserId;
/// The user's display name
@override@JsonKey() final  String displayName;
/// Whether the user has admin privileges
@override@JsonKey() final  bool isAdmin;
/// Email from auth.users (not stored in public.users)
@override final  String? email;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,authUserId,displayName,isAdmin,email);

@override
String toString() {
  return 'UserProfile(authUserId: $authUserId, displayName: $displayName, isAdmin: $isAdmin, email: $email)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String authUserId, String displayName, bool isAdmin, String? email
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authUserId = null,Object? displayName = null,Object? isAdmin = null,Object? email = freezed,}) {
  return _then(_UserProfile(
authUserId: null == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$UserProfileException {

 String get message; String? get code; Object? get originalError;
/// Create a copy of UserProfileException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileExceptionCopyWith<UserProfileException> get copyWith => _$UserProfileExceptionCopyWithImpl<UserProfileException>(this as UserProfileException, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.originalError, originalError));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(originalError));



}

/// @nodoc
abstract mixin class $UserProfileExceptionCopyWith<$Res>  {
  factory $UserProfileExceptionCopyWith(UserProfileException value, $Res Function(UserProfileException) _then) = _$UserProfileExceptionCopyWithImpl;
@useResult
$Res call({
 String message, String? code, Object? originalError
});




}
/// @nodoc
class _$UserProfileExceptionCopyWithImpl<$Res>
    implements $UserProfileExceptionCopyWith<$Res> {
  _$UserProfileExceptionCopyWithImpl(this._self, this._then);

  final UserProfileException _self;
  final $Res Function(UserProfileException) _then;

/// Create a copy of UserProfileException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? code = freezed,Object? originalError = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,originalError: freezed == originalError ? _self.originalError : originalError ,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileException].
extension UserProfileExceptionPatterns on UserProfileException {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileException value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileException() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileException value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileException():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileException value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileException() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  String? code,  Object? originalError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileException() when $default != null:
return $default(_that.message,_that.code,_that.originalError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  String? code,  Object? originalError)  $default,) {final _that = this;
switch (_that) {
case _UserProfileException():
return $default(_that.message,_that.code,_that.originalError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  String? code,  Object? originalError)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileException() when $default != null:
return $default(_that.message,_that.code,_that.originalError);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfileException extends UserProfileException {
  const _UserProfileException(this.message, {this.code, this.originalError}): super._();
  

@override final  String message;
@override final  String? code;
@override final  Object? originalError;

/// Create a copy of UserProfileException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileExceptionCopyWith<_UserProfileException> get copyWith => __$UserProfileExceptionCopyWithImpl<_UserProfileException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileException&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.originalError, originalError));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(originalError));



}

/// @nodoc
abstract mixin class _$UserProfileExceptionCopyWith<$Res> implements $UserProfileExceptionCopyWith<$Res> {
  factory _$UserProfileExceptionCopyWith(_UserProfileException value, $Res Function(_UserProfileException) _then) = __$UserProfileExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code, Object? originalError
});




}
/// @nodoc
class __$UserProfileExceptionCopyWithImpl<$Res>
    implements _$UserProfileExceptionCopyWith<$Res> {
  __$UserProfileExceptionCopyWithImpl(this._self, this._then);

  final _UserProfileException _self;
  final $Res Function(_UserProfileException) _then;

/// Create a copy of UserProfileException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,Object? originalError = freezed,}) {
  return _then(_UserProfileException(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,originalError: freezed == originalError ? _self.originalError : originalError ,
  ));
}


}

// dart format on
