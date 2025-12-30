// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_analytics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ErrorAnalyticsState {

 bool get isLoading; bool get isClearingErrors; ErrorAnalytics get analytics; String? get errorMessage;
/// Create a copy of ErrorAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorAnalyticsStateCopyWith<ErrorAnalyticsState> get copyWith => _$ErrorAnalyticsStateCopyWithImpl<ErrorAnalyticsState>(this as ErrorAnalyticsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorAnalyticsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isClearingErrors, isClearingErrors) || other.isClearingErrors == isClearingErrors)&&(identical(other.analytics, analytics) || other.analytics == analytics)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isClearingErrors,analytics,errorMessage);

@override
String toString() {
  return 'ErrorAnalyticsState(isLoading: $isLoading, isClearingErrors: $isClearingErrors, analytics: $analytics, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ErrorAnalyticsStateCopyWith<$Res>  {
  factory $ErrorAnalyticsStateCopyWith(ErrorAnalyticsState value, $Res Function(ErrorAnalyticsState) _then) = _$ErrorAnalyticsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isClearingErrors, ErrorAnalytics analytics, String? errorMessage
});


$ErrorAnalyticsCopyWith<$Res> get analytics;

}
/// @nodoc
class _$ErrorAnalyticsStateCopyWithImpl<$Res>
    implements $ErrorAnalyticsStateCopyWith<$Res> {
  _$ErrorAnalyticsStateCopyWithImpl(this._self, this._then);

  final ErrorAnalyticsState _self;
  final $Res Function(ErrorAnalyticsState) _then;

/// Create a copy of ErrorAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isClearingErrors = null,Object? analytics = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isClearingErrors: null == isClearingErrors ? _self.isClearingErrors : isClearingErrors // ignore: cast_nullable_to_non_nullable
as bool,analytics: null == analytics ? _self.analytics : analytics // ignore: cast_nullable_to_non_nullable
as ErrorAnalytics,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ErrorAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorAnalyticsCopyWith<$Res> get analytics {
  
  return $ErrorAnalyticsCopyWith<$Res>(_self.analytics, (value) {
    return _then(_self.copyWith(analytics: value));
  });
}
}


/// Adds pattern-matching-related methods to [ErrorAnalyticsState].
extension ErrorAnalyticsStatePatterns on ErrorAnalyticsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ErrorAnalyticsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ErrorAnalyticsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ErrorAnalyticsState value)  $default,){
final _that = this;
switch (_that) {
case _ErrorAnalyticsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ErrorAnalyticsState value)?  $default,){
final _that = this;
switch (_that) {
case _ErrorAnalyticsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isClearingErrors,  ErrorAnalytics analytics,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ErrorAnalyticsState() when $default != null:
return $default(_that.isLoading,_that.isClearingErrors,_that.analytics,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isClearingErrors,  ErrorAnalytics analytics,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ErrorAnalyticsState():
return $default(_that.isLoading,_that.isClearingErrors,_that.analytics,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isClearingErrors,  ErrorAnalytics analytics,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ErrorAnalyticsState() when $default != null:
return $default(_that.isLoading,_that.isClearingErrors,_that.analytics,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ErrorAnalyticsState implements ErrorAnalyticsState {
  const _ErrorAnalyticsState({this.isLoading = true, this.isClearingErrors = false, this.analytics = const ErrorAnalytics(), this.errorMessage});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isClearingErrors;
@override@JsonKey() final  ErrorAnalytics analytics;
@override final  String? errorMessage;

/// Create a copy of ErrorAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorAnalyticsStateCopyWith<_ErrorAnalyticsState> get copyWith => __$ErrorAnalyticsStateCopyWithImpl<_ErrorAnalyticsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorAnalyticsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isClearingErrors, isClearingErrors) || other.isClearingErrors == isClearingErrors)&&(identical(other.analytics, analytics) || other.analytics == analytics)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isClearingErrors,analytics,errorMessage);

@override
String toString() {
  return 'ErrorAnalyticsState(isLoading: $isLoading, isClearingErrors: $isClearingErrors, analytics: $analytics, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ErrorAnalyticsStateCopyWith<$Res> implements $ErrorAnalyticsStateCopyWith<$Res> {
  factory _$ErrorAnalyticsStateCopyWith(_ErrorAnalyticsState value, $Res Function(_ErrorAnalyticsState) _then) = __$ErrorAnalyticsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isClearingErrors, ErrorAnalytics analytics, String? errorMessage
});


@override $ErrorAnalyticsCopyWith<$Res> get analytics;

}
/// @nodoc
class __$ErrorAnalyticsStateCopyWithImpl<$Res>
    implements _$ErrorAnalyticsStateCopyWith<$Res> {
  __$ErrorAnalyticsStateCopyWithImpl(this._self, this._then);

  final _ErrorAnalyticsState _self;
  final $Res Function(_ErrorAnalyticsState) _then;

/// Create a copy of ErrorAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isClearingErrors = null,Object? analytics = null,Object? errorMessage = freezed,}) {
  return _then(_ErrorAnalyticsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isClearingErrors: null == isClearingErrors ? _self.isClearingErrors : isClearingErrors // ignore: cast_nullable_to_non_nullable
as bool,analytics: null == analytics ? _self.analytics : analytics // ignore: cast_nullable_to_non_nullable
as ErrorAnalytics,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ErrorAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorAnalyticsCopyWith<$Res> get analytics {
  
  return $ErrorAnalyticsCopyWith<$Res>(_self.analytics, (value) {
    return _then(_self.copyWith(analytics: value));
  });
}
}

// dart format on
