// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tolerance_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$toleranceControllerHash() =>
    r'000529c5c349e12cf2190075f3d94fdfe0761697';

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

abstract class _$ToleranceController
    extends BuildlessAutoDisposeAsyncNotifier<ToleranceResult> {
  late final String userId;

  FutureOr<ToleranceResult> build(String userId);
}

/// See also [ToleranceController].
@ProviderFor(ToleranceController)
const toleranceControllerProvider = ToleranceControllerFamily();

/// See also [ToleranceController].
class ToleranceControllerFamily extends Family<AsyncValue<ToleranceResult>> {
  /// See also [ToleranceController].
  const ToleranceControllerFamily();

  /// See also [ToleranceController].
  ToleranceControllerProvider call(String userId) {
    return ToleranceControllerProvider(userId);
  }

  @override
  ToleranceControllerProvider getProviderOverride(
    covariant ToleranceControllerProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'toleranceControllerProvider';
}

/// See also [ToleranceController].
class ToleranceControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ToleranceController,
          ToleranceResult
        > {
  /// See also [ToleranceController].
  ToleranceControllerProvider(String userId)
    : this._internal(
        () => ToleranceController()..userId = userId,
        from: toleranceControllerProvider,
        name: r'toleranceControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$toleranceControllerHash,
        dependencies: ToleranceControllerFamily._dependencies,
        allTransitiveDependencies:
            ToleranceControllerFamily._allTransitiveDependencies,
        userId: userId,
      );

  ToleranceControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<ToleranceResult> runNotifierBuild(
    covariant ToleranceController notifier,
  ) {
    return notifier.build(userId);
  }

  @override
  Override overrideWith(ToleranceController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ToleranceControllerProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ToleranceController, ToleranceResult>
  createElement() {
    return _ToleranceControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ToleranceControllerProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ToleranceControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ToleranceResult> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ToleranceControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ToleranceController,
          ToleranceResult
        >
    with ToleranceControllerRef {
  _ToleranceControllerProviderElement(super.provider);

  @override
  String get userId => (origin as ToleranceControllerProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
