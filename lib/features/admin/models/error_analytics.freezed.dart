// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ErrorAnalytics {

 int get totalErrors; int get last24h; List<LabelCount> get platformBreakdown; List<LabelCount> get screenBreakdown; List<LabelCount> get messageBreakdown; List<LabelCount> get severityBreakdown; List<LabelCount> get errorCodeBreakdown; List<ErrorLogEntry> get recentLogs;
/// Create a copy of ErrorAnalytics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorAnalyticsCopyWith<ErrorAnalytics> get copyWith => _$ErrorAnalyticsCopyWithImpl<ErrorAnalytics>(this as ErrorAnalytics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorAnalytics&&(identical(other.totalErrors, totalErrors) || other.totalErrors == totalErrors)&&(identical(other.last24h, last24h) || other.last24h == last24h)&&const DeepCollectionEquality().equals(other.platformBreakdown, platformBreakdown)&&const DeepCollectionEquality().equals(other.screenBreakdown, screenBreakdown)&&const DeepCollectionEquality().equals(other.messageBreakdown, messageBreakdown)&&const DeepCollectionEquality().equals(other.severityBreakdown, severityBreakdown)&&const DeepCollectionEquality().equals(other.errorCodeBreakdown, errorCodeBreakdown)&&const DeepCollectionEquality().equals(other.recentLogs, recentLogs));
}


@override
int get hashCode => Object.hash(runtimeType,totalErrors,last24h,const DeepCollectionEquality().hash(platformBreakdown),const DeepCollectionEquality().hash(screenBreakdown),const DeepCollectionEquality().hash(messageBreakdown),const DeepCollectionEquality().hash(severityBreakdown),const DeepCollectionEquality().hash(errorCodeBreakdown),const DeepCollectionEquality().hash(recentLogs));

@override
String toString() {
  return 'ErrorAnalytics(totalErrors: $totalErrors, last24h: $last24h, platformBreakdown: $platformBreakdown, screenBreakdown: $screenBreakdown, messageBreakdown: $messageBreakdown, severityBreakdown: $severityBreakdown, errorCodeBreakdown: $errorCodeBreakdown, recentLogs: $recentLogs)';
}


}

