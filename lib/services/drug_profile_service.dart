import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/error_handler.dart';

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
  /// Search drug profiles by name and aliases
  Future<List<DrugSearchResult>> searchDrugNamesWithAliases(String query) async {
    if (query.isEmpty) return [];
    
    try {
      ErrorHandler.logDebug('DrugProfileService', 'Searching for: $query');
      
      // Search in drug_profiles (name, pretty_name, and aliases JSONB array)
      final profileResponse = await Supabase.instance.client
          .from('drug_profiles')
          .select('name, pretty_name, aliases')
          .or('name.ilike.%$query%,pretty_name.ilike.%$query%')
          .limit(10);
      
      final profileResults = profileResponse as List<dynamic>;
      final results = <DrugSearchResult>[];
      
      // Add direct name/pretty_name matches
      for (final item in profileResults) {
        final name = item['name'] as String?;
        final prettyName = item['pretty_name'] as String?;
        final aliases = item['aliases'] as List<dynamic>?;
        
        final canonicalName = prettyName ?? name ?? '';
        if (canonicalName.isNotEmpty) {
          results.add(DrugSearchResult(
            displayName: canonicalName,
            canonicalName: canonicalName,
            isAlias: false,
          ));
          
          // Check if any aliases match the query
          if (aliases != null) {
            for (final alias in aliases) {
              if (alias is String && alias.toLowerCase().contains(query.toLowerCase())) {
                results.add(DrugSearchResult(
                  displayName: '$alias (alias for $canonicalName)',
                  canonicalName: canonicalName,
                  isAlias: true,
                ));
              }
            }
          }
        }
      }
      
      // Search in drug_alias_lookup table
      final aliasResponse = await Supabase.instance.client
          .from('drug_alias_lookup')
          .select('alias, canonical_name')
          .ilike('alias', '%$query%')
          .limit(10);
      
      final aliasResults = aliasResponse as List<dynamic>;
      for (final item in aliasResults) {
        final alias = item['alias'] as String?;
        final canonical = item['canonical_name'] as String?;
        
        if (alias != null && canonical != null) {
          results.add(DrugSearchResult(
            displayName: '$alias (alias for $canonical)',
            canonicalName: canonical,
            isAlias: true,
          ));
        }
      }
      
      ErrorHandler.logInfo('DrugProfileService', 'Found ${results.length} results');
      return results;
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
      
      return names.toList()..sort();
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
