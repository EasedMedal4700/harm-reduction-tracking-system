// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activityService)
final activityServiceProvider = ActivityServiceProvider._();

final class ActivityServiceProvider
    extends
        $FunctionalProvider<ActivityService, ActivityService, ActivityService>
    with $Provider<ActivityService> {
  ActivityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityServiceHash();

  @$internal
  @override
  $ProviderElement<ActivityService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActivityService create(Ref ref) {
    return activityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityService>(value),
    );
  }
}

String _$activityServiceHash() => r'2d658ab12b3421d952e566b3aed0f161b24c49b7';

@ProviderFor(ActivityController)
final activityControllerProvider = ActivityControllerProvider._();

final class ActivityControllerProvider
    extends $AsyncNotifierProvider<ActivityController, ActivityState> {
  ActivityControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityControllerHash();

  @$internal
  @override
  ActivityController create() => ActivityController();
}

String _$activityControllerHash() =>
    r'13dc47ec51f47ce3dd83e8f2089a925f0a69706e';

abstract class _$ActivityController extends $AsyncNotifier<ActivityState> {
  FutureOr<ActivityState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ActivityState>, ActivityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ActivityState>, ActivityState>,
              AsyncValue<ActivityState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
