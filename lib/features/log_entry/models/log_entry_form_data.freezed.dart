// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_entry_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LogEntryFormData {

 bool get isSimpleMode; double get dose; String get unit; String get substance; String get route; List<String> get feelings; Map<String, List<String>> get secondaryFeelings; String get location; DateTime get date; int get hour; int get minute; String get notes; bool get isMedicalPurpose; double get cravingIntensity; String? get intention; List<String> get triggers; List<String> get bodySignals; String get entryId;// Substance details for ROA validation (loaded from DB)
 Map<String, dynamic>? get substanceDetails;
/// Create a copy of LogEntryFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogEntryFormDataCopyWith<LogEntryFormData> get copyWith => _$LogEntryFormDataCopyWithImpl<LogEntryFormData>(this as LogEntryFormData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogEntryFormData&&(identical(other.isSimpleMode, isSimpleMode) || other.isSimpleMode == isSimpleMode)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.substance, substance) || other.substance == substance)&&(identical(other.route, route) || other.route == route)&&const DeepCollectionEquality().equals(other.feelings, feelings)&&const DeepCollectionEquality().equals(other.secondaryFeelings, secondaryFeelings)&&(identical(other.location, location) || other.location == location)&&(identical(other.date, date) || other.date == date)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isMedicalPurpose, isMedicalPurpose) || other.isMedicalPurpose == isMedicalPurpose)&&(identical(other.cravingIntensity, cravingIntensity) || other.cravingIntensity == cravingIntensity)&&(identical(other.intention, intention) || other.intention == intention)&&const DeepCollectionEquality().equals(other.triggers, triggers)&&const DeepCollectionEquality().equals(other.bodySignals, bodySignals)&&(identical(other.entryId, entryId) || other.entryId == entryId)&&const DeepCollectionEquality().equals(other.substanceDetails, substanceDetails));
}


@override
int get hashCode => Object.hashAll([runtimeType,isSimpleMode,dose,unit,substance,route,const DeepCollectionEquality().hash(feelings),const DeepCollectionEquality().hash(secondaryFeelings),location,date,hour,minute,notes,isMedicalPurpose,cravingIntensity,intention,const DeepCollectionEquality().hash(triggers),const DeepCollectionEquality().hash(bodySignals),entryId,const DeepCollectionEquality().hash(substanceDetails)]);

@override
String toString() {
  return 'LogEntryFormData(isSimpleMode: $isSimpleMode, dose: $dose, unit: $unit, substance: $substance, route: $route, feelings: $feelings, secondaryFeelings: $secondaryFeelings, location: $location, date: $date, hour: $hour, minute: $minute, notes: $notes, isMedicalPurpose: $isMedicalPurpose, cravingIntensity: $cravingIntensity, intention: $intention, triggers: $triggers, bodySignals: $bodySignals, entryId: $entryId, substanceDetails: $substanceDetails)';
}


}

