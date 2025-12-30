// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_setup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PinSetupController)
final pinSetupControllerProvider = PinSetupControllerProvider._();

final class PinSetupControllerProvider
    extends $NotifierProvider<PinSetupController, PinSetupState> {
  PinSetupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinSetupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinSetupControllerHash();

  @$internal
  @override
  PinSetupController create() => PinSetupController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinSetupState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinSetupState>(value),
    );
  }
}

String _$pinSetupControllerHash() =>
    r'd0ef1ba5d1ad9d913ec786a26bf5068ea9820f3e';

abstract class _$PinSetupController extends $Notifier<PinSetupState> {
  PinSetupState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PinSetupState, PinSetupState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinSetupState, PinSetupState>,
              PinSetupState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
