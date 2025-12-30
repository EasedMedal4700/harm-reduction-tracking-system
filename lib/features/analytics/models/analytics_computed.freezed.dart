// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_computed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsComputed {

 List<LogEntry> get filteredEntries; List<String> get uniqueSubstances; List<String> get uniqueCategories; List<String> get uniquePlaces; List<String> get uniqueRoutes; List<String> get uniqueFeelings; double get avgPerWeek; Map<String, int> get categoryCounts; String get mostUsedCategory; int get mostUsedCategoryCount; Map<String, int> get substanceCounts; String get mostUsedSubstance; int get mostUsedSubstanceCount; double get topCategoryPercent; String get selectedPeriodText; String get insightText; Map<String, Map<String, int>> get substanceCountsByCategory;
/// Create a copy of AnalyticsComputed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsComputedCopyWith<AnalyticsComputed> get copyWith => _$AnalyticsComputedCopyWithImpl<AnalyticsComputed>(this as AnalyticsComputed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsComputed&&const DeepCollectionEquality().equals(other.filteredEntries, filteredEntries)&&const DeepCollectionEquality().equals(other.uniqueSubstances, uniqueSubstances)&&const DeepCollectionEquality().equals(other.uniqueCategories, uniqueCategories)&&const DeepCollectionEquality().equals(other.uniquePlaces, uniquePlaces)&&const DeepCollectionEquality().equals(other.uniqueRoutes, uniqueRoutes)&&const DeepCollectionEquality().equals(other.uniqueFeelings, uniqueFeelings)&&(identical(other.avgPerWeek, avgPerWeek) || other.avgPerWeek == avgPerWeek)&&const DeepCollectionEquality().equals(other.categoryCounts, categoryCounts)&&(identical(other.mostUsedCategory, mostUsedCategory) || other.mostUsedCategory == mostUsedCategory)&&(identical(other.mostUsedCategoryCount, mostUsedCategoryCount) || other.mostUsedCategoryCount == mostUsedCategoryCount)&&const DeepCollectionEquality().equals(other.substanceCounts, substanceCounts)&&(identical(other.mostUsedSubstance, mostUsedSubstance) || other.mostUsedSubstance == mostUsedSubstance)&&(identical(other.mostUsedSubstanceCount, mostUsedSubstanceCount) || other.mostUsedSubstanceCount == mostUsedSubstanceCount)&&(identical(other.topCategoryPercent, topCategoryPercent) || other.topCategoryPercent == topCategoryPercent)&&(identical(other.selectedPeriodText, selectedPeriodText) || other.selectedPeriodText == selectedPeriodText)&&(identical(other.insightText, insightText) || other.insightText == insightText)&&const DeepCollectionEquality().equals(other.substanceCountsByCategory, substanceCountsByCategory));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(filteredEntries),const DeepCollectionEquality().hash(uniqueSubstances),const DeepCollectionEquality().hash(uniqueCategories),const DeepCollectionEquality().hash(uniquePlaces),const DeepCollectionEquality().hash(uniqueRoutes),const DeepCollectionEquality().hash(uniqueFeelings),avgPerWeek,const DeepCollectionEquality().hash(categoryCounts),mostUsedCategory,mostUsedCategoryCount,const DeepCollectionEquality().hash(substanceCounts),mostUsedSubstance,mostUsedSubstanceCount,topCategoryPercent,selectedPeriodText,insightText,const DeepCollectionEquality().hash(substanceCountsByCategory));

@override
String toString() {
  return 'AnalyticsComputed(filteredEntries: $filteredEntries, uniqueSubstances: $uniqueSubstances, uniqueCategories: $uniqueCategories, uniquePlaces: $uniquePlaces, uniqueRoutes: $uniqueRoutes, uniqueFeelings: $uniqueFeelings, avgPerWeek: $avgPerWeek, categoryCounts: $categoryCounts, mostUsedCategory: $mostUsedCategory, mostUsedCategoryCount: $mostUsedCategoryCount, substanceCounts: $substanceCounts, mostUsedSubstance: $mostUsedSubstance, mostUsedSubstanceCount: $mostUsedSubstanceCount, topCategoryPercent: $topCategoryPercent, selectedPeriodText: $selectedPeriodText, insightText: $insightText, substanceCountsByCategory: $substanceCountsByCategory)';
}


}

