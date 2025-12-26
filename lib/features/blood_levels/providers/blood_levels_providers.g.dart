// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_levels_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bloodLevelsServiceHash() =>
    r'fff278442dac8c65c2e9558314b8ff97411b3b96';

/// See also [bloodLevelsService].
@ProviderFor(bloodLevelsService)
final bloodLevelsServiceProvider =
    AutoDisposeProvider<BloodLevelsService>.internal(
      bloodLevelsService,
      name: r'bloodLevelsServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bloodLevelsServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BloodLevelsServiceRef = AutoDisposeProviderRef<BloodLevelsService>;
String _$bloodLevelsTimelineDosesHash() =>
    r'29a40c40558c6db20d7223241556fbcb94d6c3c3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [bloodLevelsTimelineDoses].
@ProviderFor(bloodLevelsTimelineDoses)
const bloodLevelsTimelineDosesProvider = BloodLevelsTimelineDosesFamily();

/// See also [bloodLevelsTimelineDoses].
class BloodLevelsTimelineDosesFamily
    extends Family<AsyncValue<Map<String, List<DoseEntry>>>> {
  /// See also [bloodLevelsTimelineDoses].
  const BloodLevelsTimelineDosesFamily();

  /// See also [bloodLevelsTimelineDoses].
  BloodLevelsTimelineDosesProvider call(BloodLevelsTimelineRequest request) {
    return BloodLevelsTimelineDosesProvider(request);
  }

  @override
  BloodLevelsTimelineDosesProvider getProviderOverride(
    covariant BloodLevelsTimelineDosesProvider provider,
  ) {
    return call(provider.request);
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    bloodLevelsServiceProvider,
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
        bloodLevelsServiceProvider,
        ...?bloodLevelsServiceProvider.allTransitiveDependencies,
      };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bloodLevelsTimelineDosesProvider';
}

/// See also [bloodLevelsTimelineDoses].
class BloodLevelsTimelineDosesProvider
    extends AutoDisposeFutureProvider<Map<String, List<DoseEntry>>> {
  /// See also [bloodLevelsTimelineDoses].
  BloodLevelsTimelineDosesProvider(BloodLevelsTimelineRequest request)
    : this._internal(
        (ref) => bloodLevelsTimelineDoses(
          ref as BloodLevelsTimelineDosesRef,
          request,
        ),
        from: bloodLevelsTimelineDosesProvider,
        name: r'bloodLevelsTimelineDosesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bloodLevelsTimelineDosesHash,
        dependencies: BloodLevelsTimelineDosesFamily._dependencies,
        allTransitiveDependencies:
            BloodLevelsTimelineDosesFamily._allTransitiveDependencies,
        request: request,
      );

  BloodLevelsTimelineDosesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.request,
  }) : super.internal();

  final BloodLevelsTimelineRequest request;

  @override
  Override overrideWith(
    FutureOr<Map<String, List<DoseEntry>>> Function(
      BloodLevelsTimelineDosesRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BloodLevelsTimelineDosesProvider._internal(
        (ref) => create(ref as BloodLevelsTimelineDosesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        request: request,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, List<DoseEntry>>>
  createElement() {
    return _BloodLevelsTimelineDosesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BloodLevelsTimelineDosesProvider &&
        other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BloodLevelsTimelineDosesRef
    on AutoDisposeFutureProviderRef<Map<String, List<DoseEntry>>> {
  /// The parameter `request` of this provider.
  BloodLevelsTimelineRequest get request;
}

class _BloodLevelsTimelineDosesProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, List<DoseEntry>>>
    with BloodLevelsTimelineDosesRef {
  _BloodLevelsTimelineDosesProviderElement(super.provider);

  @override
  BloodLevelsTimelineRequest get request =>
      (origin as BloodLevelsTimelineDosesProvider).request;
}

String _$bloodLevelsControllerHash() =>
    r'b33d167699b7e295c2ba7ed0ab5ea04a3ac35803';

/// See also [BloodLevelsController].
@ProviderFor(BloodLevelsController)
final bloodLevelsControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      BloodLevelsController,
      BloodLevelsState
    >.internal(
      BloodLevelsController.new,
      name: r'bloodLevelsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bloodLevelsControllerHash,
      dependencies: <ProviderOrFamily>[bloodLevelsServiceProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        bloodLevelsServiceProvider,
        ...?bloodLevelsServiceProvider.allTransitiveDependencies,
      },
    );

typedef _$BloodLevelsController = AutoDisposeAsyncNotifier<BloodLevelsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