/// @nodoc
abstract mixin class $LogEntryFormDataCopyWith<$Res>  {
  factory $LogEntryFormDataCopyWith(LogEntryFormData value, $Res Function(LogEntryFormData) _then) = _$LogEntryFormDataCopyWithImpl;
@useResult
$Res call({
 bool isSimpleMode, double dose, String unit, String substance, String route, List<String> feelings, Map<String, List<String>> secondaryFeelings, String location, DateTime date, int hour, int minute, String notes, bool isMedicalPurpose, double cravingIntensity, String? intention, List<String> triggers, List<String> bodySignals, String entryId, Map<String, dynamic>? substanceDetails
});




}
/// @nodoc
class _$LogEntryFormDataCopyWithImpl<$Res>
    implements $LogEntryFormDataCopyWith<$Res> {
  _$LogEntryFormDataCopyWithImpl(this._self, this._then);

  final LogEntryFormData _self;
  final $Res Function(LogEntryFormData) _then;

/// Create a copy of LogEntryFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSimpleMode = null,Object? dose = null,Object? unit = null,Object? substance = null,Object? route = null,Object? feelings = null,Object? secondaryFeelings = null,Object? location = null,Object? date = null,Object? hour = null,Object? minute = null,Object? notes = null,Object? isMedicalPurpose = null,Object? cravingIntensity = null,Object? intention = freezed,Object? triggers = null,Object? bodySignals = null,Object? entryId = null,Object? substanceDetails = freezed,}) {
  return _then(_self.copyWith(
isSimpleMode: null == isSimpleMode ? _self.isSimpleMode : isSimpleMode // ignore: cast_nullable_to_non_nullable
as bool,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,substance: null == substance ? _self.substance : substance // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,feelings: null == feelings ? _self.feelings : feelings // ignore: cast_nullable_to_non_nullable
as List<String>,secondaryFeelings: null == secondaryFeelings ? _self.secondaryFeelings : secondaryFeelings // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,isMedicalPurpose: null == isMedicalPurpose ? _self.isMedicalPurpose : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
as bool,cravingIntensity: null == cravingIntensity ? _self.cravingIntensity : cravingIntensity // ignore: cast_nullable_to_non_nullable
as double,intention: freezed == intention ? _self.intention : intention // ignore: cast_nullable_to_non_nullable
as String?,triggers: null == triggers ? _self.triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<String>,bodySignals: null == bodySignals ? _self.bodySignals : bodySignals // ignore: cast_nullable_to_non_nullable
as List<String>,entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,substanceDetails: freezed == substanceDetails ? _self.substanceDetails : substanceDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [LogEntryFormData].
extension LogEntryFormDataPatterns on LogEntryFormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogEntryFormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogEntryFormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogEntryFormData value)  $default,){
final _that = this;
switch (_that) {
case _LogEntryFormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogEntryFormData value)?  $default,){
final _that = this;
switch (_that) {
case _LogEntryFormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSimpleMode,  double dose,  String unit,  String substance,  String route,  List<String> feelings,  Map<String, List<String>> secondaryFeelings,  String location,  DateTime date,  int hour,  int minute,  String notes,  bool isMedicalPurpose,  double cravingIntensity,  String? intention,  List<String> triggers,  List<String> bodySignals,  String entryId,  Map<String, dynamic>? substanceDetails)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogEntryFormData() when $default != null:
return $default(_that.isSimpleMode,_that.dose,_that.unit,_that.substance,_that.route,_that.feelings,_that.secondaryFeelings,_that.location,_that.date,_that.hour,_that.minute,_that.notes,_that.isMedicalPurpose,_that.cravingIntensity,_that.intention,_that.triggers,_that.bodySignals,_that.entryId,_that.substanceDetails);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSimpleMode,  double dose,  String unit,  String substance,  String route,  List<String> feelings,  Map<String, List<String>> secondaryFeelings,  String location,  DateTime date,  int hour,  int minute,  String notes,  bool isMedicalPurpose,  double cravingIntensity,  String? intention,  List<String> triggers,  List<String> bodySignals,  String entryId,  Map<String, dynamic>? substanceDetails)  $default,) {final _that = this;
switch (_that) {
case _LogEntryFormData():
return $default(_that.isSimpleMode,_that.dose,_that.unit,_that.substance,_that.route,_that.feelings,_that.secondaryFeelings,_that.location,_that.date,_that.hour,_that.minute,_that.notes,_that.isMedicalPurpose,_that.cravingIntensity,_that.intention,_that.triggers,_that.bodySignals,_that.entryId,_that.substanceDetails);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSimpleMode,  double dose,  String unit,  String substance,  String route,  List<String> feelings,  Map<String, List<String>> secondaryFeelings,  String location,  DateTime date,  int hour,  int minute,  String notes,  bool isMedicalPurpose,  double cravingIntensity,  String? intention,  List<String> triggers,  List<String> bodySignals,  String entryId,  Map<String, dynamic>? substanceDetails)?  $default,) {final _that = this;
switch (_that) {
case _LogEntryFormData() when $default != null:
return $default(_that.isSimpleMode,_that.dose,_that.unit,_that.substance,_that.route,_that.feelings,_that.secondaryFeelings,_that.location,_that.date,_that.hour,_that.minute,_that.notes,_that.isMedicalPurpose,_that.cravingIntensity,_that.intention,_that.triggers,_that.bodySignals,_that.entryId,_that.substanceDetails);case _:
  return null;

}
}

}

/// @nodoc


class _LogEntryFormData extends LogEntryFormData {
  const _LogEntryFormData({this.isSimpleMode = true, this.dose = 0, this.unit = 'mg', this.substance = '', this.route = 'oral', final  List<String> feelings = const [], final  Map<String, List<String>> secondaryFeelings = const {}, this.location = '', required this.date, required this.hour, required this.minute, this.notes = '', this.isMedicalPurpose = false, this.cravingIntensity = 0, this.intention, final  List<String> triggers = const [], final  List<String> bodySignals = const [], this.entryId = '', final  Map<String, dynamic>? substanceDetails}): _feelings = feelings,_secondaryFeelings = secondaryFeelings,_triggers = triggers,_bodySignals = bodySignals,_substanceDetails = substanceDetails,super._();
  

@override@JsonKey() final  bool isSimpleMode;
@override@JsonKey() final  double dose;
@override@JsonKey() final  String unit;
@override@JsonKey() final  String substance;
@override@JsonKey() final  String route;
 final  List<String> _feelings;
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

@override@JsonKey() final  String location;
@override final  DateTime date;
@override final  int hour;
@override final  int minute;
@override@JsonKey() final  String notes;
@override@JsonKey() final  bool isMedicalPurpose;
@override@JsonKey() final  double cravingIntensity;
@override final  String? intention;
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

@override@JsonKey() final  String entryId;
// Substance details for ROA validation (loaded from DB)
 final  Map<String, dynamic>? _substanceDetails;
// Substance details for ROA validation (loaded from DB)
@override Map<String, dynamic>? get substanceDetails {
  final value = _substanceDetails;
  if (value == null) return null;
  if (_substanceDetails is EqualUnmodifiableMapView) return _substanceDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of LogEntryFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogEntryFormDataCopyWith<_LogEntryFormData> get copyWith => __$LogEntryFormDataCopyWithImpl<_LogEntryFormData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogEntryFormData&&(identical(other.isSimpleMode, isSimpleMode) || other.isSimpleMode == isSimpleMode)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.substance, substance) || other.substance == substance)&&(identical(other.route, route) || other.route == route)&&const DeepCollectionEquality().equals(other._feelings, _feelings)&&const DeepCollectionEquality().equals(other._secondaryFeelings, _secondaryFeelings)&&(identical(other.location, location) || other.location == location)&&(identical(other.date, date) || other.date == date)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isMedicalPurpose, isMedicalPurpose) || other.isMedicalPurpose == isMedicalPurpose)&&(identical(other.cravingIntensity, cravingIntensity) || other.cravingIntensity == cravingIntensity)&&(identical(other.intention, intention) || other.intention == intention)&&const DeepCollectionEquality().equals(other._triggers, _triggers)&&const DeepCollectionEquality().equals(other._bodySignals, _bodySignals)&&(identical(other.entryId, entryId) || other.entryId == entryId)&&const DeepCollectionEquality().equals(other._substanceDetails, _substanceDetails));
}