/// @nodoc
abstract mixin class $AnalyticsComputedCopyWith<$Res>  {
  factory $AnalyticsComputedCopyWith(AnalyticsComputed value, $Res Function(AnalyticsComputed) _then) = _$AnalyticsComputedCopyWithImpl;
@useResult
$Res call({
 List<LogEntry> filteredEntries, List<String> uniqueSubstances, List<String> uniqueCategories, List<String> uniquePlaces, List<String> uniqueRoutes, List<String> uniqueFeelings, double avgPerWeek, Map<String, int> categoryCounts, String mostUsedCategory, int mostUsedCategoryCount, Map<String, int> substanceCounts, String mostUsedSubstance, int mostUsedSubstanceCount, double topCategoryPercent, String selectedPeriodText, String insightText, Map<String, Map<String, int>> substanceCountsByCategory
});




}
/// @nodoc
class _$AnalyticsComputedCopyWithImpl<$Res>
    implements $AnalyticsComputedCopyWith<$Res> {
  _$AnalyticsComputedCopyWithImpl(this._self, this._then);

  final AnalyticsComputed _self;
  final $Res Function(AnalyticsComputed) _then;

/// Create a copy of AnalyticsComputed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filteredEntries = null,Object? uniqueSubstances = null,Object? uniqueCategories = null,Object? uniquePlaces = null,Object? uniqueRoutes = null,Object? uniqueFeelings = null,Object? avgPerWeek = null,Object? categoryCounts = null,Object? mostUsedCategory = null,Object? mostUsedCategoryCount = null,Object? substanceCounts = null,Object? mostUsedSubstance = null,Object? mostUsedSubstanceCount = null,Object? topCategoryPercent = null,Object? selectedPeriodText = null,Object? insightText = null,Object? substanceCountsByCategory = null,}) {
  return _then(_self.copyWith(
filteredEntries: null == filteredEntries ? _self.filteredEntries : filteredEntries // ignore: cast_nullable_to_non_nullable
as List<LogEntry>,uniqueSubstances: null == uniqueSubstances ? _self.uniqueSubstances : uniqueSubstances // ignore: cast_nullable_to_non_nullable
as List<String>,uniqueCategories: null == uniqueCategories ? _self.uniqueCategories : uniqueCategories // ignore: cast_nullable_to_non_nullable
as List<String>,uniquePlaces: null == uniquePlaces ? _self.uniquePlaces : uniquePlaces // ignore: cast_nullable_to_non_nullable
as List<String>,uniqueRoutes: null == uniqueRoutes ? _self.uniqueRoutes : uniqueRoutes // ignore: cast_nullable_to_non_nullable
as List<String>,uniqueFeelings: null == uniqueFeelings ? _self.uniqueFeelings : uniqueFeelings // ignore: cast_nullable_to_non_nullable
as List<String>,avgPerWeek: null == avgPerWeek ? _self.avgPerWeek : avgPerWeek // ignore: cast_nullable_to_non_nullable
as double,categoryCounts: null == categoryCounts ? _self.categoryCounts : categoryCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,mostUsedCategory: null == mostUsedCategory ? _self.mostUsedCategory : mostUsedCategory // ignore: cast_nullable_to_non_nullable
as String,mostUsedCategoryCount: null == mostUsedCategoryCount ? _self.mostUsedCategoryCount : mostUsedCategoryCount // ignore: cast_nullable_to_non_nullable
as int,substanceCounts: null == substanceCounts ? _self.substanceCounts : substanceCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,mostUsedSubstance: null == mostUsedSubstance ? _self.mostUsedSubstance : mostUsedSubstance // ignore: cast_nullable_to_non_nullable
as String,mostUsedSubstanceCount: null == mostUsedSubstanceCount ? _self.mostUsedSubstanceCount : mostUsedSubstanceCount // ignore: cast_nullable_to_non_nullable
as int,topCategoryPercent: null == topCategoryPercent ? _self.topCategoryPercent : topCategoryPercent // ignore: cast_nullable_to_non_nullable
as double,selectedPeriodText: null == selectedPeriodText ? _self.selectedPeriodText : selectedPeriodText // ignore: cast_nullable_to_non_nullable
as String,insightText: null == insightText ? _self.insightText : insightText // ignore: cast_nullable_to_non_nullable
as String,substanceCountsByCategory: null == substanceCountsByCategory ? _self.substanceCountsByCategory : substanceCountsByCategory // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, int>>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsComputed].
extension AnalyticsComputedPatterns on AnalyticsComputed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsComputed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsComputed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsComputed value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsComputed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsComputed value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsComputed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LogEntry> filteredEntries,  List<String> uniqueSubstances,  List<String> uniqueCategories,  List<String> uniquePlaces,  List<String> uniqueRoutes,  List<String> uniqueFeelings,  double avgPerWeek,  Map<String, int> categoryCounts,  String mostUsedCategory,  int mostUsedCategoryCount,  Map<String, int> substanceCounts,  String mostUsedSubstance,  int mostUsedSubstanceCount,  double topCategoryPercent,  String selectedPeriodText,  String insightText,  Map<String, Map<String, int>> substanceCountsByCategory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsComputed() when $default != null:
return $default(_that.filteredEntries,_that.uniqueSubstances,_that.uniqueCategories,_that.uniquePlaces,_that.uniqueRoutes,_that.uniqueFeelings,_that.avgPerWeek,_that.categoryCounts,_that.mostUsedCategory,_that.mostUsedCategoryCount,_that.substanceCounts,_that.mostUsedSubstance,_that.mostUsedSubstanceCount,_that.topCategoryPercent,_that.selectedPeriodText,_that.insightText,_that.substanceCountsByCategory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LogEntry> filteredEntries,  List<String> uniqueSubstances,  List<String> uniqueCategories,  List<String> uniquePlaces,  List<String> uniqueRoutes,  List<String> uniqueFeelings,  double avgPerWeek,  Map<String, int> categoryCounts,  String mostUsedCategory,  int mostUsedCategoryCount,  Map<String, int> substanceCounts,  String mostUsedSubstance,  int mostUsedSubstanceCount,  double topCategoryPercent,  String selectedPeriodText,  String insightText,  Map<String, Map<String, int>> substanceCountsByCategory)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsComputed():
return $default(_that.filteredEntries,_that.uniqueSubstances,_that.uniqueCategories,_that.uniquePlaces,_that.uniqueRoutes,_that.uniqueFeelings,_that.avgPerWeek,_that.categoryCounts,_that.mostUsedCategory,_that.mostUsedCategoryCount,_that.substanceCounts,_that.mostUsedSubstance,_that.mostUsedSubstanceCount,_that.topCategoryPercent,_that.selectedPeriodText,_that.insightText,_that.substanceCountsByCategory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LogEntry> filteredEntries,  List<String> uniqueSubstances,  List<String> uniqueCategories,  List<String> uniquePlaces,  List<String> uniqueRoutes,  List<String> uniqueFeelings,  double avgPerWeek,  Map<String, int> categoryCounts,  String mostUsedCategory,  int mostUsedCategoryCount,  Map<String, int> substanceCounts,  String mostUsedSubstance,  int mostUsedSubstanceCount,  double topCategoryPercent,  String selectedPeriodText,  String insightText,  Map<String, Map<String, int>> substanceCountsByCategory)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsComputed() when $default != null:
return $default(_that.filteredEntries,_that.uniqueSubstances,_that.uniqueCategories,_that.uniquePlaces,_that.uniqueRoutes,_that.uniqueFeelings,_that.avgPerWeek,_that.categoryCounts,_that.mostUsedCategory,_that.mostUsedCategoryCount,_that.substanceCounts,_that.mostUsedSubstance,_that.mostUsedSubstanceCount,_that.topCategoryPercent,_that.selectedPeriodText,_that.insightText,_that.substanceCountsByCategory);case _:
  return null;

}
}

}

