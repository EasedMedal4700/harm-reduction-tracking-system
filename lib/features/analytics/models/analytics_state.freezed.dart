// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsState {

 bool get isLoading; List<LogEntry> get entries; Map<String, String> get substanceToCategory; TimePeriod get selectedPeriod; List<String> get selectedCategories; int get selectedTypeIndex; List<String> get selectedSubstances; List<String> get selectedPlaces; List<String> get selectedRoutes; List<String> get selectedFeelings; double get minCraving; double get maxCraving; String? get errorMessage; String? get errorDetails;
/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsStateCopyWith<AnalyticsState> get copyWith => _$AnalyticsStateCopyWithImpl<AnalyticsState>(this as AnalyticsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.entries, entries)&&const DeepCollectionEquality().equals(other.substanceToCategory, substanceToCategory)&&(identical(other.selectedPeriod, selectedPeriod) || other.selectedPeriod == selectedPeriod)&&const DeepCollectionEquality().equals(other.selectedCategories, selectedCategories)&&(identical(other.selectedTypeIndex, selectedTypeIndex) || other.selectedTypeIndex == selectedTypeIndex)&&const DeepCollectionEquality().equals(other.selectedSubstances, selectedSubstances)&&const DeepCollectionEquality().equals(other.selectedPlaces, selectedPlaces)&&const DeepCollectionEquality().equals(other.selectedRoutes, selectedRoutes)&&const DeepCollectionEquality().equals(other.selectedFeelings, selectedFeelings)&&(identical(other.minCraving, minCraving) || other.minCraving == minCraving)&&(identical(other.maxCraving, maxCraving) || other.maxCraving == maxCraving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorDetails, errorDetails) || other.errorDetails == errorDetails));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(entries),const DeepCollectionEquality().hash(substanceToCategory),selectedPeriod,const DeepCollectionEquality().hash(selectedCategories),selectedTypeIndex,const DeepCollectionEquality().hash(selectedSubstances),const DeepCollectionEquality().hash(selectedPlaces),const DeepCollectionEquality().hash(selectedRoutes),const DeepCollectionEquality().hash(selectedFeelings),minCraving,maxCraving,errorMessage,errorDetails);

@override
String toString() {
  return 'AnalyticsState(isLoading: $isLoading, entries: $entries, substanceToCategory: $substanceToCategory, selectedPeriod: $selectedPeriod, selectedCategories: $selectedCategories, selectedTypeIndex: $selectedTypeIndex, selectedSubstances: $selectedSubstances, selectedPlaces: $selectedPlaces, selectedRoutes: $selectedRoutes, selectedFeelings: $selectedFeelings, minCraving: $minCraving, maxCraving: $maxCraving, errorMessage: $errorMessage, errorDetails: $errorDetails)';
}


}

