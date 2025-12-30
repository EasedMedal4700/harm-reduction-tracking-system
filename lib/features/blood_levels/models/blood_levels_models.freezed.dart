// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blood_levels_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoseEntry {

 double get dose; DateTime get startTime; double get remaining; double get hoursElapsed; double get percentRemaining;
/// Create a copy of DoseEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseEntryCopyWith<DoseEntry> get copyWith => _$DoseEntryCopyWithImpl<DoseEntry>(this as DoseEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseEntry&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.hoursElapsed, hoursElapsed) || other.hoursElapsed == hoursElapsed)&&(identical(other.percentRemaining, percentRemaining) || other.percentRemaining == percentRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,dose,startTime,remaining,hoursElapsed,percentRemaining);

@override
String toString() {
  return 'DoseEntry(dose: $dose, startTime: $startTime, remaining: $remaining, hoursElapsed: $hoursElapsed, percentRemaining: $percentRemaining)';
}


}

/// @nodoc
abstract mixin class $DoseEntryCopyWith<$Res>  {
  factory $DoseEntryCopyWith(DoseEntry value, $Res Function(DoseEntry) _then) = _$DoseEntryCopyWithImpl;
@useResult
$Res call({
 double dose, DateTime startTime, double remaining, double hoursElapsed, double percentRemaining
});




}
/// @nodoc
class _$DoseEntryCopyWithImpl<$Res>
    implements $DoseEntryCopyWith<$Res> {
  _$DoseEntryCopyWithImpl(this._self, this._then);

  final DoseEntry _self;
  final $Res Function(DoseEntry) _then;

/// Create a copy of DoseEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dose = null,Object? startTime = null,Object? remaining = null,Object? hoursElapsed = null,Object? percentRemaining = null,}) {
  return _then(_self.copyWith(
dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,hoursElapsed: null == hoursElapsed ? _self.hoursElapsed : hoursElapsed // ignore: cast_nullable_to_non_nullable
as double,percentRemaining: null == percentRemaining ? _self.percentRemaining : percentRemaining // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DoseEntry].
extension DoseEntryPatterns on DoseEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoseEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoseEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoseEntry value)  $default,){
final _that = this;
switch (_that) {
case _DoseEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoseEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DoseEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double dose,  DateTime startTime,  double remaining,  double hoursElapsed,  double percentRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoseEntry() when $default != null:
return $default(_that.dose,_that.startTime,_that.remaining,_that.hoursElapsed,_that.percentRemaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double dose,  DateTime startTime,  double remaining,  double hoursElapsed,  double percentRemaining)  $default,) {final _that = this;
switch (_that) {
case _DoseEntry():
return $default(_that.dose,_that.startTime,_that.remaining,_that.hoursElapsed,_that.percentRemaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double dose,  DateTime startTime,  double remaining,  double hoursElapsed,  double percentRemaining)?  $default,) {final _that = this;
switch (_that) {
case _DoseEntry() when $default != null:
return $default(_that.dose,_that.startTime,_that.remaining,_that.hoursElapsed,_that.percentRemaining);case _:
  return null;

}
}

}

/// @nodoc


class _DoseEntry implements DoseEntry {
  const _DoseEntry({required this.dose, required this.startTime, required this.remaining, required this.hoursElapsed, this.percentRemaining = 0.0});
  

@override final  double dose;
@override final  DateTime startTime;
@override final  double remaining;
@override final  double hoursElapsed;
@override@JsonKey() final  double percentRemaining;

/// Create a copy of DoseEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoseEntryCopyWith<_DoseEntry> get copyWith => __$DoseEntryCopyWithImpl<_DoseEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoseEntry&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.hoursElapsed, hoursElapsed) || other.hoursElapsed == hoursElapsed)&&(identical(other.percentRemaining, percentRemaining) || other.percentRemaining == percentRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,dose,startTime,remaining,hoursElapsed,percentRemaining);

@override
String toString() {
  return 'DoseEntry(dose: $dose, startTime: $startTime, remaining: $remaining, hoursElapsed: $hoursElapsed, percentRemaining: $percentRemaining)';
}


}

/// @nodoc
abstract mixin class _$DoseEntryCopyWith<$Res> implements $DoseEntryCopyWith<$Res> {
  factory _$DoseEntryCopyWith(_DoseEntry value, $Res Function(_DoseEntry) _then) = __$DoseEntryCopyWithImpl;
@override @useResult
$Res call({
 double dose, DateTime startTime, double remaining, double hoursElapsed, double percentRemaining
});




}
/// @nodoc
class __$DoseEntryCopyWithImpl<$Res>
    implements _$DoseEntryCopyWith<$Res> {
  __$DoseEntryCopyWithImpl(this._self, this._then);

  final _DoseEntry _self;
  final $Res Function(_DoseEntry) _then;

/// Create a copy of DoseEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dose = null,Object? startTime = null,Object? remaining = null,Object? hoursElapsed = null,Object? percentRemaining = null,}) {
  return _then(_DoseEntry(
dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,hoursElapsed: null == hoursElapsed ? _self.hoursElapsed : hoursElapsed // ignore: cast_nullable_to_non_nullable
as double,percentRemaining: null == percentRemaining ? _self.percentRemaining : percentRemaining // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$DrugLevel {

 String get drugName; double get totalDose; double get totalRemaining; double get lastDose; DateTime get lastUse; double get halfLife; List<DoseEntry> get doses; double get activeWindow; double get maxDuration; List<String> get categories; Map<String, dynamic>? get formattedDose;
/// Create a copy of DrugLevel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugLevelCopyWith<DrugLevel> get copyWith => _$DrugLevelCopyWithImpl<DrugLevel>(this as DrugLevel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrugLevel&&(identical(other.drugName, drugName) || other.drugName == drugName)&&(identical(other.totalDose, totalDose) || other.totalDose == totalDose)&&(identical(other.totalRemaining, totalRemaining) || other.totalRemaining == totalRemaining)&&(identical(other.lastDose, lastDose) || other.lastDose == lastDose)&&(identical(other.lastUse, lastUse) || other.lastUse == lastUse)&&(identical(other.halfLife, halfLife) || other.halfLife == halfLife)&&const DeepCollectionEquality().equals(other.doses, doses)&&(identical(other.activeWindow, activeWindow) || other.activeWindow == activeWindow)&&(identical(other.maxDuration, maxDuration) || other.maxDuration == maxDuration)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.formattedDose, formattedDose));
}


@override
int get hashCode => Object.hash(runtimeType,drugName,totalDose,totalRemaining,lastDose,lastUse,halfLife,const DeepCollectionEquality().hash(doses),activeWindow,maxDuration,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(formattedDose));

@override
String toString() {
  return 'DrugLevel(drugName: $drugName, totalDose: $totalDose, totalRemaining: $totalRemaining, lastDose: $lastDose, lastUse: $lastUse, halfLife: $halfLife, doses: $doses, activeWindow: $activeWindow, maxDuration: $maxDuration, categories: $categories, formattedDose: $formattedDose)';
}


}

/// @nodoc
abstract mixin class $DrugLevelCopyWith<$Res>  {
  factory $DrugLevelCopyWith(DrugLevel value, $Res Function(DrugLevel) _then) = _$DrugLevelCopyWithImpl;
@useResult
$Res call({
 String drugName, double totalDose, double totalRemaining, double lastDose, DateTime lastUse, double halfLife, List<DoseEntry> doses, double activeWindow, double maxDuration, List<String> categories, Map<String, dynamic>? formattedDose
});




}
/// @nodoc
class _$DrugLevelCopyWithImpl<$Res>
    implements $DrugLevelCopyWith<$Res> {
  _$DrugLevelCopyWithImpl(this._self, this._then);

  final DrugLevel _self;
  final $Res Function(DrugLevel) _then;

/// Create a copy of DrugLevel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drugName = null,Object? totalDose = null,Object? totalRemaining = null,Object? lastDose = null,Object? lastUse = null,Object? halfLife = null,Object? doses = null,Object? activeWindow = null,Object? maxDuration = null,Object? categories = null,Object? formattedDose = freezed,}) {
  return _then(_self.copyWith(
drugName: null == drugName ? _self.drugName : drugName // ignore: cast_nullable_to_non_nullable
as String,totalDose: null == totalDose ? _self.totalDose : totalDose // ignore: cast_nullable_to_non_nullable
as double,totalRemaining: null == totalRemaining ? _self.totalRemaining : totalRemaining // ignore: cast_nullable_to_non_nullable
as double,lastDose: null == lastDose ? _self.lastDose : lastDose // ignore: cast_nullable_to_non_nullable
as double,lastUse: null == lastUse ? _self.lastUse : lastUse // ignore: cast_nullable_to_non_nullable
as DateTime,halfLife: null == halfLife ? _self.halfLife : halfLife // ignore: cast_nullable_to_non_nullable
as double,doses: null == doses ? _self.doses : doses // ignore: cast_nullable_to_non_nullable
as List<DoseEntry>,activeWindow: null == activeWindow ? _self.activeWindow : activeWindow // ignore: cast_nullable_to_non_nullable
as double,maxDuration: null == maxDuration ? _self.maxDuration : maxDuration // ignore: cast_nullable_to_non_nullable
as double,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,formattedDose: freezed == formattedDose ? _self.formattedDose : formattedDose // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [DrugLevel].
extension DrugLevelPatterns on DrugLevel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrugLevel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrugLevel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrugLevel value)  $default,){
final _that = this;
switch (_that) {
case _DrugLevel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrugLevel value)?  $default,){
final _that = this;
switch (_that) {
case _DrugLevel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String drugName,  double totalDose,  double totalRemaining,  double lastDose,  DateTime lastUse,  double halfLife,  List<DoseEntry> doses,  double activeWindow,  double maxDuration,  List<String> categories,  Map<String, dynamic>? formattedDose)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrugLevel() when $default != null:
return $default(_that.drugName,_that.totalDose,_that.totalRemaining,_that.lastDose,_that.lastUse,_that.halfLife,_that.doses,_that.activeWindow,_that.maxDuration,_that.categories,_that.formattedDose);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String drugName,  double totalDose,  double totalRemaining,  double lastDose,  DateTime lastUse,  double halfLife,  List<DoseEntry> doses,  double activeWindow,  double maxDuration,  List<String> categories,  Map<String, dynamic>? formattedDose)  $default,) {final _that = this;
switch (_that) {
case _DrugLevel():
return $default(_that.drugName,_that.totalDose,_that.totalRemaining,_that.lastDose,_that.lastUse,_that.halfLife,_that.doses,_that.activeWindow,_that.maxDuration,_that.categories,_that.formattedDose);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String drugName,  double totalDose,  double totalRemaining,  double lastDose,  DateTime lastUse,  double halfLife,  List<DoseEntry> doses,  double activeWindow,  double maxDuration,  List<String> categories,  Map<String, dynamic>? formattedDose)?  $default,) {final _that = this;
switch (_that) {
case _DrugLevel() when $default != null:
return $default(_that.drugName,_that.totalDose,_that.totalRemaining,_that.lastDose,_that.lastUse,_that.halfLife,_that.doses,_that.activeWindow,_that.maxDuration,_that.categories,_that.formattedDose);case _:
  return null;

}
}

}

/// @nodoc


class _DrugLevel extends DrugLevel {
  const _DrugLevel({required this.drugName, required this.totalDose, required this.totalRemaining, required this.lastDose, required this.lastUse, required this.halfLife, required final  List<DoseEntry> doses, this.activeWindow = 8.0, this.maxDuration = 6.0, final  List<String> categories = const <String>[], final  Map<String, dynamic>? formattedDose}): _doses = doses,_categories = categories,_formattedDose = formattedDose,super._();
  

@override final  String drugName;
@override final  double totalDose;
@override final  double totalRemaining;
@override final  double lastDose;
@override final  DateTime lastUse;
@override final  double halfLife;
 final  List<DoseEntry> _doses;
@override List<DoseEntry> get doses {
  if (_doses is EqualUnmodifiableListView) return _doses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_doses);
}

@override@JsonKey() final  double activeWindow;
@override@JsonKey() final  double maxDuration;
 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  Map<String, dynamic>? _formattedDose;
@override Map<String, dynamic>? get formattedDose {
  final value = _formattedDose;
  if (value == null) return null;
  if (_formattedDose is EqualUnmodifiableMapView) return _formattedDose;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of DrugLevel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugLevelCopyWith<_DrugLevel> get copyWith => __$DrugLevelCopyWithImpl<_DrugLevel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrugLevel&&(identical(other.drugName, drugName) || other.drugName == drugName)&&(identical(other.totalDose, totalDose) || other.totalDose == totalDose)&&(identical(other.totalRemaining, totalRemaining) || other.totalRemaining == totalRemaining)&&(identical(other.lastDose, lastDose) || other.lastDose == lastDose)&&(identical(other.lastUse, lastUse) || other.lastUse == lastUse)&&(identical(other.halfLife, halfLife) || other.halfLife == halfLife)&&const DeepCollectionEquality().equals(other._doses, _doses)&&(identical(other.activeWindow, activeWindow) || other.activeWindow == activeWindow)&&(identical(other.maxDuration, maxDuration) || other.maxDuration == maxDuration)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._formattedDose, _formattedDose));
}


