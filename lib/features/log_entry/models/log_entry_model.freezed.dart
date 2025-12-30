// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LogEntry {

 String? get id;// use_id or id
 String get substance; double get dosage; String get unit; String get route; DateTime get datetime; String? get notes; int get timeDifferenceMinutes; String? get timezone;// raw tz value if present
 List<String> get feelings; Map<String, List<String>> get secondaryFeelings; List<String> get triggers; List<String> get bodySignals; String get location; bool get isMedicalPurpose; double get cravingIntensity; String? get intention; double get timezoneOffset;// parsed offset (e.g., hours)
 List<String> get people;
/// Create a copy of LogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogEntryCopyWith<LogEntry> get copyWith => _$LogEntryCopyWithImpl<LogEntry>(this as LogEntry, _$identity);

  /// Serializes this LogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.substance, substance) || other.substance == substance)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.route, route) || other.route == route)&&(identical(other.datetime, datetime) || other.datetime == datetime)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.timeDifferenceMinutes, timeDifferenceMinutes) || other.timeDifferenceMinutes == timeDifferenceMinutes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other.feelings, feelings)&&const DeepCollectionEquality().equals(other.secondaryFeelings, secondaryFeelings)&&const DeepCollectionEquality().equals(other.triggers, triggers)&&const DeepCollectionEquality().equals(other.bodySignals, bodySignals)&&(identical(other.location, location) || other.location == location)&&(identical(other.isMedicalPurpose, isMedicalPurpose) || other.isMedicalPurpose == isMedicalPurpose)&&(identical(other.cravingIntensity, cravingIntensity) || other.cravingIntensity == cravingIntensity)&&(identical(other.intention, intention) || other.intention == intention)&&(identical(other.timezoneOffset, timezoneOffset) || other.timezoneOffset == timezoneOffset)&&const DeepCollectionEquality().equals(other.people, people));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,substance,dosage,unit,route,datetime,notes,timeDifferenceMinutes,timezone,const DeepCollectionEquality().hash(feelings),const DeepCollectionEquality().hash(secondaryFeelings),const DeepCollectionEquality().hash(triggers),const DeepCollectionEquality().hash(bodySignals),location,isMedicalPurpose,cravingIntensity,intention,timezoneOffset,const DeepCollectionEquality().hash(people)]);

@override
String toString() {
  return 'LogEntry(id: $id, substance: $substance, dosage: $dosage, unit: $unit, route: $route, datetime: $datetime, notes: $notes, timeDifferenceMinutes: $timeDifferenceMinutes, timezone: $timezone, feelings: $feelings, secondaryFeelings: $secondaryFeelings, triggers: $triggers, bodySignals: $bodySignals, location: $location, isMedicalPurpose: $isMedicalPurpose, cravingIntensity: $cravingIntensity, intention: $intention, timezoneOffset: $timezoneOffset, people: $people)';
}


}