/// @nodoc


class _AnalyticsComputed extends AnalyticsComputed {
  const _AnalyticsComputed({required final  List<LogEntry> filteredEntries, required final  List<String> uniqueSubstances, required final  List<String> uniqueCategories, required final  List<String> uniquePlaces, required final  List<String> uniqueRoutes, required final  List<String> uniqueFeelings, required this.avgPerWeek, required final  Map<String, int> categoryCounts, required this.mostUsedCategory, required this.mostUsedCategoryCount, required final  Map<String, int> substanceCounts, required this.mostUsedSubstance, required this.mostUsedSubstanceCount, required this.topCategoryPercent, required this.selectedPeriodText, required this.insightText, required final  Map<String, Map<String, int>> substanceCountsByCategory}): _filteredEntries = filteredEntries,_uniqueSubstances = uniqueSubstances,_uniqueCategories = uniqueCategories,_uniquePlaces = uniquePlaces,_uniqueRoutes = uniqueRoutes,_uniqueFeelings = uniqueFeelings,_categoryCounts = categoryCounts,_substanceCounts = substanceCounts,_substanceCountsByCategory = substanceCountsByCategory,super._();
  

 final  List<LogEntry> _filteredEntries;
@override List<LogEntry> get filteredEntries {
  if (_filteredEntries is EqualUnmodifiableListView) return _filteredEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredEntries);
}

 final  List<String> _uniqueSubstances;
