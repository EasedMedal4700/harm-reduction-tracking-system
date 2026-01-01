// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_library_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonalLibrarySummary {

 int get totalUses; int get activeSubstances; double get avgUses; String get mostUsedCategory;
/// Create a copy of PersonalLibrarySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalLibrarySummaryCopyWith<PersonalLibrarySummary> get copyWith => _$PersonalLibrarySummaryCopyWithImpl<PersonalLibrarySummary>(this as PersonalLibrarySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalLibrarySummary&&(identical(other.totalUses, totalUses) || other.totalUses == totalUses)&&(identical(other.activeSubstances, activeSubstances) || other.activeSubstances == activeSubstances)&&(identical(other.avgUses, avgUses) || other.avgUses == avgUses)&&(identical(other.mostUsedCategory, mostUsedCategory) || other.mostUsedCategory == mostUsedCategory));
}


@override
int get hashCode => Object.hash(runtimeType,totalUses,activeSubstances,avgUses,mostUsedCategory);

@override
String toString() {
  return 'PersonalLibrarySummary(totalUses: $totalUses, activeSubstances: $activeSubstances, avgUses: $avgUses, mostUsedCategory: $mostUsedCategory)';
}


}

/// @nodoc
abstract mixin class $PersonalLibrarySummaryCopyWith<$Res>  {
  factory $PersonalLibrarySummaryCopyWith(PersonalLibrarySummary value, $Res Function(PersonalLibrarySummary) _then) = _$PersonalLibrarySummaryCopyWithImpl;
@useResult
$Res call({
 int totalUses, int activeSubstances, double avgUses, String mostUsedCategory
});




}
/// @nodoc
class _$PersonalLibrarySummaryCopyWithImpl<$Res>
    implements $PersonalLibrarySummaryCopyWith<$Res> {
  _$PersonalLibrarySummaryCopyWithImpl(this._self, this._then);

  final PersonalLibrarySummary _self;
  final $Res Function(PersonalLibrarySummary) _then;

/// Create a copy of PersonalLibrarySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalUses = null,Object? activeSubstances = null,Object? avgUses = null,Object? mostUsedCategory = null,}) {
  return _then(_self.copyWith(
totalUses: null == totalUses ? _self.totalUses : totalUses // ignore: cast_nullable_to_non_nullable
as int,activeSubstances: null == activeSubstances ? _self.activeSubstances : activeSubstances // ignore: cast_nullable_to_non_nullable
as int,avgUses: null == avgUses ? _self.avgUses : avgUses // ignore: cast_nullable_to_non_nullable
as double,mostUsedCategory: null == mostUsedCategory ? _self.mostUsedCategory : mostUsedCategory // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalLibrarySummary].
extension PersonalLibrarySummaryPatterns on PersonalLibrarySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalLibrarySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalLibrarySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalLibrarySummary value)  $default,){
final _that = this;
switch (_that) {
case _PersonalLibrarySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalLibrarySummary value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalLibrarySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalUses,  int activeSubstances,  double avgUses,  String mostUsedCategory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalLibrarySummary() when $default != null:
return $default(_that.totalUses,_that.activeSubstances,_that.avgUses,_that.mostUsedCategory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalUses,  int activeSubstances,  double avgUses,  String mostUsedCategory)  $default,) {final _that = this;
switch (_that) {
case _PersonalLibrarySummary():
return $default(_that.totalUses,_that.activeSubstances,_that.avgUses,_that.mostUsedCategory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalUses,  int activeSubstances,  double avgUses,  String mostUsedCategory)?  $default,) {final _that = this;
switch (_that) {
case _PersonalLibrarySummary() when $default != null:
return $default(_that.totalUses,_that.activeSubstances,_that.avgUses,_that.mostUsedCategory);case _:
  return null;

}
}

}

/// @nodoc


class _PersonalLibrarySummary extends PersonalLibrarySummary {
  const _PersonalLibrarySummary({this.totalUses = 0, this.activeSubstances = 0, this.avgUses = 0.0, this.mostUsedCategory = 'None'}): super._();
  

@override@JsonKey() final  int totalUses;
@override@JsonKey() final  int activeSubstances;
@override@JsonKey() final  double avgUses;
@override@JsonKey() final  String mostUsedCategory;

/// Create a copy of PersonalLibrarySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalLibrarySummaryCopyWith<_PersonalLibrarySummary> get copyWith => __$PersonalLibrarySummaryCopyWithImpl<_PersonalLibrarySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalLibrarySummary&&(identical(other.totalUses, totalUses) || other.totalUses == totalUses)&&(identical(other.activeSubstances, activeSubstances) || other.activeSubstances == activeSubstances)&&(identical(other.avgUses, avgUses) || other.avgUses == avgUses)&&(identical(other.mostUsedCategory, mostUsedCategory) || other.mostUsedCategory == mostUsedCategory));
}


@override
int get hashCode => Object.hash(runtimeType,totalUses,activeSubstances,avgUses,mostUsedCategory);

@override
String toString() {
  return 'PersonalLibrarySummary(totalUses: $totalUses, activeSubstances: $activeSubstances, avgUses: $avgUses, mostUsedCategory: $mostUsedCategory)';
}


}

/// @nodoc
abstract mixin class _$PersonalLibrarySummaryCopyWith<$Res> implements $PersonalLibrarySummaryCopyWith<$Res> {
  factory _$PersonalLibrarySummaryCopyWith(_PersonalLibrarySummary value, $Res Function(_PersonalLibrarySummary) _then) = __$PersonalLibrarySummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalUses, int activeSubstances, double avgUses, String mostUsedCategory
});




}
/// @nodoc
class __$PersonalLibrarySummaryCopyWithImpl<$Res>
    implements _$PersonalLibrarySummaryCopyWith<$Res> {
  __$PersonalLibrarySummaryCopyWithImpl(this._self, this._then);

  final _PersonalLibrarySummary _self;
  final $Res Function(_PersonalLibrarySummary) _then;

/// Create a copy of PersonalLibrarySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalUses = null,Object? activeSubstances = null,Object? avgUses = null,Object? mostUsedCategory = null,}) {
  return _then(_PersonalLibrarySummary(
totalUses: null == totalUses ? _self.totalUses : totalUses // ignore: cast_nullable_to_non_nullable
as int,activeSubstances: null == activeSubstances ? _self.activeSubstances : activeSubstances // ignore: cast_nullable_to_non_nullable
as int,avgUses: null == avgUses ? _self.avgUses : avgUses // ignore: cast_nullable_to_non_nullable
as double,mostUsedCategory: null == mostUsedCategory ? _self.mostUsedCategory : mostUsedCategory // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PersonalLibraryState {

 List<DrugCatalogEntry> get catalog; List<DrugCatalogEntry> get filtered; String get query; bool get showArchived; PersonalLibrarySummary get summary;
/// Create a copy of PersonalLibraryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalLibraryStateCopyWith<PersonalLibraryState> get copyWith => _$PersonalLibraryStateCopyWithImpl<PersonalLibraryState>(this as PersonalLibraryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalLibraryState&&const DeepCollectionEquality().equals(other.catalog, catalog)&&const DeepCollectionEquality().equals(other.filtered, filtered)&&(identical(other.query, query) || other.query == query)&&(identical(other.showArchived, showArchived) || other.showArchived == showArchived)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(catalog),const DeepCollectionEquality().hash(filtered),query,showArchived,summary);

@override
String toString() {
  return 'PersonalLibraryState(catalog: $catalog, filtered: $filtered, query: $query, showArchived: $showArchived, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $PersonalLibraryStateCopyWith<$Res>  {
  factory $PersonalLibraryStateCopyWith(PersonalLibraryState value, $Res Function(PersonalLibraryState) _then) = _$PersonalLibraryStateCopyWithImpl;
@useResult
$Res call({
 List<DrugCatalogEntry> catalog, List<DrugCatalogEntry> filtered, String query, bool showArchived, PersonalLibrarySummary summary
});


$PersonalLibrarySummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$PersonalLibraryStateCopyWithImpl<$Res>
    implements $PersonalLibraryStateCopyWith<$Res> {
  _$PersonalLibraryStateCopyWithImpl(this._self, this._then);

  final PersonalLibraryState _self;
  final $Res Function(PersonalLibraryState) _then;

/// Create a copy of PersonalLibraryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? catalog = null,Object? filtered = null,Object? query = null,Object? showArchived = null,Object? summary = null,}) {
  return _then(_self.copyWith(
catalog: null == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as List<DrugCatalogEntry>,filtered: null == filtered ? _self.filtered : filtered // ignore: cast_nullable_to_non_nullable
as List<DrugCatalogEntry>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,showArchived: null == showArchived ? _self.showArchived : showArchived // ignore: cast_nullable_to_non_nullable
as bool,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as PersonalLibrarySummary,
  ));
}
/// Create a copy of PersonalLibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalLibrarySummaryCopyWith<$Res> get summary {
  
  return $PersonalLibrarySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [PersonalLibraryState].
extension PersonalLibraryStatePatterns on PersonalLibraryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalLibraryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalLibraryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalLibraryState value)  $default,){
final _that = this;
switch (_that) {
case _PersonalLibraryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalLibraryState value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalLibraryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DrugCatalogEntry> catalog,  List<DrugCatalogEntry> filtered,  String query,  bool showArchived,  PersonalLibrarySummary summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalLibraryState() when $default != null:
return $default(_that.catalog,_that.filtered,_that.query,_that.showArchived,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DrugCatalogEntry> catalog,  List<DrugCatalogEntry> filtered,  String query,  bool showArchived,  PersonalLibrarySummary summary)  $default,) {final _that = this;
switch (_that) {
case _PersonalLibraryState():
return $default(_that.catalog,_that.filtered,_that.query,_that.showArchived,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DrugCatalogEntry> catalog,  List<DrugCatalogEntry> filtered,  String query,  bool showArchived,  PersonalLibrarySummary summary)?  $default,) {final _that = this;
switch (_that) {
case _PersonalLibraryState() when $default != null:
return $default(_that.catalog,_that.filtered,_that.query,_that.showArchived,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _PersonalLibraryState extends PersonalLibraryState {
  const _PersonalLibraryState({final  List<DrugCatalogEntry> catalog = const <DrugCatalogEntry>[], final  List<DrugCatalogEntry> filtered = const <DrugCatalogEntry>[], this.query = '', this.showArchived = false, this.summary = const PersonalLibrarySummary()}): _catalog = catalog,_filtered = filtered,super._();
  

 final  List<DrugCatalogEntry> _catalog;
@override@JsonKey() List<DrugCatalogEntry> get catalog {
  if (_catalog is EqualUnmodifiableListView) return _catalog;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_catalog);
}

 final  List<DrugCatalogEntry> _filtered;
@override@JsonKey() List<DrugCatalogEntry> get filtered {
  if (_filtered is EqualUnmodifiableListView) return _filtered;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filtered);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  bool showArchived;
@override@JsonKey() final  PersonalLibrarySummary summary;

/// Create a copy of PersonalLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalLibraryStateCopyWith<_PersonalLibraryState> get copyWith => __$PersonalLibraryStateCopyWithImpl<_PersonalLibraryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalLibraryState&&const DeepCollectionEquality().equals(other._catalog, _catalog)&&const DeepCollectionEquality().equals(other._filtered, _filtered)&&(identical(other.query, query) || other.query == query)&&(identical(other.showArchived, showArchived) || other.showArchived == showArchived)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_catalog),const DeepCollectionEquality().hash(_filtered),query,showArchived,summary);

@override
String toString() {
  return 'PersonalLibraryState(catalog: $catalog, filtered: $filtered, query: $query, showArchived: $showArchived, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$PersonalLibraryStateCopyWith<$Res> implements $PersonalLibraryStateCopyWith<$Res> {
  factory _$PersonalLibraryStateCopyWith(_PersonalLibraryState value, $Res Function(_PersonalLibraryState) _then) = __$PersonalLibraryStateCopyWithImpl;
@override @useResult
$Res call({
 List<DrugCatalogEntry> catalog, List<DrugCatalogEntry> filtered, String query, bool showArchived, PersonalLibrarySummary summary
});


@override $PersonalLibrarySummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$PersonalLibraryStateCopyWithImpl<$Res>
    implements _$PersonalLibraryStateCopyWith<$Res> {
  __$PersonalLibraryStateCopyWithImpl(this._self, this._then);

  final _PersonalLibraryState _self;
  final $Res Function(_PersonalLibraryState) _then;

/// Create a copy of PersonalLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? catalog = null,Object? filtered = null,Object? query = null,Object? showArchived = null,Object? summary = null,}) {
  return _then(_PersonalLibraryState(
catalog: null == catalog ? _self._catalog : catalog // ignore: cast_nullable_to_non_nullable
as List<DrugCatalogEntry>,filtered: null == filtered ? _self._filtered : filtered // ignore: cast_nullable_to_non_nullable
as List<DrugCatalogEntry>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,showArchived: null == showArchived ? _self.showArchived : showArchived // ignore: cast_nullable_to_non_nullable
as bool,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as PersonalLibrarySummary,
  ));
}

/// Create a copy of PersonalLibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalLibrarySummaryCopyWith<$Res> get summary {
  
  return $PersonalLibrarySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
