// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_key_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecoveryKeyController)
final recoveryKeyControllerProvider = RecoveryKeyControllerProvider._();

final class RecoveryKeyControllerProvider
    extends $NotifierProvider<RecoveryKeyController, RecoveryKeyState> {
  RecoveryKeyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recoveryKeyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recoveryKeyControllerHash();

  @$internal
  @override
  RecoveryKeyController create() => RecoveryKeyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecoveryKeyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecoveryKeyState>(value),
    );
  }
}

String _$recoveryKeyControllerHash() =>
    r'867142d16af144dbe84be1ea9fbb842be01b1865';

abstract class _$RecoveryKeyController extends $Notifier<RecoveryKeyState> {
  RecoveryKeyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RecoveryKeyState, RecoveryKeyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecoveryKeyState, RecoveryKeyState>,
              RecoveryKeyState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
