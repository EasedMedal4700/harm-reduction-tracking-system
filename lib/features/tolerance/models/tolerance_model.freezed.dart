// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tolerance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UseLogEntry {

 String get substanceSlug; DateTime get timestamp; double get doseUnits;
/// Create a copy of UseLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UseLogEntryCopyWith<UseLogEntry> get copyWith => _$UseLogEntryCopyWithImpl<UseLogEntry>(this as UseLogEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UseLogEntry&&(identical(other.substanceSlug, substanceSlug) || other.substanceSlug == substanceSlug)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.doseUnits, doseUnits) || other.doseUnits == doseUnits));
}


@override
int get hashCode => Object.hash(runtimeType,substanceSlug,timestamp,doseUnits);

@override
String toString() {
  return 'UseLogEntry(substanceSlug: $substanceSlug, timestamp: $timestamp, doseUnits: $doseUnits)';
}


}

/// @nodoc
abstract mixin class $UseLogEntryCopyWith<$Res>  {
  factory $UseLogEntryCopyWith(UseLogEntry value, $Res Function(UseLogEntry) _then) = _$UseLogEntryCopyWithImpl;
@useResult
$Res call({
 String substanceSlug, DateTime timestamp, double doseUnits
});




}
/// @nodoc
class _$UseLogEntryCopyWithImpl<$Res>
    implements $UseLogEntryCopyWith<$Res> {
  _$UseLogEntryCopyWithImpl(this._self, this._then);

  final UseLogEntry _self;
  final $Res Function(UseLogEntry) _then;

/// Create a copy of UseLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? substanceSlug = null,Object? timestamp = null,Object? doseUnits = null,}) {
  return _then(_self.copyWith(
substanceSlug: null == substanceSlug ? _self.substanceSlug : substanceSlug // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,doseUnits: null == doseUnits ? _self.doseUnits : doseUnits // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [UseLogEntry].
extension UseLogEntryPatterns on UseLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UseLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UseLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UseLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _UseLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UseLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _UseLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String substanceSlug,  DateTime timestamp,  double doseUnits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UseLogEntry() when $default != null:
return $default(_that.substanceSlug,_that.timestamp,_that.doseUnits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String substanceSlug,  DateTime timestamp,  double doseUnits)  $default,) {final _that = this;
switch (_that) {
case _UseLogEntry():
return $default(_that.substanceSlug,_that.timestamp,_that.doseUnits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String substanceSlug,  DateTime timestamp,  double doseUnits)?  $default,) {final _that = this;
switch (_that) {
case _UseLogEntry() when $default != null:
return $default(_that.substanceSlug,_that.timestamp,_that.doseUnits);case _:
  return null;

}
}

}

/// @nodoc


class _UseLogEntry extends UseLogEntry {
  const _UseLogEntry({required this.substanceSlug, required this.timestamp, required this.doseUnits}): super._();
  

@override final  String substanceSlug;
@override final  DateTime timestamp;
@override final  double doseUnits;

/// Create a copy of UseLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UseLogEntryCopyWith<_UseLogEntry> get copyWith => __$UseLogEntryCopyWithImpl<_UseLogEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UseLogEntry&&(identical(other.substanceSlug, substanceSlug) || other.substanceSlug == substanceSlug)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.doseUnits, doseUnits) || other.doseUnits == doseUnits));
}


@override
int get hashCode => Object.hash(runtimeType,substanceSlug,timestamp,doseUnits);

@override
String toString() {
  return 'UseLogEntry(substanceSlug: $substanceSlug, timestamp: $timestamp, doseUnits: $doseUnits)';
}


}

/// @nodoc
abstract mixin class _$UseLogEntryCopyWith<$Res> implements $UseLogEntryCopyWith<$Res> {
  factory _$UseLogEntryCopyWith(_UseLogEntry value, $Res Function(_UseLogEntry) _then) = __$UseLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String substanceSlug, DateTime timestamp, double doseUnits
});




}
/// @nodoc
class __$UseLogEntryCopyWithImpl<$Res>
    implements _$UseLogEntryCopyWith<$Res> {
  __$UseLogEntryCopyWithImpl(this._self, this._then);

  final _UseLogEntry _self;
  final $Res Function(_UseLogEntry) _then;

/// Create a copy of UseLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? substanceSlug = null,Object? timestamp = null,Object? doseUnits = null,}) {
  return _then(_UseLogEntry(
substanceSlug: null == substanceSlug ? _self.substanceSlug : substanceSlug // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,doseUnits: null == doseUnits ? _self.doseUnits : doseUnits // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ToleranceModel {

 String get notes;/// Neurotransmitter → bucket data (weight + type)
 Map<String, NeuroBucket> get neuroBuckets;/// Pharmacokinetic parameters
 double get halfLifeHours; double get toleranceDecayDays;/// Potency normalization
 double get standardUnitMg; double get potencyMultiplier; double get durationMultiplier;/// Tolerance dynamics
 double get toleranceGainRate; double get activeThreshold;
/// Create a copy of ToleranceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToleranceModelCopyWith<ToleranceModel> get copyWith => _$ToleranceModelCopyWithImpl<ToleranceModel>(this as ToleranceModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToleranceModel&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.neuroBuckets, neuroBuckets)&&(identical(other.halfLifeHours, halfLifeHours) || other.halfLifeHours == halfLifeHours)&&(identical(other.toleranceDecayDays, toleranceDecayDays) || other.toleranceDecayDays == toleranceDecayDays)&&(identical(other.standardUnitMg, standardUnitMg) || other.standardUnitMg == standardUnitMg)&&(identical(other.potencyMultiplier, potencyMultiplier) || other.potencyMultiplier == potencyMultiplier)&&(identical(other.durationMultiplier, durationMultiplier) || other.durationMultiplier == durationMultiplier)&&(identical(other.toleranceGainRate, toleranceGainRate) || other.toleranceGainRate == toleranceGainRate)&&(identical(other.activeThreshold, activeThreshold) || other.activeThreshold == activeThreshold));
}


@override
int get hashCode => Object.hash(runtimeType,notes,const DeepCollectionEquality().hash(neuroBuckets),halfLifeHours,toleranceDecayDays,standardUnitMg,potencyMultiplier,durationMultiplier,toleranceGainRate,activeThreshold);

@override
String toString() {
  return 'ToleranceModel(notes: $notes, neuroBuckets: $neuroBuckets, halfLifeHours: $halfLifeHours, toleranceDecayDays: $toleranceDecayDays, standardUnitMg: $standardUnitMg, potencyMultiplier: $potencyMultiplier, durationMultiplier: $durationMultiplier, toleranceGainRate: $toleranceGainRate, activeThreshold: $activeThreshold)';
}


}

/// @nodoc
abstract mixin class $ToleranceModelCopyWith<$Res>  {
  factory $ToleranceModelCopyWith(ToleranceModel value, $Res Function(ToleranceModel) _then) = _$ToleranceModelCopyWithImpl;
@useResult
$Res call({
 String notes, Map<String, NeuroBucket> neuroBuckets, double halfLifeHours, double toleranceDecayDays, double standardUnitMg, double potencyMultiplier, double durationMultiplier, double toleranceGainRate, double activeThreshold
});




}
/// @nodoc
class _$ToleranceModelCopyWithImpl<$Res>
    implements $ToleranceModelCopyWith<$Res> {
  _$ToleranceModelCopyWithImpl(this._self, this._then);

  final ToleranceModel _self;
  final $Res Function(ToleranceModel) _then;

/// Create a copy of ToleranceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notes = null,Object? neuroBuckets = null,Object? halfLifeHours = null,Object? toleranceDecayDays = null,Object? standardUnitMg = null,Object? potencyMultiplier = null,Object? durationMultiplier = null,Object? toleranceGainRate = null,Object? activeThreshold = null,}) {
  return _then(_self.copyWith(
notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,neuroBuckets: null == neuroBuckets ? _self.neuroBuckets : neuroBuckets // ignore: cast_nullable_to_non_nullable
as Map<String, NeuroBucket>,halfLifeHours: null == halfLifeHours ? _self.halfLifeHours : halfLifeHours // ignore: cast_nullable_to_non_nullable
as double,toleranceDecayDays: null == toleranceDecayDays ? _self.toleranceDecayDays : toleranceDecayDays // ignore: cast_nullable_to_non_nullable
as double,standardUnitMg: null == standardUnitMg ? _self.standardUnitMg : standardUnitMg // ignore: cast_nullable_to_non_nullable
as double,potencyMultiplier: null == potencyMultiplier ? _self.potencyMultiplier : potencyMultiplier // ignore: cast_nullable_to_non_nullable
as double,durationMultiplier: null == durationMultiplier ? _self.durationMultiplier : durationMultiplier // ignore: cast_nullable_to_non_nullable
as double,toleranceGainRate: null == toleranceGainRate ? _self.toleranceGainRate : toleranceGainRate // ignore: cast_nullable_to_non_nullable
as double,activeThreshold: null == activeThreshold ? _self.activeThreshold : activeThreshold // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ToleranceModel].
extension ToleranceModelPatterns on ToleranceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ToleranceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ToleranceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ToleranceModel value)  $default,){
final _that = this;
switch (_that) {
case _ToleranceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ToleranceModel value)?  $default,){
final _that = this;
switch (_that) {
case _ToleranceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String notes,  Map<String, NeuroBucket> neuroBuckets,  double halfLifeHours,  double toleranceDecayDays,  double standardUnitMg,  double potencyMultiplier,  double durationMultiplier,  double toleranceGainRate,  double activeThreshold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ToleranceModel() when $default != null:
return $default(_that.notes,_that.neuroBuckets,_that.halfLifeHours,_that.toleranceDecayDays,_that.standardUnitMg,_that.potencyMultiplier,_that.durationMultiplier,_that.toleranceGainRate,_that.activeThreshold);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String notes,  Map<String, NeuroBucket> neuroBuckets,  double halfLifeHours,  double toleranceDecayDays,  double standardUnitMg,  double potencyMultiplier,  double durationMultiplier,  double toleranceGainRate,  double activeThreshold)  $default,) {final _that = this;
switch (_that) {
case _ToleranceModel():
return $default(_that.notes,_that.neuroBuckets,_that.halfLifeHours,_that.toleranceDecayDays,_that.standardUnitMg,_that.potencyMultiplier,_that.durationMultiplier,_that.toleranceGainRate,_that.activeThreshold);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String notes,  Map<String, NeuroBucket> neuroBuckets,  double halfLifeHours,  double toleranceDecayDays,  double standardUnitMg,  double potencyMultiplier,  double durationMultiplier,  double toleranceGainRate,  double activeThreshold)?  $default,) {final _that = this;
switch (_that) {
case _ToleranceModel() when $default != null:
return $default(_that.notes,_that.neuroBuckets,_that.halfLifeHours,_that.toleranceDecayDays,_that.standardUnitMg,_that.potencyMultiplier,_that.durationMultiplier,_that.toleranceGainRate,_that.activeThreshold);case _:
  return null;

}
}

}

/// @nodoc


class _ToleranceModel extends ToleranceModel {
  const _ToleranceModel({this.notes = '', final  Map<String, NeuroBucket> neuroBuckets = const {}, this.halfLifeHours = 6.0, this.toleranceDecayDays = 2.0, this.standardUnitMg = 10.0, this.potencyMultiplier = 1.0, this.durationMultiplier = 1.0, this.toleranceGainRate = 1.0, this.activeThreshold = 0.05}): _neuroBuckets = neuroBuckets,super._();
  

@override@JsonKey() final  String notes;
/// Neurotransmitter → bucket data (weight + type)
 final  Map<String, NeuroBucket> _neuroBuckets;
/// Neurotransmitter → bucket data (weight + type)
@override@JsonKey() Map<String, NeuroBucket> get neuroBuckets {
  if (_neuroBuckets is EqualUnmodifiableMapView) return _neuroBuckets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_neuroBuckets);
}

/// Pharmacokinetic parameters
@override@JsonKey() final  double halfLifeHours;
@override@JsonKey() final  double toleranceDecayDays;
/// Potency normalization
@override@JsonKey() final  double standardUnitMg;
@override@JsonKey() final  double potencyMultiplier;
@override@JsonKey() final  double durationMultiplier;
/// Tolerance dynamics
@override@JsonKey() final  double toleranceGainRate;
@override@JsonKey() final  double activeThreshold;

/// Create a copy of ToleranceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToleranceModelCopyWith<_ToleranceModel> get copyWith => __$ToleranceModelCopyWithImpl<_ToleranceModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToleranceModel&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._neuroBuckets, _neuroBuckets)&&(identical(other.halfLifeHours, halfLifeHours) || other.halfLifeHours == halfLifeHours)&&(identical(other.toleranceDecayDays, toleranceDecayDays) || other.toleranceDecayDays == toleranceDecayDays)&&(identical(other.standardUnitMg, standardUnitMg) || other.standardUnitMg == standardUnitMg)&&(identical(other.potencyMultiplier, potencyMultiplier) || other.potencyMultiplier == potencyMultiplier)&&(identical(other.durationMultiplier, durationMultiplier) || other.durationMultiplier == durationMultiplier)&&(identical(other.toleranceGainRate, toleranceGainRate) || other.toleranceGainRate == toleranceGainRate)&&(identical(other.activeThreshold, activeThreshold) || other.activeThreshold == activeThreshold));
}