@override
int get hashCode => Object.hashAll([runtimeType,isSimpleMode,dose,unit,substance,route,const DeepCollectionEquality().hash(_feelings),const DeepCollectionEquality().hash(_secondaryFeelings),location,date,hour,minute,notes,isMedicalPurpose,cravingIntensity,intention,const DeepCollectionEquality().hash(_triggers),const DeepCollectionEquality().hash(_bodySignals),entryId,const DeepCollectionEquality().hash(_substanceDetails)]);

@override
String toString() {
  return 'LogEntryFormData(isSimpleMode: $isSimpleMode, dose: $dose, unit: $unit, substance: $substance, route: $route, feelings: $feelings, secondaryFeelings: $secondaryFeelings, location: $location, date: $date, hour: $hour, minute: $minute, notes: $notes, isMedicalPurpose: $isMedicalPurpose, cravingIntensity: $cravingIntensity, intention: $intention, triggers: $triggers, bodySignals: $bodySignals, entryId: $entryId, substanceDetails: $substanceDetails)';
}


}

/// @nodoc
abstract mixin class _$LogEntryFormDataCopyWith<$Res> implements $LogEntryFormDataCopyWith<$Res> {
  factory _$LogEntryFormDataCopyWith(_LogEntryFormData value, $Res Function(_LogEntryFormData) _then) = __$LogEntryFormDataCopyWithImpl;
@override @useResult
$Res call({
 bool isSimpleMode, double dose, String unit, String substance, String route, List<String> feelings, Map<String, List<String>> secondaryFeelings, String location, DateTime date, int hour, int minute, String notes, bool isMedicalPurpose, double cravingIntensity, String? intention, List<String> triggers, List<String> bodySignals, String entryId, Map<String, dynamic>? substanceDetails
});




}
/// @nodoc
class __$LogEntryFormDataCopyWithImpl<$Res>
    implements _$LogEntryFormDataCopyWith<$Res> {
  __$LogEntryFormDataCopyWithImpl(this._self, this._then);

  final _LogEntryFormData _self;
  final $Res Function(_LogEntryFormData) _then;

/// Create a copy of LogEntryFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSimpleMode = null,Object? dose = null,Object? unit = null,Object? substance = null,Object? route = null,Object? feelings = null,Object? secondaryFeelings = null,Object? location = null,Object? date = null,Object? hour = null,Object? minute = null,Object? notes = null,Object? isMedicalPurpose = null,Object? cravingIntensity = null,Object? intention = freezed,Object? triggers = null,Object? bodySignals = null,Object? entryId = null,Object? substanceDetails = freezed,}) {
  return _then(_LogEntryFormData(
isSimpleMode: null == isSimpleMode ? _self.isSimpleMode : isSimpleMode // ignore: cast_nullable_to_non_nullable
as bool,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,substance: null == substance ? _self.substance : substance // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,feelings: null == feelings ? _self._feelings : feelings // ignore: cast_nullable_to_non_nullable
as List<String>,secondaryFeelings: null == secondaryFeelings ? _self._secondaryFeelings : secondaryFeelings // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,isMedicalPurpose: null == isMedicalPurpose ? _self.isMedicalPurpose : isMedicalPurpose // ignore: cast_nullable_to_non_nullable
as bool,cravingIntensity: null == cravingIntensity ? _self.cravingIntensity : cravingIntensity // ignore: cast_nullable_to_non_nullable
as double,intention: freezed == intention ? _self.intention : intention // ignore: cast_nullable_to_non_nullable
as String?,triggers: null == triggers ? _self._triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<String>,bodySignals: null == bodySignals ? _self._bodySignals : bodySignals // ignore: cast_nullable_to_non_nullable
as List<String>,entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,substanceDetails: freezed == substanceDetails ? _self._substanceDetails : substanceDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
