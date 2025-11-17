import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/drug_catalog_entry.dart';
import '../utils/error_handler.dart';
import '../utils/drug_stats_calculator.dart';
import '../utils/drug_preferences_manager.dart';
import '../utils/drug_data_parser.dart';

class PersonalLibraryService {
  Future<List<DrugCatalogEntry>> fetchCatalog() async {
    try {
      ErrorHandler.logDebug('PersonalLibraryService', 'Fetching drug catalog');

      final profiles = await _loadDrugProfiles();
      final entries = await _loadDatabaseEntries();
      final prefs = await SharedPreferences.getInstance();

      final Map<String, List<Map<String, dynamic>>> grouped = {};
      for (final entry in entries) {
        final name = (entry['name'] as String?)?.trim();
        if (name == null || name.isEmpty) continue;
        grouped.putIfAbsent(name, () => []).add(entry);
      }

    final List<DrugCatalogEntry> catalog = [];
    grouped.forEach((name, entryList) {
      final normalized = DrugDataParser.normalizeName(name);
      final categories = profiles[normalized] ?? const ['Unknown'];
      final latest = DrugStatsCalculator.findLatestUsage(entryList);
      final weekdayData = DrugStatsCalculator.calculateWeekdayUsage(entryList);
      final weekday = WeekdayUsage(
        counts: weekdayData['counts'],
        mostActive: weekdayData['mostActive'],
        leastActive: weekdayData['leastActive'],
      );
      final local = DrugPreferencesManager.readPreferences(prefs, name);

      catalog.add(
        DrugCatalogEntry(
          name: name,
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

      ErrorHandler.logInfo('PersonalLibraryService', 'Loaded ${catalog.length} drug entries');
      return catalog;
    } catch (e, stackTrace) {
      ErrorHandler.logError('PersonalLibraryService.fetchCatalog', e, stackTrace);
      rethrow;
    }
  }

  Future<bool> toggleFavorite(DrugCatalogEntry entry) async {
    try {
      ErrorHandler.logDebug('PersonalLibraryService', 'Toggling favorite for ${entry.name}');

      final updatedFavorite = !entry.favorite;
      final currentPrefs = LocalPrefs(
        favorite: entry.favorite,
        archived: entry.archived,
        notes: entry.notes,
        quantity: entry.quantity,
      );
      
      await DrugPreferencesManager.saveFavorite(
        entry.name,
        updatedFavorite,
        currentPrefs,
      );

      ErrorHandler.logInfo('PersonalLibraryService', 'Favorite toggled for ${entry.name}: $updatedFavorite');
      return updatedFavorite;
    } catch (e, stackTrace) {
      ErrorHandler.logError('PersonalLibraryService.toggleFavorite', e, stackTrace);
      rethrow;
    }
  }

  List<DrugCatalogEntry> applySearch(String query, List<DrugCatalogEntry> data) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return List<DrugCatalogEntry>.from(data);
    }
    return data.where((entry) {
      final name = entry.name.toLowerCase();
      final cats = entry.categories.join(' ').toLowerCase();
      return name.contains(trimmed) || cats.contains(trimmed);
    }).toList();
  }

  Future<Map<String, List<String>>> _loadDrugProfiles() async {
    final Map<String, List<String>> profiles = {};
    try {
      final response = await Supabase.instance.client
          .from('drug_profiles')
          .select('name, categories');
      
      for (final row in (response as List<dynamic>)) {
        final data = row as Map<String, dynamic>;
        final name = (data['name'] as String?)?.trim();
        if (name == null || name.isEmpty) continue;
        profiles[DrugDataParser.normalizeName(name)] = 
            DrugDataParser.parseCategories(data['categories']);
      }
      
      if (profiles.isNotEmpty) {
        return profiles;
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError('PersonalLibraryService._loadDrugProfiles', e, stackTrace);
    }
    
    return {
      'methylphenidate': ['Stimulant'],
      'cannabis': ['Cannabinoid'],
    };
  }

  Future<List<Map<String, dynamic>>> _loadDatabaseEntries() async {
    // RLS (Row Level Security) automatically filters by authenticated user
    try {
      final response = await Supabase.instance.client
          .from('drug_use')
          .select('name, start_time, dose')
          .order('start_time', ascending: false);
      
      return (response as List<dynamic>)
          .map((item) => Map<String, dynamic>.from(item as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      ErrorHandler.logError('PersonalLibraryService._loadDatabaseEntries', e, stackTrace);
      rethrow;
    }
  }
}
