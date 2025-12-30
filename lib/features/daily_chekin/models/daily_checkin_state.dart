// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod state for Daily Check-In UI.
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'daily_checkin_model.dart';

part 'daily_checkin_state.freezed.dart';

@freezed
abstract class DailyCheckinUiEvent with _$DailyCheckinUiEvent {
  const factory DailyCheckinUiEvent.snackbar({
    required String message,
    @Default(false) bool isError,
  }) = _DailyCheckinSnackbar;

  const factory DailyCheckinUiEvent.close() = _DailyCheckinClose;

  const factory DailyCheckinUiEvent.none() = _DailyCheckinNone;
}

@freezed
abstract class DailyCheckinState with _$DailyCheckinState {
  const factory DailyCheckinState({
    @Default('Neutral') String mood,
    @Default(<String>[]) List<String> emotions,
    @Default('morning') String timeOfDay,
    @Default('') String notes,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    DailyCheckin? existingCheckin,
    @Default(<DailyCheckin>[]) List<DailyCheckin> recentCheckins,
    @Default(false) bool isSaving,
    @Default(false) bool isLoading,
    @Default(DailyCheckinUiEvent.none()) DailyCheckinUiEvent uiEvent,
  }) = _DailyCheckinState;
}
