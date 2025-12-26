// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_cache_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AdminCacheStats {
  int get totalEntries => throw _privateConstructorUsedError;
  int get activeEntries => throw _privateConstructorUsedError;
  int get expiredEntries => throw _privateConstructorUsedError;

  /// Create a copy of AdminCacheStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminCacheStatsCopyWith<AdminCacheStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminCacheStatsCopyWith<$Res> {
  factory $AdminCacheStatsCopyWith(
    AdminCacheStats value,
    $Res Function(AdminCacheStats) then,
  ) = _$AdminCacheStatsCopyWithImpl<$Res, AdminCacheStats>;
  @useResult
  $Res call({int totalEntries, int activeEntries, int expiredEntries});
}

/// @nodoc
class _$AdminCacheStatsCopyWithImpl<$Res, $Val extends AdminCacheStats>
    implements $AdminCacheStatsCopyWith<$Res> {
  _$AdminCacheStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminCacheStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEntries = null,
    Object? activeEntries = null,
    Object? expiredEntries = null,
  }) {
    return _then(
      _value.copyWith(
            totalEntries: null == totalEntries
                ? _value.totalEntries
                : totalEntries // ignore: cast_nullable_to_non_nullable
                      as int,
            activeEntries: null == activeEntries
                ? _value.activeEntries
                : activeEntries // ignore: cast_nullable_to_non_nullable
                      as int,
            expiredEntries: null == expiredEntries
                ? _value.expiredEntries
                : expiredEntries // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdminCacheStatsImplCopyWith<$Res>
    implements $AdminCacheStatsCopyWith<$Res> {
  factory _$$AdminCacheStatsImplCopyWith(
    _$AdminCacheStatsImpl value,
    $Res Function(_$AdminCacheStatsImpl) then,
  ) = __$$AdminCacheStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalEntries, int activeEntries, int expiredEntries});
}

/// @nodoc
class __$$AdminCacheStatsImplCopyWithImpl<$Res>
    extends _$AdminCacheStatsCopyWithImpl<$Res, _$AdminCacheStatsImpl>
    implements _$$AdminCacheStatsImplCopyWith<$Res> {
  __$$AdminCacheStatsImplCopyWithImpl(
    _$AdminCacheStatsImpl _value,
    $Res Function(_$AdminCacheStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminCacheStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEntries = null,
    Object? activeEntries = null,
    Object? expiredEntries = null,
  }) {
    return _then(
      _$AdminCacheStatsImpl(
        totalEntries: null == totalEntries
            ? _value.totalEntries
            : totalEntries // ignore: cast_nullable_to_non_nullable
                  as int,
        activeEntries: null == activeEntries
            ? _value.activeEntries
            : activeEntries // ignore: cast_nullable_to_non_nullable
                  as int,
        expiredEntries: null == expiredEntries
            ? _value.expiredEntries
            : expiredEntries // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$AdminCacheStatsImpl implements _AdminCacheStats {
  const _$AdminCacheStatsImpl({
    this.totalEntries = 0,
    this.activeEntries = 0,
    this.expiredEntries = 0,
  });

  @override
  @JsonKey()
  final int totalEntries;
  @override
  @JsonKey()
  final int activeEntries;
  @override
  @JsonKey()
  final int expiredEntries;

  @override
  String toString() {
    return 'AdminCacheStats(totalEntries: $totalEntries, activeEntries: $activeEntries, expiredEntries: $expiredEntries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminCacheStatsImpl &&
            (identical(other.totalEntries, totalEntries) ||
                other.totalEntries == totalEntries) &&
            (identical(other.activeEntries, activeEntries) ||
                other.activeEntries == activeEntries) &&
            (identical(other.expiredEntries, expiredEntries) ||
                other.expiredEntries == expiredEntries));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, totalEntries, activeEntries, expiredEntries);

  /// Create a copy of AdminCacheStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminCacheStatsImplCopyWith<_$AdminCacheStatsImpl> get copyWith =>
      __$$AdminCacheStatsImplCopyWithImpl<_$AdminCacheStatsImpl>(
        this,
        _$identity,
      );
}

abstract class _AdminCacheStats implements AdminCacheStats {
  const factory _AdminCacheStats({
    final int totalEntries,
    final int activeEntries,
    final int expiredEntries,
  }) = _$AdminCacheStatsImpl;

  @override
  int get totalEntries;
  @override
  int get activeEntries;
  @override
  int get expiredEntries;

  /// Create a copy of AdminCacheStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminCacheStatsImplCopyWith<_$AdminCacheStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
