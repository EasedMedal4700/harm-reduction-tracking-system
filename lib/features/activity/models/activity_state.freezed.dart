// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ActivityUiEvent {
  String get message => throw _privateConstructorUsedError;
  ActivityUiEventTone get tone => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, ActivityUiEventTone tone)
    snackBar,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, ActivityUiEventTone tone)? snackBar,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, ActivityUiEventTone tone)? snackBar,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SnackBar value) snackBar,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SnackBar value)? snackBar,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SnackBar value)? snackBar,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of ActivityUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityUiEventCopyWith<ActivityUiEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityUiEventCopyWith<$Res> {
  factory $ActivityUiEventCopyWith(
    ActivityUiEvent value,
    $Res Function(ActivityUiEvent) then,
  ) = _$ActivityUiEventCopyWithImpl<$Res, ActivityUiEvent>;
  @useResult
  $Res call({String message, ActivityUiEventTone tone});
}

/// @nodoc
class _$ActivityUiEventCopyWithImpl<$Res, $Val extends ActivityUiEvent>
    implements $ActivityUiEventCopyWith<$Res> {
  _$ActivityUiEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? tone = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            tone: null == tone
                ? _value.tone
                : tone // ignore: cast_nullable_to_non_nullable
                      as ActivityUiEventTone,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SnackBarImplCopyWith<$Res>
    implements $ActivityUiEventCopyWith<$Res> {
  factory _$$SnackBarImplCopyWith(
    _$SnackBarImpl value,
    $Res Function(_$SnackBarImpl) then,
  ) = __$$SnackBarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, ActivityUiEventTone tone});
}

/// @nodoc
class __$$SnackBarImplCopyWithImpl<$Res>
    extends _$ActivityUiEventCopyWithImpl<$Res, _$SnackBarImpl>
    implements _$$SnackBarImplCopyWith<$Res> {
  __$$SnackBarImplCopyWithImpl(
    _$SnackBarImpl _value,
    $Res Function(_$SnackBarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? tone = null}) {
    return _then(
      _$SnackBarImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        tone: null == tone
            ? _value.tone
            : tone // ignore: cast_nullable_to_non_nullable
                  as ActivityUiEventTone,
      ),
    );
  }
}

/// @nodoc

class _$SnackBarImpl implements _SnackBar {
  const _$SnackBarImpl({
    required this.message,
    this.tone = ActivityUiEventTone.neutral,
  });

  @override
  final String message;
  @override
  @JsonKey()
  final ActivityUiEventTone tone;

  @override
  String toString() {
    return 'ActivityUiEvent.snackBar(message: $message, tone: $tone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnackBarImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.tone, tone) || other.tone == tone));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, tone);

  /// Create a copy of ActivityUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SnackBarImplCopyWith<_$SnackBarImpl> get copyWith =>
      __$$SnackBarImplCopyWithImpl<_$SnackBarImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, ActivityUiEventTone tone)
    snackBar,
  }) {
    return snackBar(message, tone);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, ActivityUiEventTone tone)? snackBar,
  }) {
    return snackBar?.call(message, tone);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, ActivityUiEventTone tone)? snackBar,
    required TResult orElse(),
  }) {
    if (snackBar != null) {
      return snackBar(message, tone);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SnackBar value) snackBar,
  }) {
    return snackBar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SnackBar value)? snackBar,
  }) {
    return snackBar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SnackBar value)? snackBar,
    required TResult orElse(),
  }) {
    if (snackBar != null) {
      return snackBar(this);
    }
    return orElse();
  }
}

abstract class _SnackBar implements ActivityUiEvent {
  const factory _SnackBar({
    required final String message,
    final ActivityUiEventTone tone,
  }) = _$SnackBarImpl;

  @override
  String get message;
  @override
  ActivityUiEventTone get tone;

  /// Create a copy of ActivityUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SnackBarImplCopyWith<_$SnackBarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ActivityState {
  ActivityData get data => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  ActivityUiEvent? get event => throw _privateConstructorUsedError;