@override
int get hashCode => Object.hash(runtimeType,notes,const DeepCollectionEquality().hash(_neuroBuckets),halfLifeHours,toleranceDecayDays,standardUnitMg,potencyMultiplier,durationMultiplier,toleranceGainRate,activeThreshold);

@override
String toString() {
  return 'ToleranceModel(notes: $notes, neuroBuckets: $neuroBuckets, halfLifeHours: $halfLifeHours, toleranceDecayDays: $toleranceDecayDays, standardUnitMg: $standardUnitMg, potencyMultiplier: $potencyMultiplier, durationMultiplier: $durationMultiplier, toleranceGainRate: $toleranceGainRate, activeThreshold: $activeThreshold)';
}


}

/// @nodoc
abstract mixin class _$ToleranceModelCopyWith<$Res> implements $ToleranceModelCopyWith<$Res> {
  factory _$ToleranceModelCopyWith(_ToleranceModel value, $Res Function(_ToleranceModel) _then) = __$ToleranceModelCopyWithImpl;
@override @useResult
$Res call({
 String notes, Map<String, NeuroBucket> neuroBuckets, double halfLifeHours, double toleranceDecayDays, double standardUnitMg, double potencyMultiplier, double durationMultiplier, double toleranceGainRate, double activeThreshold
});




}
/// @nodoc
class __$ToleranceModelCopyWithImpl<$Res>
    implements _$ToleranceModelCopyWith<$Res> {
  __$ToleranceModelCopyWithImpl(this._self, this._then);

  final _ToleranceModel _self;
  final $Res Function(_ToleranceModel) _then;

/// Create a copy of ToleranceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notes = null,Object? neuroBuckets = null,Object? halfLifeHours = null,Object? toleranceDecayDays = null,Object? standardUnitMg = null,Object? potencyMultiplier = null,Object? durationMultiplier = null,Object? toleranceGainRate = null,Object? activeThreshold = null,}) {
  return _then(_ToleranceModel(
notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,neuroBuckets: null == neuroBuckets ? _self._neuroBuckets : neuroBuckets // ignore: cast_nullable_to_non_nullable
as Map<String, NeuroBucket>,halfLifeHours: null == halfLifeHours ? _self.halfLifeHours : halfLifeHours // ignore: cast_nullable_to_non_nullable
as double,toleranceDecayDays: null == toleranceDecayDays ? _self.toleranceDecayDays : toleranceDecayDays // ignore: cast_nullable_to_non_nullable
as double,standardUnitMg: null == standardUnitMg ? _self.standardUnitMg : standardUnitMg // ignore: cast_nullable_to_non_nullable
as double,potencyMultiplier: null == potencyMultiplier ? _self.potencyMultiplier : potencyMultiplier // ignore: cast_nullable_to_non_nullable
as double,durationMultiplier: null == durationMultiplier ? _self.durationMultiplier : durationMultiplier // ignore: cast_nullable_to_non_nullable
as double,toleranceGainRate: null == toleranceGainRate ? _self.toleranceGainRate : toleranceGainRate // ignore: cast_nullable_to_non_nullable
as double,activeThreshold: null == activeThreshold ? _self.activeThreshold : activeThreshold // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$NeuroBucket {

 String get name; double get weight; String? get toleranceType;
/// Create a copy of NeuroBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NeuroBucketCopyWith<NeuroBucket> get copyWith => _$NeuroBucketCopyWithImpl<NeuroBucket>(this as NeuroBucket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NeuroBucket&&(identical(other.name, name) || other.name == name)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.toleranceType, toleranceType) || other.toleranceType == toleranceType));
}


@override
int get hashCode => Object.hash(runtimeType,name,weight,toleranceType);

@override
String toString() {
  return 'NeuroBucket(name: $name, weight: $weight, toleranceType: $toleranceType)';
}


}

/// @nodoc
abstract mixin class $NeuroBucketCopyWith<$Res>  {
  factory $NeuroBucketCopyWith(NeuroBucket value, $Res Function(NeuroBucket) _then) = _$NeuroBucketCopyWithImpl;
@useResult
$Res call({
 String name, double weight, String? toleranceType
});




}
/// @nodoc
class _$NeuroBucketCopyWithImpl<$Res>
    implements $NeuroBucketCopyWith<$Res> {
  _$NeuroBucketCopyWithImpl(this._self, this._then);

  final NeuroBucket _self;
  final $Res Function(NeuroBucket) _then;

/// Create a copy of NeuroBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? weight = null,Object? toleranceType = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,toleranceType: freezed == toleranceType ? _self.toleranceType : toleranceType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NeuroBucket].
extension NeuroBucketPatterns on NeuroBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NeuroBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NeuroBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NeuroBucket value)  $default,){
final _that = this;
switch (_that) {
case _NeuroBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NeuroBucket value)?  $default,){
final _that = this;
switch (_that) {
case _NeuroBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double weight,  String? toleranceType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NeuroBucket() when $default != null:
return $default(_that.name,_that.weight,_that.toleranceType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double weight,  String? toleranceType)  $default,) {final _that = this;
switch (_that) {
case _NeuroBucket():
return $default(_that.name,_that.weight,_that.toleranceType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double weight,  String? toleranceType)?  $default,) {final _that = this;
switch (_that) {
case _NeuroBucket() when $default != null:
return $default(_that.name,_that.weight,_that.toleranceType);case _:
  return null;

}
}

}

/// @nodoc


class _NeuroBucket extends NeuroBucket {
  const _NeuroBucket({required this.name, this.weight = 1.0, this.toleranceType}): super._();
  

@override final  String name;
@override@JsonKey() final  double weight;
@override final  String? toleranceType;

/// Create a copy of NeuroBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NeuroBucketCopyWith<_NeuroBucket> get copyWith => __$NeuroBucketCopyWithImpl<_NeuroBucket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NeuroBucket&&(identical(other.name, name) || other.name == name)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.toleranceType, toleranceType) || other.toleranceType == toleranceType));
}


@override
int get hashCode => Object.hash(runtimeType,name,weight,toleranceType);

@override
String toString() {
  return 'NeuroBucket(name: $name, weight: $weight, toleranceType: $toleranceType)';
}


}

