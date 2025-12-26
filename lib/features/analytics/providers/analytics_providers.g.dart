// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsServiceHash() => r'0196a36dee2149b5d3cbb5992396046229f222b4';

/// See also [analyticsService].
@ProviderFor(analyticsService)
final analyticsServiceProvider = AutoDisposeProvider<AnalyticsService>.internal(
  analyticsService,
  name: r'analyticsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsServiceRef = AutoDisposeProviderRef<AnalyticsService>;
String _$substanceRepositoryHash() =>
    r'305e657c685429090873fa32dc958b8b3209b023';

/// See also [substanceRepository].
@ProviderFor(substanceRepository)
final substanceRepositoryProvider =
    AutoDisposeProvider<SubstanceRepository>.internal(
      substanceRepository,
      name: r'substanceRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$substanceRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubstanceRepositoryRef = AutoDisposeProviderRef<SubstanceRepository>;
String _$analyticsComputedHash() => r'7c8f575f78d2b5b1af78ddb0123bcf8c5ddac721';

/// See also [analyticsComputed].
@ProviderFor(analyticsComputed)
final analyticsComputedProvider =
    AutoDisposeProvider<AnalyticsComputed?>.internal(
      analyticsComputed,
      name: r'analyticsComputedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsComputedHash,
      dependencies: <ProviderOrFamily>[
        analyticsServiceProvider,
        analyticsControllerProvider,
      ],
      allTransitiveDependencies: <ProviderOrFamily>{
        analyticsServiceProvider,
        ...?analyticsServiceProvider.allTransitiveDependencies,
        analyticsControllerProvider,
        ...?analyticsControllerProvider.allTransitiveDependencies,
      },
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsComputedRef = AutoDisposeProviderRef<AnalyticsComputed?>;
String _$analyticsControllerHash() =>
    r'add19911c06e7baaac9cac2487137a25fd39cf5d';

/// See also [AnalyticsController].
@ProviderFor(AnalyticsController)
final analyticsControllerProvider =
    AutoDisposeNotifierProvider<AnalyticsController, AnalyticsState>.internal(
      AnalyticsController.new,
      name: r'analyticsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsControllerHash,
      dependencies: <ProviderOrFamily>[
        analyticsServiceProvider,
        substanceRepositoryProvider,
      ],
      allTransitiveDependencies: <ProviderOrFamily>{
        analyticsServiceProvider,
        ...?analyticsServiceProvider.allTransitiveDependencies,
        substanceRepositoryProvider,
        ...?substanceRepositoryProvider.allTransitiveDependencies,
      },
    );

typedef _$AnalyticsController = AutoDisposeNotifier<AnalyticsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
