// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ErrorLog {

 int get id; String? get userId; String? get appVersion; String? get platform; String? get osVersion; String? get deviceModel; String? get screenName; String get errorMessage; String? get errorCode; String get severity; String? get stacktrace; Map<String, dynamic>? get extraData; DateTime get createdAt;
/// Create a copy of ErrorLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorLogCopyWith<ErrorLog> get copyWith => _$ErrorLogCopyWithImpl<ErrorLog>(this as ErrorLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.stacktrace, stacktrace) || other.stacktrace == stacktrace)&&const DeepCollectionEquality().equals(other.extraData, extraData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,appVersion,platform,osVersion,deviceModel,screenName,errorMessage,errorCode,severity,stacktrace,const DeepCollectionEquality().hash(extraData),createdAt);

@override
String toString() {
  return 'ErrorLog(id: $id, userId: $userId, appVersion: $appVersion, platform: $platform, osVersion: $osVersion, deviceModel: $deviceModel, screenName: $screenName, errorMessage: $errorMessage, errorCode: $errorCode, severity: $severity, stacktrace: $stacktrace, extraData: $extraData, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ErrorLogCopyWith<$Res>  {
  factory $ErrorLogCopyWith(ErrorLog value, $Res Function(ErrorLog) _then) = _$ErrorLogCopyWithImpl;
@useResult
$Res call({
 int id, String? userId, String? appVersion, String? platform, String? osVersion, String? deviceModel, String? screenName, String errorMessage, String? errorCode, String severity, String? stacktrace, Map<String, dynamic>? extraData, DateTime createdAt
});




}
/// @nodoc
class _$ErrorLogCopyWithImpl<$Res>
    implements $ErrorLogCopyWith<$Res> {
  _$ErrorLogCopyWithImpl(this._self, this._then);

  final ErrorLog _self;
  final $Res Function(ErrorLog) _then;

/// Create a copy of ErrorLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? appVersion = freezed,Object? platform = freezed,Object? osVersion = freezed,Object? deviceModel = freezed,Object? screenName = freezed,Object? errorMessage = null,Object? errorCode = freezed,Object? severity = null,Object? stacktrace = freezed,Object? extraData = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,stacktrace: freezed == stacktrace ? _self.stacktrace : stacktrace // ignore: cast_nullable_to_non_nullable
as String?,extraData: freezed == extraData ? _self.extraData : extraData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ErrorLog].
extension ErrorLogPatterns on ErrorLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ErrorLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ErrorLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ErrorLog value)  $default,){
final _that = this;
switch (_that) {
case _ErrorLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ErrorLog value)?  $default,){
final _that = this;
switch (_that) {
case _ErrorLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? userId,  String? appVersion,  String? platform,  String? osVersion,  String? deviceModel,  String? screenName,  String errorMessage,  String? errorCode,  String severity,  String? stacktrace,  Map<String, dynamic>? extraData,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ErrorLog() when $default != null:
return $default(_that.id,_that.userId,_that.appVersion,_that.platform,_that.osVersion,_that.deviceModel,_that.screenName,_that.errorMessage,_that.errorCode,_that.severity,_that.stacktrace,_that.extraData,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? userId,  String? appVersion,  String? platform,  String? osVersion,  String? deviceModel,  String? screenName,  String errorMessage,  String? errorCode,  String severity,  String? stacktrace,  Map<String, dynamic>? extraData,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ErrorLog():
return $default(_that.id,_that.userId,_that.appVersion,_that.platform,_that.osVersion,_that.deviceModel,_that.screenName,_that.errorMessage,_that.errorCode,_that.severity,_that.stacktrace,_that.extraData,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? userId,  String? appVersion,  String? platform,  String? osVersion,  String? deviceModel,  String? screenName,  String errorMessage,  String? errorCode,  String severity,  String? stacktrace,  Map<String, dynamic>? extraData,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ErrorLog() when $default != null:
return $default(_that.id,_that.userId,_that.appVersion,_that.platform,_that.osVersion,_that.deviceModel,_that.screenName,_that.errorMessage,_that.errorCode,_that.severity,_that.stacktrace,_that.extraData,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ErrorLog extends ErrorLog {
  const _ErrorLog({this.id = 0, this.userId, this.appVersion, this.platform, this.osVersion, this.deviceModel, this.screenName, this.errorMessage = 'Unknown error', this.errorCode, this.severity = 'medium', this.stacktrace, final  Map<String, dynamic>? extraData, required this.createdAt}): _extraData = extraData,super._();
  

@override@JsonKey() final  int id;
@override final  String? userId;
@override final  String? appVersion;
@override final  String? platform;
@override final  String? osVersion;
@override final  String? deviceModel;
@override final  String? screenName;
@override@JsonKey() final  String errorMessage;
@override final  String? errorCode;
@override@JsonKey() final  String severity;
@override final  String? stacktrace;
 final  Map<String, dynamic>? _extraData;
@override Map<String, dynamic>? get extraData {
  final value = _extraData;
  if (value == null) return null;
  if (_extraData is EqualUnmodifiableMapView) return _extraData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;

/// Create a copy of ErrorLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorLogCopyWith<_ErrorLog> get copyWith => __$ErrorLogCopyWithImpl<_ErrorLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.stacktrace, stacktrace) || other.stacktrace == stacktrace)&&const DeepCollectionEquality().equals(other._extraData, _extraData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,appVersion,platform,osVersion,deviceModel,screenName,errorMessage,errorCode,severity,stacktrace,const DeepCollectionEquality().hash(_extraData),createdAt);

@override
String toString() {
  return 'ErrorLog(id: $id, userId: $userId, appVersion: $appVersion, platform: $platform, osVersion: $osVersion, deviceModel: $deviceModel, screenName: $screenName, errorMessage: $errorMessage, errorCode: $errorCode, severity: $severity, stacktrace: $stacktrace, extraData: $extraData, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ErrorLogCopyWith<$Res> implements $ErrorLogCopyWith<$Res> {
  factory _$ErrorLogCopyWith(_ErrorLog value, $Res Function(_ErrorLog) _then) = __$ErrorLogCopyWithImpl;
@override @useResult
$Res call({
 int id, String? userId, String? appVersion, String? platform, String? osVersion, String? deviceModel, String? screenName, String errorMessage, String? errorCode, String severity, String? stacktrace, Map<String, dynamic>? extraData, DateTime createdAt
});




}
/// @nodoc
class __$ErrorLogCopyWithImpl<$Res>
    implements _$ErrorLogCopyWith<$Res> {
  __$ErrorLogCopyWithImpl(this._self, this._then);

  final _ErrorLog _self;
  final $Res Function(_ErrorLog) _then;

/// Create a copy of ErrorLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? appVersion = freezed,Object? platform = freezed,Object? osVersion = freezed,Object? deviceModel = freezed,Object? screenName = freezed,Object? errorMessage = null,Object? errorCode = freezed,Object? severity = null,Object? stacktrace = freezed,Object? extraData = freezed,Object? createdAt = null,}) {
  return _then(_ErrorLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,stacktrace: freezed == stacktrace ? _self.stacktrace : stacktrace // ignore: cast_nullable_to_non_nullable
as String?,extraData: freezed == extraData ? _self._extraData : extraData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$ColorInfo {

 int get colorValue; String get name;
/// Create a copy of ColorInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColorInfoCopyWith<ColorInfo> get copyWith => _$ColorInfoCopyWithImpl<ColorInfo>(this as ColorInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColorInfo&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,colorValue,name);

@override
String toString() {
  return 'ColorInfo(colorValue: $colorValue, name: $name)';
}


}

/// @nodoc
abstract mixin class $ColorInfoCopyWith<$Res>  {
  factory $ColorInfoCopyWith(ColorInfo value, $Res Function(ColorInfo) _then) = _$ColorInfoCopyWithImpl;
@useResult
$Res call({
 int colorValue, String name
});




}
/// @nodoc
class _$ColorInfoCopyWithImpl<$Res>
    implements $ColorInfoCopyWith<$Res> {
  _$ColorInfoCopyWithImpl(this._self, this._then);

  final ColorInfo _self;
  final $Res Function(ColorInfo) _then;

/// Create a copy of ColorInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? colorValue = null,Object? name = null,}) {
  return _then(_self.copyWith(
colorValue: null == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ColorInfo].
extension ColorInfoPatterns on ColorInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ColorInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ColorInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ColorInfo value)  $default,){
final _that = this;
switch (_that) {
case _ColorInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ColorInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ColorInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int colorValue,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ColorInfo() when $default != null:
return $default(_that.colorValue,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int colorValue,  String name)  $default,) {final _that = this;
switch (_that) {
case _ColorInfo():
return $default(_that.colorValue,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int colorValue,  String name)?  $default,) {final _that = this;
switch (_that) {
case _ColorInfo() when $default != null:
return $default(_that.colorValue,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _ColorInfo extends ColorInfo {
  const _ColorInfo({required this.colorValue, required this.name}): super._();
  

@override final  int colorValue;
@override final  String name;

/// Create a copy of ColorInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorInfoCopyWith<_ColorInfo> get copyWith => __$ColorInfoCopyWithImpl<_ColorInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorInfo&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,colorValue,name);

@override
String toString() {
  return 'ColorInfo(colorValue: $colorValue, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ColorInfoCopyWith<$Res> implements $ColorInfoCopyWith<$Res> {
  factory _$ColorInfoCopyWith(_ColorInfo value, $Res Function(_ColorInfo) _then) = __$ColorInfoCopyWithImpl;
@override @useResult
$Res call({
 int colorValue, String name
});




}
/// @nodoc
class __$ColorInfoCopyWithImpl<$Res>
    implements _$ColorInfoCopyWith<$Res> {
  __$ColorInfoCopyWithImpl(this._self, this._then);

  final _ColorInfo _self;
  final $Res Function(_ColorInfo) _then;

/// Create a copy of ColorInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? colorValue = null,Object? name = null,}) {
  return _then(_ColorInfo(
colorValue: null == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$IconInfo {

 int get iconCodePoint; String get name;
/// Create a copy of IconInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IconInfoCopyWith<IconInfo> get copyWith => _$IconInfoCopyWithImpl<IconInfo>(this as IconInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IconInfo&&(identical(other.iconCodePoint, iconCodePoint) || other.iconCodePoint == iconCodePoint)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,iconCodePoint,name);

@override
String toString() {
  return 'IconInfo(iconCodePoint: $iconCodePoint, name: $name)';
}


}

/// @nodoc
abstract mixin class $IconInfoCopyWith<$Res>  {
  factory $IconInfoCopyWith(IconInfo value, $Res Function(IconInfo) _then) = _$IconInfoCopyWithImpl;
@useResult
$Res call({
 int iconCodePoint, String name
});




}
/// @nodoc
class _$IconInfoCopyWithImpl<$Res>
    implements $IconInfoCopyWith<$Res> {
  _$IconInfoCopyWithImpl(this._self, this._then);

  final IconInfo _self;
  final $Res Function(IconInfo) _then;

/// Create a copy of IconInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? iconCodePoint = null,Object? name = null,}) {
  return _then(_self.copyWith(
iconCodePoint: null == iconCodePoint ? _self.iconCodePoint : iconCodePoint // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IconInfo].
extension IconInfoPatterns on IconInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IconInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IconInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IconInfo value)  $default,){
final _that = this;
switch (_that) {
case _IconInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IconInfo value)?  $default,){
final _that = this;
switch (_that) {
case _IconInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int iconCodePoint,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IconInfo() when $default != null:
return $default(_that.iconCodePoint,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int iconCodePoint,  String name)  $default,) {final _that = this;
switch (_that) {
case _IconInfo():
return $default(_that.iconCodePoint,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int iconCodePoint,  String name)?  $default,) {final _that = this;
switch (_that) {
case _IconInfo() when $default != null:
return $default(_that.iconCodePoint,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _IconInfo extends IconInfo {
  const _IconInfo({required this.iconCodePoint, required this.name}): super._();
  

@override final  int iconCodePoint;
@override final  String name;

/// Create a copy of IconInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IconInfoCopyWith<_IconInfo> get copyWith => __$IconInfoCopyWithImpl<_IconInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IconInfo&&(identical(other.iconCodePoint, iconCodePoint) || other.iconCodePoint == iconCodePoint)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,iconCodePoint,name);

@override
String toString() {
  return 'IconInfo(iconCodePoint: $iconCodePoint, name: $name)';
}


}

/// @nodoc
abstract mixin class _$IconInfoCopyWith<$Res> implements $IconInfoCopyWith<$Res> {
  factory _$IconInfoCopyWith(_IconInfo value, $Res Function(_IconInfo) _then) = __$IconInfoCopyWithImpl;
@override @useResult
$Res call({
 int iconCodePoint, String name
});




}
/// @nodoc
class __$IconInfoCopyWithImpl<$Res>
    implements _$IconInfoCopyWith<$Res> {
  __$IconInfoCopyWithImpl(this._self, this._then);

  final _IconInfo _self;
  final $Res Function(_IconInfo) _then;

/// Create a copy of IconInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? iconCodePoint = null,Object? name = null,}) {
  return _then(_IconInfo(
iconCodePoint: null == iconCodePoint ? _self.iconCodePoint : iconCodePoint // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