@override List<String> get uniqueSubstances {
  if (_uniqueSubstances is EqualUnmodifiableListView) return _uniqueSubstances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uniqueSubstances);
}

 final  List<String> _uniqueCategories;
@override List<String> get uniqueCategories {
  if (_uniqueCategories is EqualUnmodifiableListView) return _uniqueCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uniqueCategories);
}

 final  List<String> _uniquePlaces;
@override List<String> get uniquePlaces {
  if (_uniquePlaces is EqualUnmodifiableListView) return _uniquePlaces;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uniquePlaces);
}

 final  List<String> _uniqueRoutes;
@override List<String> get uniqueRoutes {
  if (_uniqueRoutes is EqualUnmodifiableListView) return _uniqueRoutes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uniqueRoutes);
}

 final  List<String> _uniqueFeelings;
@override List<String> get uniqueFeelings {
  if (_uniqueFeelings is EqualUnmodifiableListView) return _uniqueFeelings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uniqueFeelings);
}

@override final  double avgPerWeek;
 final  Map<String, int> _categoryCounts;
@override Map<String, int> get categoryCounts {
  if (_categoryCounts is EqualUnmodifiableMapView) return _categoryCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoryCounts);
}

@override final  String mostUsedCategory;
@override final  int mostUsedCategoryCount;
 final  Map<String, int> _substanceCounts;
@override Map<String, int> get substanceCounts {
  if (_substanceCounts is EqualUnmodifiableMapView) return _substanceCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_substanceCounts);
}

@override final  String mostUsedSubstance;
@override final  int mostUsedSubstanceCount;
@override final  double topCategoryPercent;
@override final  String selectedPeriodText;
@override final  String insightText;
 final  Map<String, Map<String, int>> _substanceCountsByCategory;
@override Map<String, Map<String, int>> get substanceCountsByCategory {
  if (_substanceCountsByCategory is EqualUnmodifiableMapView) return _substanceCountsByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_substanceCountsByCategory);
}


