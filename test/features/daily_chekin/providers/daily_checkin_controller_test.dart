import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/models/daily_checkin_model.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/models/daily_checkin_state.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/providers/daily_checkin_providers.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/services/daily_checkin_service.dart';

class _FakeNavigationService extends NavigationService {
  int popCount = 0;
  int pushCount = 0;
  int replaceCount = 0;
  String? lastLocation;

  @override
  void pop() {
    popCount += 1;
  }

  @override
  void push(String location) {
    pushCount += 1;
    lastLocation = location;
  }

  @override
  void replace(String location) {
    replaceCount += 1;
    lastLocation = location;
  }
}

class _FakeDailyCheckinRepository implements DailyCheckinRepository {
  DailyCheckin? existing;
  DailyCheckin? saved;

  @override
  Future<DailyCheckin?> fetchCheckinByDateAndTime(
    DateTime date,
    String timeOfDay,
  ) async {
    return existing;
  }

  @override
  Future<void> saveCheckin(DailyCheckin checkin) async {
    saved = checkin;
  }

  @override
  Future<List<DailyCheckin>> fetchCheckinsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return const [];
  }

  // Unused in these tests
  @override
  Future<void> deleteCheckin(String id) => throw UnimplementedError();

  @override
  Future<List<DailyCheckin>> fetchCheckinsByDate(DateTime date) =>
      throw UnimplementedError();

  @override
  Future<void> updateCheckin(String id, DailyCheckin checkin) =>
      throw UnimplementedError();
}

void main() {
  test('checkExistingCheckin loads existing checkin into state', () async {
    final repo = _FakeDailyCheckinRepository()
      ..existing = DailyCheckin(
        id: '1',
        userId: 'u',
        checkinDate: DateTime(2025, 1, 1),
        mood: 'Good',
        emotions: const ['Calm'],
        timeOfDay: 'morning',
        notes: 'hello',
      );

    final nav = _FakeNavigationService();

    final container = ProviderContainer(
      overrides: [
        dailyCheckinRepositoryProvider.overrideWithValue(repo),
        navigationProvider.overrideWithValue(nav),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(dailyCheckinControllerProvider.notifier);

    notifier.setSelectedDate(DateTime(2025, 1, 1));
    notifier.setSelectedTime(const TimeOfDay(hour: 9, minute: 0));

    await notifier.checkExistingCheckin();

    final state = container.read(dailyCheckinControllerProvider);
    expect(state.existingCheckin, isNotNull);
    expect(state.mood, 'Good');
    expect(state.emotions, ['Calm']);
    expect(state.notes, 'hello');
    expect(state.isLoading, false);
  });

  test('saveCheckin blocks when existingCheckin is present', () async {
    final repo = _FakeDailyCheckinRepository()
      ..existing = DailyCheckin(
        id: '1',
        userId: 'u',
        checkinDate: DateTime(2025, 1, 1),
        mood: 'Good',
        emotions: const ['Calm'],
        timeOfDay: 'morning',
        notes: null,
      );

    final nav = _FakeNavigationService();

    final container = ProviderContainer(
      overrides: [
        dailyCheckinRepositoryProvider.overrideWithValue(repo),
        navigationProvider.overrideWithValue(nav),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(dailyCheckinControllerProvider.notifier);
    notifier.setSelectedDate(DateTime(2025, 1, 1));

    await notifier.checkExistingCheckin();
    await notifier.saveCheckin();

    expect(repo.saved, isNull);
    expect(nav.popCount, 0);

    final state = container.read(dailyCheckinControllerProvider);
    expect(state.uiEvent, isNot(const DailyCheckinUiEvent.none()));
  });

  test(
    'saveCheckin success calls repository and pops via NavigationService',
    () async {
      final repo = _FakeDailyCheckinRepository();
      final nav = _FakeNavigationService();

      final container = ProviderContainer(
        overrides: [
          dailyCheckinRepositoryProvider.overrideWithValue(repo),
          navigationProvider.overrideWithValue(nav),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(dailyCheckinControllerProvider.notifier);
      notifier.setSelectedDate(DateTime(2025, 1, 1));
      notifier.setMood('Great');
      notifier.setNotes('note');

      await notifier.saveCheckin();

      expect(repo.saved, isNotNull);
      expect(repo.saved!.mood, 'Great');
      expect(nav.popCount, 1);

      final state = container.read(dailyCheckinControllerProvider);
      expect(state.isSaving, false);
    },
  );
}