/// @nodoc
abstract mixin class $ErrorAnalyticsCopyWith<$Res>  {
  factory $ErrorAnalyticsCopyWith(ErrorAnalytics value, $Res Function(ErrorAnalytics) _then) = _$ErrorAnalyticsCopyWithImpl;
@useResult
$Res call({
 int totalErrors, int last24h, List<LabelCount> platformBreakdown, List<LabelCount> screenBreakdown, List<LabelCount> messageBreakdown, List<LabelCount> severityBreakdown, List<LabelCount> errorCodeBreakdown, List<ErrorLogEntry> recentLogs
});




}
/// @nodoc
class _$ErrorAnalyticsCopyWithImpl<$Res>
    implements $ErrorAnalyticsCopyWith<$Res> {
  _$ErrorAnalyticsCopyWithImpl(this._self, this._then);

  final ErrorAnalytics _self;
  final $Res Function(ErrorAnalytics) _then;

/// Create a copy of ErrorAnalytics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalErrors = null,Object? last24h = null,Object? platformBreakdown = null,Object? screenBreakdown = null,Object? messageBreakdown = null,Object? severityBreakdown = null,Object? errorCodeBreakdown = null,Object? recentLogs = null,}) {
  return _then(_self.copyWith(
totalErrors: null == totalErrors ? _self.totalErrors : totalErrors // ignore: cast_nullable_to_non_nullable
as int,last24h: null == last24h ? _self.last24h : last24h // ignore: cast_nullable_to_non_nullable
as int,platformBreakdown: null == platformBreakdown ? _self.platformBreakdown : platformBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,screenBreakdown: null == screenBreakdown ? _self.screenBreakdown : screenBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,messageBreakdown: null == messageBreakdown ? _self.messageBreakdown : messageBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,severityBreakdown: null == severityBreakdown ? _self.severityBreakdown : severityBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,errorCodeBreakdown: null == errorCodeBreakdown ? _self.errorCodeBreakdown : errorCodeBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,recentLogs: null == recentLogs ? _self.recentLogs : recentLogs // ignore: cast_nullable_to_non_nullable
as List<ErrorLogEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [ErrorAnalytics].
extension ErrorAnalyticsPatterns on ErrorAnalytics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ErrorAnalytics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ErrorAnalytics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ErrorAnalytics value)  $default,){
final _that = this;
switch (_that) {
case _ErrorAnalytics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ErrorAnalytics value)?  $default,){
final _that = this;
switch (_that) {
case _ErrorAnalytics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalErrors,  int last24h,  List<LabelCount> platformBreakdown,  List<LabelCount> screenBreakdown,  List<LabelCount> messageBreakdown,  List<LabelCount> severityBreakdown,  List<LabelCount> errorCodeBreakdown,  List<ErrorLogEntry> recentLogs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ErrorAnalytics() when $default != null:
return $default(_that.totalErrors,_that.last24h,_that.platformBreakdown,_that.screenBreakdown,_that.messageBreakdown,_that.severityBreakdown,_that.errorCodeBreakdown,_that.recentLogs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalErrors,  int last24h,  List<LabelCount> platformBreakdown,  List<LabelCount> screenBreakdown,  List<LabelCount> messageBreakdown,  List<LabelCount> severityBreakdown,  List<LabelCount> errorCodeBreakdown,  List<ErrorLogEntry> recentLogs)  $default,) {final _that = this;
switch (_that) {
case _ErrorAnalytics():
return $default(_that.totalErrors,_that.last24h,_that.platformBreakdown,_that.screenBreakdown,_that.messageBreakdown,_that.severityBreakdown,_that.errorCodeBreakdown,_that.recentLogs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalErrors,  int last24h,  List<LabelCount> platformBreakdown,  List<LabelCount> screenBreakdown,  List<LabelCount> messageBreakdown,  List<LabelCount> severityBreakdown,  List<LabelCount> errorCodeBreakdown,  List<ErrorLogEntry> recentLogs)?  $default,) {final _that = this;
switch (_that) {
case _ErrorAnalytics() when $default != null:
return $default(_that.totalErrors,_that.last24h,_that.platformBreakdown,_that.screenBreakdown,_that.messageBreakdown,_that.severityBreakdown,_that.errorCodeBreakdown,_that.recentLogs);case _:
  return null;

}
}

}

/// @nodoc


class _ErrorAnalytics implements ErrorAnalytics {
  const _ErrorAnalytics({this.totalErrors = 0, this.last24h = 0, final  List<LabelCount> platformBreakdown = const <LabelCount>[], final  List<LabelCount> screenBreakdown = const <LabelCount>[], final  List<LabelCount> messageBreakdown = const <LabelCount>[], final  List<LabelCount> severityBreakdown = const <LabelCount>[], final  List<LabelCount> errorCodeBreakdown = const <LabelCount>[], final  List<ErrorLogEntry> recentLogs = const <ErrorLogEntry>[]}): _platformBreakdown = platformBreakdown,_screenBreakdown = screenBreakdown,_messageBreakdown = messageBreakdown,_severityBreakdown = severityBreakdown,_errorCodeBreakdown = errorCodeBreakdown,_recentLogs = recentLogs;
  

@override@JsonKey() final  int totalErrors;
@override@JsonKey() final  int last24h;
 final  List<LabelCount> _platformBreakdown;
@override@JsonKey() List<LabelCount> get platformBreakdown {
  if (_platformBreakdown is EqualUnmodifiableListView) return _platformBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_platformBreakdown);
}

 final  List<LabelCount> _screenBreakdown;
@override@JsonKey() List<LabelCount> get screenBreakdown {
  if (_screenBreakdown is EqualUnmodifiableListView) return _screenBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screenBreakdown);
}

 final  List<LabelCount> _messageBreakdown;
@override@JsonKey() List<LabelCount> get messageBreakdown {
  if (_messageBreakdown is EqualUnmodifiableListView) return _messageBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBreakdown);
}

 final  List<LabelCount> _severityBreakdown;
@override@JsonKey() List<LabelCount> get severityBreakdown {
  if (_severityBreakdown is EqualUnmodifiableListView) return _severityBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_severityBreakdown);
}

 final  List<LabelCount> _errorCodeBreakdown;
@override@JsonKey() List<LabelCount> get errorCodeBreakdown {
  if (_errorCodeBreakdown is EqualUnmodifiableListView) return _errorCodeBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errorCodeBreakdown);
}

 final  List<ErrorLogEntry> _recentLogs;
