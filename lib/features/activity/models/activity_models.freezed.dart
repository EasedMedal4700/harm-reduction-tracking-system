// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityData {

 List<ActivityDrugUseEntry> get entries; List<ActivityCravingEntry> get cravings; List<ActivityReflectionEntry> get reflections;
/// Create a copy of ActivityData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityDataCopyWith<ActivityData> get copyWith => _$ActivityDataCopyWithImpl<ActivityData>(this as ActivityData, _$identity);

  /// Serializes this ActivityData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityData&&const DeepCollectionEquality().equals(other.entries, entries)&&const DeepCollectionEquality().equals(other.cravings, cravings)&&const DeepCollectionEquality().equals(other.reflections, reflections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entries),const DeepCollectionEquality().hash(cravings),const DeepCollectionEquality().hash(reflections));

@override
String toString() {
  return 'ActivityData(entries: $entries, cravings: $cravings, reflections: $reflections)';
}


}

/// @nodoc
abstract mixin class $ActivityDataCopyWith<$Res>  {
  factory $ActivityDataCopyWith(ActivityData value, $Res Function(ActivityData) _then) = _$ActivityDataCopyWithImpl;
@useResult
$Res call({
 List<ActivityDrugUseEntry> entries, List<ActivityCravingEntry> cravings, List<ActivityReflectionEntry> reflections
});




}
/// @nodoc
class _$ActivityDataCopyWithImpl<$Res>
    implements $ActivityDataCopyWith<$Res> {
  _$ActivityDataCopyWithImpl(this._self, this._then);

  final ActivityData _self;
  final $Res Function(ActivityData) _then;

/// Create a copy of ActivityData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? cravings = null,Object? reflections = null,}) {
  return _then(_self.copyWith(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<ActivityDrugUseEntry>,cravings: null == cravings ? _self.cravings : cravings // ignore: cast_nullable_to_non_nullable
as List<ActivityCravingEntry>,reflections: null == reflections ? _self.reflections : reflections // ignore: cast_nullable_to_non_nullable
as List<ActivityReflectionEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityData].
extension ActivityDataPatterns on ActivityData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityData value)  $default,){
final _that = this;
switch (_that) {
case _ActivityData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityData value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ActivityDrugUseEntry> entries,  List<ActivityCravingEntry> cravings,  List<ActivityReflectionEntry> reflections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityData() when $default != null:
return $default(_that.entries,_that.cravings,_that.reflections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ActivityDrugUseEntry> entries,  List<ActivityCravingEntry> cravings,  List<ActivityReflectionEntry> reflections)  $default,) {final _that = this;
switch (_that) {
case _ActivityData():
return $default(_that.entries,_that.cravings,_that.reflections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ActivityDrugUseEntry> entries,  List<ActivityCravingEntry> cravings,  List<ActivityReflectionEntry> reflections)?  $default,) {final _that = this;
switch (_that) {
case _ActivityData() when $default != null:
return $default(_that.entries,_that.cravings,_that.reflections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityData implements ActivityData {
  const _ActivityData({final  List<ActivityDrugUseEntry> entries = const <ActivityDrugUseEntry>[], final  List<ActivityCravingEntry> cravings = const <ActivityCravingEntry>[], final  List<ActivityReflectionEntry> reflections = const <ActivityReflectionEntry>[]}): _entries = entries,_cravings = cravings,_reflections = reflections;
  factory _ActivityData.fromJson(Map<String, dynamic> json) => _$ActivityDataFromJson(json);

 final  List<ActivityDrugUseEntry> _entries;
@override@JsonKey() List<ActivityDrugUseEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

 final  List<ActivityCravingEntry> _cravings;
@override@JsonKey() List<ActivityCravingEntry> get cravings {
  if (_cravings is EqualUnmodifiableListView) return _cravings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cravings);
}

 final  List<ActivityReflectionEntry> _reflections;
@override@JsonKey() List<ActivityReflectionEntry> get reflections {
  if (_reflections is EqualUnmodifiableListView) return _reflections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reflections);
}


/// Create a copy of ActivityData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDataCopyWith<_ActivityData> get copyWith => __$ActivityDataCopyWithImpl<_ActivityData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityData&&const DeepCollectionEquality().equals(other._entries, _entries)&&const DeepCollectionEquality().equals(other._cravings, _cravings)&&const DeepCollectionEquality().equals(other._reflections, _reflections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),const DeepCollectionEquality().hash(_cravings),const DeepCollectionEquality().hash(_reflections));

@override
String toString() {
  return 'ActivityData(entries: $entries, cravings: $cravings, reflections: $reflections)';
}


}

/// @nodoc
abstract mixin class _$ActivityDataCopyWith<$Res> implements $ActivityDataCopyWith<$Res> {
  factory _$ActivityDataCopyWith(_ActivityData value, $Res Function(_ActivityData) _then) = __$ActivityDataCopyWithImpl;
@override @useResult
$Res call({
 List<ActivityDrugUseEntry> entries, List<ActivityCravingEntry> cravings, List<ActivityReflectionEntry> reflections
});




}
/// @nodoc
class __$ActivityDataCopyWithImpl<$Res>
    implements _$ActivityDataCopyWith<$Res> {
  __$ActivityDataCopyWithImpl(this._self, this._then);

  final _ActivityData _self;
  final $Res Function(_ActivityData) _then;

/// Create a copy of ActivityData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? cravings = null,Object? reflections = null,}) {
  return _then(_ActivityData(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<ActivityDrugUseEntry>,cravings: null == cravings ? _self._cravings : cravings // ignore: cast_nullable_to_non_nullable
as List<ActivityCravingEntry>,reflections: null == reflections ? _self._reflections : reflections // ignore: cast_nullable_to_non_nullable
as List<ActivityReflectionEntry>,
  ));
}


}


/// @nodoc
mixin _$ActivityDrugUseEntry {

 String get id; String get name; String get dose; String get place; DateTime get time; String? get notes; bool get isMedicalPurpose; Map<String, Object?> get raw;
/// Create a copy of ActivityDrugUseEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityDrugUseEntryCopyWith<ActivityDrugUseEntry> get copyWith => _$ActivityDrugUseEntryCopyWithImpl<ActivityDrugUseEntry>(this as ActivityDrugUseEntry, _$identity);

  /// Serializes this ActivityDrugUseEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityDrugUseEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.place, place) || other.place == place)&&(identical(other.time, time) || other.time == time)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isMedicalPurpose, isMedicalPurpose) || other.isMedicalPurpose == isMedicalPurpose)&&const DeepCollectionEquality().equals(other.raw, raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dose,place,time,notes,isMedicalPurpose,const DeepCollectionEquality().hash(raw));

@override
String toString() {
  return 'ActivityDrugUseEntry(id: $id, name: $name, dose: $dose, place: $place, time: $time, notes: $notes, isMedicalPurpose: $isMedicalPurpose, raw: $raw)';
}


}

/// @nodoc
abstract mixin class $ActivityDrugUseEntryCopyWith<$Res>  {
  factory $ActivityDrugUseEntryCopyWith(ActivityDrugUseEntry value, $Res Function(ActivityDrugUseEntry) _then) = _$ActivityDrugUseEntryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String dose, String place, DateTime time, String? notes, bool isMedicalPurpose, Map<String, Object?> raw
});




}
/// @nodoc
class _$ActivityDrugUseEntryCopyWithImpl<$Res>
    implements $ActivityDrugUseEntryCopyWith<$Res> {
  _$ActivityDrugUseEntryCopyWithImpl(this._self, this._then);

  final ActivityDrugUseEntry _self;
  final $Res Function(ActivityDrugUseEntry) _then;

/// Create a copy of ActivityDrugUseEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dose = null,Object? place = null,Object? time = null,Object? notes = freezed,Object? isMedicalPurpose = null,Object? raw = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as String,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isMedicalPurpose: null == isMedicalPurpose ? _self.isMedicalPurpose : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
as bool,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityDrugUseEntry].
extension ActivityDrugUseEntryPatterns on ActivityDrugUseEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityDrugUseEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityDrugUseEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityDrugUseEntry value)  $default,){
final _that = this;
switch (_that) {
case _ActivityDrugUseEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityDrugUseEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityDrugUseEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String dose,  String place,  DateTime time,  String? notes,  bool isMedicalPurpose,  Map<String, Object?> raw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityDrugUseEntry() when $default != null:
return $default(_that.id,_that.name,_that.dose,_that.place,_that.time,_that.notes,_that.isMedicalPurpose,_that.raw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String dose,  String place,  DateTime time,  String? notes,  bool isMedicalPurpose,  Map<String, Object?> raw)  $default,) {final _that = this;
switch (_that) {
case _ActivityDrugUseEntry():
return $default(_that.id,_that.name,_that.dose,_that.place,_that.time,_that.notes,_that.isMedicalPurpose,_that.raw);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String dose,  String place,  DateTime time,  String? notes,  bool isMedicalPurpose,  Map<String, Object?> raw)?  $default,) {final _that = this;
switch (_that) {
case _ActivityDrugUseEntry() when $default != null:
return $default(_that.id,_that.name,_that.dose,_that.place,_that.time,_that.notes,_that.isMedicalPurpose,_that.raw);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityDrugUseEntry implements ActivityDrugUseEntry {
  const _ActivityDrugUseEntry({required this.id, required this.name, required this.dose, required this.place, required this.time, this.notes, this.isMedicalPurpose = false, final  Map<String, Object?> raw = const <String, Object?>{}}): _raw = raw;
  factory _ActivityDrugUseEntry.fromJson(Map<String, dynamic> json) => _$ActivityDrugUseEntryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String dose;
@override final  String place;
@override final  DateTime time;
@override final  String? notes;
@override@JsonKey() final  bool isMedicalPurpose;
 final  Map<String, Object?> _raw;
@override@JsonKey() Map<String, Object?> get raw {
  if (_raw is EqualUnmodifiableMapView) return _raw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_raw);
}


/// Create a copy of ActivityDrugUseEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDrugUseEntryCopyWith<_ActivityDrugUseEntry> get copyWith => __$ActivityDrugUseEntryCopyWithImpl<_ActivityDrugUseEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityDrugUseEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDrugUseEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.place, place) || other.place == place)&&(identical(other.time, time) || other.time == time)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isMedicalPurpose, isMedicalPurpose) || other.isMedicalPurpose == isMedicalPurpose)&&const DeepCollectionEquality().equals(other._raw, _raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dose,place,time,notes,isMedicalPurpose,const DeepCollectionEquality().hash(_raw));

@override
String toString() {
  return 'ActivityDrugUseEntry(id: $id, name: $name, dose: $dose, place: $place, time: $time, notes: $notes, isMedicalPurpose: $isMedicalPurpose, raw: $raw)';
}


}

/// @nodoc
abstract mixin class _$ActivityDrugUseEntryCopyWith<$Res> implements $ActivityDrugUseEntryCopyWith<$Res> {
  factory _$ActivityDrugUseEntryCopyWith(_ActivityDrugUseEntry value, $Res Function(_ActivityDrugUseEntry) _then) = __$ActivityDrugUseEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String dose, String place, DateTime time, String? notes, bool isMedicalPurpose, Map<String, Object?> raw
});




}
/// @nodoc
class __$ActivityDrugUseEntryCopyWithImpl<$Res>
    implements _$ActivityDrugUseEntryCopyWith<$Res> {
  __$ActivityDrugUseEntryCopyWithImpl(this._self, this._then);

  final _ActivityDrugUseEntry _self;
  final $Res Function(_ActivityDrugUseEntry) _then;

/// Create a copy of ActivityDrugUseEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dose = null,Object? place = null,Object? time = null,Object? notes = freezed,Object? isMedicalPurpose = null,Object? raw = null,}) {
  return _then(_ActivityDrugUseEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as String,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isMedicalPurpose: null == isMedicalPurpose ? _self.isMedicalPurpose : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
as bool,raw: null == raw ? _self._raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}


/// @nodoc
mixin _$ActivityCravingEntry {

 String get id; String get substance; double get intensity; String get location; DateTime get time; String? get trigger; String? get action; String? get notes; Map<String, Object?> get raw;
/// Create a copy of ActivityCravingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityCravingEntryCopyWith<ActivityCravingEntry> get copyWith => _$ActivityCravingEntryCopyWithImpl<ActivityCravingEntry>(this as ActivityCravingEntry, _$identity);

  /// Serializes this ActivityCravingEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityCravingEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.substance, substance) || other.substance == substance)&&(identical(other.intensity, intensity) || other.intensity == intensity)&&(identical(other.location, location) || other.location == location)&&(identical(other.time, time) || other.time == time)&&(identical(other.trigger, trigger) || other.trigger == trigger)&&(identical(other.action, action) || other.action == action)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.raw, raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,substance,intensity,location,time,trigger,action,notes,const DeepCollectionEquality().hash(raw));

@override
String toString() {
  return 'ActivityCravingEntry(id: $id, substance: $substance, intensity: $intensity, location: $location, time: $time, trigger: $trigger, action: $action, notes: $notes, raw: $raw)';
}


}

/// @nodoc
abstract mixin class $ActivityCravingEntryCopyWith<$Res>  {
  factory $ActivityCravingEntryCopyWith(ActivityCravingEntry value, $Res Function(ActivityCravingEntry) _then) = _$ActivityCravingEntryCopyWithImpl;
@useResult
$Res call({
 String id, String substance, double intensity, String location, DateTime time, String? trigger, String? action, String? notes, Map<String, Object?> raw
});




}
/// @nodoc
class _$ActivityCravingEntryCopyWithImpl<$Res>
    implements $ActivityCravingEntryCopyWith<$Res> {
  _$ActivityCravingEntryCopyWithImpl(this._self, this._then);

  final ActivityCravingEntry _self;
  final $Res Function(ActivityCravingEntry) _then;

/// Create a copy of ActivityCravingEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? substance = null,Object? intensity = null,Object? location = null,Object? time = null,Object? trigger = freezed,Object? action = freezed,Object? notes = freezed,Object? raw = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,substance: null == substance ? _self.substance : substance // ignore: cast_nullable_to_non_nullable
as String,intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as double,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,trigger: freezed == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityCravingEntry].
extension ActivityCravingEntryPatterns on ActivityCravingEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityCravingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityCravingEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityCravingEntry value)  $default,){
final _that = this;
switch (_that) {
case _ActivityCravingEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityCravingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityCravingEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String substance,  double intensity,  String location,  DateTime time,  String? trigger,  String? action,  String? notes,  Map<String, Object?> raw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityCravingEntry() when $default != null:
return $default(_that.id,_that.substance,_that.intensity,_that.location,_that.time,_that.trigger,_that.action,_that.notes,_that.raw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String substance,  double intensity,  String location,  DateTime time,  String? trigger,  String? action,  String? notes,  Map<String, Object?> raw)  $default,) {final _that = this;
switch (_that) {
case _ActivityCravingEntry():
return $default(_that.id,_that.substance,_that.intensity,_that.location,_that.time,_that.trigger,_that.action,_that.notes,_that.raw);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String substance,  double intensity,  String location,  DateTime time,  String? trigger,  String? action,  String? notes,  Map<String, Object?> raw)?  $default,) {final _that = this;
switch (_that) {
case _ActivityCravingEntry() when $default != null:
return $default(_that.id,_that.substance,_that.intensity,_that.location,_that.time,_that.trigger,_that.action,_that.notes,_that.raw);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityCravingEntry implements ActivityCravingEntry {
  const _ActivityCravingEntry({required this.id, required this.substance, required this.intensity, required this.location, required this.time, this.trigger, this.action, this.notes, final  Map<String, Object?> raw = const <String, Object?>{}}): _raw = raw;
  factory _ActivityCravingEntry.fromJson(Map<String, dynamic> json) => _$ActivityCravingEntryFromJson(json);

@override final  String id;
@override final  String substance;
@override final  double intensity;
@override final  String location;
@override final  DateTime time;
@override final  String? trigger;
@override final  String? action;
@override final  String? notes;
 final  Map<String, Object?> _raw;
@override@JsonKey() Map<String, Object?> get raw {
  if (_raw is EqualUnmodifiableMapView) return _raw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_raw);
}


/// Create a copy of ActivityCravingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityCravingEntryCopyWith<_ActivityCravingEntry> get copyWith => __$ActivityCravingEntryCopyWithImpl<_ActivityCravingEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityCravingEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityCravingEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.substance, substance) || other.substance == substance)&&(identical(other.intensity, intensity) || other.intensity == intensity)&&(identical(other.location, location) || other.location == location)&&(identical(other.time, time) || other.time == time)&&(identical(other.trigger, trigger) || other.trigger == trigger)&&(identical(other.action, action) || other.action == action)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._raw, _raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,substance,intensity,location,time,trigger,action,notes,const DeepCollectionEquality().hash(_raw));

@override
String toString() {
  return 'ActivityCravingEntry(id: $id, substance: $substance, intensity: $intensity, location: $location, time: $time, trigger: $trigger, action: $action, notes: $notes, raw: $raw)';
}


}

/// @nodoc
abstract mixin class _$ActivityCravingEntryCopyWith<$Res> implements $ActivityCravingEntryCopyWith<$Res> {
  factory _$ActivityCravingEntryCopyWith(_ActivityCravingEntry value, $Res Function(_ActivityCravingEntry) _then) = __$ActivityCravingEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String substance, double intensity, String location, DateTime time, String? trigger, String? action, String? notes, Map<String, Object?> raw
});




}
/// @nodoc
class __$ActivityCravingEntryCopyWithImpl<$Res>
    implements _$ActivityCravingEntryCopyWith<$Res> {
  __$ActivityCravingEntryCopyWithImpl(this._self, this._then);

  final _ActivityCravingEntry _self;
  final $Res Function(_ActivityCravingEntry) _then;

/// Create a copy of ActivityCravingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? substance = null,Object? intensity = null,Object? location = null,Object? time = null,Object? trigger = freezed,Object? action = freezed,Object? notes = freezed,Object? raw = null,}) {
  return _then(_ActivityCravingEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,substance: null == substance ? _self.substance : substance // ignore: cast_nullable_to_non_nullable
as String,intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as double,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,trigger: freezed == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,raw: null == raw ? _self._raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}


/// @nodoc
mixin _$ActivityReflectionEntry {

 String get id; DateTime get createdAt; int? get effectiveness; num? get sleepHours; String? get notes; Map<String, Object?> get raw;
/// Create a copy of ActivityReflectionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityReflectionEntryCopyWith<ActivityReflectionEntry> get copyWith => _$ActivityReflectionEntryCopyWithImpl<ActivityReflectionEntry>(this as ActivityReflectionEntry, _$identity);

  /// Serializes this ActivityReflectionEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityReflectionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.effectiveness, effectiveness) || other.effectiveness == effectiveness)&&(identical(other.sleepHours, sleepHours) || other.sleepHours == sleepHours)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.raw, raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,effectiveness,sleepHours,notes,const DeepCollectionEquality().hash(raw));

@override
String toString() {
  return 'ActivityReflectionEntry(id: $id, createdAt: $createdAt, effectiveness: $effectiveness, sleepHours: $sleepHours, notes: $notes, raw: $raw)';
}


}

/// @nodoc
abstract mixin class $ActivityReflectionEntryCopyWith<$Res>  {
  factory $ActivityReflectionEntryCopyWith(ActivityReflectionEntry value, $Res Function(ActivityReflectionEntry) _then) = _$ActivityReflectionEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, int? effectiveness, num? sleepHours, String? notes, Map<String, Object?> raw
});




}
/// @nodoc
class _$ActivityReflectionEntryCopyWithImpl<$Res>
    implements $ActivityReflectionEntryCopyWith<$Res> {
  _$ActivityReflectionEntryCopyWithImpl(this._self, this._then);

  final ActivityReflectionEntry _self;
  final $Res Function(ActivityReflectionEntry) _then;

/// Create a copy of ActivityReflectionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? effectiveness = freezed,Object? sleepHours = freezed,Object? notes = freezed,Object? raw = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveness: freezed == effectiveness ? _self.effectiveness : effectiveness // ignore: cast_nullable_to_non_nullable
as int?,sleepHours: freezed == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as num?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityReflectionEntry].
extension ActivityReflectionEntryPatterns on ActivityReflectionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityReflectionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityReflectionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityReflectionEntry value)  $default,){
final _that = this;
switch (_that) {
case _ActivityReflectionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityReflectionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityReflectionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  int? effectiveness,  num? sleepHours,  String? notes,  Map<String, Object?> raw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityReflectionEntry() when $default != null:
return $default(_that.id,_that.createdAt,_that.effectiveness,_that.sleepHours,_that.notes,_that.raw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  int? effectiveness,  num? sleepHours,  String? notes,  Map<String, Object?> raw)  $default,) {final _that = this;
switch (_that) {
case _ActivityReflectionEntry():
return $default(_that.id,_that.createdAt,_that.effectiveness,_that.sleepHours,_that.notes,_that.raw);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  int? effectiveness,  num? sleepHours,  String? notes,  Map<String, Object?> raw)?  $default,) {final _that = this;
switch (_that) {
case _ActivityReflectionEntry() when $default != null:
return $default(_that.id,_that.createdAt,_that.effectiveness,_that.sleepHours,_that.notes,_that.raw);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityReflectionEntry implements ActivityReflectionEntry {
  const _ActivityReflectionEntry({required this.id, required this.createdAt, this.effectiveness, this.sleepHours, this.notes, final  Map<String, Object?> raw = const <String, Object?>{}}): _raw = raw;
  factory _ActivityReflectionEntry.fromJson(Map<String, dynamic> json) => _$ActivityReflectionEntryFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  int? effectiveness;
@override final  num? sleepHours;
@override final  String? notes;
 final  Map<String, Object?> _raw;
@override@JsonKey() Map<String, Object?> get raw {
  if (_raw is EqualUnmodifiableMapView) return _raw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_raw);
}


/// Create a copy of ActivityReflectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityReflectionEntryCopyWith<_ActivityReflectionEntry> get copyWith => __$ActivityReflectionEntryCopyWithImpl<_ActivityReflectionEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityReflectionEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityReflectionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.effectiveness, effectiveness) || other.effectiveness == effectiveness)&&(identical(other.sleepHours, sleepHours) || other.sleepHours == sleepHours)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._raw, _raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,effectiveness,sleepHours,notes,const DeepCollectionEquality().hash(_raw));

@override
String toString() {
  return 'ActivityReflectionEntry(id: $id, createdAt: $createdAt, effectiveness: $effectiveness, sleepHours: $sleepHours, notes: $notes, raw: $raw)';
}


}

/// @nodoc
abstract mixin class _$ActivityReflectionEntryCopyWith<$Res> implements $ActivityReflectionEntryCopyWith<$Res> {
  factory _$ActivityReflectionEntryCopyWith(_ActivityReflectionEntry value, $Res Function(_ActivityReflectionEntry) _then) = __$ActivityReflectionEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, int? effectiveness, num? sleepHours, String? notes, Map<String, Object?> raw
});




}
/// @nodoc
class __$ActivityReflectionEntryCopyWithImpl<$Res>
    implements _$ActivityReflectionEntryCopyWith<$Res> {
  __$ActivityReflectionEntryCopyWithImpl(this._self, this._then);

  final _ActivityReflectionEntry _self;
  final $Res Function(_ActivityReflectionEntry) _then;

/// Create a copy of ActivityReflectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? effectiveness = freezed,Object? sleepHours = freezed,Object? notes = freezed,Object? raw = null,}) {
  return _then(_ActivityReflectionEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveness: freezed == effectiveness ? _self.effectiveness : effectiveness // ignore: cast_nullable_to_non_nullable
as int?,sleepHours: freezed == sleepHours ? _self.sleepHours : sleepHours // ignore: cast_nullable_to_non_nullable
as num?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,raw: null == raw ? _self._raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