/// @nodoc
abstract mixin class $LogEntryCopyWith<$Res>  {
  factory $LogEntryCopyWith(LogEntry value, $Res Function(LogEntry) _then) = _$LogEntryCopyWithImpl;
@useResult
$Res call({
 String? id, String substance, double dosage, String unit, String route, DateTime datetime, String? notes, int timeDifferenceMinutes, String? timezone, List<String> feelings, Map<String, List<String>> secondaryFeelings, List<String> triggers, List<String> bodySignals, String location, bool isMedicalPurpose, double cravingIntensity, String? intention, double timezoneOffset, List<String> people
});




}
/// @nodoc
class _$LogEntryCopyWithImpl<$Res>
    implements $LogEntryCopyWith<$Res> {
  _$LogEntryCopyWithImpl(this._self, this._then);

  final LogEntry _self;
  final $Res Function(LogEntry) _then;

/// Create a copy of LogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? substance = null,Object? dosage = null,Object? unit = null,Object? route = null,Object? datetime = null,Object? notes = freezed,Object? timeDifferenceMinutes = null,Object? timezone = freezed,Object? feelings = null,Object? secondaryFeelings = null,Object? triggers = null,Object? bodySignals = null,Object? location = null,Object? isMedicalPurpose = null,Object? cravingIntensity = null,Object? intention = freezed,Object? timezoneOffset = null,Object? people = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,substance: null == substance ? _self.substance : substance // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,datetime: null == datetime ? _self.datetime : datetime // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,timeDifferenceMinutes: null == timeDifferenceMinutes ? _self.timeDifferenceMinutes : timeDifferenceMinutes // ignore: cast_nullable_to_non_nullable
as int,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,feelings: null == feelings ? _self.feelings : feelings // ignore: cast_nullable_to_non_nullable
as List<String>,secondaryFeelings: null == secondaryFeelings ? _self.secondaryFeelings : secondaryFeelings // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,triggers: null == triggers ? _self.triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<String>,bodySignals: null == bodySignals ? _self.bodySignals : bodySignals // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,isMedicalPurpose: null == isMedicalPurpose ? _self.isMedicalPurpose : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
as bool,cravingIntensity: null == cravingIntensity ? _self.cravingIntensity : cravingIntensity // ignore: cast_nullable_to_non_nullable
as double,intention: freezed == intention ? _self.intention : intention // ignore: cast_nullable_to_non_nullable
as String?,timezoneOffset: null == timezoneOffset ? _self.timezoneOffset : timezoneOffset // ignore: cast_nullable_to_non_nullable
as double,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LogEntry].
extension LogEntryPatterns on LogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogEntry value)  $default,){
final _that = this;
switch (_that) {
case _LogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String substance,  double dosage,  String unit,  String route,  DateTime datetime,  String? notes,  int timeDifferenceMinutes,  String? timezone,  List<String> feelings,  Map<String, List<String>> secondaryFeelings,  List<String> triggers,  List<String> bodySignals,  String location,  bool isMedicalPurpose,  double cravingIntensity,  String? intention,  double timezoneOffset,  List<String> people)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogEntry() when $default != null:
return $default(_that.id,_that.substance,_that.dosage,_that.unit,_that.route,_that.datetime,_that.notes,_that.timeDifferenceMinutes,_that.timezone,_that.feelings,_that.secondaryFeelings,_that.triggers,_that.bodySignals,_that.location,_that.isMedicalPurpose,_that.cravingIntensity,_that.intention,_that.timezoneOffset,_that.people);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String substance,  double dosage,  String unit,  String route,  DateTime datetime,  String? notes,  int timeDifferenceMinutes,  String? timezone,  List<String> feelings,  Map<String, List<String>> secondaryFeelings,  List<String> triggers,  List<String> bodySignals,  String location,  bool isMedicalPurpose,  double cravingIntensity,  String? intention,  double timezoneOffset,  List<String> people)  $default,) {final _that = this;
switch (_that) {
case _LogEntry():
return $default(_that.id,_that.substance,_that.dosage,_that.unit,_that.route,_that.datetime,_that.notes,_that.timeDifferenceMinutes,_that.timezone,_that.feelings,_that.secondaryFeelings,_that.triggers,_that.bodySignals,_that.location,_that.isMedicalPurpose,_that.cravingIntensity,_that.intention,_that.timezoneOffset,_that.people);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String substance,  double dosage,  String unit,  String route,  DateTime datetime,  String? notes,  int timeDifferenceMinutes,  String? timezone,  List<String> feelings,  Map<String, List<String>> secondaryFeelings,  List<String> triggers,  List<String> bodySignals,  String location,  bool isMedicalPurpose,  double cravingIntensity,  String? intention,  double timezoneOffset,  List<String> people)?  $default,) {final _that = this;
switch (_that) {
case _LogEntry() when $default != null:
return $default(_that.id,_that.substance,_that.dosage,_that.unit,_that.route,_that.datetime,_that.notes,_that.timeDifferenceMinutes,_that.timezone,_that.feelings,_that.secondaryFeelings,_that.triggers,_that.bodySignals,_that.location,_that.isMedicalPurpose,_that.cravingIntensity,_that.intention,_that.timezoneOffset,_that.people);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LogEntry extends LogEntry {
  const _LogEntry({this.id, required this.substance, required this.dosage, required this.unit, required this.route, required this.datetime, this.notes, this.timeDifferenceMinutes = 0, this.timezone, final  List<String> feelings = const [], final  Map<String, List<String>> secondaryFeelings = const {}, final  List<String> triggers = const [], final  List<String> bodySignals = const [], this.location = '', this.isMedicalPurpose = false, this.cravingIntensity = 0.0, this.intention, this.timezoneOffset = 0.0, final  List<String> people = const []}): _feelings = feelings,_secondaryFeelings = secondaryFeelings,_triggers = triggers,_bodySignals = bodySignals,_people = people,super._();
  factory _LogEntry.fromJson(Map<String, dynamic> json) => _$LogEntryFromJson(json);

@override final  String? id;
// use_id or id
@override final  String substance;
@override final  double dosage;
@override final  String unit;
@override final  String route;
@override final  DateTime datetime;
@override final  String? notes;
@override@JsonKey() final  int timeDifferenceMinutes;
@override final  String? timezone;
// raw tz value if present
 final  List<String> _feelings;
// raw tz value if present
@override@JsonKey() List<String> get feelings {
  if (_feelings is EqualUnmodifiableListView) return _feelings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feelings);
}

 final  Map<String, List<String>> _secondaryFeelings;
@override@JsonKey() Map<String, List<String>> get secondaryFeelings {
  if (_secondaryFeelings is EqualUnmodifiableMapView) return _secondaryFeelings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_secondaryFeelings);
}

 final  List<String> _triggers;
@override@JsonKey() List<String> get triggers {
  if (_triggers is EqualUnmodifiableListView) return _triggers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_triggers);
}

 final  List<String> _bodySignals;
@override@JsonKey() List<String> get bodySignals {
  if (_bodySignals is EqualUnmodifiableListView) return _bodySignals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bodySignals);
}

@override@JsonKey() final  String location;
@override@JsonKey() final  bool isMedicalPurpose;
@override@JsonKey() final  double cravingIntensity;
@override final  String? intention;
@override@JsonKey() final  double timezoneOffset;
// parsed offset (e.g., hours)
 final  List<String> _people;