/// Create a copy of AnalyticsComputed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsComputedCopyWith<_AnalyticsComputed> get copyWith => __$AnalyticsComputedCopyWithImpl<_AnalyticsComputed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsComputed&&const DeepCollectionEquality().equals(other._filteredEntries, _filteredEntries)&&const DeepCollectionEquality().equals(other._uniqueSubstances, _uniqueSubstances)&&const DeepCollectionEquality().equals(other._uniqueCategories, _uniqueCategories)&&const DeepCollectionEquality().equals(other._uniquePlaces, _uniquePlaces)&&const DeepCollectionEquality().equals(other._uniqueRoutes, _uniqueRoutes)&&const DeepCollectionEquality().equals(other._uniqueFeelings, _uniqueFeelings)&&(identical(other.avgPerWeek, avgPerWeek) || other.avgPerWeek == avgPerWeek)&&const DeepCollectionEquality().equals(other._categoryCounts, _categoryCounts)&&(identical(other.mostUsedCategory, mostUsedCategory) || other.mostUsedCategory == mostUsedCategory)&&(identical(other.mostUsedCategoryCount, mostUsedCategoryCount) || other.mostUsedCategoryCount == mostUsedCategoryCount)&&const DeepCollectionEquality().equals(other._substanceCounts, _substanceCounts)&&(identical(other.mostUsedSubstance, mostUsedSubstance) || other.mostUsedSubstance == mostUsedSubstance)&&(identical(other.mostUsedSubstanceCount, mostUsedSubstanceCount) || other.mostUsedSubstanceCount == mostUsedSubstanceCount)&&(identical(other.topCategoryPercent, topCategoryPercent) || other.topCategoryPercent == topCategoryPercent)&&(identical(other.selectedPeriodText, selectedPeriodText) || other.selectedPeriodText == selectedPeriodText)&&(identical(other.insightText, insightText) || other.insightText == insightText)&&const DeepCollectionEquality().equals(other._substanceCountsByCategory, _substanceCountsByCategory));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_filteredEntries),const DeepCollectionEquality().hash(_uniqueSubstances),const DeepCollectionEquality().hash(_uniqueCategories),const DeepCollectionEquality().hash(_uniquePlaces),const DeepCollectionEquality().hash(_uniqueRoutes),const DeepCollectionEquality().hash(_uniqueFeelings),avgPerWeek,const DeepCollectionEquality().hash(_categoryCounts),mostUsedCategory,mostUsedCategoryCount,const DeepCollectionEquality().hash(_substanceCounts),mostUsedSubstance,mostUsedSubstanceCount,topCategoryPercent,selectedPeriodText,insightText,const DeepCollectionEquality().hash(_substanceCountsByCategory));

