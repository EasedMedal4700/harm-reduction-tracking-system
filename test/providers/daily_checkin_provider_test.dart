import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/models/daily_checkin_model.dart';
import 'package:mobile_drug_use_app/providers/daily_checkin_provider.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/services/daily_checkin_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'daily_checkin_provider_test.mocks.dart';

@GenerateMocks([DailyCheckinRepository])
void main() {
  late MockDailyCheckinRepository mockRepository;
  late DailyCheckinProvider provider;

  setUp(() {
    mockRepository = MockDailyCheckinRepository();
    provider = DailyCheckinProvider(repository: mockRepository);
  });

  tearDown(() {
    provider.dispose();
  });

  group('DailyCheckinProvider - Initialization', () {
    test('should initialize with default values', () {
      expect(provider.mood, 'Neutral');
      expect(provider.emotions, isEmpty);
      expect(provider.timeOfDay, 'morning');
      expect(provider.notes, isEmpty);
      expect(provider.selectedDate, isA<DateTime>());
      expect(provider.selectedTime, isNull);
      expect(provider.existingCheckin, isNull);
      expect(provider.isSaving, false);
      expect(provider.isLoading, false);
      expect(provider.recentCheckins, isEmpty);
    });

    test('should have correct available options', () {
      expect(
        provider.availableMoods,
        containsAll(['Great', 'Good', 'Neutral', 'Struggling', 'Poor']),
      );
      expect(
        provider.availableTimesOfDay,
        containsAll(['morning', 'afternoon', 'evening']),
      );
      expect(
        provider.availableEmotions,
        containsAll(['Happy', 'Calm', 'Energetic', 'Tired', 'Anxious']),
      );
    });
  });

  group('DailyCheckinProvider - Setters', () {
    test('setMood should update mood and notify listeners', () {
      var notified = false;
      provider.addListener(() => notified = true);

      provider.setMood('Great');

      expect(provider.mood, 'Great');
      expect(notified, true);
    });

    test('setEmotions should update emotions and notify listeners', () {
      var notified = false;
      provider.addListener(() => notified = true);

      provider.setEmotions(['Happy', 'Calm']);

      expect(provider.emotions, ['Happy', 'Calm']);
      expect(notified, true);
    });

    test('toggleEmotion should add emotion when not present', () {
      var notified = false;
      provider.addListener(() => notified = true);

      provider.toggleEmotion('Happy');

      expect(provider.emotions, contains('Happy'));
      expect(notified, true);
    });

    test('toggleEmotion should remove emotion when present', () {
      provider.setEmotions(['Happy']);
      var notified = false;
      provider.addListener(() => notified = true);

      provider.toggleEmotion('Happy');

      expect(provider.emotions, isNot(contains('Happy')));
      expect(notified, true);
    });

    test('setTimeOfDay should update timeOfDay and notify listeners', () {
      var notified = false;
      provider.addListener(() => notified = true);

      provider.setTimeOfDay('afternoon');

      expect(provider.timeOfDay, 'afternoon');
      expect(notified, true);
    });

    test('setNotes should update notes and notify listeners', () {
      var notified = false;
      provider.addListener(() => notified = true);

      provider.setNotes('Test notes');

      expect(provider.notes, 'Test notes');
      expect(notified, true);
    });

    test('setSelectedDate should update selectedDate and notify listeners', () {
      var notified = false;
      provider.addListener(() => notified = true);
      final newDate = DateTime(2023, 10, 15);

      provider.setSelectedDate(newDate);

      expect(provider.selectedDate, newDate);
      expect(notified, true);
    });

    test(
      'setSelectedTime should update selectedTime and auto-set timeOfDay',
      () {
        var notified = false;
        provider.addListener(() => notified = true);

        // Morning time (before 12)
        provider.setSelectedTime(const TimeOfDay(hour: 9, minute: 0));

        expect(provider.selectedTime, const TimeOfDay(hour: 9, minute: 0));
        expect(provider.timeOfDay, 'morning');
        expect(notified, true);

        notified = false;
        // Afternoon time (12-17)
        provider.setSelectedTime(const TimeOfDay(hour: 14, minute: 0));

        expect(provider.timeOfDay, 'afternoon');
        expect(notified, true);

        notified = false;
        // Evening time (after 17)
        provider.setSelectedTime(const TimeOfDay(hour: 20, minute: 0));

        expect(provider.timeOfDay, 'evening');
        expect(notified, true);
      },
    );
  });

  group('DailyCheckinProvider - Check Existing Checkin', () {
    test(
      'checkExistingCheckin should load existing checkin data when found',
      () async {
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

        await provider.checkExistingCheckin();

        expect(provider.existingCheckin, existingCheckin);
        expect(provider.mood, 'Good');
        expect(provider.emotions, ['Happy', 'Calm']);
        expect(provider.notes, 'Test notes');
        expect(provider.isLoading, false);
      },
    );

    test('checkExistingCheckin should handle no existing checkin', () async {
      when(
        mockRepository.fetchCheckinByDateAndTime(any, any),
      ).thenAnswer((_) async => null);

      await provider.checkExistingCheckin();

      expect(provider.existingCheckin, isNull);
      expect(provider.isLoading, false);
    });

    test('checkExistingCheckin should handle errors gracefully', () async {
      when(
        mockRepository.fetchCheckinByDateAndTime(any, any),
      ).thenThrow(Exception('Test error'));

      await provider.checkExistingCheckin();

      expect(provider.existingCheckin, isNull);
      expect(provider.isLoading, false);
    });
  });

  group('DailyCheckinProvider - Reset', () {
    test('reset should restore default values', () {
      // Set some values
      provider.setMood('Good');
      provider.setEmotions(['Happy']);
      provider.setNotes('Test notes');
      provider.setTimeOfDay('afternoon');

      provider.reset();

      expect(provider.mood, 'Neutral');
      expect(provider.emotions, isEmpty);
      expect(provider.notes, isEmpty);
      expect(
        provider.timeOfDay,
        isNotEmpty,
      ); // Should be set to current time of day
      expect(provider.existingCheckin, isNull);
    });
  });

  group('DailyCheckinProvider - Load Recent Checkins', () {
    test('loadRecentCheckins should load checkins from repository', () async {
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

      await provider.loadRecentCheckins();

      expect(provider.recentCheckins, checkins);
      expect(provider.isLoading, false);
    });

    test('loadRecentCheckins should handle errors gracefully', () async {
      when(
        mockRepository.fetchCheckinsInRange(any, any),
      ).thenThrow(Exception('Test error'));

      await provider.loadRecentCheckins();

      expect(provider.recentCheckins, isEmpty);
      expect(provider.isLoading, false);
    });
  });

  group('DailyCheckinProvider - Load Checkins For Date', () {
    test(
      'loadCheckinsForDate should return checkins from repository',
      () async {
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
          mockRepository.fetchCheckinsByDate(any),
        ).thenAnswer((_) async => checkins);

        final result = await provider.loadCheckinsForDate(DateTime.now());

        expect(result, checkins);
      },
    );

    test('loadCheckinsForDate should return empty list on error', () async {
      when(
        mockRepository.fetchCheckinsByDate(any),
      ).thenThrow(Exception('Test error'));

      final result = await provider.loadCheckinsForDate(DateTime.now());

      expect(result, isEmpty);
    });
  });
}
