// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blood_levels_timeline_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BloodLevelsTimelineRequest {

 List<String> get drugNames; DateTime get referenceTime; int get hoursBack; int get hoursForward;
/// Create a copy of BloodLevelsTimelineRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BloodLevelsTimelineRequestCopyWith<BloodLevelsTimelineRequest> get copyWith => _$BloodLevelsTimelineRequestCopyWithImpl<BloodLevelsTimelineRequest>(this as BloodLevelsTimelineRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BloodLevelsTimelineRequest&&const DeepCollectionEquality().equals(other.drugNames, drugNames)&&(identical(other.referenceTime, referenceTime) || other.referenceTime == referenceTime)&&(identical(other.hoursBack, hoursBack) || other.hoursBack == hoursBack)&&(identical(other.hoursForward, hoursForward) || other.hoursForward == hoursForward));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(drugNames),referenceTime,hoursBack,hoursForward);

@override
String toString() {
  return 'BloodLevelsTimelineRequest(drugNames: $drugNames, referenceTime: $referenceTime, hoursBack: $hoursBack, hoursForward: $hoursForward)';
}


}

/// @nodoc
abstract mixin class $BloodLevelsTimelineRequestCopyWith<$Res>  {
  factory $BloodLevelsTimelineRequestCopyWith(BloodLevelsTimelineRequest value, $Res Function(BloodLevelsTimelineRequest) _then) = _$BloodLevelsTimelineRequestCopyWithImpl;
@useResult
$Res call({
 List<String> drugNames, DateTime referenceTime, int hoursBack, int hoursForward
});




}
/// @nodoc
class _$BloodLevelsTimelineRequestCopyWithImpl<$Res>
    implements $BloodLevelsTimelineRequestCopyWith<$Res> {
  _$BloodLevelsTimelineRequestCopyWithImpl(this._self, this._then);

  final BloodLevelsTimelineRequest _self;
  final $Res Function(BloodLevelsTimelineRequest) _then;

/// Create a copy of BloodLevelsTimelineRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drugNames = null,Object? referenceTime = null,Object? hoursBack = null,Object? hoursForward = null,}) {
  return _then(_self.copyWith(
drugNames: null == drugNames ? _self.drugNames : drugNames // ignore: cast_nullable_to_non_nullable
as List<String>,referenceTime: null == referenceTime ? _self.referenceTime : referenceTime // ignore: cast_nullable_to_non_nullable
as DateTime,hoursBack: null == hoursBack ? _self.hoursBack : hoursBack // ignore: cast_nullable_to_non_nullable
as int,hoursForward: null == hoursForward ? _self.hoursForward : hoursForward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BloodLevelsTimelineRequest].
extension BloodLevelsTimelineRequestPatterns on BloodLevelsTimelineRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BloodLevelsTimelineRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BloodLevelsTimelineRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BloodLevelsTimelineRequest value)  $default,){
final _that = this;
switch (_that) {
case _BloodLevelsTimelineRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BloodLevelsTimelineRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BloodLevelsTimelineRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> drugNames,  DateTime referenceTime,  int hoursBack,  int hoursForward)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BloodLevelsTimelineRequest() when $default != null:
return $default(_that.drugNames,_that.referenceTime,_that.hoursBack,_that.hoursForward);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> drugNames,  DateTime referenceTime,  int hoursBack,  int hoursForward)  $default,) {final _that = this;
switch (_that) {
case _BloodLevelsTimelineRequest():
return $default(_that.drugNames,_that.referenceTime,_that.hoursBack,_that.hoursForward);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> drugNames,  DateTime referenceTime,  int hoursBack,  int hoursForward)?  $default,) {final _that = this;
switch (_that) {
case _BloodLevelsTimelineRequest() when $default != null:
return $default(_that.drugNames,_that.referenceTime,_that.hoursBack,_that.hoursForward);case _:
  return null;

}
}

}

/// @nodoc


class _BloodLevelsTimelineRequest implements BloodLevelsTimelineRequest {
  const _BloodLevelsTimelineRequest({required final  List<String> drugNames, required this.referenceTime, required this.hoursBack, required this.hoursForward}): _drugNames = drugNames;
  

 final  List<String> _drugNames;
@override List<String> get drugNames {
  if (_drugNames is EqualUnmodifiableListView) return _drugNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drugNames);
}

@override final  DateTime referenceTime;
@override final  int hoursBack;
@override final  int hoursForward;

/// Create a copy of BloodLevelsTimelineRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BloodLevelsTimelineRequestCopyWith<_BloodLevelsTimelineRequest> get copyWith => __$BloodLevelsTimelineRequestCopyWithImpl<_BloodLevelsTimelineRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BloodLevelsTimelineRequest&&const DeepCollectionEquality().equals(other._drugNames, _drugNames)&&(identical(other.referenceTime, referenceTime) || other.referenceTime == referenceTime)&&(identical(other.hoursBack, hoursBack) || other.hoursBack == hoursBack)&&(identical(other.hoursForward, hoursForward) || other.hoursForward == hoursForward));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_drugNames),referenceTime,hoursBack,hoursForward);

@override
String toString() {
  return 'BloodLevelsTimelineRequest(drugNames: $drugNames, referenceTime: $referenceTime, hoursBack: $hoursBack, hoursForward: $hoursForward)';
}


}

/// @nodoc
abstract mixin class _$BloodLevelsTimelineRequestCopyWith<$Res> implements $BloodLevelsTimelineRequestCopyWith<$Res> {
  factory _$BloodLevelsTimelineRequestCopyWith(_BloodLevelsTimelineRequest value, $Res Function(_BloodLevelsTimelineRequest) _then) = __$BloodLevelsTimelineRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String> drugNames, DateTime referenceTime, int hoursBack, int hoursForward
});




}
/// @nodoc
class __$BloodLevelsTimelineRequestCopyWithImpl<$Res>
    implements _$BloodLevelsTimelineRequestCopyWith<$Res> {
  __$BloodLevelsTimelineRequestCopyWithImpl(this._self, this._then);

  final _BloodLevelsTimelineRequest _self;
  final $Res Function(_BloodLevelsTimelineRequest) _then;

/// Create a copy of BloodLevelsTimelineRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drugNames = null,Object? referenceTime = null,Object? hoursBack = null,Object? hoursForward = null,}) {
  return _then(_BloodLevelsTimelineRequest(
drugNames: null == drugNames ? _self._drugNames : drugNames // ignore: cast_nullable_to_non_nullable
as List<String>,referenceTime: null == referenceTime ? _self.referenceTime : referenceTime // ignore: cast_nullable_to_non_nullable
as DateTime,hoursBack: null == hoursBack ? _self.hoursBack : hoursBack // ignore: cast_nullable_to_non_nullable
as int,hoursForward: null == hoursForward ? _self.hoursForward : hoursForward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