@override
int get hashCode => Object.hash(runtimeType,drugName,totalDose,totalRemaining,lastDose,lastUse,halfLife,const DeepCollectionEquality().hash(_doses),activeWindow,maxDuration,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_formattedDose));

@override
String toString() {
  return 'DrugLevel(drugName: $drugName, totalDose: $totalDose, totalRemaining: $totalRemaining, lastDose: $lastDose, lastUse: $lastUse, halfLife: $halfLife, doses: $doses, activeWindow: $activeWindow, maxDuration: $maxDuration, categories: $categories, formattedDose: $formattedDose)';
}


}

/// @nodoc
abstract mixin class _$DrugLevelCopyWith<$Res> implements $DrugLevelCopyWith<$Res> {
  factory _$DrugLevelCopyWith(_DrugLevel value, $Res Function(_DrugLevel) _then) = __$DrugLevelCopyWithImpl;
@override @useResult
$Res call({
 String drugName, double totalDose, double totalRemaining, double lastDose, DateTime lastUse, double halfLife, List<DoseEntry> doses, double activeWindow, double maxDuration, List<String> categories, Map<String, dynamic>? formattedDose
});




}
/// @nodoc
class __$DrugLevelCopyWithImpl<$Res>
    implements _$DrugLevelCopyWith<$Res> {
  __$DrugLevelCopyWithImpl(this._self, this._then);

  final _DrugLevel _self;
  final $Res Function(_DrugLevel) _then;

/// Create a copy of DrugLevel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drugName = null,Object? totalDose = null,Object? totalRemaining = null,Object? lastDose = null,Object? lastUse = null,Object? halfLife = null,Object? doses = null,Object? activeWindow = null,Object? maxDuration = null,Object? categories = null,Object? formattedDose = freezed,}) {
  return _then(_DrugLevel(
drugName: null == drugName ? _self.drugName : drugName // ignore: cast_nullable_to_non_nullable
as String,totalDose: null == totalDose ? _self.totalDose : totalDose // ignore: cast_nullable_to_non_nullable
as double,totalRemaining: null == totalRemaining ? _self.totalRemaining : totalRemaining // ignore: cast_nullable_to_non_nullable
as double,lastDose: null == lastDose ? _self.lastDose : lastDose // ignore: cast_nullable_to_non_nullable
as double,lastUse: null == lastUse ? _self.lastUse : lastUse // ignore: cast_nullable_to_non_nullable
as DateTime,halfLife: null == halfLife ? _self.halfLife : halfLife // ignore: cast_nullable_to_non_nullable
as double,doses: null == doses ? _self._doses : doses // ignore: cast_nullable_to_non_nullable
as List<DoseEntry>,activeWindow: null == activeWindow ? _self.activeWindow : activeWindow // ignore: cast_nullable_to_non_nullable
as double,maxDuration: null == maxDuration ? _self.maxDuration : maxDuration // ignore: cast_nullable_to_non_nullable
as double,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,formattedDose: freezed == formattedDose ? _self._formattedDose : formattedDose // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