/// @nodoc
abstract mixin class $AnalyticsStateCopyWith<$Res>  {
  factory $AnalyticsStateCopyWith(AnalyticsState value, $Res Function(AnalyticsState) _then) = _$AnalyticsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<LogEntry> entries, Map<String, String> substanceToCategory, TimePeriod selectedPeriod, List<String> selectedCategories, int selectedTypeIndex, List<String> selectedSubstances, List<String> selectedPlaces, List<String> selectedRoutes, List<String> selectedFeelings, double minCraving, double maxCraving, String? errorMessage, String? errorDetails
});




}
/// @nodoc
class _$AnalyticsStateCopyWithImpl<$Res>
    implements $AnalyticsStateCopyWith<$Res> {
  _$AnalyticsStateCopyWithImpl(this._self, this._then);

  final AnalyticsState _self;
  final $Res Function(AnalyticsState) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? entries = null,Object? substanceToCategory = null,Object? selectedPeriod = null,Object? selectedCategories = null,Object? selectedTypeIndex = null,Object? selectedSubstances = null,Object? selectedPlaces = null,Object? selectedRoutes = null,Object? selectedFeelings = null,Object? minCraving = null,Object? maxCraving = null,Object? errorMessage = freezed,Object? errorDetails = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<LogEntry>,substanceToCategory: null == substanceToCategory ? _self.substanceToCategory : substanceToCategory // ignore: cast_nullable_to_non_nullable
as Map<String, String>,selectedPeriod: null == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as TimePeriod,selectedCategories: null == selectedCategories ? _self.selectedCategories : selectedCategories // ignore: cast_nullable_to_non_nullable
as List<String>,selectedTypeIndex: null == selectedTypeIndex ? _self.selectedTypeIndex : selectedTypeIndex // ignore: cast_nullable_to_non_nullable
as int,selectedSubstances: null == selectedSubstances ? _self.selectedSubstances : selectedSubstances // ignore: cast_nullable_to_non_nullable
as List<String>,selectedPlaces: null == selectedPlaces ? _self.selectedPlaces : selectedPlaces // ignore: cast_nullable_to_non_nullable
as List<String>,selectedRoutes: null == selectedRoutes ? _self.selectedRoutes : selectedRoutes // ignore: cast_nullable_to_non_nullable
as List<String>,selectedFeelings: null == selectedFeelings ? _self.selectedFeelings : selectedFeelings // ignore: cast_nullable_to_non_nullable
as List<String>,minCraving: null == minCraving ? _self.minCraving : minCraving // ignore: cast_nullable_to_non_nullable
as double,maxCraving: null == maxCraving ? _self.maxCraving : maxCraving // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorDetails: freezed == errorDetails ? _self.errorDetails : errorDetails // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsState].
extension AnalyticsStatePatterns on AnalyticsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsState value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsState value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<LogEntry> entries,  Map<String, String> substanceToCategory,  TimePeriod selectedPeriod,  List<String> selectedCategories,  int selectedTypeIndex,  List<String> selectedSubstances,  List<String> selectedPlaces,  List<String> selectedRoutes,  List<String> selectedFeelings,  double minCraving,  double maxCraving,  String? errorMessage,  String? errorDetails)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
return $default(_that.isLoading,_that.entries,_that.substanceToCategory,_that.selectedPeriod,_that.selectedCategories,_that.selectedTypeIndex,_that.selectedSubstances,_that.selectedPlaces,_that.selectedRoutes,_that.selectedFeelings,_that.minCraving,_that.maxCraving,_that.errorMessage,_that.errorDetails);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<LogEntry> entries,  Map<String, String> substanceToCategory,  TimePeriod selectedPeriod,  List<String> selectedCategories,  int selectedTypeIndex,  List<String> selectedSubstances,  List<String> selectedPlaces,  List<String> selectedRoutes,  List<String> selectedFeelings,  double minCraving,  double maxCraving,  String? errorMessage,  String? errorDetails)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsState():
return $default(_that.isLoading,_that.entries,_that.substanceToCategory,_that.selectedPeriod,_that.selectedCategories,_that.selectedTypeIndex,_that.selectedSubstances,_that.selectedPlaces,_that.selectedRoutes,_that.selectedFeelings,_that.minCraving,_that.maxCraving,_that.errorMessage,_that.errorDetails);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<LogEntry> entries,  Map<String, String> substanceToCategory,  TimePeriod selectedPeriod,  List<String> selectedCategories,  int selectedTypeIndex,  List<String> selectedSubstances,  List<String> selectedPlaces,  List<String> selectedRoutes,  List<String> selectedFeelings,  double minCraving,  double maxCraving,  String? errorMessage,  String? errorDetails)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
return $default(_that.isLoading,_that.entries,_that.substanceToCategory,_that.selectedPeriod,_that.selectedCategories,_that.selectedTypeIndex,_that.selectedSubstances,_that.selectedPlaces,_that.selectedRoutes,_that.selectedFeelings,_that.minCraving,_that.maxCraving,_that.errorMessage,_that.errorDetails);case _:
  return null;

}
}

}

/// @nodoc


class _AnalyticsState extends AnalyticsState {
  const _AnalyticsState({this.isLoading = true, final  List<LogEntry> entries = const <LogEntry>[], final  Map<String, String> substanceToCategory = const <String, String>{}, this.selectedPeriod = TimePeriod.all, final  List<String> selectedCategories = const <String>[], this.selectedTypeIndex = 0, final  List<String> selectedSubstances = const <String>[], final  List<String> selectedPlaces = const <String>[], final  List<String> selectedRoutes = const <String>[], final  List<String> selectedFeelings = const <String>[], this.minCraving = 0, this.maxCraving = 10, this.errorMessage, this.errorDetails}): _entries = entries,_substanceToCategory = substanceToCategory,_selectedCategories = selectedCategories,_selectedSubstances = selectedSubstances,_selectedPlaces = selectedPlaces,_selectedRoutes = selectedRoutes,_selectedFeelings = selectedFeelings,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<LogEntry> _entries;
@override@JsonKey() List<LogEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

 final  Map<String, String> _substanceToCategory;
@override@JsonKey() Map<String, String> get substanceToCategory {
  if (_substanceToCategory is EqualUnmodifiableMapView) return _substanceToCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_substanceToCategory);
}

@override@JsonKey() final  TimePeriod selectedPeriod;
 final  List<String> _selectedCategories;
@override@JsonKey() List<String> get selectedCategories {
  if (_selectedCategories is EqualUnmodifiableListView) return _selectedCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedCategories);
}

@override@JsonKey() final  int selectedTypeIndex;
 final  List<String> _selectedSubstances;
@override@JsonKey() List<String> get selectedSubstances {
  if (_selectedSubstances is EqualUnmodifiableListView) return _selectedSubstances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedSubstances);
}

 final  List<String> _selectedPlaces;
@override@JsonKey() List<String> get selectedPlaces {
  if (_selectedPlaces is EqualUnmodifiableListView) return _selectedPlaces;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedPlaces);
}

 final  List<String> _selectedRoutes;
@override@JsonKey() List<String> get selectedRoutes {
  if (_selectedRoutes is EqualUnmodifiableListView) return _selectedRoutes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedRoutes);
}

 final  List<String> _selectedFeelings;
@override@JsonKey() List<String> get selectedFeelings {
  if (_selectedFeelings is EqualUnmodifiableListView) return _selectedFeelings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedFeelings);
}

