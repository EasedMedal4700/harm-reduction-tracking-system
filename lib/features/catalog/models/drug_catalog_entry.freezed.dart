// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drug_catalog_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DrugCatalogEntry {

 String get name; List<String> get categories; int get totalUses; double get avgDose; DateTime? get lastUsed; WeekdayUsage get weekdayUsage; bool get favorite; bool get archived; String get notes; num get quantity;
/// Create a copy of DrugCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugCatalogEntryCopyWith<DrugCatalogEntry> get copyWith => _$DrugCatalogEntryCopyWithImpl<DrugCatalogEntry>(this as DrugCatalogEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrugCatalogEntry&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.totalUses, totalUses) || other.totalUses == totalUses)&&(identical(other.avgDose, avgDose) || other.avgDose == avgDose)&&(identical(other.lastUsed, lastUsed) || other.lastUsed == lastUsed)&&(identical(other.weekdayUsage, weekdayUsage) || other.weekdayUsage == weekdayUsage)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(categories),totalUses,avgDose,lastUsed,weekdayUsage,favorite,archived,notes,quantity);

@override
String toString() {
  return 'DrugCatalogEntry(name: $name, categories: $categories, totalUses: $totalUses, avgDose: $avgDose, lastUsed: $lastUsed, weekdayUsage: $weekdayUsage, favorite: $favorite, archived: $archived, notes: $notes, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $DrugCatalogEntryCopyWith<$Res>  {
  factory $DrugCatalogEntryCopyWith(DrugCatalogEntry value, $Res Function(DrugCatalogEntry) _then) = _$DrugCatalogEntryCopyWithImpl;
@useResult
$Res call({
 String name, List<String> categories, int totalUses, double avgDose, DateTime? lastUsed, WeekdayUsage weekdayUsage, bool favorite, bool archived, String notes, num quantity
});


$WeekdayUsageCopyWith<$Res> get weekdayUsage;

}
/// @nodoc
class _$DrugCatalogEntryCopyWithImpl<$Res>
    implements $DrugCatalogEntryCopyWith<$Res> {
  _$DrugCatalogEntryCopyWithImpl(this._self, this._then);

  final DrugCatalogEntry _self;
  final $Res Function(DrugCatalogEntry) _then;

/// Create a copy of DrugCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? categories = null,Object? totalUses = null,Object? avgDose = null,Object? lastUsed = freezed,Object? weekdayUsage = null,Object? favorite = null,Object? archived = null,Object? notes = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,totalUses: null == totalUses ? _self.totalUses : totalUses // ignore: cast_nullable_to_non_nullable
as int,avgDose: null == avgDose ? _self.avgDose : avgDose // ignore: cast_nullable_to_non_nullable
as double,lastUsed: freezed == lastUsed ? _self.lastUsed : lastUsed // ignore: cast_nullable_to_non_nullable
as DateTime?,weekdayUsage: null == weekdayUsage ? _self.weekdayUsage : weekdayUsage // ignore: cast_nullable_to_non_nullable
as WeekdayUsage,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}
/// Create a copy of DrugCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekdayUsageCopyWith<$Res> get weekdayUsage {
  
  return $WeekdayUsageCopyWith<$Res>(_self.weekdayUsage, (value) {
    return _then(_self.copyWith(weekdayUsage: value));
  });
}
}


