import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_drug_use_app/features/admin/models/admin_system_stats.dart';
import 'package:mobile_drug_use_app/features/admin/models/admin_user.dart';
import 'package:mobile_drug_use_app/features/admin/providers/admin_providers.dart';
import 'package:mobile_drug_use_app/features/admin/services/admin_service.dart';
import 'package:mobile_drug_use_app/core/services/cache_service.dart';

import 'admin_panel_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdminService>(), MockSpec<CacheService>()])
void main() {
  group('AdminPanelController', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });

    test('loads users/system/cache/perf on build', () async {
      final mockService = MockAdminService();
      final mockCache = MockCacheService();

      when(mockService.fetchAllUsers()).thenAnswer(
        (_) async => const [
          AdminUser(
            authUserId: 'u1',
            displayName: 'Alice',
            email: 'alice@example.com',
            isAdmin: true,
            entryCount: 3,
            cravingCount: 1,
            reflectionCount: 2,
          ),
        ],
      );
      when(mockService.getSystemStats()).thenAnswer(
        (_) async => const AdminSystemStats(totalEntries: 10, activeUsers: 2),
      );
      when(mockCache.getStats()).thenReturn({
        'total_entries': 7,
        'active_entries': 6,
        'expired_entries': 1,
      });

      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockService),
          adminCacheServiceProvider.overrideWithValue(mockCache),
        ],
      );
      addTearDown(container.dispose);

      final initial = container.read(adminPanelControllerProvider);
      expect(initial.isLoading, isTrue);

      // Ensure loading completes.
      await container.read(adminPanelControllerProvider.notifier).refresh();

      final loaded = container.read(adminPanelControllerProvider);
      expect(loaded.isLoading, isFalse);
      expect(loaded.errorMessage, isNull);

      expect(loaded.users, hasLength(1));
      expect(loaded.users.first.displayName, 'Alice');
      expect(loaded.users.first.totalActivity, 6);

      expect(loaded.systemStats.totalEntries, 10);
      expect(loaded.systemStats.activeUsers, 2);

      expect(loaded.cacheStats.totalEntries, 7);
      expect(loaded.cacheStats.activeEntries, 6);
      expect(loaded.cacheStats.expiredEntries, 1);
    });

    test('toggleAdmin promotes when currentlyAdmin=false', () async {
      final mockService = MockAdminService();
      final mockCache = MockCacheService();

      when(mockService.fetchAllUsers()).thenAnswer((_) async => const []);
      when(
        mockService.getSystemStats(),
      ).thenAnswer((_) async => const AdminSystemStats());
      when(mockService.promoteUser(any)).thenAnswer((_) async {});
      when(mockCache.getStats()).thenReturn({
        'total_entries': 0,
        'active_entries': 0,
        'expired_entries': 0,
      });

      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockService),
          adminCacheServiceProvider.overrideWithValue(mockCache),
        ],
      );
      addTearDown(container.dispose);

      // Allow initial load to complete, then clear recorded calls so we can
      // focus on the method under test.
      container.read(adminPanelControllerProvider);
      await pumpEventQueue();
      await pumpEventQueue();
      clearInteractions(mockService);

      await container
          .read(adminPanelControllerProvider.notifier)
          .toggleAdmin(authUserId: 'u1', currentlyAdmin: false);

      verify(mockService.promoteUser('u1')).called(1);
    });

    test('toggleAdmin demotes when currentlyAdmin=true', () async {
      final mockService = MockAdminService();
      final mockCache = MockCacheService();

      when(mockService.fetchAllUsers()).thenAnswer((_) async => const []);
      when(
        mockService.getSystemStats(),
      ).thenAnswer((_) async => const AdminSystemStats());
      when(mockService.demoteUser(any)).thenAnswer((_) async {});
      when(mockCache.getStats()).thenReturn({
        'total_entries': 0,
        'active_entries': 0,
        'expired_entries': 0,
      });

      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockService),
          adminCacheServiceProvider.overrideWithValue(mockCache),
        ],
      );
      addTearDown(container.dispose);

      container.read(adminPanelControllerProvider);
      await pumpEventQueue();
      await pumpEventQueue();
      clearInteractions(mockService);

      await container
          .read(adminPanelControllerProvider.notifier)
          .toggleAdmin(authUserId: 'u1', currentlyAdmin: true);

      verify(mockService.demoteUser('u1')).called(1);
    });

    test('clearAllCache clears cache and does not refetch users', () async {
      final mockService = MockAdminService();
      final mockCache = MockCacheService();

      when(mockService.fetchAllUsers()).thenAnswer((_) async => const []);
      when(
        mockService.getSystemStats(),
      ).thenAnswer((_) async => const AdminSystemStats());
      when(mockCache.getStats()).thenReturn({
        'total_entries': 0,
        'active_entries': 0,
        'expired_entries': 0,
      });

      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockService),
          adminCacheServiceProvider.overrideWithValue(mockCache),
        ],
      );
      addTearDown(container.dispose);

      container.read(adminPanelControllerProvider);
      await pumpEventQueue();
      await pumpEventQueue();
      clearInteractions(mockService);
      clearInteractions(mockCache);

      await container
          .read(adminPanelControllerProvider.notifier)
          .clearAllCache();

      verify(mockCache.clearAll()).called(1);
      verifyNever(mockService.fetchAllUsers());
      verifyNever(mockService.getSystemStats());
    });
  });
}
