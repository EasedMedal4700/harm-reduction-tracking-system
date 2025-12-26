// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_panel_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AdminPanelState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<AdminUser> get users => throw _privateConstructorUsedError;
  AdminSystemStats get systemStats => throw _privateConstructorUsedError;
  AdminCacheStats get cacheStats => throw _privateConstructorUsedError;
  AdminPerformanceStats get performanceStats =>
      throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of AdminPanelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminPanelStateCopyWith<AdminPanelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminPanelStateCopyWith<$Res> {
  factory $AdminPanelStateCopyWith(
    AdminPanelState value,
    $Res Function(AdminPanelState) then,
  ) = _$AdminPanelStateCopyWithImpl<$Res, AdminPanelState>;
  @useResult
  $Res call({
    bool isLoading,
    List<AdminUser> users,
    AdminSystemStats systemStats,
    AdminCacheStats cacheStats,
    AdminPerformanceStats performanceStats,
    String? errorMessage,
  });

  $AdminSystemStatsCopyWith<$Res> get systemStats;
  $AdminCacheStatsCopyWith<$Res> get cacheStats;
  $AdminPerformanceStatsCopyWith<$Res> get performanceStats;
}

/// @nodoc
class _$AdminPanelStateCopyWithImpl<$Res, $Val extends AdminPanelState>
    implements $AdminPanelStateCopyWith<$Res> {
  _$AdminPanelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminPanelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? users = null,
    Object? systemStats = null,
    Object? cacheStats = null,
    Object? performanceStats = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<AdminUser>,
            systemStats: null == systemStats
                ? _value.systemStats
                : systemStats // ignore: cast_nullable_to_non_nullable
                      as AdminSystemStats,
            cacheStats: null == cacheStats
                ? _value.cacheStats
                : cacheStats // ignore: cast_nullable_to_non_nullable
                      as AdminCacheStats,
            performanceStats: null == performanceStats
                ? _value.performanceStats
                : performanceStats // ignore: cast_nullable_to_non_nullable
                      as AdminPerformanceStats,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of AdminPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdminSystemStatsCopyWith<$Res> get systemStats {
    return $AdminSystemStatsCopyWith<$Res>(_value.systemStats, (value) {
      return _then(_value.copyWith(systemStats: value) as $Val);
    });
  }

  /// Create a copy of AdminPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdminCacheStatsCopyWith<$Res> get cacheStats {
    return $AdminCacheStatsCopyWith<$Res>(_value.cacheStats, (value) {
      return _then(_value.copyWith(cacheStats: value) as $Val);
    });
  }

  /// Create a copy of AdminPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdminPerformanceStatsCopyWith<$Res> get performanceStats {
    return $AdminPerformanceStatsCopyWith<$Res>(_value.performanceStats, (
      value,
    ) {
      return _then(_value.copyWith(performanceStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdminPanelStateImplCopyWith<$Res>
    implements $AdminPanelStateCopyWith<$Res> {
  factory _$$AdminPanelStateImplCopyWith(
    _$AdminPanelStateImpl value,
    $Res Function(_$AdminPanelStateImpl) then,
  ) = __$$AdminPanelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    List<AdminUser> users,
    AdminSystemStats systemStats,
    AdminCacheStats cacheStats,
    AdminPerformanceStats performanceStats,
    String? errorMessage,
  });

  @override
  $AdminSystemStatsCopyWith<$Res> get systemStats;
  @override
  $AdminCacheStatsCopyWith<$Res> get cacheStats;
  @override
  $AdminPerformanceStatsCopyWith<$Res> get performanceStats;
}

/// @nodoc
class __$$AdminPanelStateImplCopyWithImpl<$Res>
    extends _$AdminPanelStateCopyWithImpl<$Res, _$AdminPanelStateImpl>
    implements _$$AdminPanelStateImplCopyWith<$Res> {
  __$$AdminPanelStateImplCopyWithImpl(
    _$AdminPanelStateImpl _value,
    $Res Function(_$AdminPanelStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminPanelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? users = null,
    Object? systemStats = null,
    Object? cacheStats = null,
    Object? performanceStats = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$AdminPanelStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<AdminUser>,
        systemStats: null == systemStats
            ? _value.systemStats
            : systemStats // ignore: cast_nullable_to_non_nullable
                  as AdminSystemStats,
        cacheStats: null == cacheStats
            ? _value.cacheStats
            : cacheStats // ignore: cast_nullable_to_non_nullable
                  as AdminCacheStats,
        performanceStats: null == performanceStats
            ? _value.performanceStats
            : performanceStats // ignore: cast_nullable_to_non_nullable
                  as AdminPerformanceStats,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AdminPanelStateImpl implements _AdminPanelState {
  const _$AdminPanelStateImpl({
    this.isLoading = true,
    final List<AdminUser> users = const <AdminUser>[],
    this.systemStats = const AdminSystemStats(),
    this.cacheStats = const AdminCacheStats(),
    this.performanceStats = const AdminPerformanceStats(),
    this.errorMessage,
  }) : _users = users;

  @override
  @JsonKey()
  final bool isLoading;
  final List<AdminUser> _users;
  @override
  @JsonKey()
  List<AdminUser> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  @JsonKey()
  final AdminSystemStats systemStats;
  @override
  @JsonKey()
  final AdminCacheStats cacheStats;
  @override
  @JsonKey()
  final AdminPerformanceStats performanceStats;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AdminPanelState(isLoading: $isLoading, users: $users, systemStats: $systemStats, cacheStats: $cacheStats, performanceStats: $performanceStats, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminPanelStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.systemStats, systemStats) ||
                other.systemStats == systemStats) &&
            (identical(other.cacheStats, cacheStats) ||
                other.cacheStats == cacheStats) &&
            (identical(other.performanceStats, performanceStats) ||
                other.performanceStats == performanceStats) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_users),
    systemStats,
    cacheStats,
    performanceStats,
    errorMessage,
  );

  /// Create a copy of AdminPanelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminPanelStateImplCopyWith<_$AdminPanelStateImpl> get copyWith =>
      __$$AdminPanelStateImplCopyWithImpl<_$AdminPanelStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AdminPanelState implements AdminPanelState {
  const factory _AdminPanelState({
    final bool isLoading,
    final List<AdminUser> users,
    final AdminSystemStats systemStats,
    final AdminCacheStats cacheStats,
    final AdminPerformanceStats performanceStats,
    final String? errorMessage,
  }) = _$AdminPanelStateImpl;

  @override
  bool get isLoading;
  @override
  List<AdminUser> get users;
  @override
  AdminSystemStats get systemStats;
  @override
  AdminCacheStats get cacheStats;
  @override
  AdminPerformanceStats get performanceStats;
  @override
  String? get errorMessage;

  /// Create a copy of AdminPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminPanelStateImplCopyWith<_$AdminPanelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
