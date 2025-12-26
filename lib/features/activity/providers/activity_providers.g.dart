// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityServiceHash() => r'f4094c34385c3f75a4c053daa6dcabe102d795eb';

/// See also [activityService].
@ProviderFor(activityService)
final activityServiceProvider = AutoDisposeProvider<ActivityService>.internal(
  activityService,
  name: r'activityServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activityServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivityServiceRef = AutoDisposeProviderRef<ActivityService>;
String _$activityControllerHash() =>
    r'd6169c3f2bec9a6730b866c3a74c9485138d2339';

/// See also [ActivityController].
@ProviderFor(ActivityController)
final activityControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      ActivityController,
      ActivityState
    >.internal(
      ActivityController.new,
      name: r'activityControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activityControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActivityController = AutoDisposeAsyncNotifier<ActivityState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
