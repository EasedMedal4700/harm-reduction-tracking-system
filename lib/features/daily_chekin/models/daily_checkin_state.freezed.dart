// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_checkin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DailyCheckinUiEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, bool isError) snackbar,
    required TResult Function() close,
    required TResult Function() none,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, bool isError)? snackbar,
    TResult? Function()? close,
    TResult? Function()? none,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, bool isError)? snackbar,
    TResult Function()? close,
    TResult Function()? none,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckinSnackbar value) snackbar,
    required TResult Function(_DailyCheckinClose value) close,
    required TResult Function(_DailyCheckinNone value) none,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckinSnackbar value)? snackbar,
    TResult? Function(_DailyCheckinClose value)? close,
    TResult? Function(_DailyCheckinNone value)? none,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckinSnackbar value)? snackbar,
    TResult Function(_DailyCheckinClose value)? close,
    TResult Function(_DailyCheckinNone value)? none,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyCheckinUiEventCopyWith<$Res> {
  factory $DailyCheckinUiEventCopyWith(
    DailyCheckinUiEvent value,
    $Res Function(DailyCheckinUiEvent) then,
  ) = _$DailyCheckinUiEventCopyWithImpl<$Res, DailyCheckinUiEvent>;
}

/// @nodoc
class _$DailyCheckinUiEventCopyWithImpl<$Res, $Val extends DailyCheckinUiEvent>
    implements $DailyCheckinUiEventCopyWith<$Res> {
  _$DailyCheckinUiEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyCheckinUiEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DailyCheckinSnackbarImplCopyWith<$Res> {
  factory _$$DailyCheckinSnackbarImplCopyWith(
    _$DailyCheckinSnackbarImpl value,
    $Res Function(_$DailyCheckinSnackbarImpl) then,
  ) = __$$DailyCheckinSnackbarImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, bool isError});
}

/// @nodoc
class __$$DailyCheckinSnackbarImplCopyWithImpl<$Res>
    extends _$DailyCheckinUiEventCopyWithImpl<$Res, _$DailyCheckinSnackbarImpl>
    implements _$$DailyCheckinSnackbarImplCopyWith<$Res> {
  __$$DailyCheckinSnackbarImplCopyWithImpl(
    _$DailyCheckinSnackbarImpl _value,
    $Res Function(_$DailyCheckinSnackbarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyCheckinUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? isError = null}) {
    return _then(
      _$DailyCheckinSnackbarImpl(
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

class _$DailyCheckinSnackbarImpl implements _DailyCheckinSnackbar {
  const _$DailyCheckinSnackbarImpl({
    required this.message,
    this.isError = false,
  });

  @override
  final String message;
  @override
  @JsonKey()
  final bool isError;

  @override
  String toString() {
    return 'DailyCheckinUiEvent.snackbar(message: $message, isError: $isError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyCheckinSnackbarImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isError, isError) || other.isError == isError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, isError);

  /// Create a copy of DailyCheckinUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyCheckinSnackbarImplCopyWith<_$DailyCheckinSnackbarImpl>
  get copyWith =>
      __$$DailyCheckinSnackbarImplCopyWithImpl<_$DailyCheckinSnackbarImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, bool isError) snackbar,
    required TResult Function() close,
    required TResult Function() none,
  }) {
    return snackbar(message, isError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, bool isError)? snackbar,
    TResult? Function()? close,
    TResult? Function()? none,
  }) {
    return snackbar?.call(message, isError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, bool isError)? snackbar,
    TResult Function()? close,
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
    required TResult Function(_DailyCheckinSnackbar value) snackbar,
    required TResult Function(_DailyCheckinClose value) close,
    required TResult Function(_DailyCheckinNone value) none,
  }) {
    return snackbar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckinSnackbar value)? snackbar,
    TResult? Function(_DailyCheckinClose value)? close,
    TResult? Function(_DailyCheckinNone value)? none,
  }) {
    return snackbar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckinSnackbar value)? snackbar,
    TResult Function(_DailyCheckinClose value)? close,
    TResult Function(_DailyCheckinNone value)? none,
    required TResult orElse(),
  }) {
    if (snackbar != null) {
      return snackbar(this);
    }
    return orElse();
  }
}

abstract class _DailyCheckinSnackbar implements DailyCheckinUiEvent {
  const factory _DailyCheckinSnackbar({
    required final String message,
    final bool isError,
  }) = _$DailyCheckinSnackbarImpl;

  String get message;
  bool get isError;

