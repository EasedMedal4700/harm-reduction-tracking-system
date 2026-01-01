// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_unlock_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PinUnlockController)
final pinUnlockControllerProvider = PinUnlockControllerProvider._();

final class PinUnlockControllerProvider
    extends $NotifierProvider<PinUnlockController, PinUnlockState> {
  PinUnlockControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinUnlockControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinUnlockControllerHash();

  @$internal
  @override
  PinUnlockController create() => PinUnlockController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinUnlockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinUnlockState>(value),
    );
  }
}

String _$pinUnlockControllerHash() =>
    r'5bad2f9493e27641c887aac4677e5a7203d2da6a';

abstract class _$PinUnlockController extends $Notifier<PinUnlockState> {
  PinUnlockState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PinUnlockState, PinUnlockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinUnlockState, PinUnlockState>,
              PinUnlockState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
