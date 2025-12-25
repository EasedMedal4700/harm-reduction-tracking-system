// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Tests for tolerance controller

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

  test('ToleranceController builds correctly', () async {
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

    expect(result, isA<ToleranceResult>());
    expect(result.toleranceScore, 0.0);
    verify(mockRepository.fetchToleranceModels()).called(1);
    verify(mockRepository.fetchUseLogs(userId: 'user1')).called(1);
  });
}
