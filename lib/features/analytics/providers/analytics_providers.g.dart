// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(analyticsService)
final analyticsServiceProvider = AnalyticsServiceProvider._();

final class AnalyticsServiceProvider
    extends
        $FunctionalProvider<
          AnalyticsService,
          AnalyticsService,
          AnalyticsService
        >
    with $Provider<AnalyticsService> {
  AnalyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsServiceHash();

  @$internal
  @override
  $ProviderElement<AnalyticsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsService create(Ref ref) {
    return analyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsService>(value),
    );
  }
}

String _$analyticsServiceHash() => r'4928fb3ed712b41230dcf79231ab61cb4da3f83d';

@ProviderFor(substanceRepository)
final substanceRepositoryProvider = SubstanceRepositoryProvider._();

final class SubstanceRepositoryProvider
    extends
        $FunctionalProvider<
          SubstanceRepository,
          SubstanceRepository,
          SubstanceRepository
        >
    with $Provider<SubstanceRepository> {
  SubstanceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'substanceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$substanceRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubstanceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubstanceRepository create(Ref ref) {
    return substanceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubstanceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubstanceRepository>(value),
    );
  }
}

String _$substanceRepositoryHash() =>
    r'04c5688844632ce7cf30ed868baf75f303883785';

@ProviderFor(AnalyticsController)
final analyticsControllerProvider = AnalyticsControllerProvider._();

final class AnalyticsControllerProvider
    extends $NotifierProvider<AnalyticsController, AnalyticsState> {
  AnalyticsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsControllerProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          analyticsServiceProvider,
          substanceRepositoryProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AnalyticsControllerProvider.$allTransitiveDependencies0,
          AnalyticsControllerProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = analyticsServiceProvider;
  static final $allTransitiveDependencies1 = substanceRepositoryProvider;

  @override
  String debugGetCreateSourceHash() => _$analyticsControllerHash();

  @$internal
  @override
  AnalyticsController create() => AnalyticsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsState>(value),
    );
  }
}

String _$analyticsControllerHash() =>
    r'add19911c06e7baaac9cac2487137a25fd39cf5d';

abstract class _$AnalyticsController extends $Notifier<AnalyticsState> {
  AnalyticsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AnalyticsState, AnalyticsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AnalyticsState, AnalyticsState>,
              AnalyticsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(analyticsComputed)
final analyticsComputedProvider = AnalyticsComputedProvider._();

final class AnalyticsComputedProvider
    extends
        $FunctionalProvider<
          AnalyticsComputed?,
          AnalyticsComputed?,
          AnalyticsComputed?
        >
    with $Provider<AnalyticsComputed?> {
  AnalyticsComputedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsComputedProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          analyticsServiceProvider,
          analyticsControllerProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AnalyticsComputedProvider.$allTransitiveDependencies0,
          AnalyticsComputedProvider.$allTransitiveDependencies1,
          AnalyticsComputedProvider.$allTransitiveDependencies2,
        ],
      );

  static final $allTransitiveDependencies0 = analyticsServiceProvider;
  static final $allTransitiveDependencies1 = analyticsControllerProvider;
  static final $allTransitiveDependencies2 =
      AnalyticsControllerProvider.$allTransitiveDependencies1;

  @override
  String debugGetCreateSourceHash() => _$analyticsComputedHash();

  @$internal
  @override
  $ProviderElement<AnalyticsComputed?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsComputed? create(Ref ref) {
    return analyticsComputed(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsComputed? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsComputed?>(value),
    );
  }
}

String _$analyticsComputedHash() => r'a4c9ed871cd2c7ded6701d5cf4aedb65379acf21';
