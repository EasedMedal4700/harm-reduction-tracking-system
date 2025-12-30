import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/features/activity/models/activity_models.dart';
import 'package:mobile_drug_use_app/features/activity/services/activity_service.dart';
import 'package:mobile_drug_use_app/features/activity/providers/activity_providers.dart';

class FakeActivityService implements ActivityService {
  FakeActivityService(this._data);

  ActivityData _data;
  int fetchCount = 0;
  final deleted = <({ActivityItemType type, String id})>[];

  @override
  Future<ActivityData> fetchRecentActivity() async {
    fetchCount += 1;
    return _data;
  }

  @override
  Future<void> deleteActivityItem({
    required ActivityItemType type,
    required String id,
  }) async {
    deleted.add((type: type, id: id));
    _data = _data.copyWith(
      entries: _data.entries.where((e) => e.id != id).toList(growable: false),
      cravings: _data.cravings.where((e) => e.id != id).toList(growable: false),
      reflections: _data.reflections
          .where((e) => e.id != id)
          .toList(growable: false),
    );
  }
}

ActivityData _fixtureData() {
  final now = DateTime(2025, 1, 1, 12);
  return ActivityData(
    entries: [
      ActivityDrugUseEntry(
        id: 'u1',
        name: 'Test Substance',
        dose: '10 mg',
        place: 'Home',
        time: now,
        raw: const {'use_id': 'u1'},
      ),
    ],
    cravings: [
      ActivityCravingEntry(
        id: 'c1',
        substance: 'Test Substance',
        intensity: 6.0,
        location: 'Work',
        time: now,
        raw: const {'craving_id': 'c1'},
      ),
    ],
    reflections: [
      ActivityReflectionEntry(
        id: 'r1',
        createdAt: now,
        effectiveness: 7,
        sleepHours: 8,
        raw: const {'reflection_id': 'r1'},
      ),
    ],
  );
}

void main() {
  group('ActivityController', () {
    test('loads initial activity data', () async {
      final fake = FakeActivityService(_fixtureData());
      final container = ProviderContainer(
        overrides: [activityServiceProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      final state = await container.read(activityControllerProvider.future);
      expect(fake.fetchCount, 1);
      expect(state.data.entries, hasLength(1));
      expect(state.data.cravings, hasLength(1));
      expect(state.data.reflections, hasLength(1));
    });

    test('refreshActivity refetches data', () async {
      final fake = FakeActivityService(_fixtureData());
      final container = ProviderContainer(
        overrides: [activityServiceProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      await container.read(activityControllerProvider.future);
      expect(fake.fetchCount, 1);

      await container
          .read(activityControllerProvider.notifier)
          .refreshActivity();
      expect(fake.fetchCount, 2);
    });

    test('deleteEntry deletes and refreshes', () async {
      final fake = FakeActivityService(_fixtureData());
      final container = ProviderContainer(
        overrides: [activityServiceProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      await container.read(activityControllerProvider.future);

      await container
          .read(activityControllerProvider.notifier)
          .deleteEntry(id: 'u1', type: ActivityItemType.drugUse);

      expect(fake.deleted, hasLength(1));
      expect(fake.deleted.single.type, ActivityItemType.drugUse);
      expect(fake.deleted.single.id, 'u1');

      final after = container.read(activityControllerProvider).value;
      expect(after, isNotNull);
      expect(after!.data.entries, isEmpty);
      expect(after.event, isNotNull);
    });
  });
}