// parsed offset (e.g., hours)
@override@JsonKey() List<String> get people {
  if (_people is EqualUnmodifiableListView) return _people;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_people);
}


/// Create a copy of LogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogEntryCopyWith<_LogEntry> get copyWith => __$LogEntryCopyWithImpl<_LogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.substance, substance) || other.substance == substance)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.route, route) || other.route == route)&&(identical(other.datetime, datetime) || other.datetime == datetime)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.timeDifferenceMinutes, timeDifferenceMinutes) || other.timeDifferenceMinutes == timeDifferenceMinutes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other._feelings, _feelings)&&const DeepCollectionEquality().equals(other._secondaryFeelings, _secondaryFeelings)&&const DeepCollectionEquality().equals(other._triggers, _triggers)&&const DeepCollectionEquality().equals(other._bodySignals, _bodySignals)&&(identical(other.location, location) || other.location == location)&&(identical(other.isMedicalPurpose, isMedicalPurpose) || other.isMedicalPurpose == isMedicalPurpose)&&(identical(other.cravingIntensity, cravingIntensity) || other.cravingIntensity == cravingIntensity)&&(identical(other.intention, intention) || other.intention == intention)&&(identical(other.timezoneOffset, timezoneOffset) || other.timezoneOffset == timezoneOffset)&&const DeepCollectionEquality().equals(other._people, _people));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,substance,dosage,unit,route,datetime,notes,timeDifferenceMinutes,timezone,const DeepCollectionEquality().hash(_feelings),const DeepCollectionEquality().hash(_secondaryFeelings),const DeepCollectionEquality().hash(_triggers),const DeepCollectionEquality().hash(_bodySignals),location,isMedicalPurpose,cravingIntensity,intention,timezoneOffset,const DeepCollectionEquality().hash(_people)]);

@override
String toString() {
  return 'LogEntry(id: $id, substance: $substance, dosage: $dosage, unit: $unit, route: $route, datetime: $datetime, notes: $notes, timeDifferenceMinutes: $timeDifferenceMinutes, timezone: $timezone, feelings: $feelings, secondaryFeelings: $secondaryFeelings, triggers: $triggers, bodySignals: $bodySignals, location: $location, isMedicalPurpose: $isMedicalPurpose, cravingIntensity: $cravingIntensity, intention: $intention, timezoneOffset: $timezoneOffset, people: $people)';
}


}

/// @nodoc
abstract mixin class _$LogEntryCopyWith<$Res> implements $LogEntryCopyWith<$Res> {
  factory _$LogEntryCopyWith(_LogEntry value, $Res Function(_LogEntry) _then) = __$LogEntryCopyWithImpl;
@override @useResult
$Res call({
 String? id, String substance, double dosage, String unit, String route, DateTime datetime, String? notes, int timeDifferenceMinutes, String? timezone, List<String> feelings, Map<String, List<String>> secondaryFeelings, List<String> triggers, List<String> bodySignals, String location, bool isMedicalPurpose, double cravingIntensity, String? intention, double timezoneOffset, List<String> people
});




}
/// @nodoc
class __$LogEntryCopyWithImpl<$Res>
    implements _$LogEntryCopyWith<$Res> {
  __$LogEntryCopyWithImpl(this._self, this._then);

  final _LogEntry _self;
  final $Res Function(_LogEntry) _then;

/// Create a copy of LogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? substance = null,Object? dosage = null,Object? unit = null,Object? route = null,Object? datetime = null,Object? notes = freezed,Object? timeDifferenceMinutes = null,Object? timezone = freezed,Object? feelings = null,Object? secondaryFeelings = null,Object? triggers = null,Object? bodySignals = null,Object? location = null,Object? isMedicalPurpose = null,Object? cravingIntensity = null,Object? intention = freezed,Object? timezoneOffset = null,Object? people = null,}) {
  return _then(_LogEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,substance: null == substance ? _self.substance : substance // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,datetime: null == datetime ? _self.datetime : datetime // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,timeDifferenceMinutes: null == timeDifferenceMinutes ? _self.timeDifferenceMinutes : timeDifferenceMinutes // ignore: cast_nullable_to_non_nullable
as int,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,feelings: null == feelings ? _self._feelings : feelings // ignore: cast_nullable_to_non_nullable
as List<String>,secondaryFeelings: null == secondaryFeelings ? _self._secondaryFeelings : secondaryFeelings // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,triggers: null == triggers ? _self._triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<String>,bodySignals: null == bodySignals ? _self._bodySignals : bodySignals // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,isMedicalPurpose: null == isMedicalPurpose ? _self.isMedicalPurpose : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
as bool,cravingIntensity: null == cravingIntensity ? _self.cravingIntensity : cravingIntensity // ignore: cast_nullable_to_non_nullable
as double,intention: freezed == intention ? _self.intention : intention // ignore: cast_nullable_to_non_nullable
as String?,timezoneOffset: null == timezoneOffset ? _self.timezoneOffset : timezoneOffset // ignore: cast_nullable_to_non_nullable
as double,people: null == people ? _self._people : people // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