  /// Create a copy of ActivityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityStateCopyWith<ActivityState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityStateCopyWith<$Res> {
  factory $ActivityStateCopyWith(
    ActivityState value,
    $Res Function(ActivityState) then,
  ) = _$ActivityStateCopyWithImpl<$Res, ActivityState>;
  @useResult
  $Res call({ActivityData data, bool isDeleting, ActivityUiEvent? event});

  $ActivityDataCopyWith<$Res> get data;
  $ActivityUiEventCopyWith<$Res>? get event;
}

/// @nodoc
class _$ActivityStateCopyWithImpl<$Res, $Val extends ActivityState>
    implements $ActivityStateCopyWith<$Res> {
  _$ActivityStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? isDeleting = null,
    Object? event = freezed,
  }) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as ActivityData,
            isDeleting: null == isDeleting
                ? _value.isDeleting
                : isDeleting // ignore: cast_nullable_to_non_nullable
                      as bool,
            event: freezed == event
                ? _value.event
                : event // ignore: cast_nullable_to_non_nullable
                      as ActivityUiEvent?,
          )
          as $Val,
    );
  }

  /// Create a copy of ActivityState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityDataCopyWith<$Res> get data {
    return $ActivityDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }

  /// Create a copy of ActivityState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityUiEventCopyWith<$Res>? get event {
    if (_value.event == null) {
      return null;
    }

    return $ActivityUiEventCopyWith<$Res>(_value.event!, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityStateImplCopyWith<$Res>
    implements $ActivityStateCopyWith<$Res> {
  factory _$$ActivityStateImplCopyWith(
    _$ActivityStateImpl value,
    $Res Function(_$ActivityStateImpl) then,
  ) = __$$ActivityStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ActivityData data, bool isDeleting, ActivityUiEvent? event});

  @override
  $ActivityDataCopyWith<$Res> get data;
  @override
  $ActivityUiEventCopyWith<$Res>? get event;
}

/// @nodoc
class __$$ActivityStateImplCopyWithImpl<$Res>
    extends _$ActivityStateCopyWithImpl<$Res, _$ActivityStateImpl>
    implements _$$ActivityStateImplCopyWith<$Res> {
  __$$ActivityStateImplCopyWithImpl(
    _$ActivityStateImpl _value,
    $Res Function(_$ActivityStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? isDeleting = null,
    Object? event = freezed,
  }) {
    return _then(
      _$ActivityStateImpl(
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as ActivityData,
        isDeleting: null == isDeleting
            ? _value.isDeleting
            : isDeleting // ignore: cast_nullable_to_non_nullable
                  as bool,
        event: freezed == event
            ? _value.event
            : event // ignore: cast_nullable_to_non_nullable
                  as ActivityUiEvent?,
      ),
    );
  }
}

/// @nodoc

class _$ActivityStateImpl implements _ActivityState {
  const _$ActivityStateImpl({
    this.data = const ActivityData(),
    this.isDeleting = false,
    this.event,
  });

  @override
  @JsonKey()
  final ActivityData data;
  @override
  @JsonKey()
  final bool isDeleting;
  @override
  final ActivityUiEvent? event;

  @override
  String toString() {
    return 'ActivityState(data: $data, isDeleting: $isDeleting, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityStateImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data, isDeleting, event);

  /// Create a copy of ActivityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityStateImplCopyWith<_$ActivityStateImpl> get copyWith =>
      __$$ActivityStateImplCopyWithImpl<_$ActivityStateImpl>(this, _$identity);
}

abstract class _ActivityState implements ActivityState {
  const factory _ActivityState({
    final ActivityData data,
    final bool isDeleting,
    final ActivityUiEvent? event,
  }) = _$ActivityStateImpl;

  @override
  ActivityData get data;
  @override
  bool get isDeleting;
  @override
  ActivityUiEvent? get event;

  /// Create a copy of ActivityState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityStateImplCopyWith<_$ActivityStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
