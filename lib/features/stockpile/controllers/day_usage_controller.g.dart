// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_usage_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dayUsageControllerHash() =>
    r'b3fdd5719b37e8fe67a3162ff10184dd7ebe36d5';

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

abstract class _$DayUsageController
    extends BuildlessAutoDisposeAsyncNotifier<List<DayUsageEntry>> {
  late final String substanceName;
  late final int weekdayIndex;

  FutureOr<List<DayUsageEntry>> build({
    required String substanceName,
    required int weekdayIndex,
  });
}

/// See also [DayUsageController].
@ProviderFor(DayUsageController)
const dayUsageControllerProvider = DayUsageControllerFamily();

/// See also [DayUsageController].
class DayUsageControllerFamily extends Family<AsyncValue<List<DayUsageEntry>>> {
  /// See also [DayUsageController].
  const DayUsageControllerFamily();

  /// See also [DayUsageController].
  DayUsageControllerProvider call({
    required String substanceName,
    required int weekdayIndex,
  }) {
    return DayUsageControllerProvider(
      substanceName: substanceName,
      weekdayIndex: weekdayIndex,
    );
  }

  @override
  DayUsageControllerProvider getProviderOverride(
    covariant DayUsageControllerProvider provider,
  ) {
    return call(
      substanceName: provider.substanceName,
      weekdayIndex: provider.weekdayIndex,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dayUsageControllerProvider';
}

/// See also [DayUsageController].
class DayUsageControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          DayUsageController,
          List<DayUsageEntry>
        > {
  /// See also [DayUsageController].
  DayUsageControllerProvider({
    required String substanceName,
    required int weekdayIndex,
  }) : this._internal(
         () => DayUsageController()
           ..substanceName = substanceName
           ..weekdayIndex = weekdayIndex,
         from: dayUsageControllerProvider,
         name: r'dayUsageControllerProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$dayUsageControllerHash,
         dependencies: DayUsageControllerFamily._dependencies,
         allTransitiveDependencies:
             DayUsageControllerFamily._allTransitiveDependencies,
         substanceName: substanceName,
         weekdayIndex: weekdayIndex,
       );

  DayUsageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.substanceName,
    required this.weekdayIndex,
  }) : super.internal();

  final String substanceName;
  final int weekdayIndex;

  @override
  FutureOr<List<DayUsageEntry>> runNotifierBuild(
    covariant DayUsageController notifier,
  ) {
    return notifier.build(
      substanceName: substanceName,
      weekdayIndex: weekdayIndex,
    );
  }

  @override
  Override overrideWith(DayUsageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: DayUsageControllerProvider._internal(
        () => create()
          ..substanceName = substanceName
          ..weekdayIndex = weekdayIndex,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        substanceName: substanceName,
        weekdayIndex: weekdayIndex,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    DayUsageController,
    List<DayUsageEntry>
  >
  createElement() {
    return _DayUsageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DayUsageControllerProvider &&
        other.substanceName == substanceName &&
        other.weekdayIndex == weekdayIndex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, substanceName.hashCode);
    hash = _SystemHash.combine(hash, weekdayIndex.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DayUsageControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<DayUsageEntry>> {
  /// The parameter `substanceName` of this provider.
  String get substanceName;

  /// The parameter `weekdayIndex` of this provider.
  int get weekdayIndex;
}

class _DayUsageControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          DayUsageController,
          List<DayUsageEntry>
        >
    with DayUsageControllerRef {
  _DayUsageControllerProviderElement(super.provider);

  @override
  String get substanceName =>
      (origin as DayUsageControllerProvider).substanceName;
  @override
  int get weekdayIndex => (origin as DayUsageControllerProvider).weekdayIndex;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