  /// Create a copy of DailyCheckinUiEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyCheckinSnackbarImplCopyWith<_$DailyCheckinSnackbarImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DailyCheckinCloseImplCopyWith<$Res> {
  factory _$$DailyCheckinCloseImplCopyWith(
    _$DailyCheckinCloseImpl value,
    $Res Function(_$DailyCheckinCloseImpl) then,
  ) = __$$DailyCheckinCloseImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DailyCheckinCloseImplCopyWithImpl<$Res>
    extends _$DailyCheckinUiEventCopyWithImpl<$Res, _$DailyCheckinCloseImpl>
    implements _$$DailyCheckinCloseImplCopyWith<$Res> {
  __$$DailyCheckinCloseImplCopyWithImpl(
    _$DailyCheckinCloseImpl _value,
    $Res Function(_$DailyCheckinCloseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyCheckinUiEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DailyCheckinCloseImpl implements _DailyCheckinClose {
  const _$DailyCheckinCloseImpl();

  @override
  String toString() {
    return 'DailyCheckinUiEvent.close()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DailyCheckinCloseImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, bool isError) snackbar,
    required TResult Function() close,
    required TResult Function() none,
  }) {
    return close();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, bool isError)? snackbar,
    TResult? Function()? close,
    TResult? Function()? none,
  }) {
    return close?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, bool isError)? snackbar,
    TResult Function()? close,
    TResult Function()? none,
    required TResult orElse(),
  }) {
    if (close != null) {
      return close();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckinSnackbar value) snackbar,
    required TResult Function(_DailyCheckinClose value) close,
    required TResult Function(_DailyCheckinNone value) none,
  }) {
    return close(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckinSnackbar value)? snackbar,
    TResult? Function(_DailyCheckinClose value)? close,
    TResult? Function(_DailyCheckinNone value)? none,
  }) {
    return close?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckinSnackbar value)? snackbar,
    TResult Function(_DailyCheckinClose value)? close,
    TResult Function(_DailyCheckinNone value)? none,
    required TResult orElse(),
  }) {
    if (close != null) {
      return close(this);
    }
    return orElse();
  }
}

abstract class _DailyCheckinClose implements DailyCheckinUiEvent {
  const factory _DailyCheckinClose() = _$DailyCheckinCloseImpl;
}

