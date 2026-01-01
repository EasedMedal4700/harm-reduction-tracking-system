// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflection_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReflectionController)
final reflectionControllerProvider = ReflectionControllerProvider._();

final class ReflectionControllerProvider
    extends $NotifierProvider<ReflectionController, ReflectionState> {
  ReflectionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reflectionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reflectionControllerHash();

  @$internal
  @override
  ReflectionController create() => ReflectionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReflectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReflectionState>(value),
    );
  }
}

String _$reflectionControllerHash() =>
    r'f27d835ce776b6ccf4038e6e0edb787340950262';

abstract class _$ReflectionController extends $Notifier<ReflectionState> {
  ReflectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ReflectionState, ReflectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReflectionState, ReflectionState>,
              ReflectionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
