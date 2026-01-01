// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tolerance_models.dart';

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

  /// Serializes this UseLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UseLogEntry&&(identical(other.substanceSlug, substanceSlug) || other.substanceSlug == substanceSlug)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.doseUnits, doseUnits) || other.doseUnits == doseUnits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
@JsonSerializable()

class _UseLogEntry implements UseLogEntry {
  const _UseLogEntry({required this.substanceSlug, required this.timestamp, required this.doseUnits});
  factory _UseLogEntry.fromJson(Map<String, dynamic> json) => _$UseLogEntryFromJson(json);

@override final  String substanceSlug;
@override final  DateTime timestamp;
@override final  double doseUnits;

/// Create a copy of UseLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UseLogEntryCopyWith<_UseLogEntry> get copyWith => __$UseLogEntryCopyWithImpl<_UseLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UseLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UseLogEntry&&(identical(other.substanceSlug, substanceSlug) || other.substanceSlug == substanceSlug)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.doseUnits, doseUnits) || other.doseUnits == doseUnits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
mixin _$NeuroBucket {

 String get name; double get weight; String? get toleranceType;
/// Create a copy of NeuroBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NeuroBucketCopyWith<NeuroBucket> get copyWith => _$NeuroBucketCopyWithImpl<NeuroBucket>(this as NeuroBucket, _$identity);

  /// Serializes this NeuroBucket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NeuroBucket&&(identical(other.name, name) || other.name == name)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.toleranceType, toleranceType) || other.toleranceType == toleranceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
@JsonSerializable()

class _NeuroBucket implements NeuroBucket {
  const _NeuroBucket({required this.name, required this.weight, this.toleranceType});
  factory _NeuroBucket.fromJson(Map<String, dynamic> json) => _$NeuroBucketFromJson(json);

@override final  String name;
@override final  double weight;
@override final  String? toleranceType;

/// Create a copy of NeuroBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NeuroBucketCopyWith<_NeuroBucket> get copyWith => __$NeuroBucketCopyWithImpl<_NeuroBucket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NeuroBucketToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NeuroBucket&&(identical(other.name, name) || other.name == name)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.toleranceType, toleranceType) || other.toleranceType == toleranceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
mixin _$ToleranceModel {

 String get notes; Map<String, NeuroBucket> get neuroBuckets; double get halfLifeHours; double get toleranceDecayDays; double get standardUnitMg; double get potencyMultiplier; double get durationMultiplier; double get toleranceGainRate; double get activeThreshold;
/// Create a copy of ToleranceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToleranceModelCopyWith<ToleranceModel> get copyWith => _$ToleranceModelCopyWithImpl<ToleranceModel>(this as ToleranceModel, _$identity);

  /// Serializes this ToleranceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToleranceModel&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.neuroBuckets, neuroBuckets)&&(identical(other.halfLifeHours, halfLifeHours) || other.halfLifeHours == halfLifeHours)&&(identical(other.toleranceDecayDays, toleranceDecayDays) || other.toleranceDecayDays == toleranceDecayDays)&&(identical(other.standardUnitMg, standardUnitMg) || other.standardUnitMg == standardUnitMg)&&(identical(other.potencyMultiplier, potencyMultiplier) || other.potencyMultiplier == potencyMultiplier)&&(identical(other.durationMultiplier, durationMultiplier) || other.durationMultiplier == durationMultiplier)&&(identical(other.toleranceGainRate, toleranceGainRate) || other.toleranceGainRate == toleranceGainRate)&&(identical(other.activeThreshold, activeThreshold) || other.activeThreshold == activeThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
@JsonSerializable()

class _ToleranceModel implements ToleranceModel {
  const _ToleranceModel({this.notes = '', required final  Map<String, NeuroBucket> neuroBuckets, this.halfLifeHours = 6.0, this.toleranceDecayDays = 2.0, this.standardUnitMg = 10.0, this.potencyMultiplier = 1.0, this.durationMultiplier = 1.0, this.toleranceGainRate = 1.0, this.activeThreshold = 0.05}): _neuroBuckets = neuroBuckets;
  factory _ToleranceModel.fromJson(Map<String, dynamic> json) => _$ToleranceModelFromJson(json);

@override@JsonKey() final  String notes;
 final  Map<String, NeuroBucket> _neuroBuckets;
@override Map<String, NeuroBucket> get neuroBuckets {
  if (_neuroBuckets is EqualUnmodifiableMapView) return _neuroBuckets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_neuroBuckets);
}

@override@JsonKey() final  double halfLifeHours;
@override@JsonKey() final  double toleranceDecayDays;
@override@JsonKey() final  double standardUnitMg;
@override@JsonKey() final  double potencyMultiplier;
@override@JsonKey() final  double durationMultiplier;
@override@JsonKey() final  double toleranceGainRate;
@override@JsonKey() final  double activeThreshold;

/// Create a copy of ToleranceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToleranceModelCopyWith<_ToleranceModel> get copyWith => __$ToleranceModelCopyWithImpl<_ToleranceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ToleranceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToleranceModel&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._neuroBuckets, _neuroBuckets)&&(identical(other.halfLifeHours, halfLifeHours) || other.halfLifeHours == halfLifeHours)&&(identical(other.toleranceDecayDays, toleranceDecayDays) || other.toleranceDecayDays == toleranceDecayDays)&&(identical(other.standardUnitMg, standardUnitMg) || other.standardUnitMg == standardUnitMg)&&(identical(other.potencyMultiplier, potencyMultiplier) || other.potencyMultiplier == potencyMultiplier)&&(identical(other.durationMultiplier, durationMultiplier) || other.durationMultiplier == durationMultiplier)&&(identical(other.toleranceGainRate, toleranceGainRate) || other.toleranceGainRate == toleranceGainRate)&&(identical(other.activeThreshold, activeThreshold) || other.activeThreshold == activeThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
mixin _$ToleranceResult {

 Map<String, double> get bucketPercents; Map<String, double> get bucketRawLoads; double get toleranceScore; Map<String, double> get daysUntilBaseline; double get overallDaysUntilBaseline; Map<String, Map<String, double>> get substanceContributions; Map<String, bool> get substanceActiveStates;
/// Create a copy of ToleranceResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToleranceResultCopyWith<ToleranceResult> get copyWith => _$ToleranceResultCopyWithImpl<ToleranceResult>(this as ToleranceResult, _$identity);

  /// Serializes this ToleranceResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToleranceResult&&const DeepCollectionEquality().equals(other.bucketPercents, bucketPercents)&&const DeepCollectionEquality().equals(other.bucketRawLoads, bucketRawLoads)&&(identical(other.toleranceScore, toleranceScore) || other.toleranceScore == toleranceScore)&&const DeepCollectionEquality().equals(other.daysUntilBaseline, daysUntilBaseline)&&(identical(other.overallDaysUntilBaseline, overallDaysUntilBaseline) || other.overallDaysUntilBaseline == overallDaysUntilBaseline)&&const DeepCollectionEquality().equals(other.substanceContributions, substanceContributions)&&const DeepCollectionEquality().equals(other.substanceActiveStates, substanceActiveStates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bucketPercents),const DeepCollectionEquality().hash(bucketRawLoads),toleranceScore,const DeepCollectionEquality().hash(daysUntilBaseline),overallDaysUntilBaseline,const DeepCollectionEquality().hash(substanceContributions),const DeepCollectionEquality().hash(substanceActiveStates));

@override
String toString() {
  return 'ToleranceResult(bucketPercents: $bucketPercents, bucketRawLoads: $bucketRawLoads, toleranceScore: $toleranceScore, daysUntilBaseline: $daysUntilBaseline, overallDaysUntilBaseline: $overallDaysUntilBaseline, substanceContributions: $substanceContributions, substanceActiveStates: $substanceActiveStates)';
}


}

/// @nodoc
abstract mixin class $ToleranceResultCopyWith<$Res>  {
  factory $ToleranceResultCopyWith(ToleranceResult value, $Res Function(ToleranceResult) _then) = _$ToleranceResultCopyWithImpl;
@useResult
$Res call({
 Map<String, double> bucketPercents, Map<String, double> bucketRawLoads, double toleranceScore, Map<String, double> daysUntilBaseline, double overallDaysUntilBaseline, Map<String, Map<String, double>> substanceContributions, Map<String, bool> substanceActiveStates
});




}
/// @nodoc
class _$ToleranceResultCopyWithImpl<$Res>
    implements $ToleranceResultCopyWith<$Res> {
  _$ToleranceResultCopyWithImpl(this._self, this._then);

  final ToleranceResult _self;
  final $Res Function(ToleranceResult) _then;

/// Create a copy of ToleranceResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bucketPercents = null,Object? bucketRawLoads = null,Object? toleranceScore = null,Object? daysUntilBaseline = null,Object? overallDaysUntilBaseline = null,Object? substanceContributions = null,Object? substanceActiveStates = null,}) {
  return _then(_self.copyWith(
bucketPercents: null == bucketPercents ? _self.bucketPercents : bucketPercents // ignore: cast_nullable_to_non_nullable
as Map<String, double>,bucketRawLoads: null == bucketRawLoads ? _self.bucketRawLoads : bucketRawLoads // ignore: cast_nullable_to_non_nullable
as Map<String, double>,toleranceScore: null == toleranceScore ? _self.toleranceScore : toleranceScore // ignore: cast_nullable_to_non_nullable
as double,daysUntilBaseline: null == daysUntilBaseline ? _self.daysUntilBaseline : daysUntilBaseline // ignore: cast_nullable_to_non_nullable
as Map<String, double>,overallDaysUntilBaseline: null == overallDaysUntilBaseline ? _self.overallDaysUntilBaseline : overallDaysUntilBaseline // ignore: cast_nullable_to_non_nullable
as double,substanceContributions: null == substanceContributions ? _self.substanceContributions : substanceContributions // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, double>>,substanceActiveStates: null == substanceActiveStates ? _self.substanceActiveStates : substanceActiveStates // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [ToleranceResult].
extension ToleranceResultPatterns on ToleranceResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ToleranceResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ToleranceResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ToleranceResult value)  $default,){
final _that = this;
switch (_that) {
case _ToleranceResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ToleranceResult value)?  $default,){
final _that = this;
switch (_that) {
case _ToleranceResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, double> bucketPercents,  Map<String, double> bucketRawLoads,  double toleranceScore,  Map<String, double> daysUntilBaseline,  double overallDaysUntilBaseline,  Map<String, Map<String, double>> substanceContributions,  Map<String, bool> substanceActiveStates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ToleranceResult() when $default != null:
return $default(_that.bucketPercents,_that.bucketRawLoads,_that.toleranceScore,_that.daysUntilBaseline,_that.overallDaysUntilBaseline,_that.substanceContributions,_that.substanceActiveStates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, double> bucketPercents,  Map<String, double> bucketRawLoads,  double toleranceScore,  Map<String, double> daysUntilBaseline,  double overallDaysUntilBaseline,  Map<String, Map<String, double>> substanceContributions,  Map<String, bool> substanceActiveStates)  $default,) {final _that = this;
switch (_that) {
case _ToleranceResult():
return $default(_that.bucketPercents,_that.bucketRawLoads,_that.toleranceScore,_that.daysUntilBaseline,_that.overallDaysUntilBaseline,_that.substanceContributions,_that.substanceActiveStates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, double> bucketPercents,  Map<String, double> bucketRawLoads,  double toleranceScore,  Map<String, double> daysUntilBaseline,  double overallDaysUntilBaseline,  Map<String, Map<String, double>> substanceContributions,  Map<String, bool> substanceActiveStates)?  $default,) {final _that = this;
switch (_that) {
case _ToleranceResult() when $default != null:
return $default(_that.bucketPercents,_that.bucketRawLoads,_that.toleranceScore,_that.daysUntilBaseline,_that.overallDaysUntilBaseline,_that.substanceContributions,_that.substanceActiveStates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ToleranceResult implements ToleranceResult {
  const _ToleranceResult({required final  Map<String, double> bucketPercents, required final  Map<String, double> bucketRawLoads, required this.toleranceScore, required final  Map<String, double> daysUntilBaseline, required this.overallDaysUntilBaseline, final  Map<String, Map<String, double>> substanceContributions = const {}, final  Map<String, bool> substanceActiveStates = const {}}): _bucketPercents = bucketPercents,_bucketRawLoads = bucketRawLoads,_daysUntilBaseline = daysUntilBaseline,_substanceContributions = substanceContributions,_substanceActiveStates = substanceActiveStates;
  factory _ToleranceResult.fromJson(Map<String, dynamic> json) => _$ToleranceResultFromJson(json);

 final  Map<String, double> _bucketPercents;
@override Map<String, double> get bucketPercents {
  if (_bucketPercents is EqualUnmodifiableMapView) return _bucketPercents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_bucketPercents);
}

 final  Map<String, double> _bucketRawLoads;
@override Map<String, double> get bucketRawLoads {
  if (_bucketRawLoads is EqualUnmodifiableMapView) return _bucketRawLoads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_bucketRawLoads);
}

@override final  double toleranceScore;
 final  Map<String, double> _daysUntilBaseline;
@override Map<String, double> get daysUntilBaseline {
  if (_daysUntilBaseline is EqualUnmodifiableMapView) return _daysUntilBaseline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_daysUntilBaseline);
}

@override final  double overallDaysUntilBaseline;
 final  Map<String, Map<String, double>> _substanceContributions;
@override@JsonKey() Map<String, Map<String, double>> get substanceContributions {
  if (_substanceContributions is EqualUnmodifiableMapView) return _substanceContributions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_substanceContributions);
}

 final  Map<String, bool> _substanceActiveStates;
@override@JsonKey() Map<String, bool> get substanceActiveStates {
  if (_substanceActiveStates is EqualUnmodifiableMapView) return _substanceActiveStates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_substanceActiveStates);
}


/// Create a copy of ToleranceResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToleranceResultCopyWith<_ToleranceResult> get copyWith => __$ToleranceResultCopyWithImpl<_ToleranceResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ToleranceResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToleranceResult&&const DeepCollectionEquality().equals(other._bucketPercents, _bucketPercents)&&const DeepCollectionEquality().equals(other._bucketRawLoads, _bucketRawLoads)&&(identical(other.toleranceScore, toleranceScore) || other.toleranceScore == toleranceScore)&&const DeepCollectionEquality().equals(other._daysUntilBaseline, _daysUntilBaseline)&&(identical(other.overallDaysUntilBaseline, overallDaysUntilBaseline) || other.overallDaysUntilBaseline == overallDaysUntilBaseline)&&const DeepCollectionEquality().equals(other._substanceContributions, _substanceContributions)&&const DeepCollectionEquality().equals(other._substanceActiveStates, _substanceActiveStates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bucketPercents),const DeepCollectionEquality().hash(_bucketRawLoads),toleranceScore,const DeepCollectionEquality().hash(_daysUntilBaseline),overallDaysUntilBaseline,const DeepCollectionEquality().hash(_substanceContributions),const DeepCollectionEquality().hash(_substanceActiveStates));

@override
String toString() {
  return 'ToleranceResult(bucketPercents: $bucketPercents, bucketRawLoads: $bucketRawLoads, toleranceScore: $toleranceScore, daysUntilBaseline: $daysUntilBaseline, overallDaysUntilBaseline: $overallDaysUntilBaseline, substanceContributions: $substanceContributions, substanceActiveStates: $substanceActiveStates)';
}


}

/// @nodoc
abstract mixin class _$ToleranceResultCopyWith<$Res> implements $ToleranceResultCopyWith<$Res> {
  factory _$ToleranceResultCopyWith(_ToleranceResult value, $Res Function(_ToleranceResult) _then) = __$ToleranceResultCopyWithImpl;
@override @useResult
$Res call({
 Map<String, double> bucketPercents, Map<String, double> bucketRawLoads, double toleranceScore, Map<String, double> daysUntilBaseline, double overallDaysUntilBaseline, Map<String, Map<String, double>> substanceContributions, Map<String, bool> substanceActiveStates
});




}
/// @nodoc
class __$ToleranceResultCopyWithImpl<$Res>
    implements _$ToleranceResultCopyWith<$Res> {
  __$ToleranceResultCopyWithImpl(this._self, this._then);

  final _ToleranceResult _self;
  final $Res Function(_ToleranceResult) _then;

/// Create a copy of ToleranceResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bucketPercents = null,Object? bucketRawLoads = null,Object? toleranceScore = null,Object? daysUntilBaseline = null,Object? overallDaysUntilBaseline = null,Object? substanceContributions = null,Object? substanceActiveStates = null,}) {
  return _then(_ToleranceResult(
bucketPercents: null == bucketPercents ? _self._bucketPercents : bucketPercents // ignore: cast_nullable_to_non_nullable
as Map<String, double>,bucketRawLoads: null == bucketRawLoads ? _self._bucketRawLoads : bucketRawLoads // ignore: cast_nullable_to_non_nullable
as Map<String, double>,toleranceScore: null == toleranceScore ? _self.toleranceScore : toleranceScore // ignore: cast_nullable_to_non_nullable
as double,daysUntilBaseline: null == daysUntilBaseline ? _self._daysUntilBaseline : daysUntilBaseline // ignore: cast_nullable_to_non_nullable
as Map<String, double>,overallDaysUntilBaseline: null == overallDaysUntilBaseline ? _self.overallDaysUntilBaseline : overallDaysUntilBaseline // ignore: cast_nullable_to_non_nullable
as double,substanceContributions: null == substanceContributions ? _self._substanceContributions : substanceContributions // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, double>>,substanceActiveStates: null == substanceActiveStates ? _self._substanceActiveStates : substanceActiveStates // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

// dart format on
