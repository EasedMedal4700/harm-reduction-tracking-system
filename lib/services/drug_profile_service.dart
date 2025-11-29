import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/error_handler.dart';
import 'cache_service.dart';

/// Result of a drug name search with normalization info
class DrugSearchResult {
  final String displayName;
  final String canonicalName;
  final bool isAlias;

  DrugSearchResult({
    required this.displayName,
    required this.canonicalName,
    required this.isAlias,
  });
}

/// Service for searching and fetching drug profiles
class DrugProfileService {
  final _cache = CacheService();
  
  /// Search drug profiles by name and aliases
  Future<List<DrugSearchResult>> searchDrugNamesWithAliases(String query) async {
    if (query.isEmpty) return [];
    
    // Check cache first (short TTL for search results)
    final cacheKey = 'drug_search:$query';
    final cached = _cache.get<List<DrugSearchResult>>(cacheKey);
    if (cached != null) {
      ErrorHandler.logDebug('DrugProfileService', 'Cache hit for: $query');
      return cached;
    }
    
    try {
      ErrorHandler.logDebug('DrugProfileService', 'Searching for: $query');
      
      // Get all drug profiles and filter client-side for aliases
      // We need to fetch more rows to check aliases in the JSONB array
      final profileResponse = await Supabase.instance.client
          .from('drug_profiles')
          .select('name, pretty_name, aliases')
          .or('name.ilike.%$query%,pretty_name.ilike.%$query%')
          .limit(50); // Fetch more to check aliases
      
      final profileResults = profileResponse as List<dynamic>;
      final results = <DrugSearchResult>[];
      final seenCanonical = <String>{};
      
      // First pass: Add direct name/pretty_name matches
      for (final item in profileResults) {
        final name = item['name'] as String?;
        final prettyName = item['pretty_name'] as String?;
        final canonicalName = prettyName ?? name ?? '';
        
        if (canonicalName.isNotEmpty && !seenCanonical.contains(canonicalName.toLowerCase())) {
          results.add(DrugSearchResult(
            displayName: canonicalName,
            canonicalName: canonicalName,
            isAlias: false,
          ));
          seenCanonical.add(canonicalName.toLowerCase());
        }
      }
      
      // Second pass: Check all profiles for matching aliases
      // Fetch ALL profiles to search aliases (since we can't query JSONB array easily)
      final allProfilesResponse = await Supabase.instance.client
          .from('drug_profiles')
          .select('name, pretty_name, aliases')
          .limit(1000);
      
      final allProfiles = allProfilesResponse as List<dynamic>;
      for (final item in allProfiles) {
        final name = item['name'] as String?;
        final prettyName = item['pretty_name'] as String?;
        final aliases = item['aliases'] as List<dynamic>?;
        final canonicalName = prettyName ?? name ?? '';
        
        if (canonicalName.isNotEmpty && aliases != null) {
          for (final alias in aliases) {
            if (alias is String && alias.toLowerCase().contains(query.toLowerCase())) {
              // Don't add duplicate canonical names
              if (!seenCanonical.contains(canonicalName.toLowerCase())) {
                results.add(DrugSearchResult(
                  displayName: '$alias → $canonicalName',
                  canonicalName: canonicalName,
                  isAlias: true,
                ));
                seenCanonical.add(canonicalName.toLowerCase());
              }
            }
          }
        }
      }
      
      ErrorHandler.logInfo('DrugProfileService', 'Found ${results.length} results');
      
      // Cache the results with short TTL (search results change frequently)
      _cache.set(cacheKey, results, ttl: CacheService.shortTTL);
      
      return results.take(10).toList(); // Limit final results
    } catch (e, stackTrace) {
      // Silently handle AssertionError when Supabase is not initialized (e.g., in tests)
      if (e is AssertionError && e.toString().contains('_isInitialized')) {
        return [];
      }
      ErrorHandler.logError('DrugProfileService.searchDrugNamesWithAliases', e, stackTrace);
      return [];
    }
  }
  
  /// Search drug profiles by name (legacy method for simple string results)
  Future<List<String>> searchDrugNames(String query) async {
    final results = await searchDrugNamesWithAliases(query);
    return results.map((r) => r.displayName).toList();
  }
  
  /// Get all drug names (for initial suggestions)
  Future<List<String>> getAllDrugNames() async {
    // Check cache first (long TTL since drug names don't change often)
    final cached = _cache.get<List<String>>(CacheKeys.allDrugNames);
    if (cached != null) {
      ErrorHandler.logDebug('DrugProfileService', 'Cache hit for all drug names');
      return cached;
    }
    
    try {
      final response = await Supabase.instance.client
          .from('drug_profiles')
          .select('name, pretty_name')
          .order('pretty_name')
          .limit(100);
      
      final results = response as List<dynamic>;
      final names = <String>{};
      
      for (final item in results) {
        final name = item['name'] as String?;
        final prettyName = item['pretty_name'] as String?;
        
        if (prettyName != null && prettyName.isNotEmpty) {
          names.add(prettyName);
        } else if (name != null && name.isNotEmpty) {
          names.add(name);
        }
      }
      
      final sortedNames = names.toList()..sort();
      
      // Cache with long TTL (drug names don't change often)
      _cache.set(CacheKeys.allDrugNames, sortedNames, ttl: CacheService.longTTL);
      
      return sortedNames;
    } catch (e, stackTrace) {
      // Silently handle AssertionError when Supabase is not initialized (e.g., in tests)
      if (e is AssertionError && e.toString().contains('_isInitialized')) {
        return [];
      }
      ErrorHandler.logError('DrugProfileService.getAllDrugNames', e, stackTrace);
      return [];
    }
  }
}
