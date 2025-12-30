// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bug_report_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BugReportUiEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, bool isError) snackbar,
    required TResult Function() none,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, bool isError)? snackbar,
    TResult? Function()? none,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, bool isError)? snackbar,
    TResult Function()? none,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BugReportSnackbar value) snackbar,
    required TResult Function(_BugReportNone value) none,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BugReportSnackbar value)? snackbar,
    TResult? Function(_BugReportNone value)? none,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BugReportSnackbar value)? snackbar,
    TResult Function(_BugReportNone value)? none,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BugReportUiEventCopyWith<$Res> {
  factory $BugReportUiEventCopyWith(
    BugReportUiEvent value,
    $Res Function(BugReportUiEvent) then,
  ) = _$BugReportUiEventCopyWithImpl<$Res, BugReportUiEvent>;
}

/// @nodoc
class _$BugReportUiEventCopyWithImpl<$Res, $Val extends BugReportUiEvent>
    implements $BugReportUiEventCopyWith<$Res> {
  _$BugReportUiEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BugReportUiEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BugReportSnackbarImplCopyWith<$Res> {
  factory _$$BugReportSnackbarImplCopyWith(
    _$BugReportSnackbarImpl value,
    $Res Function(_$BugReportSnackbarImpl) then,
  ) = __$$BugReportSnackbarImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, bool isError});
}

/// @nodoc
class __$$BugReportSnackbarImplCopyWithImpl<$Res>
    extends _$BugReportUiEventCopyWithImpl<$Res, _$BugReportSnackbarImpl>
    implements _$$BugReportSnackbarImplCopyWith<$Res> {
  __$$BugReportSnackbarImplCopyWithImpl(
    _$BugReportSnackbarImpl _value,
    $Res Function(_$BugReportSnackbarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BugReportUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? isError = null}) {
    return _then(
      _$BugReportSnackbarImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        isError: null == isError
            ? _value.isError
            : isError // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$BugReportSnackbarImpl implements _BugReportSnackbar {
  const _$BugReportSnackbarImpl({required this.message, this.isError = false});

  @override
  final String message;
  @override
  @JsonKey()
  final bool isError;

  @override
  String toString() {
    return 'BugReportUiEvent.snackbar(message: $message, isError: $isError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BugReportSnackbarImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isError, isError) || other.isError == isError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, isError);

  /// Create a copy of BugReportUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BugReportSnackbarImplCopyWith<_$BugReportSnackbarImpl> get copyWith =>
      __$$BugReportSnackbarImplCopyWithImpl<_$BugReportSnackbarImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, bool isError) snackbar,
    required TResult Function() none,
  }) {
    return snackbar(message, isError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, bool isError)? snackbar,
    TResult? Function()? none,
  }) {
    return snackbar?.call(message, isError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, bool isError)? snackbar,
    TResult Function()? none,
    required TResult orElse(),
  }) {
    if (snackbar != null) {
      return snackbar(message, isError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BugReportSnackbar value) snackbar,
    required TResult Function(_BugReportNone value) none,
  }) {
    return snackbar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BugReportSnackbar value)? snackbar,
    TResult? Function(_BugReportNone value)? none,
  }) {
    return snackbar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BugReportSnackbar value)? snackbar,
    TResult Function(_BugReportNone value)? none,
    required TResult orElse(),
  }) {
    if (snackbar != null) {
      return snackbar(this);
    }
    return orElse();
  }
}

abstract class _BugReportSnackbar implements BugReportUiEvent {
  const factory _BugReportSnackbar({
    required final String message,
    final bool isError,
  }) = _$BugReportSnackbarImpl;

  String get message;
  bool get isError;

