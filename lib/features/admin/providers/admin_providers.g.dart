// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminService)
final adminServiceProvider = AdminServiceProvider._();

final class AdminServiceProvider
    extends $FunctionalProvider<AdminService, AdminService, AdminService>
    with $Provider<AdminService> {
  AdminServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminServiceHash();

  @$internal
  @override
  $ProviderElement<AdminService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdminService create(Ref ref) {
    return adminService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminService>(value),
    );
  }
}

String _$adminServiceHash() => r'c2da5f141a31e73adc29e566810086a2ded2ba5f';

@ProviderFor(adminCacheService)
final adminCacheServiceProvider = AdminCacheServiceProvider._();

final class AdminCacheServiceProvider
    extends $FunctionalProvider<CacheService, CacheService, CacheService>
    with $Provider<CacheService> {
  AdminCacheServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminCacheServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminCacheServiceHash();

  @$internal
  @override
  $ProviderElement<CacheService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheService create(Ref ref) {
    return adminCacheService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheService>(value),
    );
  }
}

String _$adminCacheServiceHash() => r'9d3b8d7b1edbd6e59b733e13c8c1e1aa4e5d327f';

@ProviderFor(AdminPanelController)
final adminPanelControllerProvider = AdminPanelControllerProvider._();

final class AdminPanelControllerProvider
    extends $NotifierProvider<AdminPanelController, AdminPanelState> {
  AdminPanelControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminPanelControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminPanelControllerHash();

  @$internal
  @override
  AdminPanelController create() => AdminPanelController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminPanelState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminPanelState>(value),
    );
  }
}

String _$adminPanelControllerHash() =>
    r'9caf1b9748b668b11d4cd11ee4f459f1ad098f8b';

abstract class _$AdminPanelController extends $Notifier<AdminPanelState> {
  AdminPanelState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AdminPanelState, AdminPanelState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminPanelState, AdminPanelState>,
              AdminPanelState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ErrorAnalyticsController)
final errorAnalyticsControllerProvider = ErrorAnalyticsControllerProvider._();

final class ErrorAnalyticsControllerProvider
    extends $NotifierProvider<ErrorAnalyticsController, ErrorAnalyticsState> {
  ErrorAnalyticsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorAnalyticsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorAnalyticsControllerHash();

  @$internal
  @override
  ErrorAnalyticsController create() => ErrorAnalyticsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ErrorAnalyticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ErrorAnalyticsState>(value),
    );
  }
}

String _$errorAnalyticsControllerHash() =>
    r'dcf1f179d4394b5a513b4dadefceffba041936e4';

abstract class _$ErrorAnalyticsController
    extends $Notifier<ErrorAnalyticsState> {
  ErrorAnalyticsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ErrorAnalyticsState, ErrorAnalyticsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ErrorAnalyticsState, ErrorAnalyticsState>,
              ErrorAnalyticsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
