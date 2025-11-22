import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/time_period.dart';
import '../models/log_entry_model.dart';
import '../repo/substance_repository.dart';
import '../services/user_service.dart';
import '../utils/error_handler.dart';

class AnalyticsService {
  Map<String, String> substanceToCategory = {};

  Future<List<LogEntry>> fetchEntries() async {
    try {
      final supabase = Supabase.instance.client;
      final intUserId = await UserService.getIntegerUserId();
      final response = await supabase
          .from('drug_use')
          .select(
            'name, dose, consumption, medical, place, craving_0_10, primary_emotions, secondary_emotions, body_signals, triggers, people, start_time',
          )
          .eq('user_id', intUserId);
      final data = response as List<dynamic>;
      return data.map((json) {
        try {
          return LogEntry.fromJson(json);
        } catch (e, stackTrace) {
          ErrorHandler.logError(
            'AnalyticsService.parseLogEntry',
            e,
            stackTrace,
          );
          return null;
        }
      }).where((entry) => entry != null).cast<LogEntry>().toList();
    } catch (e, stackTrace) {
      ErrorHandler.logError('AnalyticsService.fetchEntries', e, stackTrace);
      rethrow;
    }
  }

  double calculateAvgPerWeek(List<LogEntry> entries) {
    if (entries.isEmpty) return 0.0;
    final dates = entries.map((e) => e.datetime).toList();
    dates.sort();
    final start = dates.first;
    final end = dates.last;
    final daysDiff = end.difference(start).inDays;
    final weeks = daysDiff > 0 ? daysDiff / 7.0 : 1.0;
    return entries.length / weeks;
  }

  Future<List<Map<String, dynamic>>> fetchSubstancesCatalog() async {
    try {
      final repository = SubstanceRepository();
      return await repository.fetchSubstancesCatalog();
    } catch (e, stackTrace) {
      ErrorHandler.logError('AnalyticsService.fetchSubstancesCatalog', e, stackTrace);
      rethrow;
    }
  }

  // Updated to use the DB-fetched map
  Map<String, int> getCategoryCounts(List<LogEntry> entries) {
    final counts = <String, int>{};
    for (final entry in entries) {
      final category = substanceToCategory[entry.substance.toLowerCase()] ?? 'Placeholder'; // Use lowercase lookup
      counts[category] = (counts[category] ?? 0) + 1;
    }
    return counts;
  }

  MapEntry<String, int> getMostUsedCategory(Map<String, int> counts) {
    if (counts.isEmpty) return const MapEntry('None', 0);
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b);
  }

  void setSubstanceToCategory(Map<String, String> map) { // Add this method
    substanceToCategory = map;
  }

  List<LogEntry> filterEntriesByPeriod(List<LogEntry> entries, TimePeriod period) {
    final now = DateTime.now();
    switch (period) {
      case TimePeriod.last7Days:
        return entries.where((e) => e.datetime.isAfter(now.subtract(const Duration(days: 7)))).toList();
      case TimePeriod.last7Weeks:
        return entries.where((e) => e.datetime.isAfter(now.subtract(const Duration(days: 49)))).toList();
      case TimePeriod.last7Months:
        return entries.where((e) => e.datetime.isAfter(now.subtract(const Duration(days: 210)))).toList();
      case TimePeriod.all:
      default:
        return entries;
    }
  }

  Map<String, int> getSubstanceCounts(List<LogEntry> entries) {
    final counts = <String, int>{};
    for (final entry in entries) {
      counts[entry.substance] = (counts[entry.substance] ?? 0) + 1;
    }
    return counts;
  }

  MapEntry<String, int> getMostUsedSubstance(Map<String, int> substanceCounts) {
    if (substanceCounts.isEmpty) return MapEntry<String, int>('', 0);
    return substanceCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
  }

  int getTopCategoryPercent(int mostUsedCount, int totalEntries) {
    return totalEntries > 0 ? (mostUsedCount / totalEntries * 100).round() : 0;
  }

  /// Compute weekly usage for a substance (returns counts for Mon-Sun)
  Map<String, int> computeWeeklyUse(List<LogEntry> entries, String substanceName) {
    final weekdays = {
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0,
      'Sunday': 0,
    };

    // Filter entries for this substance
    final substanceEntries = entries.where(
      (e) => e.substance.toLowerCase() == substanceName.toLowerCase(),
    ).toList();

    // Count by weekday
    for (final entry in substanceEntries) {
      final weekday = _getWeekdayName(entry.datetime.weekday);
      weekdays[weekday] = (weekdays[weekday] ?? 0) + 1;
    }

    return weekdays;
  }

  /// Get the day with most activity for a substance
  String getMostActiveDay(List<LogEntry> entries, String substanceName) {
    final weeklyUse = computeWeeklyUse(entries, substanceName);
    if (weeklyUse.values.every((count) => count == 0)) {
      return 'None';
    }

    final maxEntry = weeklyUse.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return maxEntry.value > 0 ? maxEntry.key : 'None';
  }

  /// Get the day with least activity for a substance (excluding zero days)
  String getLeastActiveDay(List<LogEntry> entries, String substanceName) {
    final weeklyUse = computeWeeklyUse(entries, substanceName);
    
    // Filter out days with zero activity
    final nonZeroDays = weeklyUse.entries.where((e) => e.value > 0).toList();
    
    if (nonZeroDays.isEmpty) {
      return 'None';
    }

    final minEntry = nonZeroDays.reduce(
      (a, b) => a.value < b.value ? a : b,
    );

    return minEntry.key;
  }

  /// Helper to convert weekday number to name
  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }
}
