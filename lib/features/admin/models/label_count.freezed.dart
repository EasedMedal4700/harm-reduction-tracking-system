// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LabelCount {

 String get label; int get count;
/// Create a copy of LabelCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabelCountCopyWith<LabelCount> get copyWith => _$LabelCountCopyWithImpl<LabelCount>(this as LabelCount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabelCount&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,label,count);

@override
String toString() {
  return 'LabelCount(label: $label, count: $count)';
}


}

/// @nodoc
abstract mixin class $LabelCountCopyWith<$Res>  {
  factory $LabelCountCopyWith(LabelCount value, $Res Function(LabelCount) _then) = _$LabelCountCopyWithImpl;
@useResult
$Res call({
 String label, int count
});




}
/// @nodoc
class _$LabelCountCopyWithImpl<$Res>
    implements $LabelCountCopyWith<$Res> {
  _$LabelCountCopyWithImpl(this._self, this._then);

  final LabelCount _self;
  final $Res Function(LabelCount) _then;

/// Create a copy of LabelCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? count = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LabelCount].
extension LabelCountPatterns on LabelCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabelCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabelCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabelCount value)  $default,){
final _that = this;
switch (_that) {
case _LabelCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabelCount value)?  $default,){
final _that = this;
switch (_that) {
case _LabelCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabelCount() when $default != null:
return $default(_that.label,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  int count)  $default,) {final _that = this;
switch (_that) {
case _LabelCount():
return $default(_that.label,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  int count)?  $default,) {final _that = this;
switch (_that) {
case _LabelCount() when $default != null:
return $default(_that.label,_that.count);case _:
  return null;

}
}

}

/// @nodoc


class _LabelCount implements LabelCount {
  const _LabelCount({required this.label, this.count = 0});
  

@override final  String label;
@override@JsonKey() final  int count;

/// Create a copy of LabelCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabelCountCopyWith<_LabelCount> get copyWith => __$LabelCountCopyWithImpl<_LabelCount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabelCount&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,label,count);

@override
String toString() {
  return 'LabelCount(label: $label, count: $count)';
}


}

/// @nodoc
abstract mixin class _$LabelCountCopyWith<$Res> implements $LabelCountCopyWith<$Res> {
  factory _$LabelCountCopyWith(_LabelCount value, $Res Function(_LabelCount) _then) = __$LabelCountCopyWithImpl;
@override @useResult
$Res call({
 String label, int count
});




}
/// @nodoc
class __$LabelCountCopyWithImpl<$Res>
    implements _$LabelCountCopyWith<$Res> {
  __$LabelCountCopyWithImpl(this._self, this._then);

  final _LabelCount _self;
  final $Res Function(_LabelCount) _then;

/// Create a copy of LabelCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? count = null,}) {
  return _then(_LabelCount(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