@override
String toString() {
  return 'AnalyticsComputed(filteredEntries: $filteredEntries, uniqueSubstances: $uniqueSubstances, uniqueCategories: $uniqueCategories, uniquePlaces: $uniquePlaces, uniqueRoutes: $uniqueRoutes, uniqueFeelings: $uniqueFeelings, avgPerWeek: $avgPerWeek, categoryCounts: $categoryCounts, mostUsedCategory: $mostUsedCategory, mostUsedCategoryCount: $mostUsedCategoryCount, substanceCounts: $substanceCounts, mostUsedSubstance: $mostUsedSubstance, mostUsedSubstanceCount: $mostUsedSubstanceCount, topCategoryPercent: $topCategoryPercent, selectedPeriodText: $selectedPeriodText, insightText: $insightText, substanceCountsByCategory: $substanceCountsByCategory)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsComputedCopyWith<$Res> implements $AnalyticsComputedCopyWith<$Res> {
  factory _$AnalyticsComputedCopyWith(_AnalyticsComputed value, $Res Function(_AnalyticsComputed) _then) = __$AnalyticsComputedCopyWithImpl;
@override @useResult
$Res call({
 List<LogEntry> filteredEntries, List<String> uniqueSubstances, List<String> uniqueCategories, List<String> uniquePlaces, List<String> uniqueRoutes, List<String> uniqueFeelings, double avgPerWeek, Map<String, int> categoryCounts, String mostUsedCategory, int mostUsedCategoryCount, Map<String, int> substanceCounts, String mostUsedSubstance, int mostUsedSubstanceCount, double topCategoryPercent, String selectedPeriodText, String insightText, Map<String, Map<String, int>> substanceCountsByCategory
});




}
/// @nodoc
class __$AnalyticsComputedCopyWithImpl<$Res>
    implements _$AnalyticsComputedCopyWith<$Res> {
  __$AnalyticsComputedCopyWithImpl(this._self, this._then);

  final _AnalyticsComputed _self;
  final $Res Function(_AnalyticsComputed) _then;

/// Create a copy of AnalyticsComputed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filteredEntries = null,Object? uniqueSubstances = null,Object? uniqueCategories = null,Object? uniquePlaces = null,Object? uniqueRoutes = null,Object? uniqueFeelings = null,Object? avgPerWeek = null,Object? categoryCounts = null,Object? mostUsedCategory = null,Object? mostUsedCategoryCount = null,Object? substanceCounts = null,Object? mostUsedSubstance = null,Object? mostUsedSubstanceCount = null,Object? topCategoryPercent = null,Object? selectedPeriodText = null,Object? insightText = null,Object? substanceCountsByCategory = null,}) {
  return _then(_AnalyticsComputed(
filteredEntries: null == filteredEntries ? _self._filteredEntries : filteredEntries // ignore: cast_nullable_to_non_nullable
as List<LogEntry>,uniqueSubstances: null == uniqueSubstances ? _self._uniqueSubstances : uniqueSubstances // ignore: cast_nullable_to_non_nullable
as List<String>,uniqueCategories: null == uniqueCategories ? _self._uniqueCategories : uniqueCategories // ignore: cast_nullable_to_non_nullable
as List<String>,uniquePlaces: null == uniquePlaces ? _self._uniquePlaces : uniquePlaces // ignore: cast_nullable_to_non_nullable
as List<String>,uniqueRoutes: null == uniqueRoutes ? _self._uniqueRoutes : uniqueRoutes // ignore: cast_nullable_to_non_nullable
as List<String>,uniqueFeelings: null == uniqueFeelings ? _self._uniqueFeelings : uniqueFeelings // ignore: cast_nullable_to_non_nullable
as List<String>,avgPerWeek: null == avgPerWeek ? _self.avgPerWeek : avgPerWeek // ignore: cast_nullable_to_non_nullable
as double,categoryCounts: null == categoryCounts ? _self._categoryCounts : categoryCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,mostUsedCategory: null == mostUsedCategory ? _self.mostUsedCategory : mostUsedCategory // ignore: cast_nullable_to_non_nullable
as String,mostUsedCategoryCount: null == mostUsedCategoryCount ? _self.mostUsedCategoryCount : mostUsedCategoryCount // ignore: cast_nullable_to_non_nullable
as int,substanceCounts: null == substanceCounts ? _self._substanceCounts : substanceCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,mostUsedSubstance: null == mostUsedSubstance ? _self.mostUsedSubstance : mostUsedSubstance // ignore: cast_nullable_to_non_nullable
as String,mostUsedSubstanceCount: null == mostUsedSubstanceCount ? _self.mostUsedSubstanceCount : mostUsedSubstanceCount // ignore: cast_nullable_to_non_nullable
as int,topCategoryPercent: null == topCategoryPercent ? _self.topCategoryPercent : topCategoryPercent // ignore: cast_nullable_to_non_nullable
as double,selectedPeriodText: null == selectedPeriodText ? _self.selectedPeriodText : selectedPeriodText // ignore: cast_nullable_to_non_nullable
as String,insightText: null == insightText ? _self.insightText : insightText // ignore: cast_nullable_to_non_nullable
as String,substanceCountsByCategory: null == substanceCountsByCategory ? _self._substanceCountsByCategory : substanceCountsByCategory // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, int>>,
  ));
}


}

// dart format on
