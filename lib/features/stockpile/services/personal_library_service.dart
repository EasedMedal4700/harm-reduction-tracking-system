// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Service for personal library management.
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/drug_catalog_entry.dart';
import '../../../services/user_service.dart';
import '../../../utils/drug_data_parser.dart';
import '../../../utils/drug_preferences_manager.dart';
import '../../analytics/utils/drug_stats_calculator.dart';
import '../../../utils/error_handler.dart';

abstract class PersonalLibraryApi {
  Future<List<Map<String, dynamic>>> fetchDrugProfiles();

  Future<List<Map<String, dynamic>>> fetchDrugUseRows({required String userId});
}

class SupabasePersonalLibraryApi implements PersonalLibraryApi {
  SupabasePersonalLibraryApi(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Map<String, dynamic>>> fetchDrugProfiles() async {
    final response = await _client
        .from('drug_profiles')
        .select('name, categories');
    return (response as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String userId,
  }) async {
    final response = await _client
        .from('drug_use')
        .select('name, start_time, dose')
        .eq('uuid_user_id', userId)
        .order('start_time', ascending: false);

    return (response as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
        .toList();
  }
}

class PersonalLibraryService {
  PersonalLibraryService({
    PersonalLibraryApi? api,
    Future<SharedPreferences> Function()? prefsFactory,
    String Function()? userIdGetter,
    Future<void> Function(String, bool, LocalPrefs)? saveFavorite,
    Future<void> Function(String, bool, LocalPrefs)? saveArchived,
  }) : _api = api ?? SupabasePersonalLibraryApi(Supabase.instance.client),
       _prefsFactory = prefsFactory ?? SharedPreferences.getInstance,
       _userIdGetter = userIdGetter ?? UserService.getCurrentUserId,
       _saveFavorite = saveFavorite ?? DrugPreferencesManager.saveFavorite,
       _saveArchived = saveArchived ?? DrugPreferencesManager.saveArchived;

  final PersonalLibraryApi _api;
  final Future<SharedPreferences> Function() _prefsFactory;
  final String Function() _userIdGetter;
  final Future<void> Function(String, bool, LocalPrefs) _saveFavorite;
  final Future<void> Function(String, bool, LocalPrefs) _saveArchived;

  Future<List<DrugCatalogEntry>> fetchCatalog() async {
    try {
      ErrorHandler.logDebug('PersonalLibraryService', 'Fetching drug catalog');

      final profiles = await _loadDrugProfiles();
      final userId = _userIdGetter();
      final entries = await _loadDatabaseEntries(userId: userId);
      final prefs = await _prefsFactory();

      final Map<String, List<Map<String, dynamic>>> grouped = {};
      for (final entry in entries) {
        final name = (entry['name'] as String?)?.trim();
        if (name == null || name.isEmpty) continue;

        grouped
            .putIfAbsent(DrugDataParser.normalizeName(name), () => [])
            .add(entry);
      }

      final List<DrugCatalogEntry> catalog = [];

      grouped.forEach((normalizedName, entryList) {
        final categories = profiles[normalizedName] ?? const ['Unknown'];
        final latest = DrugStatsCalculator.findLatestUsage(entryList);
        final weekdayData = DrugStatsCalculator.calculateWeekdayUsage(
          entryList,
        );
        final weekday = WeekdayUsage(
          counts: weekdayData['counts'],
          mostActive: weekdayData['mostActive'],
          leastActive: weekdayData['leastActive'],
        );

        final rawName = entryList.first['name'] as String;
        final displayName = DrugDataParser.toTitleCase(rawName);
        final local = DrugPreferencesManager.readPreferences(
          prefs,
          displayName,
        );

        catalog.add(
          DrugCatalogEntry(
            name: displayName,
            categories: categories,
            totalUses: entryList.length,
            avgDose: DrugStatsCalculator.calculateAverageDose(entryList),
            lastUsed: latest,
            weekdayUsage: weekday,
            favorite: local.favorite,
            archived: local.archived,
            notes: local.notes,
            quantity: local.quantity,
          ),
        );
      });

      catalog.sort(
        (a, b) => (b.lastUsed ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.lastUsed ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );

      ErrorHandler.logInfo(
        'PersonalLibraryService',
        'Loaded ${catalog.length} drug entries',
      );
      return catalog;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'PersonalLibraryService.fetchCatalog',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> toggleFavorite(DrugCatalogEntry entry) async {
    try {
      final updatedFavorite = !entry.favorite;
      final currentPrefs = LocalPrefs(
        favorite: entry.favorite,
        archived: entry.archived,
        notes: entry.notes,
        quantity: entry.quantity,
      );

      await _saveFavorite(entry.name, updatedFavorite, currentPrefs);
      return updatedFavorite;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'PersonalLibraryService.toggleFavorite',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> toggleArchive(DrugCatalogEntry entry) async {
    try {
      final updatedArchived = !entry.archived;
      final currentPrefs = LocalPrefs(
        favorite: entry.favorite,
        archived: entry.archived,
        notes: entry.notes,
        quantity: entry.quantity,
      );

      await _saveArchived(entry.name, updatedArchived, currentPrefs);
      return updatedArchived;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'PersonalLibraryService.toggleArchive',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  List<DrugCatalogEntry> applySearch(
    String query,
    List<DrugCatalogEntry> data,
  ) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return List<DrugCatalogEntry>.from(data);

    return data.where((entry) {
      final name = entry.name.toLowerCase();
      final cats = entry.categories.join(' ').toLowerCase();
      return name.contains(trimmed) || cats.contains(trimmed);
    }).toList();
  }

  Future<Map<String, List<String>>> _loadDrugProfiles() async {
    final Map<String, List<String>> profiles = {};

    try {
      final rows = await _api.fetchDrugProfiles();
      for (final row in rows) {
        final name = (row['name'] as String?)?.trim();
        if (name == null || name.isEmpty) continue;

        profiles[DrugDataParser.normalizeName(name)] =
            DrugDataParser.parseCategories(row['categories']);
      }

      if (profiles.isNotEmpty) return profiles;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'PersonalLibraryService._loadDrugProfiles',
        e,
        stackTrace,
      );
    }

    return {
      'methylphenidate': ['Stimulant'],
      'cannabis': ['Cannabinoid'],
    };
  }

  Future<List<Map<String, dynamic>>> _loadDatabaseEntries({
    required String userId,
  }) async {
    try {
      return await _api.fetchDrugUseRows(userId: userId);
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'PersonalLibraryService._loadDatabaseEntries',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
