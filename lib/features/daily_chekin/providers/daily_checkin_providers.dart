// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod state management for Daily Check-In.
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/navigation_provider.dart';
import '../../../core/routes/app_router.dart' show AppRoutePaths;
import '../../../common/logging/logger.dart';
import '../models/daily_checkin_model.dart';
import '../models/daily_checkin_state.dart';
import '../services/daily_checkin_service.dart';

part 'daily_checkin_providers.g.dart';

@riverpod
DailyCheckinRepository dailyCheckinRepository(Ref ref) {
  return DailyCheckinService();
}

@Riverpod(dependencies: [dailyCheckinRepository])
Future<DailyCheckin?> dailyCheckinForNow(Ref ref) async {
  final repo = ref.watch(dailyCheckinRepositoryProvider);
  final now = DateTime.now();
  final date = DateTime(now.year, now.month, now.day);
  final timeOfDay = DailyCheckinController._getTimeOfDay(TimeOfDay.now());
  return repo.fetchCheckinByDateAndTime(date, timeOfDay);
}

@Riverpod(dependencies: [dailyCheckinRepository])
class DailyCheckinController extends _$DailyCheckinController {
  static const availableMoods = <String>[
    'Great',
    'Good',
    'Neutral',
    'Struggling',
    'Poor',
  ];

  static const availableEmotions = <String>[
    'Happy',
    'Calm',
    'Energetic',
    'Tired',
    'Anxious',
    'Stressed',
    'Sad',
    'Angry',
    'Content',
    'Motivated',
    'Overwhelmed',
    'Peaceful',
  ];

  @override
  DailyCheckinState build() {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    final time = TimeOfDay.now();
    return DailyCheckinState(
      selectedDate: date,
      selectedTime: time,
      timeOfDay: _getTimeOfDay(time),
    );
  }

  DailyCheckinRepository get _repo => ref.read(dailyCheckinRepositoryProvider);

  void clearUiEvent() {
    state = state.copyWith(uiEvent: const DailyCheckinUiEvent.none());
  }

  Future<void> initialize() async {
    await checkExistingCheckin();
  }

  void setMood(String value) {
    state = state.copyWith(mood: value);
  }

  void toggleEmotion(String emotion) {
    final current = [...state.emotions];
    if (current.contains(emotion)) {
      current.remove(emotion);
    } else {
      current.add(emotion);
    }
    state = state.copyWith(emotions: current);
  }

  void setNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void setSelectedDate(DateTime value) {
    final normalized = DateTime(value.year, value.month, value.day);
    state = state.copyWith(selectedDate: normalized);
  }

  void setSelectedTime(TimeOfDay value) {
    state = state.copyWith(
      selectedTime: value,
      timeOfDay: _getTimeOfDay(value),
    );
  }

  Future<void> checkExistingCheckin() async {
    final selectedDate = state.selectedDate;
    if (selectedDate == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final existing = await _repo.fetchCheckinByDateAndTime(
        selectedDate,
        state.timeOfDay,
      );

      if (existing != null) {
        state = state.copyWith(
          existingCheckin: existing,
          mood: existing.mood,
          emotions: List<String>.from(existing.emotions),
          notes: existing.notes ?? '',
          isLoading: false,
        );
      } else {
        state = state.copyWith(existingCheckin: null, isLoading: false);
      }
    } catch (e, st) {
      logger.error(
        '[DailyCheckinController] checkExistingCheckin failed',
        error: e,
        stackTrace: st,
      );
      state = state.copyWith(
        isLoading: false,
        uiEvent: DailyCheckinUiEvent.snackbar(
          message: 'Error checking existing check-in: $e',
          isError: true,
        ),
      );
    }
  }

  Future<void> loadRecentCheckins() async {
    state = state.copyWith(isLoading: true);

    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 7));
      final recent = await _repo.fetchCheckinsInRange(startDate, endDate);
      state = state.copyWith(recentCheckins: recent, isLoading: false);
    } catch (e, st) {
      logger.error(
        '[DailyCheckinController] loadRecentCheckins failed',
        error: e,
        stackTrace: st,
      );
      state = state.copyWith(
        isLoading: false,
        uiEvent: DailyCheckinUiEvent.snackbar(
          message: 'Error loading check-ins: $e',
          isError: true,
        ),
      );
    }
  }

  Future<void> saveCheckin() async {
    if (state.existingCheckin != null) {
      state = state.copyWith(
        uiEvent: const DailyCheckinUiEvent.snackbar(
          message: 'A check-in already exists for this time.',
          isError: true,
        ),
      );
      return;
    }

    final selectedDate = state.selectedDate;
    if (selectedDate == null) return;

    state = state.copyWith(isSaving: true);

    try {
      final checkin = DailyCheckin(
        id: null,
        userId: '',
        checkinDate: selectedDate,
        mood: state.mood,
        emotions: state.emotions,
        timeOfDay: state.timeOfDay,
        notes: state.notes.isEmpty ? null : state.notes,
      );

      await _repo.saveCheckin(checkin);
      await loadRecentCheckins();
      await checkExistingCheckin();

      state = state.copyWith(
        isSaving: false,
        uiEvent: const DailyCheckinUiEvent.snackbar(
          message: 'Check-in saved successfully!',
        ),
      );

      ref.read(navigationProvider).pop();
    } catch (e, st) {
      logger.error(
        '[DailyCheckinController] saveCheckin failed',
        error: e,
        stackTrace: st,
      );
      state = state.copyWith(
        isSaving: false,
        uiEvent: DailyCheckinUiEvent.snackbar(
          message: 'Error saving check-in: $e',
          isError: true,
        ),
      );
    }
  }

  void openHistory() {
    ref.read(navigationProvider).push(AppRoutePaths.checkinHistory);
  }

  void close() {
    ref.read(navigationProvider).pop();
  }

  static String _getTimeOfDay(TimeOfDay time) {
    final hour = time.hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}