@override@JsonKey() List<ErrorLogEntry> get recentLogs {
  if (_recentLogs is EqualUnmodifiableListView) return _recentLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentLogs);
}


/// Create a copy of ErrorAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorAnalyticsCopyWith<_ErrorAnalytics> get copyWith => __$ErrorAnalyticsCopyWithImpl<_ErrorAnalytics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorAnalytics&&(identical(other.totalErrors, totalErrors) || other.totalErrors == totalErrors)&&(identical(other.last24h, last24h) || other.last24h == last24h)&&const DeepCollectionEquality().equals(other._platformBreakdown, _platformBreakdown)&&const DeepCollectionEquality().equals(other._screenBreakdown, _screenBreakdown)&&const DeepCollectionEquality().equals(other._messageBreakdown, _messageBreakdown)&&const DeepCollectionEquality().equals(other._severityBreakdown, _severityBreakdown)&&const DeepCollectionEquality().equals(other._errorCodeBreakdown, _errorCodeBreakdown)&&const DeepCollectionEquality().equals(other._recentLogs, _recentLogs));
}


@override
int get hashCode => Object.hash(runtimeType,totalErrors,last24h,const DeepCollectionEquality().hash(_platformBreakdown),const DeepCollectionEquality().hash(_screenBreakdown),const DeepCollectionEquality().hash(_messageBreakdown),const DeepCollectionEquality().hash(_severityBreakdown),const DeepCollectionEquality().hash(_errorCodeBreakdown),const DeepCollectionEquality().hash(_recentLogs));

@override
String toString() {
  return 'ErrorAnalytics(totalErrors: $totalErrors, last24h: $last24h, platformBreakdown: $platformBreakdown, screenBreakdown: $screenBreakdown, messageBreakdown: $messageBreakdown, severityBreakdown: $severityBreakdown, errorCodeBreakdown: $errorCodeBreakdown, recentLogs: $recentLogs)';
}


}

/// @nodoc
abstract mixin class _$ErrorAnalyticsCopyWith<$Res> implements $ErrorAnalyticsCopyWith<$Res> {
  factory _$ErrorAnalyticsCopyWith(_ErrorAnalytics value, $Res Function(_ErrorAnalytics) _then) = __$ErrorAnalyticsCopyWithImpl;
@override @useResult
$Res call({
 int totalErrors, int last24h, List<LabelCount> platformBreakdown, List<LabelCount> screenBreakdown, List<LabelCount> messageBreakdown, List<LabelCount> severityBreakdown, List<LabelCount> errorCodeBreakdown, List<ErrorLogEntry> recentLogs
});




}
/// @nodoc
class __$ErrorAnalyticsCopyWithImpl<$Res>
    implements _$ErrorAnalyticsCopyWith<$Res> {
  __$ErrorAnalyticsCopyWithImpl(this._self, this._then);

  final _ErrorAnalytics _self;
  final $Res Function(_ErrorAnalytics) _then;

/// Create a copy of ErrorAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalErrors = null,Object? last24h = null,Object? platformBreakdown = null,Object? screenBreakdown = null,Object? messageBreakdown = null,Object? severityBreakdown = null,Object? errorCodeBreakdown = null,Object? recentLogs = null,}) {
  return _then(_ErrorAnalytics(
totalErrors: null == totalErrors ? _self.totalErrors : totalErrors // ignore: cast_nullable_to_non_nullable
as int,last24h: null == last24h ? _self.last24h : last24h // ignore: cast_nullable_to_non_nullable
as int,platformBreakdown: null == platformBreakdown ? _self._platformBreakdown : platformBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,screenBreakdown: null == screenBreakdown ? _self._screenBreakdown : screenBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,messageBreakdown: null == messageBreakdown ? _self._messageBreakdown : messageBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,severityBreakdown: null == severityBreakdown ? _self._severityBreakdown : severityBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,errorCodeBreakdown: null == errorCodeBreakdown ? _self._errorCodeBreakdown : errorCodeBreakdown // ignore: cast_nullable_to_non_nullable
as List<LabelCount>,recentLogs: null == recentLogs ? _self._recentLogs : recentLogs // ignore: cast_nullable_to_non_nullable
as List<ErrorLogEntry>,
  ));
}


}

// dart format on
