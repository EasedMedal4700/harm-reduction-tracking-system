import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_drug_use_app/features/admin/models/error_analytics.dart';
import 'package:mobile_drug_use_app/features/admin/providers/admin_providers.dart';
import 'package:mobile_drug_use_app/features/admin/services/admin_service.dart';

import 'error_analytics_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdminService>()])
void main() {
  group('ErrorAnalyticsController', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('loads analytics on build', () async {
      final mockService = MockAdminService();
      when(mockService.getErrorAnalytics()).thenAnswer(
        (_) async => const ErrorAnalytics(totalErrors: 10, last24h: 3),
      );

      final container = ProviderContainer(
        overrides: [adminServiceProvider.overrideWithValue(mockService)],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        errorAnalyticsControllerProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      container.read(errorAnalyticsControllerProvider);

      await pumpEventQueue();
      await pumpEventQueue();

      final loaded = container.read(errorAnalyticsControllerProvider);
      expect(loaded.isLoading, isFalse);
      expect(loaded.errorMessage, isNull);
      expect(loaded.analytics.totalErrors, 10);
      expect(loaded.analytics.last24h, 3);
      verify(mockService.getErrorAnalytics()).called(greaterThanOrEqualTo(1));
    });

    test('clearErrorLogs calls service and reloads analytics', () async {
      final mockService = MockAdminService();
      when(mockService.getErrorAnalytics()).thenAnswer(
        (_) async => const ErrorAnalytics(totalErrors: 1, last24h: 1),
      );
      when(
        mockService.clearErrorLogs(
          deleteAll: anyNamed('deleteAll'),
          olderThanDays: anyNamed('olderThanDays'),
          platform: anyNamed('platform'),
          screenName: anyNamed('screenName'),
        ),
      ).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [adminServiceProvider.overrideWithValue(mockService)],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        errorAnalyticsControllerProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      container.read(errorAnalyticsControllerProvider);
      await pumpEventQueue();
      await pumpEventQueue();
      clearInteractions(mockService);

      await container
          .read(errorAnalyticsControllerProvider.notifier)
          .clearErrorLogs(deleteAll: true);

      verify(mockService.clearErrorLogs(deleteAll: true)).called(1);
      verify(mockService.getErrorAnalytics()).called(1);

      final state = container.read(errorAnalyticsControllerProvider);
      expect(state.isClearingErrors, isFalse);
    });
  });
}
