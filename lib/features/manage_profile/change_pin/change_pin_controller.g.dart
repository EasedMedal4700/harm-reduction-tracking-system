// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_pin_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller responsible for:
/// - Validating PIN input
/// - Performing encryption key re-wrapping
/// - Handling success / error states
/// - Emitting navigation intent

@ProviderFor(ChangePinController)
final changePinControllerProvider = ChangePinControllerProvider._();

/// Controller responsible for:
/// - Validating PIN input
/// - Performing encryption key re-wrapping
/// - Handling success / error states
/// - Emitting navigation intent
final class ChangePinControllerProvider
    extends $NotifierProvider<ChangePinController, ChangePinState> {
  /// Controller responsible for:
  /// - Validating PIN input
  /// - Performing encryption key re-wrapping
  /// - Handling success / error states
  /// - Emitting navigation intent
  ChangePinControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePinControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePinControllerHash();

  @$internal
  @override
  ChangePinController create() => ChangePinController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangePinState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangePinState>(value),
    );
  }
}

String _$changePinControllerHash() =>
    r'94973a86778f092ada0f01c113be854716d6349f';

/// Controller responsible for:
/// - Validating PIN input
/// - Performing encryption key re-wrapping
/// - Handling success / error states
/// - Emitting navigation intent

abstract class _$ChangePinController extends $Notifier<ChangePinState> {
  ChangePinState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChangePinState, ChangePinState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChangePinState, ChangePinState>,
              ChangePinState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