/// @nodoc
abstract class _$$DailyCheckinNoneImplCopyWith<$Res> {
  factory _$$DailyCheckinNoneImplCopyWith(
    _$DailyCheckinNoneImpl value,
    $Res Function(_$DailyCheckinNoneImpl) then,
  ) = __$$DailyCheckinNoneImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DailyCheckinNoneImplCopyWithImpl<$Res>
    extends _$DailyCheckinUiEventCopyWithImpl<$Res, _$DailyCheckinNoneImpl>
    implements _$$DailyCheckinNoneImplCopyWith<$Res> {
  __$$DailyCheckinNoneImplCopyWithImpl(
    _$DailyCheckinNoneImpl _value,
    $Res Function(_$DailyCheckinNoneImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyCheckinUiEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DailyCheckinNoneImpl implements _DailyCheckinNone {
  const _$DailyCheckinNoneImpl();

  @override
  String toString() {
    return 'DailyCheckinUiEvent.none()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DailyCheckinNoneImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, bool isError) snackbar,
    required TResult Function() close,
    required TResult Function() none,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, bool isError)? snackbar,
    TResult? Function()? close,
    TResult? Function()? none,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, bool isError)? snackbar,
    TResult Function()? close,
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
    required TResult Function(_DailyCheckinSnackbar value) snackbar,
    required TResult Function(_DailyCheckinClose value) close,
    required TResult Function(_DailyCheckinNone value) none,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckinSnackbar value)? snackbar,
    TResult? Function(_DailyCheckinClose value)? close,
    TResult? Function(_DailyCheckinNone value)? none,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckinSnackbar value)? snackbar,
    TResult Function(_DailyCheckinClose value)? close,
    TResult Function(_DailyCheckinNone value)? none,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class _DailyCheckinNone implements DailyCheckinUiEvent {
  const factory _DailyCheckinNone() = _$DailyCheckinNoneImpl;
}

/// @nodoc
mixin _$DailyCheckinState {
  String get mood => throw _privateConstructorUsedError;
  List<String> get emotions => throw _privateConstructorUsedError;
  String get timeOfDay => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  TimeOfDay? get selectedTime => throw _privateConstructorUsedError;
  DailyCheckin? get existingCheckin => throw _privateConstructorUsedError;
  List<DailyCheckin> get recentCheckins => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  DailyCheckinUiEvent get uiEvent => throw _privateConstructorUsedError;

  /// Create a copy of DailyCheckinState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyCheckinStateCopyWith<DailyCheckinState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyCheckinStateCopyWith<$Res> {
  factory $DailyCheckinStateCopyWith(
    DailyCheckinState value,
    $Res Function(DailyCheckinState) then,
  ) = _$DailyCheckinStateCopyWithImpl<$Res, DailyCheckinState>;
  @useResult
  $Res call({
    String mood,
    List<String> emotions,
    String timeOfDay,
    String notes,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    DailyCheckin? existingCheckin,
    List<DailyCheckin> recentCheckins,
    bool isSaving,
    bool isLoading,
    DailyCheckinUiEvent uiEvent,
  });

  $DailyCheckinUiEventCopyWith<$Res> get uiEvent;
}

/// @nodoc
class _$DailyCheckinStateCopyWithImpl<$Res, $Val extends DailyCheckinState>
    implements $DailyCheckinStateCopyWith<$Res> {
  _$DailyCheckinStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyCheckinState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mood = null,
    Object? emotions = null,
    Object? timeOfDay = null,
    Object? notes = null,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? existingCheckin = freezed,
    Object? recentCheckins = null,
    Object? isSaving = null,
    Object? isLoading = null,
    Object? uiEvent = null,
  }) {
    return _then(
      _value.copyWith(
            mood: null == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                      as String,
            emotions: null == emotions
                ? _value.emotions
                : emotions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            timeOfDay: null == timeOfDay
                ? _value.timeOfDay
                : timeOfDay // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedDate: freezed == selectedDate
                ? _value.selectedDate
                : selectedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            selectedTime: freezed == selectedTime
                ? _value.selectedTime
                : selectedTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay?,
            existingCheckin: freezed == existingCheckin
                ? _value.existingCheckin
                : existingCheckin // ignore: cast_nullable_to_non_nullable
                      as DailyCheckin?,
            recentCheckins: null == recentCheckins
                ? _value.recentCheckins
                : recentCheckins // ignore: cast_nullable_to_non_nullable
                      as List<DailyCheckin>,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            uiEvent: null == uiEvent
                ? _value.uiEvent
                : uiEvent // ignore: cast_nullable_to_non_nullable
                      as DailyCheckinUiEvent,
          )
          as $Val,
    );
  }

