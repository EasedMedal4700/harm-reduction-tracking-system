// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OnboardingState {
  int get currentPage => throw _privateConstructorUsedError;
  String? get selectedFrequency => throw _privateConstructorUsedError;
  bool get privacyAccepted => throw _privateConstructorUsedError;
  bool get isDarkTheme => throw _privateConstructorUsedError;
  bool get isCompleting => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingStateCopyWith<OnboardingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<$Res> {
  factory $OnboardingStateCopyWith(
    OnboardingState value,
    $Res Function(OnboardingState) then,
  ) = _$OnboardingStateCopyWithImpl<$Res, OnboardingState>;
  @useResult
  $Res call({
    int currentPage,
    String? selectedFrequency,
    bool privacyAccepted,
    bool isDarkTheme,
    bool isCompleting,
    String? errorMessage,
  });
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res, $Val extends OnboardingState>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? selectedFrequency = freezed,
    Object? privacyAccepted = null,
    Object? isDarkTheme = null,
    Object? isCompleting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            selectedFrequency: freezed == selectedFrequency
                ? _value.selectedFrequency
                : selectedFrequency // ignore: cast_nullable_to_non_nullable
                      as String?,
            privacyAccepted: null == privacyAccepted
                ? _value.privacyAccepted
                : privacyAccepted // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDarkTheme: null == isDarkTheme
                ? _value.isDarkTheme
                : isDarkTheme // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompleting: null == isCompleting
                ? _value.isCompleting
                : isCompleting // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OnboardingStateImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingStateImplCopyWith(
    _$OnboardingStateImpl value,
    $Res Function(_$OnboardingStateImpl) then,
  ) = __$$OnboardingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentPage,
    String? selectedFrequency,
    bool privacyAccepted,
    bool isDarkTheme,
    bool isCompleting,
    String? errorMessage,
  });
}

/// @nodoc
class __$$OnboardingStateImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingStateImpl>
    implements _$$OnboardingStateImplCopyWith<$Res> {
  __$$OnboardingStateImplCopyWithImpl(
    _$OnboardingStateImpl _value,
    $Res Function(_$OnboardingStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? selectedFrequency = freezed,
    Object? privacyAccepted = null,
    Object? isDarkTheme = null,
    Object? isCompleting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$OnboardingStateImpl(
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        selectedFrequency: freezed == selectedFrequency
            ? _value.selectedFrequency
            : selectedFrequency // ignore: cast_nullable_to_non_nullable
                  as String?,
        privacyAccepted: null == privacyAccepted
            ? _value.privacyAccepted
            : privacyAccepted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDarkTheme: null == isDarkTheme
            ? _value.isDarkTheme
            : isDarkTheme // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompleting: null == isCompleting
            ? _value.isCompleting
            : isCompleting // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OnboardingStateImpl extends _OnboardingState {
  const _$OnboardingStateImpl({
    this.currentPage = 0,
    this.selectedFrequency,
    this.privacyAccepted = false,
    this.isDarkTheme = false,
    this.isCompleting = false,
    this.errorMessage,
  }) : super._();

  @override
  @JsonKey()
  final int currentPage;
  @override
  final String? selectedFrequency;
  @override
  @JsonKey()
  final bool privacyAccepted;
  @override
  @JsonKey()
  final bool isDarkTheme;
  @override
  @JsonKey()
  final bool isCompleting;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'OnboardingState(currentPage: $currentPage, selectedFrequency: $selectedFrequency, privacyAccepted: $privacyAccepted, isDarkTheme: $isDarkTheme, isCompleting: $isCompleting, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.selectedFrequency, selectedFrequency) ||
                other.selectedFrequency == selectedFrequency) &&
            (identical(other.privacyAccepted, privacyAccepted) ||
                other.privacyAccepted == privacyAccepted) &&
            (identical(other.isDarkTheme, isDarkTheme) ||
                other.isDarkTheme == isDarkTheme) &&
            (identical(other.isCompleting, isCompleting) ||
                other.isCompleting == isCompleting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentPage,
    selectedFrequency,
    privacyAccepted,
    isDarkTheme,
    isCompleting,
    errorMessage,
  );

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      __$$OnboardingStateImplCopyWithImpl<_$OnboardingStateImpl>(
        this,
        _$identity,
      );
}

abstract class _OnboardingState extends OnboardingState {
  const factory _OnboardingState({
    final int currentPage,
    final String? selectedFrequency,
    final bool privacyAccepted,
    final bool isDarkTheme,
    final bool isCompleting,
    final String? errorMessage,
  }) = _$OnboardingStateImpl;
  const _OnboardingState._() : super._();

  @override
  int get currentPage;
  @override
  String? get selectedFrequency;
  @override
  bool get privacyAccepted;
  @override
  bool get isDarkTheme;
  @override
  bool get isCompleting;
  @override
  String? get errorMessage;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