  /// Create a copy of BugReportUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BugReportSnackbarImplCopyWith<_$BugReportSnackbarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BugReportNoneImplCopyWith<$Res> {
  factory _$$BugReportNoneImplCopyWith(
    _$BugReportNoneImpl value,
    $Res Function(_$BugReportNoneImpl) then,
  ) = __$$BugReportNoneImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BugReportNoneImplCopyWithImpl<$Res>
    extends _$BugReportUiEventCopyWithImpl<$Res, _$BugReportNoneImpl>
    implements _$$BugReportNoneImplCopyWith<$Res> {
  __$$BugReportNoneImplCopyWithImpl(
    _$BugReportNoneImpl _value,
    $Res Function(_$BugReportNoneImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BugReportUiEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BugReportNoneImpl implements _BugReportNone {
  const _$BugReportNoneImpl();

  @override
  String toString() {
    return 'BugReportUiEvent.none()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BugReportNoneImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, bool isError) snackbar,
    required TResult Function() none,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, bool isError)? snackbar,
    TResult? Function()? none,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, bool isError)? snackbar,
    TResult Function()? none,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BugReportSnackbar value) snackbar,
    required TResult Function(_BugReportNone value) none,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BugReportSnackbar value)? snackbar,
    TResult? Function(_BugReportNone value)? none,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BugReportSnackbar value)? snackbar,
    TResult Function(_BugReportNone value)? none,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class _BugReportNone implements BugReportUiEvent {
  const factory _BugReportNone() = _$BugReportNoneImpl;
}

/// @nodoc
mixin _$BugReportState {
  String get severity => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  BugReportUiEvent get uiEvent => throw _privateConstructorUsedError;

  /// Create a copy of BugReportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BugReportStateCopyWith<BugReportState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BugReportStateCopyWith<$Res> {
  factory $BugReportStateCopyWith(
    BugReportState value,
    $Res Function(BugReportState) then,
  ) = _$BugReportStateCopyWithImpl<$Res, BugReportState>;
  @useResult
  $Res call({
    String severity,
    String category,
    bool isSubmitting,
    BugReportUiEvent uiEvent,
  });

  $BugReportUiEventCopyWith<$Res> get uiEvent;
}

/// @nodoc
class _$BugReportStateCopyWithImpl<$Res, $Val extends BugReportState>
    implements $BugReportStateCopyWith<$Res> {
  _$BugReportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BugReportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? severity = null,
    Object? category = null,
    Object? isSubmitting = null,
    Object? uiEvent = null,
  }) {
    return _then(
      _value.copyWith(
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            uiEvent: null == uiEvent
                ? _value.uiEvent
                : uiEvent // ignore: cast_nullable_to_non_nullable
                      as BugReportUiEvent,
          )
          as $Val,
    );
  }

  /// Create a copy of BugReportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BugReportUiEventCopyWith<$Res> get uiEvent {
    return $BugReportUiEventCopyWith<$Res>(_value.uiEvent, (value) {
      return _then(_value.copyWith(uiEvent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BugReportStateImplCopyWith<$Res>
    implements $BugReportStateCopyWith<$Res> {
  factory _$$BugReportStateImplCopyWith(
    _$BugReportStateImpl value,
    $Res Function(_$BugReportStateImpl) then,
  ) = __$$BugReportStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String severity,
    String category,
    bool isSubmitting,
    BugReportUiEvent uiEvent,
  });

  @override
  $BugReportUiEventCopyWith<$Res> get uiEvent;
}

/// @nodoc
class __$$BugReportStateImplCopyWithImpl<$Res>
    extends _$BugReportStateCopyWithImpl<$Res, _$BugReportStateImpl>
    implements _$$BugReportStateImplCopyWith<$Res> {
  __$$BugReportStateImplCopyWithImpl(
    _$BugReportStateImpl _value,
    $Res Function(_$BugReportStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BugReportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? severity = null,
    Object? category = null,
    Object? isSubmitting = null,
    Object? uiEvent = null,
  }) {
    return _then(
      _$BugReportStateImpl(
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        uiEvent: null == uiEvent
            ? _value.uiEvent
            : uiEvent // ignore: cast_nullable_to_non_nullable
                  as BugReportUiEvent,
      ),
    );
  }
}

/// @nodoc

class _$BugReportStateImpl implements _BugReportState {
  const _$BugReportStateImpl({
    this.severity = 'Medium',
    this.category = 'General',
    this.isSubmitting = false,
    this.uiEvent = const BugReportUiEvent.none(),
  });

  @override
  @JsonKey()
  final String severity;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  @JsonKey()
  final BugReportUiEvent uiEvent;

  @override
  String toString() {
    return 'BugReportState(severity: $severity, category: $category, isSubmitting: $isSubmitting, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BugReportStateImpl &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, severity, category, isSubmitting, uiEvent);

  /// Create a copy of BugReportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BugReportStateImplCopyWith<_$BugReportStateImpl> get copyWith =>
      __$$BugReportStateImplCopyWithImpl<_$BugReportStateImpl>(
        this,
        _$identity,
      );
}

abstract class _BugReportState implements BugReportState {
  const factory _BugReportState({
    final String severity,
    final String category,
    final bool isSubmitting,
    final BugReportUiEvent uiEvent,
  }) = _$BugReportStateImpl;

  @override
  String get severity;
  @override
  String get category;
  @override
  bool get isSubmitting;
  @override
  BugReportUiEvent get uiEvent;

  /// Create a copy of BugReportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BugReportStateImplCopyWith<_$BugReportStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
