// MIGRATION:
// State: LEGACY
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Legacy ChangeNotifier provider.
import 'package:flutter/material.dart';
import '../models/daily_checkin_model.dart';
import '../features/daily_chekin/services/daily_checkin_service.dart';
import '../common/logging/app_log.dart';

class DailyCheckinProvider extends ChangeNotifier {
  DailyCheckinProvider({DailyCheckinRepository? repository})
    : _repository = repository ?? DailyCheckinService();
  final DailyCheckinRepository _repository;
  // Current check-in being edited
  String _mood = 'Neutral';
  List<String> _emotions = [];
  String _timeOfDay = 'morning';
  String _notes = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  // Existing check-in (if editing)
  DailyCheckin? _existingCheckin;
  // Loading states
  bool _isSaving = false;
  bool _isLoading = false;
  // History
  List<DailyCheckin> _recentCheckins = [];
  // Getters
  String get mood => _mood;
  List<String> get emotions => _emotions;
  String get timeOfDay => _timeOfDay;
  String get notes => _notes;
  DateTime get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  DailyCheckin? get existingCheckin => _existingCheckin;
  bool get isSaving => _isSaving;
  bool get isLoading => _isLoading;
  List<DailyCheckin> get recentCheckins => _recentCheckins;
  // Available options
  final List<String> availableMoods = [
    'Great',
    'Good',
    'Neutral',
    'Struggling',
    'Poor',
  ];
  final List<String> availableTimesOfDay = ['morning', 'afternoon', 'evening'];
  // Available emotions (can be expanded)
  final List<String> availableEmotions = [
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
  // Setters
  void setMood(String value) {
    _mood = value;
    notifyListeners();
  }

  void setEmotions(List<String> value) {
    _emotions = value;
    notifyListeners();
  }

  void toggleEmotion(String emotion) {
    if (_emotions.contains(emotion)) {
      _emotions.remove(emotion);
    } else {
      _emotions.add(emotion);
    }
    notifyListeners();
  }

  void setTimeOfDay(String value) {
    _timeOfDay = value;
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value;
    notifyListeners();
  }

  void setSelectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay value) {
    _selectedTime = value;
    // Auto-update time of day
    if (value.hour < 12) {
      _timeOfDay = 'morning';
    } else if (value.hour < 17) {
      _timeOfDay = 'afternoon';
    } else {
      _timeOfDay = 'evening';
    }
    notifyListeners();
  }

  /// Check if a check-in already exists for the selected date and time
  Future<void> checkExistingCheckin() async {
    try {
      _isLoading = true;
      notifyListeners();
      _existingCheckin = await _repository.fetchCheckinByDateAndTime(
        _selectedDate,
        _timeOfDay,
      );
      if (_existingCheckin != null) {
        // Load existing data
        _mood = _existingCheckin!.mood;
        _emotions = List.from(_existingCheckin!.emotions);
        _notes = _existingCheckin!.notes ?? '';
      }
    } catch (e) {
      AppLog.e('Error checking existing check-in: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save the current check-in
  Future<void> saveCheckin(BuildContext context) async {
    // Block if check-in already exists
    if (_existingCheckin != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'A check-in already exists for this time. Please choose a different time or date.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
      }
      return;
    }
    try {
      _isSaving = true;
      notifyListeners();
      final checkin = DailyCheckin(
        id: null,
        userId: '', // Will be set by the service
        checkinDate: _selectedDate,
        mood: _mood,
        emotions: _emotions,
        timeOfDay: _timeOfDay,
        notes: _notes.isEmpty ? null : _notes,
      );
      // Create new check-in only
      await _repository.saveCheckin(checkin);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check-in saved successfully!')),
        );
      }
      // Refresh recent check-ins
      await loadRecentCheckins();
      // Reload to check existing again
      await checkExistingCheckin();
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving check-in: $e')));
      }
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Load recent check-ins (last 7 days)
  Future<void> loadRecentCheckins() async {
    try {
      _isLoading = true;
      notifyListeners();
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 7));
      _recentCheckins = await _repository.fetchCheckinsInRange(
        startDate,
        endDate,
      );
    } catch (e) {
      AppLog.e('Error loading recent check-ins: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load check-ins for a specific date
  Future<List<DailyCheckin>> loadCheckinsForDate(DateTime date) async {
    try {
      return await _repository.fetchCheckinsByDate(date);
    } catch (e) {
      AppLog.e('Error loading check-ins for date: $e');
      return [];
    }
  }

  /// Reset the form to default values
  void reset() {
    _mood = 'Neutral';
    _emotions = [];
    _timeOfDay = _getDefaultTimeOfDay();
    _notes = '';
    _selectedDate = DateTime.now();
    _existingCheckin = null;
    notifyListeners();
  }

  /// Get default time of day based on current time
  String _getDefaultTimeOfDay() {
    final hour = TimeOfDay.now().hour;
    if (hour < 12) {
      return 'morning';
    } else if (hour < 17) {
      return 'afternoon';
    } else {
      return 'evening';
    }
  }

  /// Initialize provider with default time of day
  void initialize() {
    _timeOfDay = _getDefaultTimeOfDay();
    _selectedTime = TimeOfDay.now();
    notifyListeners();
  }
}