/// Adds pattern-matching-related methods to [DrugCatalogEntry].
extension DrugCatalogEntryPatterns on DrugCatalogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrugCatalogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrugCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrugCatalogEntry value)  $default,){
final _that = this;
switch (_that) {
case _DrugCatalogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrugCatalogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DrugCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<String> categories,  int totalUses,  double avgDose,  DateTime? lastUsed,  WeekdayUsage weekdayUsage,  bool favorite,  bool archived,  String notes,  num quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrugCatalogEntry() when $default != null:
return $default(_that.name,_that.categories,_that.totalUses,_that.avgDose,_that.lastUsed,_that.weekdayUsage,_that.favorite,_that.archived,_that.notes,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<String> categories,  int totalUses,  double avgDose,  DateTime? lastUsed,  WeekdayUsage weekdayUsage,  bool favorite,  bool archived,  String notes,  num quantity)  $default,) {final _that = this;
switch (_that) {
case _DrugCatalogEntry():
return $default(_that.name,_that.categories,_that.totalUses,_that.avgDose,_that.lastUsed,_that.weekdayUsage,_that.favorite,_that.archived,_that.notes,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<String> categories,  int totalUses,  double avgDose,  DateTime? lastUsed,  WeekdayUsage weekdayUsage,  bool favorite,  bool archived,  String notes,  num quantity)?  $default,) {final _that = this;
switch (_that) {
case _DrugCatalogEntry() when $default != null:
return $default(_that.name,_that.categories,_that.totalUses,_that.avgDose,_that.lastUsed,_that.weekdayUsage,_that.favorite,_that.archived,_that.notes,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _DrugCatalogEntry extends DrugCatalogEntry {
  const _DrugCatalogEntry({required this.name, required final  List<String> categories, required this.totalUses, required this.avgDose, this.lastUsed, required this.weekdayUsage, required this.favorite, required this.archived, required this.notes, required this.quantity}): _categories = categories,super._();
  

@override final  String name;
 final  List<String> _categories;
@override List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override final  int totalUses;
@override final  double avgDose;
@override final  DateTime? lastUsed;
@override final  WeekdayUsage weekdayUsage;
@override final  bool favorite;
@override final  bool archived;
@override final  String notes;
@override final  num quantity;

/// Create a copy of DrugCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugCatalogEntryCopyWith<_DrugCatalogEntry> get copyWith => __$DrugCatalogEntryCopyWithImpl<_DrugCatalogEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrugCatalogEntry&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.totalUses, totalUses) || other.totalUses == totalUses)&&(identical(other.avgDose, avgDose) || other.avgDose == avgDose)&&(identical(other.lastUsed, lastUsed) || other.lastUsed == lastUsed)&&(identical(other.weekdayUsage, weekdayUsage) || other.weekdayUsage == weekdayUsage)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_categories),totalUses,avgDose,lastUsed,weekdayUsage,favorite,archived,notes,quantity);

@override
String toString() {
  return 'DrugCatalogEntry(name: $name, categories: $categories, totalUses: $totalUses, avgDose: $avgDose, lastUsed: $lastUsed, weekdayUsage: $weekdayUsage, favorite: $favorite, archived: $archived, notes: $notes, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$DrugCatalogEntryCopyWith<$Res> implements $DrugCatalogEntryCopyWith<$Res> {
  factory _$DrugCatalogEntryCopyWith(_DrugCatalogEntry value, $Res Function(_DrugCatalogEntry) _then) = __$DrugCatalogEntryCopyWithImpl;
@override @useResult
$Res call({
 String name, List<String> categories, int totalUses, double avgDose, DateTime? lastUsed, WeekdayUsage weekdayUsage, bool favorite, bool archived, String notes, num quantity
});


@override $WeekdayUsageCopyWith<$Res> get weekdayUsage;

}
/// @nodoc
class __$DrugCatalogEntryCopyWithImpl<$Res>
    implements _$DrugCatalogEntryCopyWith<$Res> {
  __$DrugCatalogEntryCopyWithImpl(this._self, this._then);

  final _DrugCatalogEntry _self;
  final $Res Function(_DrugCatalogEntry) _then;

/// Create a copy of DrugCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? categories = null,Object? totalUses = null,Object? avgDose = null,Object? lastUsed = freezed,Object? weekdayUsage = null,Object? favorite = null,Object? archived = null,Object? notes = null,Object? quantity = null,}) {
  return _then(_DrugCatalogEntry(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,totalUses: null == totalUses ? _self.totalUses : totalUses // ignore: cast_nullable_to_non_nullable
as int,avgDose: null == avgDose ? _self.avgDose : avgDose // ignore: cast_nullable_to_non_nullable
as double,lastUsed: freezed == lastUsed ? _self.lastUsed : lastUsed // ignore: cast_nullable_to_non_nullable
as DateTime?,weekdayUsage: null == weekdayUsage ? _self.weekdayUsage : weekdayUsage // ignore: cast_nullable_to_non_nullable
as WeekdayUsage,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

/// Create a copy of DrugCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekdayUsageCopyWith<$Res> get weekdayUsage {
  
  return $WeekdayUsageCopyWith<$Res>(_self.weekdayUsage, (value) {
    return _then(_self.copyWith(weekdayUsage: value));
  });
}
}

/// @nodoc
mixin _$WeekdayUsage {

 List<int> get counts; int get mostActive; int get leastActive;
/// Create a copy of WeekdayUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekdayUsageCopyWith<WeekdayUsage> get copyWith => _$WeekdayUsageCopyWithImpl<WeekdayUsage>(this as WeekdayUsage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekdayUsage&&const DeepCollectionEquality().equals(other.counts, counts)&&(identical(other.mostActive, mostActive) || other.mostActive == mostActive)&&(identical(other.leastActive, leastActive) || other.leastActive == leastActive));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(counts),mostActive,leastActive);

@override
String toString() {
  return 'WeekdayUsage(counts: $counts, mostActive: $mostActive, leastActive: $leastActive)';
}


}

/// @nodoc
abstract mixin class $WeekdayUsageCopyWith<$Res>  {
  factory $WeekdayUsageCopyWith(WeekdayUsage value, $Res Function(WeekdayUsage) _then) = _$WeekdayUsageCopyWithImpl;
@useResult
$Res call({
 List<int> counts, int mostActive, int leastActive
});




}
/// @nodoc
class _$WeekdayUsageCopyWithImpl<$Res>
    implements $WeekdayUsageCopyWith<$Res> {
  _$WeekdayUsageCopyWithImpl(this._self, this._then);

  final WeekdayUsage _self;
  final $Res Function(WeekdayUsage) _then;

/// Create a copy of WeekdayUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? counts = null,Object? mostActive = null,Object? leastActive = null,}) {
  return _then(_self.copyWith(
counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as List<int>,mostActive: null == mostActive ? _self.mostActive : mostActive // ignore: cast_nullable_to_non_nullable
as int,leastActive: null == leastActive ? _self.leastActive : leastActive // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekdayUsage].
extension WeekdayUsagePatterns on WeekdayUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekdayUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekdayUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekdayUsage value)  $default,){
final _that = this;
switch (_that) {
case _WeekdayUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekdayUsage value)?  $default,){
final _that = this;
switch (_that) {
case _WeekdayUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> counts,  int mostActive,  int leastActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekdayUsage() when $default != null:
return $default(_that.counts,_that.mostActive,_that.leastActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> counts,  int mostActive,  int leastActive)  $default,) {final _that = this;
switch (_that) {
case _WeekdayUsage():
return $default(_that.counts,_that.mostActive,_that.leastActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> counts,  int mostActive,  int leastActive)?  $default,) {final _that = this;
switch (_that) {
case _WeekdayUsage() when $default != null:
return $default(_that.counts,_that.mostActive,_that.leastActive);case _:
  return null;

}
}

}

/// @nodoc


class _WeekdayUsage extends WeekdayUsage {
  const _WeekdayUsage({required final  List<int> counts, required this.mostActive, required this.leastActive}): _counts = counts,super._();
  

 final  List<int> _counts;
@override List<int> get counts {
  if (_counts is EqualUnmodifiableListView) return _counts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_counts);
}

@override final  int mostActive;
@override final  int leastActive;

/// Create a copy of WeekdayUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekdayUsageCopyWith<_WeekdayUsage> get copyWith => __$WeekdayUsageCopyWithImpl<_WeekdayUsage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekdayUsage&&const DeepCollectionEquality().equals(other._counts, _counts)&&(identical(other.mostActive, mostActive) || other.mostActive == mostActive)&&(identical(other.leastActive, leastActive) || other.leastActive == leastActive));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_counts),mostActive,leastActive);

@override
String toString() {
  return 'WeekdayUsage(counts: $counts, mostActive: $mostActive, leastActive: $leastActive)';
}


}

/// @nodoc
abstract mixin class _$WeekdayUsageCopyWith<$Res> implements $WeekdayUsageCopyWith<$Res> {
  factory _$WeekdayUsageCopyWith(_WeekdayUsage value, $Res Function(_WeekdayUsage) _then) = __$WeekdayUsageCopyWithImpl;
@override @useResult
$Res call({
 List<int> counts, int mostActive, int leastActive
});




}
/// @nodoc
class __$WeekdayUsageCopyWithImpl<$Res>
    implements _$WeekdayUsageCopyWith<$Res> {
  __$WeekdayUsageCopyWithImpl(this._self, this._then);

  final _WeekdayUsage _self;
  final $Res Function(_WeekdayUsage) _then;

/// Create a copy of WeekdayUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? counts = null,Object? mostActive = null,Object? leastActive = null,}) {
  return _then(_WeekdayUsage(
counts: null == counts ? _self._counts : counts // ignore: cast_nullable_to_non_nullable
as List<int>,mostActive: null == mostActive ? _self.mostActive : mostActive // ignore: cast_nullable_to_non_nullable
as int,leastActive: null == leastActive ? _self.leastActive : leastActive // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LocalPrefs {

 bool get favorite; bool get archived; String get notes; num get quantity;
/// Create a copy of LocalPrefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalPrefsCopyWith<LocalPrefs> get copyWith => _$LocalPrefsCopyWithImpl<LocalPrefs>(this as LocalPrefs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPrefs&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,favorite,archived,notes,quantity);

@override
String toString() {
  return 'LocalPrefs(favorite: $favorite, archived: $archived, notes: $notes, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $LocalPrefsCopyWith<$Res>  {
  factory $LocalPrefsCopyWith(LocalPrefs value, $Res Function(LocalPrefs) _then) = _$LocalPrefsCopyWithImpl;
@useResult
$Res call({
 bool favorite, bool archived, String notes, num quantity
});




}
/// @nodoc
class _$LocalPrefsCopyWithImpl<$Res>
    implements $LocalPrefsCopyWith<$Res> {
  _$LocalPrefsCopyWithImpl(this._self, this._then);

  final LocalPrefs _self;
  final $Res Function(LocalPrefs) _then;

/// Create a copy of LocalPrefs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? favorite = null,Object? archived = null,Object? notes = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalPrefs].
extension LocalPrefsPatterns on LocalPrefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalPrefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalPrefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalPrefs value)  $default,){
final _that = this;
switch (_that) {
case _LocalPrefs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalPrefs value)?  $default,){
final _that = this;
switch (_that) {
case _LocalPrefs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool favorite,  bool archived,  String notes,  num quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalPrefs() when $default != null:
return $default(_that.favorite,_that.archived,_that.notes,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool favorite,  bool archived,  String notes,  num quantity)  $default,) {final _that = this;
switch (_that) {
case _LocalPrefs():
return $default(_that.favorite,_that.archived,_that.notes,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool favorite,  bool archived,  String notes,  num quantity)?  $default,) {final _that = this;
switch (_that) {
case _LocalPrefs() when $default != null:
return $default(_that.favorite,_that.archived,_that.notes,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _LocalPrefs extends LocalPrefs {
  const _LocalPrefs({required this.favorite, required this.archived, required this.notes, required this.quantity}): super._();
  

@override final  bool favorite;
@override final  bool archived;
@override final  String notes;
@override final  num quantity;

/// Create a copy of LocalPrefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalPrefsCopyWith<_LocalPrefs> get copyWith => __$LocalPrefsCopyWithImpl<_LocalPrefs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalPrefs&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,favorite,archived,notes,quantity);

@override
String toString() {
  return 'LocalPrefs(favorite: $favorite, archived: $archived, notes: $notes, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$LocalPrefsCopyWith<$Res> implements $LocalPrefsCopyWith<$Res> {
  factory _$LocalPrefsCopyWith(_LocalPrefs value, $Res Function(_LocalPrefs) _then) = __$LocalPrefsCopyWithImpl;
@override @useResult
$Res call({
 bool favorite, bool archived, String notes, num quantity
});




}
/// @nodoc
class __$LocalPrefsCopyWithImpl<$Res>
    implements _$LocalPrefsCopyWith<$Res> {
  __$LocalPrefsCopyWithImpl(this._self, this._then);

  final _LocalPrefs _self;
  final $Res Function(_LocalPrefs) _then;

/// Create a copy of LocalPrefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? favorite = null,Object? archived = null,Object? notes = null,Object? quantity = null,}) {
  return _then(_LocalPrefs(
favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
