// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_new_password_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SetNewPasswordController)
final setNewPasswordControllerProvider = SetNewPasswordControllerProvider._();

final class SetNewPasswordControllerProvider
    extends $NotifierProvider<SetNewPasswordController, SetNewPasswordState> {
  SetNewPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setNewPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setNewPasswordControllerHash();

  @$internal
  @override
  SetNewPasswordController create() => SetNewPasswordController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetNewPasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetNewPasswordState>(value),
    );
  }
}

String _$setNewPasswordControllerHash() =>
    r'7b58d3a103c24525126121a82681bd706c2680da';

abstract class _$SetNewPasswordController
    extends $Notifier<SetNewPasswordState> {
  SetNewPasswordState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SetNewPasswordState, SetNewPasswordState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SetNewPasswordState, SetNewPasswordState>,
              SetNewPasswordState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
