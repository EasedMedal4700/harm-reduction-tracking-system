// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_levels_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bloodLevelsService)
final bloodLevelsServiceProvider = BloodLevelsServiceProvider._();

final class BloodLevelsServiceProvider
    extends
        $FunctionalProvider<
          BloodLevelsService,
          BloodLevelsService,
          BloodLevelsService
        >
    with $Provider<BloodLevelsService> {
  BloodLevelsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bloodLevelsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bloodLevelsServiceHash();

  @$internal
  @override
  $ProviderElement<BloodLevelsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BloodLevelsService create(Ref ref) {
    return bloodLevelsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BloodLevelsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BloodLevelsService>(value),
    );
  }
}

String _$bloodLevelsServiceHash() =>
    r'fff278442dac8c65c2e9558314b8ff97411b3b96';

@ProviderFor(BloodLevelsController)
final bloodLevelsControllerProvider = BloodLevelsControllerProvider._();

final class BloodLevelsControllerProvider
    extends $AsyncNotifierProvider<BloodLevelsController, BloodLevelsState> {
  BloodLevelsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bloodLevelsControllerProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[bloodLevelsServiceProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          BloodLevelsControllerProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = bloodLevelsServiceProvider;

  @override
  String debugGetCreateSourceHash() => _$bloodLevelsControllerHash();

  @$internal
  @override
  BloodLevelsController create() => BloodLevelsController();
}

String _$bloodLevelsControllerHash() =>
    r'0d44b3f16cbecccb13d57103074799f0ac464762';

abstract class _$BloodLevelsController
    extends $AsyncNotifier<BloodLevelsState> {
  FutureOr<BloodLevelsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<BloodLevelsState>, BloodLevelsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BloodLevelsState>, BloodLevelsState>,
              AsyncValue<BloodLevelsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(bloodLevelsTimelineDoses)
final bloodLevelsTimelineDosesProvider = BloodLevelsTimelineDosesFamily._();

final class BloodLevelsTimelineDosesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<DoseEntry>>>,
          Map<String, List<DoseEntry>>,
          FutureOr<Map<String, List<DoseEntry>>>
        >
    with
        $FutureModifier<Map<String, List<DoseEntry>>>,
        $FutureProvider<Map<String, List<DoseEntry>>> {
  BloodLevelsTimelineDosesProvider._({
    required BloodLevelsTimelineDosesFamily super.from,
    required BloodLevelsTimelineRequest super.argument,
  }) : super(
         retry: null,
         name: r'bloodLevelsTimelineDosesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = bloodLevelsServiceProvider;

  @override
  String debugGetCreateSourceHash() => _$bloodLevelsTimelineDosesHash();

  @override
  String toString() {
    return r'bloodLevelsTimelineDosesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, List<DoseEntry>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<DoseEntry>>> create(Ref ref) {
    final argument = this.argument as BloodLevelsTimelineRequest;
    return bloodLevelsTimelineDoses(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BloodLevelsTimelineDosesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bloodLevelsTimelineDosesHash() =>
    r'29a40c40558c6db20d7223241556fbcb94d6c3c3';

final class BloodLevelsTimelineDosesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, List<DoseEntry>>>,
          BloodLevelsTimelineRequest
        > {
  BloodLevelsTimelineDosesFamily._()
    : super(
        retry: null,
        name: r'bloodLevelsTimelineDosesProvider',
        dependencies: <ProviderOrFamily>[bloodLevelsServiceProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          BloodLevelsTimelineDosesProvider.$allTransitiveDependencies0,
        ],
        isAutoDispose: true,
      );

  BloodLevelsTimelineDosesProvider call(BloodLevelsTimelineRequest request) =>
      BloodLevelsTimelineDosesProvider._(argument: request, from: this);

  @override
  String toString() => r'bloodLevelsTimelineDosesProvider';
}
