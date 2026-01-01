// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Comprehensive tests for tolerance controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_drug_use_app/features/tolerance/controllers/tolerance_controller.dart';
import 'package:mobile_drug_use_app/features/tolerance/controllers/tolerance_repository.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';

import 'tolerance_mocks.mocks.dart';

void main() {
  late MockToleranceRepository mockRepository;

  setUp(() {
    mockRepository = MockToleranceRepository();
  });

  group('ToleranceController - build', () {
    test('successfully loads tolerance data', () async {
      final container = ProviderContainer(
        overrides: [
          toleranceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final models = {
        'alcohol': const ToleranceModel(
          neuroBuckets: {'gaba': NeuroBucket(name: 'gaba', weight: 0.9)},
          halfLifeHours: 8.0,
        ),
      };

      final useLogs = [
        UseLogEntry(
          substanceSlug: 'alcohol',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          doseUnits: 20.0,
        ),
      ];

      when(
        mockRepository.fetchToleranceModels(),
      ).thenAnswer((_) async => models);
      when(
        mockRepository.fetchUseLogs(userId: anyNamed('userId')),
      ).thenAnswer((_) async => useLogs);

      final result = await container.read(
        toleranceControllerProvider('user1').future,
      );

      expect(result, isA<ToleranceResult>());
      expect(result.toleranceScore, greaterThan(0.0));
      expect(result.bucketPercents['gaba'], greaterThan(0.0));
      verify(mockRepository.fetchToleranceModels()).called(1);
      verify(mockRepository.fetchUseLogs(userId: 'user1')).called(1);
    });

    test('handles empty tolerance models', () async {
      final container = ProviderContainer(
        overrides: [
          toleranceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(mockRepository.fetchToleranceModels()).thenAnswer((_) async => {});
      when(
        mockRepository.fetchUseLogs(userId: anyNamed('userId')),
      ).thenAnswer((_) async => []);

      final result = await container.read(
        toleranceControllerProvider('user1').future,
      );

      expect(result.toleranceScore, 0.0);
      expect(result.bucketPercents.values.every((v) => v == 0.0), isTrue);
    });

    test('handles empty use logs', () async {
      final container = ProviderContainer(
        overrides: [
          toleranceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final models = {
        'alcohol': const ToleranceModel(
          neuroBuckets: {'gaba': NeuroBucket(name: 'gaba', weight: 0.9)},
          halfLifeHours: 8.0,
        ),
      };

      when(
        mockRepository.fetchToleranceModels(),
      ).thenAnswer((_) async => models);
      when(
        mockRepository.fetchUseLogs(userId: anyNamed('userId')),
      ).thenAnswer((_) async => []);

      final result = await container.read(
        toleranceControllerProvider('user1').future,
      );

      expect(result.toleranceScore, 0.0);
    });

    test('propagates repository errors', () async {
      final container = ProviderContainer(
        overrides: [
          toleranceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(
        mockRepository.fetchToleranceModels(),
      ).thenAnswer((_) => Future.error(Exception('Database error')));
      when(
        mockRepository.fetchUseLogs(
          userId: anyNamed('userId'),
          daysBack: anyNamed('daysBack'),
        ),
      ).thenAnswer((_) => Future.value([]));

      // Keep provider alive
      container.listen(
        toleranceControllerProvider('user1'),
        (_, __) {},
        fireImmediately: false,
      );

      // Trigger build and catch error
      container.read(toleranceControllerProvider('user1').future).catchError((
        _,
      ) {
        return const ToleranceResult(
          toleranceScore: 0,
          bucketPercents: {},
          bucketRawLoads: {},
          daysUntilBaseline: {},
          overallDaysUntilBaseline: 0,
        );
      });

      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(toleranceControllerProvider('user1'));
      expect(state.hasError, true);
      expect(state.error, isA<Exception>());
    });

    test('handles different user IDs', () async {
      final container = ProviderContainer(
        overrides: [
          toleranceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(mockRepository.fetchToleranceModels()).thenAnswer((_) async => {});
      when(
        mockRepository.fetchUseLogs(userId: 'user1'),
      ).thenAnswer((_) async => []);
      when(
        mockRepository.fetchUseLogs(userId: 'user2'),
      ).thenAnswer((_) async => []);

      await container.read(toleranceControllerProvider('user1').future);
      await container.read(toleranceControllerProvider('user2').future);

      verify(mockRepository.fetchUseLogs(userId: 'user1')).called(1);
      verify(mockRepository.fetchUseLogs(userId: 'user2')).called(1);
    });

    test('calculates tolerance with multiple substances', () async {
      final container = ProviderContainer(
        overrides: [
          toleranceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final models = {
        'alcohol': const ToleranceModel(
          neuroBuckets: {'gaba': NeuroBucket(name: 'gaba', weight: 0.9)},
          halfLifeHours: 8.0,
        ),
        'caffeine': const ToleranceModel(
          neuroBuckets: {
            'stimulant': NeuroBucket(name: 'stimulant', weight: 1.0),
          },
          halfLifeHours: 5.0,
        ),
      };

      final useLogs = [
        UseLogEntry(
          substanceSlug: 'alcohol',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          doseUnits: 20.0,
        ),
        UseLogEntry(
          substanceSlug: 'caffeine',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          doseUnits: 100.0,
        ),
      ];

      when(
        mockRepository.fetchToleranceModels(),
      ).thenAnswer((_) async => models);
      when(
        mockRepository.fetchUseLogs(userId: anyNamed('userId')),
      ).thenAnswer((_) async => useLogs);

      final result = await container.read(
        toleranceControllerProvider('user1').future,
      );

      expect(result.bucketPercents['gaba'], greaterThan(0.0));
      expect(result.bucketPercents['stimulant'], greaterThan(0.0));
    });
  });

  group('ToleranceController - state management', () {
    test('starts in loading state', () {
      final container = ProviderContainer(
        overrides: [
          toleranceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(mockRepository.fetchToleranceModels()).thenAnswer((_) async => {});
      when(
        mockRepository.fetchUseLogs(userId: anyNamed('userId')),
      ).thenAnswer((_) async => []);

      final state = container.read(toleranceControllerProvider('user1'));

      expect(state, isA<AsyncLoading>());
    });

    test('transitions to data state on success', () async {
      final container = ProviderContainer(
        overrides: [
          toleranceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(mockRepository.fetchToleranceModels()).thenAnswer((_) async => {});
      when(
        mockRepository.fetchUseLogs(userId: anyNamed('userId')),
      ).thenAnswer((_) async => []);

      await container.read(toleranceControllerProvider('user1').future);

      final state = container.read(toleranceControllerProvider('user1'));

      expect(state, isA<AsyncData<ToleranceResult>>());
    });

    test('transitions to error state on failure', () async {
      final container = ProviderContainer(
        overrides: [
          toleranceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(
        mockRepository.fetchToleranceModels(),
      ).thenAnswer((_) => Future.error(Exception('Network error')));
      when(
        mockRepository.fetchUseLogs(
          userId: anyNamed('userId'),
          daysBack: anyNamed('daysBack'),
        ),
      ).thenAnswer((_) => Future.value([]));

      // Keep provider alive
      container.listen(
        toleranceControllerProvider('user1'),
        (_, __) {},
        fireImmediately: false,
      );

      // Trigger build and catch error
      container.read(toleranceControllerProvider('user1').future).catchError((
        _,
      ) {
        return const ToleranceResult(
          toleranceScore: 0,
          bucketPercents: {},
          bucketRawLoads: {},
          daysUntilBaseline: {},
          overallDaysUntilBaseline: 0,
        );
      });

      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(toleranceControllerProvider('user1'));

      expect(state.hasError, true);
      expect(state.error, isA<Exception>());
    });
  });
}
