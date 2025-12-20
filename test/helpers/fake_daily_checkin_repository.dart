import 'package:mobile_drug_use_app/models/daily_checkin_model.dart';
import 'package:mobile_drug_use_app/services/daily_checkin_service.dart';

/// A lightweight in-memory implementation that avoids touching Supabase during widget tests.
class FakeDailyCheckinRepository implements DailyCheckinRepository {
  DailyCheckin? existingCheckin;
  final List<DailyCheckin> _checkins = [];

  @override
  Future<void> deleteCheckin(String id) async {
    _checkins.removeWhere((checkin) => checkin.id == id);
  }

  @override
  Future<DailyCheckin?> fetchCheckinByDateAndTime(
    DateTime date,
    String timeOfDay,
  ) async {
    return existingCheckin;
  }

  @override
  Future<List<DailyCheckin>> fetchCheckinsByDate(DateTime date) async {
    return List.unmodifiable(_checkins);
  }

  @override
  Future<List<DailyCheckin>> fetchCheckinsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return List.unmodifiable(_checkins);
  }

  @override
  Future<void> saveCheckin(DailyCheckin checkin) async {
    _checkins.add(checkin);
    existingCheckin = checkin;
  }

  @override
  Future<void> updateCheckin(String id, DailyCheckin checkin) async {
    final index = _checkins.indexWhere((current) => current.id == id);
    if (index != -1) {
      _checkins[index] = checkin;
    }
    existingCheckin = checkin;
  }
}
