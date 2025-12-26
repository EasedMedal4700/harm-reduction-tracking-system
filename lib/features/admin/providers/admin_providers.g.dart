// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminServiceHash() => r'c2da5f141a31e73adc29e566810086a2ded2ba5f';

/// See also [adminService].
@ProviderFor(adminService)
final adminServiceProvider = AutoDisposeProvider<AdminService>.internal(
  adminService,
  name: r'adminServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminServiceRef = AutoDisposeProviderRef<AdminService>;
String _$adminCacheServiceHash() => r'9d3b8d7b1edbd6e59b733e13c8c1e1aa4e5d327f';

/// See also [adminCacheService].
@ProviderFor(adminCacheService)
final adminCacheServiceProvider = AutoDisposeProvider<CacheService>.internal(
  adminCacheService,
  name: r'adminCacheServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminCacheServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminCacheServiceRef = AutoDisposeProviderRef<CacheService>;
String _$adminPanelControllerHash() =>
    r'9caf1b9748b668b11d4cd11ee4f459f1ad098f8b';

/// See also [AdminPanelController].
@ProviderFor(AdminPanelController)
final adminPanelControllerProvider =
    AutoDisposeNotifierProvider<AdminPanelController, AdminPanelState>.internal(
      AdminPanelController.new,
      name: r'adminPanelControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adminPanelControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AdminPanelController = AutoDisposeNotifier<AdminPanelState>;
String _$errorAnalyticsControllerHash() =>
    r'dcf1f179d4394b5a513b4dadefceffba041936e4';

/// See also [ErrorAnalyticsController].
@ProviderFor(ErrorAnalyticsController)
final errorAnalyticsControllerProvider =
    AutoDisposeNotifierProvider<
      ErrorAnalyticsController,
      ErrorAnalyticsState
    >.internal(
      ErrorAnalyticsController.new,
      name: r'errorAnalyticsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$errorAnalyticsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ErrorAnalyticsController = AutoDisposeNotifier<ErrorAnalyticsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