@override@JsonKey() final  double minCraving;
@override@JsonKey() final  double maxCraving;
@override final  String? errorMessage;
@override final  String? errorDetails;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsStateCopyWith<_AnalyticsState> get copyWith => __$AnalyticsStateCopyWithImpl<_AnalyticsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._entries, _entries)&&const DeepCollectionEquality().equals(other._substanceToCategory, _substanceToCategory)&&(identical(other.selectedPeriod, selectedPeriod) || other.selectedPeriod == selectedPeriod)&&const DeepCollectionEquality().equals(other._selectedCategories, _selectedCategories)&&(identical(other.selectedTypeIndex, selectedTypeIndex) || other.selectedTypeIndex == selectedTypeIndex)&&const DeepCollectionEquality().equals(other._selectedSubstances, _selectedSubstances)&&const DeepCollectionEquality().equals(other._selectedPlaces, _selectedPlaces)&&const DeepCollectionEquality().equals(other._selectedRoutes, _selectedRoutes)&&const DeepCollectionEquality().equals(other._selectedFeelings, _selectedFeelings)&&(identical(other.minCraving, minCraving) || other.minCraving == minCraving)&&(identical(other.maxCraving, maxCraving) || other.maxCraving == maxCraving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorDetails, errorDetails) || other.errorDetails == errorDetails));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_entries),const DeepCollectionEquality().hash(_substanceToCategory),selectedPeriod,const DeepCollectionEquality().hash(_selectedCategories),selectedTypeIndex,const DeepCollectionEquality().hash(_selectedSubstances),const DeepCollectionEquality().hash(_selectedPlaces),const DeepCollectionEquality().hash(_selectedRoutes),const DeepCollectionEquality().hash(_selectedFeelings),minCraving,maxCraving,errorMessage,errorDetails);

@override
String toString() {
  return 'AnalyticsState(isLoading: $isLoading, entries: $entries, substanceToCategory: $substanceToCategory, selectedPeriod: $selectedPeriod, selectedCategories: $selectedCategories, selectedTypeIndex: $selectedTypeIndex, selectedSubstances: $selectedSubstances, selectedPlaces: $selectedPlaces, selectedRoutes: $selectedRoutes, selectedFeelings: $selectedFeelings, minCraving: $minCraving, maxCraving: $maxCraving, errorMessage: $errorMessage, errorDetails: $errorDetails)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsStateCopyWith<$Res> implements $AnalyticsStateCopyWith<$Res> {
  factory _$AnalyticsStateCopyWith(_AnalyticsState value, $Res Function(_AnalyticsState) _then) = __$AnalyticsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<LogEntry> entries, Map<String, String> substanceToCategory, TimePeriod selectedPeriod, List<String> selectedCategories, int selectedTypeIndex, List<String> selectedSubstances, List<String> selectedPlaces, List<String> selectedRoutes, List<String> selectedFeelings, double minCraving, double maxCraving, String? errorMessage, String? errorDetails
});




}
/// @nodoc
class __$AnalyticsStateCopyWithImpl<$Res>
    implements _$AnalyticsStateCopyWith<$Res> {
  __$AnalyticsStateCopyWithImpl(this._self, this._then);

  final _AnalyticsState _self;
  final $Res Function(_AnalyticsState) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? entries = null,Object? substanceToCategory = null,Object? selectedPeriod = null,Object? selectedCategories = null,Object? selectedTypeIndex = null,Object? selectedSubstances = null,Object? selectedPlaces = null,Object? selectedRoutes = null,Object? selectedFeelings = null,Object? minCraving = null,Object? maxCraving = null,Object? errorMessage = freezed,Object? errorDetails = freezed,}) {
  return _then(_AnalyticsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LogEntry>,substanceToCategory: null == substanceToCategory ? _self._substanceToCategory : substanceToCategory // ignore: cast_nullable_to_non_nullable
as Map<String, String>,selectedPeriod: null == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as TimePeriod,selectedCategories: null == selectedCategories ? _self._selectedCategories : selectedCategories // ignore: cast_nullable_to_non_nullable
as List<String>,selectedTypeIndex: null == selectedTypeIndex ? _self.selectedTypeIndex : selectedTypeIndex // ignore: cast_nullable_to_non_nullable
as int,selectedSubstances: null == selectedSubstances ? _self._selectedSubstances : selectedSubstances // ignore: cast_nullable_to_non_nullable
as List<String>,selectedPlaces: null == selectedPlaces ? _self._selectedPlaces : selectedPlaces // ignore: cast_nullable_to_non_nullable
as List<String>,selectedRoutes: null == selectedRoutes ? _self._selectedRoutes : selectedRoutes // ignore: cast_nullable_to_non_nullable
as List<String>,selectedFeelings: null == selectedFeelings ? _self._selectedFeelings : selectedFeelings // ignore: cast_nullable_to_non_nullable
as List<String>,minCraving: null == minCraving ? _self.minCraving : minCraving // ignore: cast_nullable_to_non_nullable
as double,maxCraving: null == maxCraving ? _self.maxCraving : maxCraving // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorDetails: freezed == errorDetails ? _self.errorDetails : errorDetails // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
