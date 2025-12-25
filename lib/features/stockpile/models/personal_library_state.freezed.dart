// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_library_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PersonalLibrarySummary {
  int get totalUses => throw _privateConstructorUsedError;
  int get activeSubstances => throw _privateConstructorUsedError;
  double get avgUses => throw _privateConstructorUsedError;
  String get mostUsedCategory => throw _privateConstructorUsedError;

  /// Create a copy of PersonalLibrarySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalLibrarySummaryCopyWith<PersonalLibrarySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalLibrarySummaryCopyWith<$Res> {
  factory $PersonalLibrarySummaryCopyWith(
    PersonalLibrarySummary value,
    $Res Function(PersonalLibrarySummary) then,
  ) = _$PersonalLibrarySummaryCopyWithImpl<$Res, PersonalLibrarySummary>;
  @useResult
  $Res call({
    int totalUses,
    int activeSubstances,
    double avgUses,
    String mostUsedCategory,
  });
}

/// @nodoc
class _$PersonalLibrarySummaryCopyWithImpl<
  $Res,
  $Val extends PersonalLibrarySummary
>
    implements $PersonalLibrarySummaryCopyWith<$Res> {
  _$PersonalLibrarySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalLibrarySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUses = null,
    Object? activeSubstances = null,
    Object? avgUses = null,
    Object? mostUsedCategory = null,
  }) {
    return _then(
      _value.copyWith(
            totalUses: null == totalUses
                ? _value.totalUses
                : totalUses // ignore: cast_nullable_to_non_nullable
                      as int,
            activeSubstances: null == activeSubstances
                ? _value.activeSubstances
                : activeSubstances // ignore: cast_nullable_to_non_nullable
                      as int,
            avgUses: null == avgUses
                ? _value.avgUses
                : avgUses // ignore: cast_nullable_to_non_nullable
                      as double,
            mostUsedCategory: null == mostUsedCategory
                ? _value.mostUsedCategory
                : mostUsedCategory // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PersonalLibrarySummaryImplCopyWith<$Res>
    implements $PersonalLibrarySummaryCopyWith<$Res> {
  factory _$$PersonalLibrarySummaryImplCopyWith(
    _$PersonalLibrarySummaryImpl value,
    $Res Function(_$PersonalLibrarySummaryImpl) then,
  ) = __$$PersonalLibrarySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalUses,
    int activeSubstances,
    double avgUses,
    String mostUsedCategory,
  });
}

/// @nodoc
class __$$PersonalLibrarySummaryImplCopyWithImpl<$Res>
    extends
        _$PersonalLibrarySummaryCopyWithImpl<$Res, _$PersonalLibrarySummaryImpl>
    implements _$$PersonalLibrarySummaryImplCopyWith<$Res> {
  __$$PersonalLibrarySummaryImplCopyWithImpl(
    _$PersonalLibrarySummaryImpl _value,
    $Res Function(_$PersonalLibrarySummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalLibrarySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUses = null,
    Object? activeSubstances = null,
    Object? avgUses = null,
    Object? mostUsedCategory = null,
  }) {
    return _then(
      _$PersonalLibrarySummaryImpl(
        totalUses: null == totalUses
            ? _value.totalUses
            : totalUses // ignore: cast_nullable_to_non_nullable
                  as int,
        activeSubstances: null == activeSubstances
            ? _value.activeSubstances
            : activeSubstances // ignore: cast_nullable_to_non_nullable
                  as int,
        avgUses: null == avgUses
            ? _value.avgUses
            : avgUses // ignore: cast_nullable_to_non_nullable
                  as double,
        mostUsedCategory: null == mostUsedCategory
            ? _value.mostUsedCategory
            : mostUsedCategory // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PersonalLibrarySummaryImpl extends _PersonalLibrarySummary {
  const _$PersonalLibrarySummaryImpl({
    this.totalUses = 0,
    this.activeSubstances = 0,
    this.avgUses = 0.0,
    this.mostUsedCategory = 'None',
  }) : super._();

  @override
  @JsonKey()
  final int totalUses;
  @override
  @JsonKey()
  final int activeSubstances;
  @override
  @JsonKey()
  final double avgUses;
  @override
  @JsonKey()
  final String mostUsedCategory;

  @override
  String toString() {
    return 'PersonalLibrarySummary(totalUses: $totalUses, activeSubstances: $activeSubstances, avgUses: $avgUses, mostUsedCategory: $mostUsedCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalLibrarySummaryImpl &&
            (identical(other.totalUses, totalUses) ||
                other.totalUses == totalUses) &&
            (identical(other.activeSubstances, activeSubstances) ||
                other.activeSubstances == activeSubstances) &&
            (identical(other.avgUses, avgUses) || other.avgUses == avgUses) &&
            (identical(other.mostUsedCategory, mostUsedCategory) ||
                other.mostUsedCategory == mostUsedCategory));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalUses,
    activeSubstances,
    avgUses,
    mostUsedCategory,
  );

  /// Create a copy of PersonalLibrarySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalLibrarySummaryImplCopyWith<_$PersonalLibrarySummaryImpl>
  get copyWith =>
      __$$PersonalLibrarySummaryImplCopyWithImpl<_$PersonalLibrarySummaryImpl>(
        this,
        _$identity,
      );
}

abstract class _PersonalLibrarySummary extends PersonalLibrarySummary {
  const factory _PersonalLibrarySummary({
    final int totalUses,
    final int activeSubstances,
    final double avgUses,
    final String mostUsedCategory,
  }) = _$PersonalLibrarySummaryImpl;
  const _PersonalLibrarySummary._() : super._();

  @override
  int get totalUses;
  @override
  int get activeSubstances;
  @override
  double get avgUses;
  @override
  String get mostUsedCategory;

  /// Create a copy of PersonalLibrarySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalLibrarySummaryImplCopyWith<_$PersonalLibrarySummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PersonalLibraryState {
  List<DrugCatalogEntry> get catalog => throw _privateConstructorUsedError;
  List<DrugCatalogEntry> get filtered => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  bool get showArchived => throw _privateConstructorUsedError;
  PersonalLibrarySummary get summary => throw _privateConstructorUsedError;

  /// Create a copy of PersonalLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalLibraryStateCopyWith<PersonalLibraryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalLibraryStateCopyWith<$Res> {
  factory $PersonalLibraryStateCopyWith(
    PersonalLibraryState value,
    $Res Function(PersonalLibraryState) then,
  ) = _$PersonalLibraryStateCopyWithImpl<$Res, PersonalLibraryState>;
  @useResult
  $Res call({
    List<DrugCatalogEntry> catalog,
    List<DrugCatalogEntry> filtered,
    String query,
    bool showArchived,
    PersonalLibrarySummary summary,
  });

  $PersonalLibrarySummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$PersonalLibraryStateCopyWithImpl<
  $Res,
  $Val extends PersonalLibraryState
>
    implements $PersonalLibraryStateCopyWith<$Res> {
  _$PersonalLibraryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? catalog = null,
    Object? filtered = null,
    Object? query = null,
    Object? showArchived = null,
    Object? summary = null,
  }) {
    return _then(
      _value.copyWith(
            catalog: null == catalog
                ? _value.catalog
                : catalog // ignore: cast_nullable_to_non_nullable
                      as List<DrugCatalogEntry>,
            filtered: null == filtered
                ? _value.filtered
                : filtered // ignore: cast_nullable_to_non_nullable
                      as List<DrugCatalogEntry>,
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
            showArchived: null == showArchived
                ? _value.showArchived
                : showArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as PersonalLibrarySummary,
          )
          as $Val,
    );
  }

  /// Create a copy of PersonalLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonalLibrarySummaryCopyWith<$Res> get summary {
    return $PersonalLibrarySummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PersonalLibraryStateImplCopyWith<$Res>
    implements $PersonalLibraryStateCopyWith<$Res> {
  factory _$$PersonalLibraryStateImplCopyWith(
    _$PersonalLibraryStateImpl value,
    $Res Function(_$PersonalLibraryStateImpl) then,
  ) = __$$PersonalLibraryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<DrugCatalogEntry> catalog,
    List<DrugCatalogEntry> filtered,
    String query,
    bool showArchived,
    PersonalLibrarySummary summary,
  });

  @override
  $PersonalLibrarySummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$PersonalLibraryStateImplCopyWithImpl<$Res>
    extends _$PersonalLibraryStateCopyWithImpl<$Res, _$PersonalLibraryStateImpl>
    implements _$$PersonalLibraryStateImplCopyWith<$Res> {
  __$$PersonalLibraryStateImplCopyWithImpl(
    _$PersonalLibraryStateImpl _value,
    $Res Function(_$PersonalLibraryStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? catalog = null,
    Object? filtered = null,
    Object? query = null,
    Object? showArchived = null,
    Object? summary = null,
  }) {
    return _then(
      _$PersonalLibraryStateImpl(
        catalog: null == catalog
            ? _value._catalog
            : catalog // ignore: cast_nullable_to_non_nullable
                  as List<DrugCatalogEntry>,
        filtered: null == filtered
            ? _value._filtered
            : filtered // ignore: cast_nullable_to_non_nullable
                  as List<DrugCatalogEntry>,
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        showArchived: null == showArchived
            ? _value.showArchived
            : showArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as PersonalLibrarySummary,
      ),
    );
  }
}

/// @nodoc

class _$PersonalLibraryStateImpl extends _PersonalLibraryState {
  const _$PersonalLibraryStateImpl({
    final List<DrugCatalogEntry> catalog = const <DrugCatalogEntry>[],
    final List<DrugCatalogEntry> filtered = const <DrugCatalogEntry>[],
    this.query = '',
    this.showArchived = false,
    this.summary = const PersonalLibrarySummary(),
  }) : _catalog = catalog,
       _filtered = filtered,
       super._();

  final List<DrugCatalogEntry> _catalog;
  @override
  @JsonKey()
  List<DrugCatalogEntry> get catalog {
    if (_catalog is EqualUnmodifiableListView) return _catalog;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_catalog);
  }

  final List<DrugCatalogEntry> _filtered;
  @override
  @JsonKey()
  List<DrugCatalogEntry> get filtered {
    if (_filtered is EqualUnmodifiableListView) return _filtered;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filtered);
  }

  @override
  @JsonKey()
  final String query;
  @override
  @JsonKey()
  final bool showArchived;
  @override
  @JsonKey()
  final PersonalLibrarySummary summary;

  @override
  String toString() {
    return 'PersonalLibraryState(catalog: $catalog, filtered: $filtered, query: $query, showArchived: $showArchived, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalLibraryStateImpl &&
            const DeepCollectionEquality().equals(other._catalog, _catalog) &&
            const DeepCollectionEquality().equals(other._filtered, _filtered) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.showArchived, showArchived) ||
                other.showArchived == showArchived) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_catalog),
    const DeepCollectionEquality().hash(_filtered),
    query,
    showArchived,
    summary,
  );

  /// Create a copy of PersonalLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalLibraryStateImplCopyWith<_$PersonalLibraryStateImpl>
  get copyWith =>
      __$$PersonalLibraryStateImplCopyWithImpl<_$PersonalLibraryStateImpl>(
        this,
        _$identity,
      );
}

abstract class _PersonalLibraryState extends PersonalLibraryState {
  const factory _PersonalLibraryState({
    final List<DrugCatalogEntry> catalog,
    final List<DrugCatalogEntry> filtered,
    final String query,
    final bool showArchived,
    final PersonalLibrarySummary summary,
  }) = _$PersonalLibraryStateImpl;
  const _PersonalLibraryState._() : super._();

  @override
  List<DrugCatalogEntry> get catalog;
  @override
  List<DrugCatalogEntry> get filtered;
  @override
  String get query;
  @override
  bool get showArchived;
  @override
  PersonalLibrarySummary get summary;

  /// Create a copy of PersonalLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalLibraryStateImplCopyWith<_$PersonalLibraryStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
