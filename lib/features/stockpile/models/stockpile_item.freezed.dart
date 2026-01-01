// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stockpile_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockpileItem {

 String get substanceId; double get totalAddedMg; double get currentAmountMg; double? get unitMg; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StockpileItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockpileItemCopyWith<StockpileItem> get copyWith => _$StockpileItemCopyWithImpl<StockpileItem>(this as StockpileItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockpileItem&&(identical(other.substanceId, substanceId) || other.substanceId == substanceId)&&(identical(other.totalAddedMg, totalAddedMg) || other.totalAddedMg == totalAddedMg)&&(identical(other.currentAmountMg, currentAmountMg) || other.currentAmountMg == currentAmountMg)&&(identical(other.unitMg, unitMg) || other.unitMg == unitMg)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,substanceId,totalAddedMg,currentAmountMg,unitMg,createdAt,updatedAt);



}

/// @nodoc
abstract mixin class $StockpileItemCopyWith<$Res>  {
  factory $StockpileItemCopyWith(StockpileItem value, $Res Function(StockpileItem) _then) = _$StockpileItemCopyWithImpl;
@useResult
$Res call({
 String substanceId, double totalAddedMg, double currentAmountMg, double? unitMg, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StockpileItemCopyWithImpl<$Res>
    implements $StockpileItemCopyWith<$Res> {
  _$StockpileItemCopyWithImpl(this._self, this._then);

  final StockpileItem _self;
  final $Res Function(StockpileItem) _then;

/// Create a copy of StockpileItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? substanceId = null,Object? totalAddedMg = null,Object? currentAmountMg = null,Object? unitMg = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
substanceId: null == substanceId ? _self.substanceId : substanceId // ignore: cast_nullable_to_non_nullable
as String,totalAddedMg: null == totalAddedMg ? _self.totalAddedMg : totalAddedMg // ignore: cast_nullable_to_non_nullable
as double,currentAmountMg: null == currentAmountMg ? _self.currentAmountMg : currentAmountMg // ignore: cast_nullable_to_non_nullable
as double,unitMg: freezed == unitMg ? _self.unitMg : unitMg // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StockpileItem].
extension StockpileItemPatterns on StockpileItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockpileItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockpileItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockpileItem value)  $default,){
final _that = this;
switch (_that) {
case _StockpileItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockpileItem value)?  $default,){
final _that = this;
switch (_that) {
case _StockpileItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String substanceId,  double totalAddedMg,  double currentAmountMg,  double? unitMg,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockpileItem() when $default != null:
return $default(_that.substanceId,_that.totalAddedMg,_that.currentAmountMg,_that.unitMg,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String substanceId,  double totalAddedMg,  double currentAmountMg,  double? unitMg,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StockpileItem():
return $default(_that.substanceId,_that.totalAddedMg,_that.currentAmountMg,_that.unitMg,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String substanceId,  double totalAddedMg,  double currentAmountMg,  double? unitMg,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StockpileItem() when $default != null:
return $default(_that.substanceId,_that.totalAddedMg,_that.currentAmountMg,_that.unitMg,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _StockpileItem extends StockpileItem {
  const _StockpileItem({required this.substanceId, required this.totalAddedMg, required this.currentAmountMg, this.unitMg, required this.createdAt, required this.updatedAt}): super._();
  

@override final  String substanceId;
@override final  double totalAddedMg;
@override final  double currentAmountMg;
@override final  double? unitMg;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StockpileItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockpileItemCopyWith<_StockpileItem> get copyWith => __$StockpileItemCopyWithImpl<_StockpileItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockpileItem&&(identical(other.substanceId, substanceId) || other.substanceId == substanceId)&&(identical(other.totalAddedMg, totalAddedMg) || other.totalAddedMg == totalAddedMg)&&(identical(other.currentAmountMg, currentAmountMg) || other.currentAmountMg == currentAmountMg)&&(identical(other.unitMg, unitMg) || other.unitMg == unitMg)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,substanceId,totalAddedMg,currentAmountMg,unitMg,createdAt,updatedAt);



}

/// @nodoc
abstract mixin class _$StockpileItemCopyWith<$Res> implements $StockpileItemCopyWith<$Res> {
  factory _$StockpileItemCopyWith(_StockpileItem value, $Res Function(_StockpileItem) _then) = __$StockpileItemCopyWithImpl;
@override @useResult
$Res call({
 String substanceId, double totalAddedMg, double currentAmountMg, double? unitMg, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StockpileItemCopyWithImpl<$Res>
    implements _$StockpileItemCopyWith<$Res> {
  __$StockpileItemCopyWithImpl(this._self, this._then);

  final _StockpileItem _self;
  final $Res Function(_StockpileItem) _then;

/// Create a copy of StockpileItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? substanceId = null,Object? totalAddedMg = null,Object? currentAmountMg = null,Object? unitMg = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StockpileItem(
substanceId: null == substanceId ? _self.substanceId : substanceId // ignore: cast_nullable_to_non_nullable
as String,totalAddedMg: null == totalAddedMg ? _self.totalAddedMg : totalAddedMg // ignore: cast_nullable_to_non_nullable
as double,currentAmountMg: null == currentAmountMg ? _self.currentAmountMg : currentAmountMg // ignore: cast_nullable_to_non_nullable
as double,unitMg: freezed == unitMg ? _self.unitMg : unitMg // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
