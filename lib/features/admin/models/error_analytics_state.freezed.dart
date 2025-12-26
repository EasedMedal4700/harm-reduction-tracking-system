// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_analytics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ErrorAnalyticsState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isClearingErrors => throw _privateConstructorUsedError;
  ErrorAnalytics get analytics => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ErrorAnalyticsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ErrorAnalyticsStateCopyWith<ErrorAnalyticsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorAnalyticsStateCopyWith<$Res> {
  factory $ErrorAnalyticsStateCopyWith(
    ErrorAnalyticsState value,
    $Res Function(ErrorAnalyticsState) then,
  ) = _$ErrorAnalyticsStateCopyWithImpl<$Res, ErrorAnalyticsState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isClearingErrors,
    ErrorAnalytics analytics,
    String? errorMessage,
  });

  $ErrorAnalyticsCopyWith<$Res> get analytics;
}

/// @nodoc
class _$ErrorAnalyticsStateCopyWithImpl<$Res, $Val extends ErrorAnalyticsState>
    implements $ErrorAnalyticsStateCopyWith<$Res> {
  _$ErrorAnalyticsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ErrorAnalyticsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isClearingErrors = null,
    Object? analytics = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isClearingErrors: null == isClearingErrors
                ? _value.isClearingErrors
                : isClearingErrors // ignore: cast_nullable_to_non_nullable
                      as bool,
            analytics: null == analytics
                ? _value.analytics
                : analytics // ignore: cast_nullable_to_non_nullable
                      as ErrorAnalytics,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ErrorAnalyticsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ErrorAnalyticsCopyWith<$Res> get analytics {
    return $ErrorAnalyticsCopyWith<$Res>(_value.analytics, (value) {
      return _then(_value.copyWith(analytics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ErrorAnalyticsStateImplCopyWith<$Res>
    implements $ErrorAnalyticsStateCopyWith<$Res> {
  factory _$$ErrorAnalyticsStateImplCopyWith(
    _$ErrorAnalyticsStateImpl value,
    $Res Function(_$ErrorAnalyticsStateImpl) then,
  ) = __$$ErrorAnalyticsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isClearingErrors,
    ErrorAnalytics analytics,
    String? errorMessage,
  });

  @override
  $ErrorAnalyticsCopyWith<$Res> get analytics;
}

/// @nodoc
class __$$ErrorAnalyticsStateImplCopyWithImpl<$Res>
    extends _$ErrorAnalyticsStateCopyWithImpl<$Res, _$ErrorAnalyticsStateImpl>
    implements _$$ErrorAnalyticsStateImplCopyWith<$Res> {
  __$$ErrorAnalyticsStateImplCopyWithImpl(
    _$ErrorAnalyticsStateImpl _value,
    $Res Function(_$ErrorAnalyticsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ErrorAnalyticsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isClearingErrors = null,
    Object? analytics = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$ErrorAnalyticsStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isClearingErrors: null == isClearingErrors
            ? _value.isClearingErrors
            : isClearingErrors // ignore: cast_nullable_to_non_nullable
                  as bool,
        analytics: null == analytics
            ? _value.analytics
            : analytics // ignore: cast_nullable_to_non_nullable
                  as ErrorAnalytics,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ErrorAnalyticsStateImpl implements _ErrorAnalyticsState {
  const _$ErrorAnalyticsStateImpl({
    this.isLoading = true,
    this.isClearingErrors = false,
    this.analytics = const ErrorAnalytics(),
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isClearingErrors;
  @override
  @JsonKey()
  final ErrorAnalytics analytics;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ErrorAnalyticsState(isLoading: $isLoading, isClearingErrors: $isClearingErrors, analytics: $analytics, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorAnalyticsStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isClearingErrors, isClearingErrors) ||
                other.isClearingErrors == isClearingErrors) &&
            (identical(other.analytics, analytics) ||
                other.analytics == analytics) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    isClearingErrors,
    analytics,
    errorMessage,
  );

  /// Create a copy of ErrorAnalyticsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorAnalyticsStateImplCopyWith<_$ErrorAnalyticsStateImpl> get copyWith =>
      __$$ErrorAnalyticsStateImplCopyWithImpl<_$ErrorAnalyticsStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ErrorAnalyticsState implements ErrorAnalyticsState {
  const factory _ErrorAnalyticsState({
    final bool isLoading,
    final bool isClearingErrors,
    final ErrorAnalytics analytics,
    final String? errorMessage,
  }) = _$ErrorAnalyticsStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isClearingErrors;
  @override
  ErrorAnalytics get analytics;
  @override
  String? get errorMessage;

  /// Create a copy of ErrorAnalyticsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorAnalyticsStateImplCopyWith<_$ErrorAnalyticsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
