// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tolerance_bucket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ToleranceBucket {

 String get type; double get weight; String get toleranceType; double get potencyMultiplier; double get durationMultiplier;
/// Create a copy of ToleranceBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToleranceBucketCopyWith<ToleranceBucket> get copyWith => _$ToleranceBucketCopyWithImpl<ToleranceBucket>(this as ToleranceBucket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToleranceBucket&&(identical(other.type, type) || other.type == type)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.toleranceType, toleranceType) || other.toleranceType == toleranceType)&&(identical(other.potencyMultiplier, potencyMultiplier) || other.potencyMultiplier == potencyMultiplier)&&(identical(other.durationMultiplier, durationMultiplier) || other.durationMultiplier == durationMultiplier));
}


@override
int get hashCode => Object.hash(runtimeType,type,weight,toleranceType,potencyMultiplier,durationMultiplier);

@override
String toString() {
  return 'ToleranceBucket(type: $type, weight: $weight, toleranceType: $toleranceType, potencyMultiplier: $potencyMultiplier, durationMultiplier: $durationMultiplier)';
}


}

/// @nodoc
abstract mixin class $ToleranceBucketCopyWith<$Res>  {
  factory $ToleranceBucketCopyWith(ToleranceBucket value, $Res Function(ToleranceBucket) _then) = _$ToleranceBucketCopyWithImpl;
@useResult
$Res call({
 String type, double weight, String toleranceType, double potencyMultiplier, double durationMultiplier
});




}
/// @nodoc
class _$ToleranceBucketCopyWithImpl<$Res>
    implements $ToleranceBucketCopyWith<$Res> {
  _$ToleranceBucketCopyWithImpl(this._self, this._then);

  final ToleranceBucket _self;
  final $Res Function(ToleranceBucket) _then;

/// Create a copy of ToleranceBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? weight = null,Object? toleranceType = null,Object? potencyMultiplier = null,Object? durationMultiplier = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,toleranceType: null == toleranceType ? _self.toleranceType : toleranceType // ignore: cast_nullable_to_non_nullable
as String,potencyMultiplier: null == potencyMultiplier ? _self.potencyMultiplier : potencyMultiplier // ignore: cast_nullable_to_non_nullable
as double,durationMultiplier: null == durationMultiplier ? _self.durationMultiplier : durationMultiplier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ToleranceBucket].
extension ToleranceBucketPatterns on ToleranceBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ToleranceBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ToleranceBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ToleranceBucket value)  $default,){
final _that = this;
switch (_that) {
case _ToleranceBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ToleranceBucket value)?  $default,){
final _that = this;
switch (_that) {
case _ToleranceBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  double weight,  String toleranceType,  double potencyMultiplier,  double durationMultiplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ToleranceBucket() when $default != null:
return $default(_that.type,_that.weight,_that.toleranceType,_that.potencyMultiplier,_that.durationMultiplier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  double weight,  String toleranceType,  double potencyMultiplier,  double durationMultiplier)  $default,) {final _that = this;
switch (_that) {
case _ToleranceBucket():
return $default(_that.type,_that.weight,_that.toleranceType,_that.potencyMultiplier,_that.durationMultiplier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  double weight,  String toleranceType,  double potencyMultiplier,  double durationMultiplier)?  $default,) {final _that = this;
switch (_that) {
case _ToleranceBucket() when $default != null:
return $default(_that.type,_that.weight,_that.toleranceType,_that.potencyMultiplier,_that.durationMultiplier);case _:
  return null;

}
}

}

/// @nodoc


class _ToleranceBucket extends ToleranceBucket {
  const _ToleranceBucket({required this.type, this.weight = 1.0, this.toleranceType = 'stimulant', this.potencyMultiplier = 1.0, this.durationMultiplier = 1.0}): super._();
  

@override final  String type;
@override@JsonKey() final  double weight;
@override@JsonKey() final  String toleranceType;
@override@JsonKey() final  double potencyMultiplier;
@override@JsonKey() final  double durationMultiplier;

/// Create a copy of ToleranceBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToleranceBucketCopyWith<_ToleranceBucket> get copyWith => __$ToleranceBucketCopyWithImpl<_ToleranceBucket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToleranceBucket&&(identical(other.type, type) || other.type == type)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.toleranceType, toleranceType) || other.toleranceType == toleranceType)&&(identical(other.potencyMultiplier, potencyMultiplier) || other.potencyMultiplier == potencyMultiplier)&&(identical(other.durationMultiplier, durationMultiplier) || other.durationMultiplier == durationMultiplier));
}


@override
int get hashCode => Object.hash(runtimeType,type,weight,toleranceType,potencyMultiplier,durationMultiplier);

@override
String toString() {
  return 'ToleranceBucket(type: $type, weight: $weight, toleranceType: $toleranceType, potencyMultiplier: $potencyMultiplier, durationMultiplier: $durationMultiplier)';
}


}

