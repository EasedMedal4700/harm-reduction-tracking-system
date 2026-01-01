// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ErrorLogEntry {

 String? get id; String? get uuidUserId; String? get appVersion; String? get platform; String? get osVersion; String? get deviceModel; String? get screenName; String? get errorMessage; String? get errorCode; String get severity; String? get stacktrace; dynamic get extraData; DateTime? get createdAt;
/// Create a copy of ErrorLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorLogEntryCopyWith<ErrorLogEntry> get copyWith => _$ErrorLogEntryCopyWithImpl<ErrorLogEntry>(this as ErrorLogEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.uuidUserId, uuidUserId) || other.uuidUserId == uuidUserId)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.stacktrace, stacktrace) || other.stacktrace == stacktrace)&&const DeepCollectionEquality().equals(other.extraData, extraData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,uuidUserId,appVersion,platform,osVersion,deviceModel,screenName,errorMessage,errorCode,severity,stacktrace,const DeepCollectionEquality().hash(extraData),createdAt);

@override
String toString() {
  return 'ErrorLogEntry(id: $id, uuidUserId: $uuidUserId, appVersion: $appVersion, platform: $platform, osVersion: $osVersion, deviceModel: $deviceModel, screenName: $screenName, errorMessage: $errorMessage, errorCode: $errorCode, severity: $severity, stacktrace: $stacktrace, extraData: $extraData, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ErrorLogEntryCopyWith<$Res>  {
  factory $ErrorLogEntryCopyWith(ErrorLogEntry value, $Res Function(ErrorLogEntry) _then) = _$ErrorLogEntryCopyWithImpl;
@useResult
$Res call({
 String? id, String? uuidUserId, String? appVersion, String? platform, String? osVersion, String? deviceModel, String? screenName, String? errorMessage, String? errorCode, String severity, String? stacktrace, dynamic extraData, DateTime? createdAt
});




}
/// @nodoc
class _$ErrorLogEntryCopyWithImpl<$Res>
    implements $ErrorLogEntryCopyWith<$Res> {
  _$ErrorLogEntryCopyWithImpl(this._self, this._then);

  final ErrorLogEntry _self;
  final $Res Function(ErrorLogEntry) _then;

/// Create a copy of ErrorLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? uuidUserId = freezed,Object? appVersion = freezed,Object? platform = freezed,Object? osVersion = freezed,Object? deviceModel = freezed,Object? screenName = freezed,Object? errorMessage = freezed,Object? errorCode = freezed,Object? severity = null,Object? stacktrace = freezed,Object? extraData = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,uuidUserId: freezed == uuidUserId ? _self.uuidUserId : uuidUserId // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,stacktrace: freezed == stacktrace ? _self.stacktrace : stacktrace // ignore: cast_nullable_to_non_nullable
as String?,extraData: freezed == extraData ? _self.extraData : extraData // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ErrorLogEntry].
extension ErrorLogEntryPatterns on ErrorLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ErrorLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ErrorLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ErrorLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _ErrorLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ErrorLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ErrorLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? uuidUserId,  String? appVersion,  String? platform,  String? osVersion,  String? deviceModel,  String? screenName,  String? errorMessage,  String? errorCode,  String severity,  String? stacktrace,  dynamic extraData,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ErrorLogEntry() when $default != null:
return $default(_that.id,_that.uuidUserId,_that.appVersion,_that.platform,_that.osVersion,_that.deviceModel,_that.screenName,_that.errorMessage,_that.errorCode,_that.severity,_that.stacktrace,_that.extraData,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? uuidUserId,  String? appVersion,  String? platform,  String? osVersion,  String? deviceModel,  String? screenName,  String? errorMessage,  String? errorCode,  String severity,  String? stacktrace,  dynamic extraData,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ErrorLogEntry():
return $default(_that.id,_that.uuidUserId,_that.appVersion,_that.platform,_that.osVersion,_that.deviceModel,_that.screenName,_that.errorMessage,_that.errorCode,_that.severity,_that.stacktrace,_that.extraData,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? uuidUserId,  String? appVersion,  String? platform,  String? osVersion,  String? deviceModel,  String? screenName,  String? errorMessage,  String? errorCode,  String severity,  String? stacktrace,  dynamic extraData,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ErrorLogEntry() when $default != null:
return $default(_that.id,_that.uuidUserId,_that.appVersion,_that.platform,_that.osVersion,_that.deviceModel,_that.screenName,_that.errorMessage,_that.errorCode,_that.severity,_that.stacktrace,_that.extraData,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ErrorLogEntry extends ErrorLogEntry {
  const _ErrorLogEntry({this.id, this.uuidUserId, this.appVersion, this.platform, this.osVersion, this.deviceModel, this.screenName, this.errorMessage, this.errorCode, this.severity = 'medium', this.stacktrace, this.extraData, this.createdAt}): super._();
  

@override final  String? id;
@override final  String? uuidUserId;
@override final  String? appVersion;
@override final  String? platform;
@override final  String? osVersion;
@override final  String? deviceModel;
@override final  String? screenName;
@override final  String? errorMessage;
@override final  String? errorCode;
@override@JsonKey() final  String severity;
@override final  String? stacktrace;
@override final  dynamic extraData;
@override final  DateTime? createdAt;

/// Create a copy of ErrorLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorLogEntryCopyWith<_ErrorLogEntry> get copyWith => __$ErrorLogEntryCopyWithImpl<_ErrorLogEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.uuidUserId, uuidUserId) || other.uuidUserId == uuidUserId)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.stacktrace, stacktrace) || other.stacktrace == stacktrace)&&const DeepCollectionEquality().equals(other.extraData, extraData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,uuidUserId,appVersion,platform,osVersion,deviceModel,screenName,errorMessage,errorCode,severity,stacktrace,const DeepCollectionEquality().hash(extraData),createdAt);

@override
String toString() {
  return 'ErrorLogEntry(id: $id, uuidUserId: $uuidUserId, appVersion: $appVersion, platform: $platform, osVersion: $osVersion, deviceModel: $deviceModel, screenName: $screenName, errorMessage: $errorMessage, errorCode: $errorCode, severity: $severity, stacktrace: $stacktrace, extraData: $extraData, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ErrorLogEntryCopyWith<$Res> implements $ErrorLogEntryCopyWith<$Res> {
  factory _$ErrorLogEntryCopyWith(_ErrorLogEntry value, $Res Function(_ErrorLogEntry) _then) = __$ErrorLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? uuidUserId, String? appVersion, String? platform, String? osVersion, String? deviceModel, String? screenName, String? errorMessage, String? errorCode, String severity, String? stacktrace, dynamic extraData, DateTime? createdAt
});




}
/// @nodoc
class __$ErrorLogEntryCopyWithImpl<$Res>
    implements _$ErrorLogEntryCopyWith<$Res> {
  __$ErrorLogEntryCopyWithImpl(this._self, this._then);

  final _ErrorLogEntry _self;
  final $Res Function(_ErrorLogEntry) _then;

/// Create a copy of ErrorLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? uuidUserId = freezed,Object? appVersion = freezed,Object? platform = freezed,Object? osVersion = freezed,Object? deviceModel = freezed,Object? screenName = freezed,Object? errorMessage = freezed,Object? errorCode = freezed,Object? severity = null,Object? stacktrace = freezed,Object? extraData = freezed,Object? createdAt = freezed,}) {
  return _then(_ErrorLogEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,uuidUserId: freezed == uuidUserId ? _self.uuidUserId : uuidUserId // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,stacktrace: freezed == stacktrace ? _self.stacktrace : stacktrace // ignore: cast_nullable_to_non_nullable
as String?,extraData: freezed == extraData ? _self.extraData : extraData // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
