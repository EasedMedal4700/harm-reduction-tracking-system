// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_system_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AdminSystemStats {
  int get totalEntries => throw _privateConstructorUsedError;
  int get activeUsers => throw _privateConstructorUsedError;
  double get cacheHitRate => throw _privateConstructorUsedError;
  double get avgResponseTimeMs => throw _privateConstructorUsedError;

  /// Create a copy of AdminSystemStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminSystemStatsCopyWith<AdminSystemStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminSystemStatsCopyWith<$Res> {
  factory $AdminSystemStatsCopyWith(
    AdminSystemStats value,
    $Res Function(AdminSystemStats) then,
  ) = _$AdminSystemStatsCopyWithImpl<$Res, AdminSystemStats>;
  @useResult
  $Res call({
    int totalEntries,
    int activeUsers,
    double cacheHitRate,
    double avgResponseTimeMs,
  });
}

/// @nodoc
class _$AdminSystemStatsCopyWithImpl<$Res, $Val extends AdminSystemStats>
    implements $AdminSystemStatsCopyWith<$Res> {
  _$AdminSystemStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminSystemStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEntries = null,
    Object? activeUsers = null,
    Object? cacheHitRate = null,
    Object? avgResponseTimeMs = null,
  }) {
    return _then(
      _value.copyWith(
            totalEntries: null == totalEntries
                ? _value.totalEntries
                : totalEntries // ignore: cast_nullable_to_non_nullable
                      as int,
            activeUsers: null == activeUsers
                ? _value.activeUsers
                : activeUsers // ignore: cast_nullable_to_non_nullable
                      as int,
            cacheHitRate: null == cacheHitRate
                ? _value.cacheHitRate
                : cacheHitRate // ignore: cast_nullable_to_non_nullable
                      as double,
            avgResponseTimeMs: null == avgResponseTimeMs
                ? _value.avgResponseTimeMs
                : avgResponseTimeMs // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdminSystemStatsImplCopyWith<$Res>
    implements $AdminSystemStatsCopyWith<$Res> {
  factory _$$AdminSystemStatsImplCopyWith(
    _$AdminSystemStatsImpl value,
    $Res Function(_$AdminSystemStatsImpl) then,
  ) = __$$AdminSystemStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalEntries,
    int activeUsers,
    double cacheHitRate,
    double avgResponseTimeMs,
  });
}

/// @nodoc
class __$$AdminSystemStatsImplCopyWithImpl<$Res>
    extends _$AdminSystemStatsCopyWithImpl<$Res, _$AdminSystemStatsImpl>
    implements _$$AdminSystemStatsImplCopyWith<$Res> {
  __$$AdminSystemStatsImplCopyWithImpl(
    _$AdminSystemStatsImpl _value,
    $Res Function(_$AdminSystemStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminSystemStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEntries = null,
    Object? activeUsers = null,
    Object? cacheHitRate = null,
    Object? avgResponseTimeMs = null,
  }) {
    return _then(
      _$AdminSystemStatsImpl(
        totalEntries: null == totalEntries
            ? _value.totalEntries
            : totalEntries // ignore: cast_nullable_to_non_nullable
                  as int,
        activeUsers: null == activeUsers
            ? _value.activeUsers
            : activeUsers // ignore: cast_nullable_to_non_nullable
                  as int,
        cacheHitRate: null == cacheHitRate
            ? _value.cacheHitRate
            : cacheHitRate // ignore: cast_nullable_to_non_nullable
                  as double,
        avgResponseTimeMs: null == avgResponseTimeMs
            ? _value.avgResponseTimeMs
            : avgResponseTimeMs // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$AdminSystemStatsImpl implements _AdminSystemStats {
  const _$AdminSystemStatsImpl({
    this.totalEntries = 0,
    this.activeUsers = 0,
    this.cacheHitRate = 0.0,
    this.avgResponseTimeMs = 0.0,
  });

  @override
  @JsonKey()
  final int totalEntries;
  @override
  @JsonKey()
  final int activeUsers;
  @override
  @JsonKey()
  final double cacheHitRate;
  @override
  @JsonKey()
  final double avgResponseTimeMs;

  @override
  String toString() {
    return 'AdminSystemStats(totalEntries: $totalEntries, activeUsers: $activeUsers, cacheHitRate: $cacheHitRate, avgResponseTimeMs: $avgResponseTimeMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminSystemStatsImpl &&
            (identical(other.totalEntries, totalEntries) ||
                other.totalEntries == totalEntries) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.cacheHitRate, cacheHitRate) ||
                other.cacheHitRate == cacheHitRate) &&
            (identical(other.avgResponseTimeMs, avgResponseTimeMs) ||
                other.avgResponseTimeMs == avgResponseTimeMs));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalEntries,
    activeUsers,
    cacheHitRate,
    avgResponseTimeMs,
  );

  /// Create a copy of AdminSystemStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminSystemStatsImplCopyWith<_$AdminSystemStatsImpl> get copyWith =>
      __$$AdminSystemStatsImplCopyWithImpl<_$AdminSystemStatsImpl>(
        this,
        _$identity,
      );
}

abstract class _AdminSystemStats implements AdminSystemStats {
  const factory _AdminSystemStats({
    final int totalEntries,
    final int activeUsers,
    final double cacheHitRate,
    final double avgResponseTimeMs,
  }) = _$AdminSystemStatsImpl;

  @override
  int get totalEntries;
  @override
  int get activeUsers;
  @override
  double get cacheHitRate;
  @override
  double get avgResponseTimeMs;

  /// Create a copy of AdminSystemStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminSystemStatsImplCopyWith<_$AdminSystemStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
