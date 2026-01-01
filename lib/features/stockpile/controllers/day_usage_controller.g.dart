// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_usage_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DayUsageController)
final dayUsageControllerProvider = DayUsageControllerFamily._();

final class DayUsageControllerProvider
    extends $AsyncNotifierProvider<DayUsageController, List<DayUsageEntry>> {
  DayUsageControllerProvider._({
    required DayUsageControllerFamily super.from,
    required ({String substanceName, int weekdayIndex}) super.argument,
  }) : super(
         retry: null,
         name: r'dayUsageControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dayUsageControllerHash();

  @override
  String toString() {
    return r'dayUsageControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DayUsageController create() => DayUsageController();

  @override
  bool operator ==(Object other) {
    return other is DayUsageControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dayUsageControllerHash() =>
    r'b3fdd5719b37e8fe67a3162ff10184dd7ebe36d5';

final class DayUsageControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DayUsageController,
          AsyncValue<List<DayUsageEntry>>,
          List<DayUsageEntry>,
          FutureOr<List<DayUsageEntry>>,
          ({String substanceName, int weekdayIndex})
        > {
  DayUsageControllerFamily._()
    : super(
        retry: null,
        name: r'dayUsageControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DayUsageControllerProvider call({
    required String substanceName,
    required int weekdayIndex,
  }) => DayUsageControllerProvider._(
    argument: (substanceName: substanceName, weekdayIndex: weekdayIndex),
    from: this,
  );

  @override
  String toString() => r'dayUsageControllerProvider';
}

abstract class _$DayUsageController
    extends $AsyncNotifier<List<DayUsageEntry>> {
  late final _$args = ref.$arg as ({String substanceName, int weekdayIndex});
  String get substanceName => _$args.substanceName;
  int get weekdayIndex => _$args.weekdayIndex;

  FutureOr<List<DayUsageEntry>> build({
    required String substanceName,
    required int weekdayIndex,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<DayUsageEntry>>, List<DayUsageEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DayUsageEntry>>, List<DayUsageEntry>>,
              AsyncValue<List<DayUsageEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        substanceName: _$args.substanceName,
        weekdayIndex: _$args.weekdayIndex,
      ),
    );
  }
}