/// @nodoc
abstract mixin class _$ToleranceBucketCopyWith<$Res> implements $ToleranceBucketCopyWith<$Res> {
  factory _$ToleranceBucketCopyWith(_ToleranceBucket value, $Res Function(_ToleranceBucket) _then) = __$ToleranceBucketCopyWithImpl;
@override @useResult
$Res call({
 String type, double weight, String toleranceType, double potencyMultiplier, double durationMultiplier
});




}
/// @nodoc
class __$ToleranceBucketCopyWithImpl<$Res>
    implements _$ToleranceBucketCopyWith<$Res> {
  __$ToleranceBucketCopyWithImpl(this._self, this._then);

  final _ToleranceBucket _self;
  final $Res Function(_ToleranceBucket) _then;

/// Create a copy of ToleranceBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? weight = null,Object? toleranceType = null,Object? potencyMultiplier = null,Object? durationMultiplier = null,}) {
  return _then(_ToleranceBucket(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,toleranceType: null == toleranceType ? _self.toleranceType : toleranceType // ignore: cast_nullable_to_non_nullable
as String,potencyMultiplier: null == potencyMultiplier ? _self.potencyMultiplier : potencyMultiplier // ignore: cast_nullable_to_non_nullable
as double,durationMultiplier: null == durationMultiplier ? _self.durationMultiplier : durationMultiplier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$BucketToleranceModel {

 String get substanceName; double get halfLifeHours; double get activeThreshold; double get toleranceGainRate; double get toleranceDecayDays; Map<String, ToleranceBucket> get neuroBuckets; String? get notes;
/// Create a copy of BucketToleranceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BucketToleranceModelCopyWith<BucketToleranceModel> get copyWith => _$BucketToleranceModelCopyWithImpl<BucketToleranceModel>(this as BucketToleranceModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BucketToleranceModel&&(identical(other.substanceName, substanceName) || other.substanceName == substanceName)&&(identical(other.halfLifeHours, halfLifeHours) || other.halfLifeHours == halfLifeHours)&&(identical(other.activeThreshold, activeThreshold) || other.activeThreshold == activeThreshold)&&(identical(other.toleranceGainRate, toleranceGainRate) || other.toleranceGainRate == toleranceGainRate)&&(identical(other.toleranceDecayDays, toleranceDecayDays) || other.toleranceDecayDays == toleranceDecayDays)&&const DeepCollectionEquality().equals(other.neuroBuckets, neuroBuckets)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,substanceName,halfLifeHours,activeThreshold,toleranceGainRate,toleranceDecayDays,const DeepCollectionEquality().hash(neuroBuckets),notes);

@override
String toString() {
  return 'BucketToleranceModel(substanceName: $substanceName, halfLifeHours: $halfLifeHours, activeThreshold: $activeThreshold, toleranceGainRate: $toleranceGainRate, toleranceDecayDays: $toleranceDecayDays, neuroBuckets: $neuroBuckets, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $BucketToleranceModelCopyWith<$Res>  {
  factory $BucketToleranceModelCopyWith(BucketToleranceModel value, $Res Function(BucketToleranceModel) _then) = _$BucketToleranceModelCopyWithImpl;
@useResult
$Res call({
 String substanceName, double halfLifeHours, double activeThreshold, double toleranceGainRate, double toleranceDecayDays, Map<String, ToleranceBucket> neuroBuckets, String? notes
});




}
/// @nodoc
class _$BucketToleranceModelCopyWithImpl<$Res>
    implements $BucketToleranceModelCopyWith<$Res> {
  _$BucketToleranceModelCopyWithImpl(this._self, this._then);

  final BucketToleranceModel _self;
  final $Res Function(BucketToleranceModel) _then;

/// Create a copy of BucketToleranceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? substanceName = null,Object? halfLifeHours = null,Object? activeThreshold = null,Object? toleranceGainRate = null,Object? toleranceDecayDays = null,Object? neuroBuckets = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
substanceName: null == substanceName ? _self.substanceName : substanceName // ignore: cast_nullable_to_non_nullable
as String,halfLifeHours: null == halfLifeHours ? _self.halfLifeHours : halfLifeHours // ignore: cast_nullable_to_non_nullable
as double,activeThreshold: null == activeThreshold ? _self.activeThreshold : activeThreshold // ignore: cast_nullable_to_non_nullable
as double,toleranceGainRate: null == toleranceGainRate ? _self.toleranceGainRate : toleranceGainRate // ignore: cast_nullable_to_non_nullable
as double,toleranceDecayDays: null == toleranceDecayDays ? _self.toleranceDecayDays : toleranceDecayDays // ignore: cast_nullable_to_non_nullable
as double,neuroBuckets: null == neuroBuckets ? _self.neuroBuckets : neuroBuckets // ignore: cast_nullable_to_non_nullable
as Map<String, ToleranceBucket>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BucketToleranceModel].
extension BucketToleranceModelPatterns on BucketToleranceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BucketToleranceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BucketToleranceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BucketToleranceModel value)  $default,){
final _that = this;
switch (_that) {
case _BucketToleranceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BucketToleranceModel value)?  $default,){
final _that = this;
switch (_that) {
case _BucketToleranceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String substanceName,  double halfLifeHours,  double activeThreshold,  double toleranceGainRate,  double toleranceDecayDays,  Map<String, ToleranceBucket> neuroBuckets,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BucketToleranceModel() when $default != null:
return $default(_that.substanceName,_that.halfLifeHours,_that.activeThreshold,_that.toleranceGainRate,_that.toleranceDecayDays,_that.neuroBuckets,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String substanceName,  double halfLifeHours,  double activeThreshold,  double toleranceGainRate,  double toleranceDecayDays,  Map<String, ToleranceBucket> neuroBuckets,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _BucketToleranceModel():
return $default(_that.substanceName,_that.halfLifeHours,_that.activeThreshold,_that.toleranceGainRate,_that.toleranceDecayDays,_that.neuroBuckets,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String substanceName,  double halfLifeHours,  double activeThreshold,  double toleranceGainRate,  double toleranceDecayDays,  Map<String, ToleranceBucket> neuroBuckets,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _BucketToleranceModel() when $default != null:
return $default(_that.substanceName,_that.halfLifeHours,_that.activeThreshold,_that.toleranceGainRate,_that.toleranceDecayDays,_that.neuroBuckets,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _BucketToleranceModel extends BucketToleranceModel {
  const _BucketToleranceModel({required this.substanceName, this.halfLifeHours = 24.0, this.activeThreshold = 0.05, this.toleranceGainRate = 1.0, this.toleranceDecayDays = 7.0, final  Map<String, ToleranceBucket> neuroBuckets = const {}, this.notes}): _neuroBuckets = neuroBuckets,super._();
  

@override final  String substanceName;
@override@JsonKey() final  double halfLifeHours;
@override@JsonKey() final  double activeThreshold;
@override@JsonKey() final  double toleranceGainRate;
@override@JsonKey() final  double toleranceDecayDays;
 final  Map<String, ToleranceBucket> _neuroBuckets;
@override@JsonKey() Map<String, ToleranceBucket> get neuroBuckets {
  if (_neuroBuckets is EqualUnmodifiableMapView) return _neuroBuckets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_neuroBuckets);
}

@override final  String? notes;

/// Create a copy of BucketToleranceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BucketToleranceModelCopyWith<_BucketToleranceModel> get copyWith => __$BucketToleranceModelCopyWithImpl<_BucketToleranceModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BucketToleranceModel&&(identical(other.substanceName, substanceName) || other.substanceName == substanceName)&&(identical(other.halfLifeHours, halfLifeHours) || other.halfLifeHours == halfLifeHours)&&(identical(other.activeThreshold, activeThreshold) || other.activeThreshold == activeThreshold)&&(identical(other.toleranceGainRate, toleranceGainRate) || other.toleranceGainRate == toleranceGainRate)&&(identical(other.toleranceDecayDays, toleranceDecayDays) || other.toleranceDecayDays == toleranceDecayDays)&&const DeepCollectionEquality().equals(other._neuroBuckets, _neuroBuckets)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,substanceName,halfLifeHours,activeThreshold,toleranceGainRate,toleranceDecayDays,const DeepCollectionEquality().hash(_neuroBuckets),notes);

@override
String toString() {
  return 'BucketToleranceModel(substanceName: $substanceName, halfLifeHours: $halfLifeHours, activeThreshold: $activeThreshold, toleranceGainRate: $toleranceGainRate, toleranceDecayDays: $toleranceDecayDays, neuroBuckets: $neuroBuckets, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$BucketToleranceModelCopyWith<$Res> implements $BucketToleranceModelCopyWith<$Res> {
  factory _$BucketToleranceModelCopyWith(_BucketToleranceModel value, $Res Function(_BucketToleranceModel) _then) = __$BucketToleranceModelCopyWithImpl;
@override @useResult
$Res call({
 String substanceName, double halfLifeHours, double activeThreshold, double toleranceGainRate, double toleranceDecayDays, Map<String, ToleranceBucket> neuroBuckets, String? notes
});




}
/// @nodoc
class __$BucketToleranceModelCopyWithImpl<$Res>
    implements _$BucketToleranceModelCopyWith<$Res> {
  __$BucketToleranceModelCopyWithImpl(this._self, this._then);

  final _BucketToleranceModel _self;
  final $Res Function(_BucketToleranceModel) _then;

/// Create a copy of BucketToleranceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? substanceName = null,Object? halfLifeHours = null,Object? activeThreshold = null,Object? toleranceGainRate = null,Object? toleranceDecayDays = null,Object? neuroBuckets = null,Object? notes = freezed,}) {
  return _then(_BucketToleranceModel(
substanceName: null == substanceName ? _self.substanceName : substanceName // ignore: cast_nullable_to_non_nullable
as String,halfLifeHours: null == halfLifeHours ? _self.halfLifeHours : halfLifeHours // ignore: cast_nullable_to_non_nullable
as double,activeThreshold: null == activeThreshold ? _self.activeThreshold : activeThreshold // ignore: cast_nullable_to_non_nullable
as double,toleranceGainRate: null == toleranceGainRate ? _self.toleranceGainRate : toleranceGainRate // ignore: cast_nullable_to_non_nullable
as double,toleranceDecayDays: null == toleranceDecayDays ? _self.toleranceDecayDays : toleranceDecayDays // ignore: cast_nullable_to_non_nullable
as double,neuroBuckets: null == neuroBuckets ? _self._neuroBuckets : neuroBuckets // ignore: cast_nullable_to_non_nullable
as Map<String, ToleranceBucket>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