  /// Create a copy of DailyCheckinState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyCheckinUiEventCopyWith<$Res> get uiEvent {
    return $DailyCheckinUiEventCopyWith<$Res>(_value.uiEvent, (value) {
      return _then(_value.copyWith(uiEvent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DailyCheckinStateImplCopyWith<$Res>
    implements $DailyCheckinStateCopyWith<$Res> {
  factory _$$DailyCheckinStateImplCopyWith(
    _$DailyCheckinStateImpl value,
    $Res Function(_$DailyCheckinStateImpl) then,
  ) = __$$DailyCheckinStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String mood,
    List<String> emotions,
    String timeOfDay,
    String notes,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    DailyCheckin? existingCheckin,
    List<DailyCheckin> recentCheckins,
    bool isSaving,
    bool isLoading,
    DailyCheckinUiEvent uiEvent,
  });

  @override
  $DailyCheckinUiEventCopyWith<$Res> get uiEvent;
}

/// @nodoc
class __$$DailyCheckinStateImplCopyWithImpl<$Res>
    extends _$DailyCheckinStateCopyWithImpl<$Res, _$DailyCheckinStateImpl>
    implements _$$DailyCheckinStateImplCopyWith<$Res> {
  __$$DailyCheckinStateImplCopyWithImpl(
    _$DailyCheckinStateImpl _value,
    $Res Function(_$DailyCheckinStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyCheckinState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mood = null,
    Object? emotions = null,
    Object? timeOfDay = null,
    Object? notes = null,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? existingCheckin = freezed,
    Object? recentCheckins = null,
    Object? isSaving = null,
    Object? isLoading = null,
    Object? uiEvent = null,
  }) {
    return _then(
      _$DailyCheckinStateImpl(
        mood: null == mood
            ? _value.mood
            : mood // ignore: cast_nullable_to_non_nullable
                  as String,
        emotions: null == emotions
            ? _value._emotions
            : emotions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        timeOfDay: null == timeOfDay
            ? _value.timeOfDay
            : timeOfDay // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedDate: freezed == selectedDate
            ? _value.selectedDate
            : selectedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        selectedTime: freezed == selectedTime
            ? _value.selectedTime
            : selectedTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay?,
        existingCheckin: freezed == existingCheckin
            ? _value.existingCheckin
            : existingCheckin // ignore: cast_nullable_to_non_nullable
                  as DailyCheckin?,
        recentCheckins: null == recentCheckins
            ? _value._recentCheckins
            : recentCheckins // ignore: cast_nullable_to_non_nullable
                  as List<DailyCheckin>,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        uiEvent: null == uiEvent
            ? _value.uiEvent
            : uiEvent // ignore: cast_nullable_to_non_nullable
                  as DailyCheckinUiEvent,
      ),
    );
  }
}

/// @nodoc

class _$DailyCheckinStateImpl implements _DailyCheckinState {
  const _$DailyCheckinStateImpl({
    this.mood = 'Neutral',
    final List<String> emotions = const <String>[],
    this.timeOfDay = 'morning',
    this.notes = '',
    this.selectedDate,
    this.selectedTime,
    this.existingCheckin,
    final List<DailyCheckin> recentCheckins = const <DailyCheckin>[],
    this.isSaving = false,
    this.isLoading = false,
    this.uiEvent = const DailyCheckinUiEvent.none(),
  }) : _emotions = emotions,
       _recentCheckins = recentCheckins;

  @override
  @JsonKey()
  final String mood;
  final List<String> _emotions;
  @override
  @JsonKey()
  List<String> get emotions {
    if (_emotions is EqualUnmodifiableListView) return _emotions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emotions);
  }

  @override
  @JsonKey()
  final String timeOfDay;
  @override
  @JsonKey()
  final String notes;
  @override
  final DateTime? selectedDate;
  @override
  final TimeOfDay? selectedTime;
  @override
  final DailyCheckin? existingCheckin;
  final List<DailyCheckin> _recentCheckins;
  @override
  @JsonKey()
  List<DailyCheckin> get recentCheckins {
    if (_recentCheckins is EqualUnmodifiableListView) return _recentCheckins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentCheckins);
  }

  @override
  @JsonKey()
  final bool isSaving;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final DailyCheckinUiEvent uiEvent;

  @override
  String toString() {
    return 'DailyCheckinState(mood: $mood, emotions: $emotions, timeOfDay: $timeOfDay, notes: $notes, selectedDate: $selectedDate, selectedTime: $selectedTime, existingCheckin: $existingCheckin, recentCheckins: $recentCheckins, isSaving: $isSaving, isLoading: $isLoading, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyCheckinStateImpl &&
            (identical(other.mood, mood) || other.mood == mood) &&
            const DeepCollectionEquality().equals(other._emotions, _emotions) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.selectedTime, selectedTime) ||
                other.selectedTime == selectedTime) &&
            (identical(other.existingCheckin, existingCheckin) ||
                other.existingCheckin == existingCheckin) &&
            const DeepCollectionEquality().equals(
              other._recentCheckins,
              _recentCheckins,
            ) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    mood,
    const DeepCollectionEquality().hash(_emotions),
    timeOfDay,
    notes,
    selectedDate,
    selectedTime,
    existingCheckin,
    const DeepCollectionEquality().hash(_recentCheckins),
    isSaving,
    isLoading,
    uiEvent,
  );

  /// Create a copy of DailyCheckinState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyCheckinStateImplCopyWith<_$DailyCheckinStateImpl> get copyWith =>
      __$$DailyCheckinStateImplCopyWithImpl<_$DailyCheckinStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DailyCheckinState implements DailyCheckinState {
  const factory _DailyCheckinState({
    final String mood,
    final List<String> emotions,
    final String timeOfDay,
    final String notes,
    final DateTime? selectedDate,
    final TimeOfDay? selectedTime,
    final DailyCheckin? existingCheckin,
    final List<DailyCheckin> recentCheckins,
    final bool isSaving,
    final bool isLoading,
    final DailyCheckinUiEvent uiEvent,
  }) = _$DailyCheckinStateImpl;

  @override
  String get mood;
  @override
  List<String> get emotions;
  @override
  String get timeOfDay;
  @override
  String get notes;
  @override
  DateTime? get selectedDate;
  @override
  TimeOfDay? get selectedTime;
  @override
  DailyCheckin? get existingCheckin;
  @override
  List<DailyCheckin> get recentCheckins;
  @override
  bool get isSaving;
  @override
  bool get isLoading;
  @override
  DailyCheckinUiEvent get uiEvent;

  /// Create a copy of DailyCheckinState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyCheckinStateImplCopyWith<_$DailyCheckinStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