/// @nodoc
abstract mixin class _$NeuroBucketCopyWith<$Res> implements $NeuroBucketCopyWith<$Res> {
  factory _$NeuroBucketCopyWith(_NeuroBucket value, $Res Function(_NeuroBucket) _then) = __$NeuroBucketCopyWithImpl;
@override @useResult
$Res call({
 String name, double weight, String? toleranceType
});




}
/// @nodoc
class __$NeuroBucketCopyWithImpl<$Res>
    implements _$NeuroBucketCopyWith<$Res> {
  __$NeuroBucketCopyWithImpl(this._self, this._then);

  final _NeuroBucket _self;
  final $Res Function(_NeuroBucket) _then;

/// Create a copy of NeuroBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? weight = null,Object? toleranceType = freezed,}) {
  return _then(_NeuroBucket(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,toleranceType: freezed == toleranceType ? _self.toleranceType : toleranceType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$UseEvent {

 DateTime get timestamp; double get dose; String get substanceName;
/// Create a copy of UseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UseEventCopyWith<UseEvent> get copyWith => _$UseEventCopyWithImpl<UseEvent>(this as UseEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UseEvent&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.substanceName, substanceName) || other.substanceName == substanceName));
}


@override
int get hashCode => Object.hash(runtimeType,timestamp,dose,substanceName);

@override
String toString() {
  return 'UseEvent(timestamp: $timestamp, dose: $dose, substanceName: $substanceName)';
}


}

/// @nodoc
abstract mixin class $UseEventCopyWith<$Res>  {
  factory $UseEventCopyWith(UseEvent value, $Res Function(UseEvent) _then) = _$UseEventCopyWithImpl;
@useResult
$Res call({
 DateTime timestamp, double dose, String substanceName
});




}
/// @nodoc
class _$UseEventCopyWithImpl<$Res>
    implements $UseEventCopyWith<$Res> {
  _$UseEventCopyWithImpl(this._self, this._then);

  final UseEvent _self;
  final $Res Function(UseEvent) _then;

/// Create a copy of UseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? dose = null,Object? substanceName = null,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,substanceName: null == substanceName ? _self.substanceName : substanceName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UseEvent].
extension UseEventPatterns on UseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UseEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UseEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UseEvent value)  $default,){
final _that = this;
switch (_that) {
case _UseEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UseEvent value)?  $default,){
final _that = this;
switch (_that) {
case _UseEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime timestamp,  double dose,  String substanceName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UseEvent() when $default != null:
return $default(_that.timestamp,_that.dose,_that.substanceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime timestamp,  double dose,  String substanceName)  $default,) {final _that = this;
switch (_that) {
case _UseEvent():
return $default(_that.timestamp,_that.dose,_that.substanceName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime timestamp,  double dose,  String substanceName)?  $default,) {final _that = this;
switch (_that) {
case _UseEvent() when $default != null:
return $default(_that.timestamp,_that.dose,_that.substanceName);case _:
  return null;

}
}

}

/// @nodoc


class _UseEvent extends UseEvent {
  const _UseEvent({required this.timestamp, required this.dose, required this.substanceName}): super._();
  

@override final  DateTime timestamp;
@override final  double dose;
@override final  String substanceName;

/// Create a copy of UseEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UseEventCopyWith<_UseEvent> get copyWith => __$UseEventCopyWithImpl<_UseEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UseEvent&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.substanceName, substanceName) || other.substanceName == substanceName));
}


@override
int get hashCode => Object.hash(runtimeType,timestamp,dose,substanceName);

@override
String toString() {
  return 'UseEvent(timestamp: $timestamp, dose: $dose, substanceName: $substanceName)';
}


}

/// @nodoc
abstract mixin class _$UseEventCopyWith<$Res> implements $UseEventCopyWith<$Res> {
  factory _$UseEventCopyWith(_UseEvent value, $Res Function(_UseEvent) _then) = __$UseEventCopyWithImpl;
@override @useResult
$Res call({
 DateTime timestamp, double dose, String substanceName
});




}
/// @nodoc
class __$UseEventCopyWithImpl<$Res>
    implements _$UseEventCopyWith<$Res> {
  __$UseEventCopyWithImpl(this._self, this._then);

  final _UseEvent _self;
  final $Res Function(_UseEvent) _then;

/// Create a copy of UseEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? dose = null,Object? substanceName = null,}) {
  return _then(_UseEvent(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,substanceName: null == substanceName ? _self.substanceName : substanceName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TolerancePoint {

 DateTime get time; double get score;
/// Create a copy of TolerancePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TolerancePointCopyWith<TolerancePoint> get copyWith => _$TolerancePointCopyWithImpl<TolerancePoint>(this as TolerancePoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TolerancePoint&&(identical(other.time, time) || other.time == time)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,time,score);

@override
String toString() {
  return 'TolerancePoint(time: $time, score: $score)';
}


}

/// @nodoc
abstract mixin class $TolerancePointCopyWith<$Res>  {
  factory $TolerancePointCopyWith(TolerancePoint value, $Res Function(TolerancePoint) _then) = _$TolerancePointCopyWithImpl;
@useResult
$Res call({
 DateTime time, double score
});




}
/// @nodoc
class _$TolerancePointCopyWithImpl<$Res>
    implements $TolerancePointCopyWith<$Res> {
  _$TolerancePointCopyWithImpl(this._self, this._then);

  final TolerancePoint _self;
  final $Res Function(TolerancePoint) _then;

/// Create a copy of TolerancePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? score = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TolerancePoint].
extension TolerancePointPatterns on TolerancePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TolerancePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TolerancePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TolerancePoint value)  $default,){
final _that = this;
switch (_that) {
case _TolerancePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TolerancePoint value)?  $default,){
final _that = this;
switch (_that) {
case _TolerancePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  double score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TolerancePoint() when $default != null:
return $default(_that.time,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  double score)  $default,) {final _that = this;
switch (_that) {
case _TolerancePoint():
return $default(_that.time,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  double score)?  $default,) {final _that = this;
switch (_that) {
case _TolerancePoint() when $default != null:
return $default(_that.time,_that.score);case _:
  return null;

}
}

}

/// @nodoc


class _TolerancePoint extends TolerancePoint {
  const _TolerancePoint({required this.time, required this.score}): super._();
  

@override final  DateTime time;
@override final  double score;

/// Create a copy of TolerancePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TolerancePointCopyWith<_TolerancePoint> get copyWith => __$TolerancePointCopyWithImpl<_TolerancePoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TolerancePoint&&(identical(other.time, time) || other.time == time)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,time,score);

@override
String toString() {
  return 'TolerancePoint(time: $time, score: $score)';
}


}

/// @nodoc
abstract mixin class _$TolerancePointCopyWith<$Res> implements $TolerancePointCopyWith<$Res> {
  factory _$TolerancePointCopyWith(_TolerancePoint value, $Res Function(_TolerancePoint) _then) = __$TolerancePointCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, double score
});




}
/// @nodoc
class __$TolerancePointCopyWithImpl<$Res>
    implements _$TolerancePointCopyWith<$Res> {
  __$TolerancePointCopyWithImpl(this._self, this._then);

  final _TolerancePoint _self;
  final $Res Function(_TolerancePoint) _then;

/// Create a copy of TolerancePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? score = null,}) {
  return _then(_TolerancePoint(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
