import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/models/daily_checkin_model.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/providers/daily_checkin_providers.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/services/daily_checkin_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'daily_checkin_provider_test.mocks.dart';

@GenerateMocks([DailyCheckinRepository])
void main() {
  late MockDailyCheckinRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockDailyCheckinRepository();
    container = ProviderContainer(
      overrides: [
        dailyCheckinRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('DailyCheckinController - Initialization', () {
    test('should initialize with default values', () {
      final state = container.read(dailyCheckinControllerProvider);
      expect(state.mood, 'Neutral');
      expect(state.emotions, isEmpty);
      final hour = TimeOfDay.now().hour;
      final expectedTimeOfDay = hour < 12
          ? 'morning'
          : (hour < 17 ? 'afternoon' : 'evening');
      expect(state.timeOfDay, expectedTimeOfDay);
      expect(state.notes, isEmpty);
      expect(state.selectedDate, isA<DateTime>());
      expect(state.selectedTime, isA<TimeOfDay>());
      expect(state.existingCheckin, isNull);
      expect(state.isSaving, false);
      expect(state.isLoading, false);
      expect(state.recentCheckins, isEmpty);
    });

    test('should have correct available options', () {
      expect(
        DailyCheckinController.availableMoods,
        containsAll(['Great', 'Good', 'Neutral', 'Struggling', 'Poor']),
      );
      expect(
        DailyCheckinController.availableEmotions,
        containsAll(['Happy', 'Calm', 'Energetic', 'Tired', 'Anxious']),
      );
    });
  });

  group('DailyCheckinController - Setters', () {
    test('setMood should update mood', () {
      final controller = container.read(
        dailyCheckinControllerProvider.notifier,
      );
      controller.setMood('Great');
      expect(container.read(dailyCheckinControllerProvider).mood, 'Great');
    });

    test('toggleEmotion should add and remove', () {
      final controller = container.read(
        dailyCheckinControllerProvider.notifier,
      );

      controller.toggleEmotion('Happy');
      expect(
        container.read(dailyCheckinControllerProvider).emotions,
        contains('Happy'),
      );

      controller.toggleEmotion('Happy');
      expect(
        container.read(dailyCheckinControllerProvider).emotions,
        isNot(contains('Happy')),
      );
    });

    test('setNotes should update notes', () {
      final controller = container.read(
        dailyCheckinControllerProvider.notifier,
      );
      controller.setNotes('Test notes');
      expect(
        container.read(dailyCheckinControllerProvider).notes,
        'Test notes',
      );
    });

    test('setSelectedDate should normalize date', () {
      final controller = container.read(
        dailyCheckinControllerProvider.notifier,
      );
      final newDate = DateTime(2023, 10, 15, 12, 30);
      controller.setSelectedDate(newDate);
      expect(
        container.read(dailyCheckinControllerProvider).selectedDate,
        DateTime(2023, 10, 15),
      );
    });

    test(
      'setSelectedTime should update selectedTime and auto-set timeOfDay',
      () {
        final controller = container.read(
          dailyCheckinControllerProvider.notifier,
        );

        // Morning time (before 12)
        controller.setSelectedTime(const TimeOfDay(hour: 9, minute: 0));

        final state1 = container.read(dailyCheckinControllerProvider);
        expect(state1.selectedTime, const TimeOfDay(hour: 9, minute: 0));
        expect(state1.timeOfDay, 'morning');

        // Afternoon time (12-17)
        controller.setSelectedTime(const TimeOfDay(hour: 14, minute: 0));

        final state2 = container.read(dailyCheckinControllerProvider);
        expect(state2.timeOfDay, 'afternoon');

        // Evening time (after 17)
        controller.setSelectedTime(const TimeOfDay(hour: 20, minute: 0));

        final state3 = container.read(dailyCheckinControllerProvider);
        expect(state3.timeOfDay, 'evening');
      },
    );
  });

  group('DailyCheckinController - Check Existing Checkin', () {
    test(
      'checkExistingCheckin should load existing checkin data when found',
      () async {
        final controller = container.read(
          dailyCheckinControllerProvider.notifier,
        );

        final existingCheckin = DailyCheckin(
          id: 'test-id',
          userId: 'test-user',
          checkinDate: DateTime.now(),
          mood: 'Good',
          emotions: ['Happy', 'Calm'],
          timeOfDay: 'morning',
          notes: 'Test notes',
          createdAt: DateTime.now(),
        );

        when(
          mockRepository.fetchCheckinByDateAndTime(any, any),
        ).thenAnswer((_) async => existingCheckin);

        await controller.checkExistingCheckin();

        final state = container.read(dailyCheckinControllerProvider);
        expect(state.existingCheckin, existingCheckin);
        expect(state.mood, 'Good');
        expect(state.emotions, ['Happy', 'Calm']);
        expect(state.notes, 'Test notes');
        expect(state.isLoading, false);
      },
    );

    test('checkExistingCheckin should handle no existing checkin', () async {
      final controller = container.read(
        dailyCheckinControllerProvider.notifier,
      );
      when(
        mockRepository.fetchCheckinByDateAndTime(any, any),
      ).thenAnswer((_) async => null);

      await controller.checkExistingCheckin();

      final state = container.read(dailyCheckinControllerProvider);
      expect(state.existingCheckin, isNull);
      expect(state.isLoading, false);
    });

    test('checkExistingCheckin should handle errors gracefully', () async {
      final controller = container.read(
        dailyCheckinControllerProvider.notifier,
      );
      when(
        mockRepository.fetchCheckinByDateAndTime(any, any),
      ).thenThrow(Exception('Test error'));

      await controller.checkExistingCheckin();

      final state = container.read(dailyCheckinControllerProvider);
      expect(state.existingCheckin, isNull);
      expect(state.isLoading, false);
    });
  });

  group('DailyCheckinController - Load Recent Checkins', () {
    test('loadRecentCheckins should load checkins from repository', () async {
      final controller = container.read(
        dailyCheckinControllerProvider.notifier,
      );
      final checkins = [
        DailyCheckin(
          id: '1',
          userId: 'user1',
          checkinDate: DateTime.now(),
          mood: 'Good',
          emotions: ['Happy'],
          timeOfDay: 'morning',
        ),
      ];

      when(
        mockRepository.fetchCheckinsInRange(any, any),
      ).thenAnswer((_) async => checkins);

      await controller.loadRecentCheckins();

      final state = container.read(dailyCheckinControllerProvider);
      expect(state.recentCheckins, checkins);
      expect(state.isLoading, false);
    });

    test('loadRecentCheckins should handle errors gracefully', () async {
      final controller = container.read(
        dailyCheckinControllerProvider.notifier,
      );
      when(
        mockRepository.fetchCheckinsInRange(any, any),
      ).thenThrow(Exception('Test error'));

      await controller.loadRecentCheckins();

      final state = container.read(dailyCheckinControllerProvider);
      expect(state.recentCheckins, isEmpty);
      expect(state.isLoading, false);
    });
  });
}
