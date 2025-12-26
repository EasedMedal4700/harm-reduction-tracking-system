// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Service for drug profile search and normalization.
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/error_handler.dart';
import '../../../services/cache_service.dart';
import 'dart:math';

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

/// Central service for drug profile lookup and alias normalization.
/// Fully Riverpod-independent. UI-independent.
class DrugProfileService {
  final _cache = CacheService();
  final _client = Supabase.instance.client;
  // ---------------------------------------------------------------------------
  // ⭐ HIGH-ACCURACY FUZZY SEARCH (RECOMMENDED)
  // ---------------------------------------------------------------------------
  Future<List<DrugSearchResult>> searchDrugNamesWithAliases(
    String query,
  ) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final cacheKey = 'drug_search_fuzzy:$q';
    final cached = _cache.get<List<DrugSearchResult>>(cacheKey);
    if (cached != null) return cached;
    try {
      final client = Supabase.instance.client;
      // 1) Load all profiles
      final allRows = await client
          .from('drug_profiles')
          .select('name, pretty_name, aliases')
          .limit(2000);
      final rows = allRows as List<dynamic>;
      final List<_ScoredResult> scored = [];
      // 2) Score canonical & aliases
      for (final row in rows) {
        final name = row['name'] as String?;
        final pretty = row['pretty_name'] as String?;
        final aliases = (row['aliases'] ?? []) as List<dynamic>;
        final canonical = (pretty ?? name ?? '').trim();
        if (canonical.isEmpty) continue;
        // canonical scoring
        final canonicalScore = _scoreFuzzyMatch(q, canonical.toLowerCase());
        if (canonicalScore > 0) {
          scored.add(
            _ScoredResult(
              DrugSearchResult(
                displayName: canonical,
                canonicalName: canonical,
                isAlias: false,
              ),
              canonicalScore,
            ),
          );
        }
        // alias scoring
        for (final alias in aliases) {
          if (alias is! String) continue;
          final aliasLower = alias.toLowerCase();
          final aliasScore = _scoreFuzzyMatch(q, aliasLower);
          if (aliasScore > 0) {
            scored.add(
              _ScoredResult(
                DrugSearchResult(
                  displayName: '$alias → $canonical',
                  canonicalName: canonical,
                  isAlias: true,
                ),
                aliasScore + 0.5, // alias boost
              ),
            );
          }
        }
      }
      // 3) Sort by score
      scored.sort((a, b) => b.score.compareTo(a.score));
      // 4) Deduplicate by canonical name
      final seen = <String>{};
      final List<DrugSearchResult> finalResults = [];
      for (final item in scored) {
        final key = item.result.canonicalName.toLowerCase();
        if (!seen.contains(key)) {
          seen.add(key);
          finalResults.add(item.result);
        }
      }
      final limited = finalResults.take(25).toList();
      _cache.set(cacheKey, limited, ttl: CacheService.shortTTL);
      return limited;
    } catch (e, stack) {
      ErrorHandler.logError('DrugProfileService.fuzzySearch', e, stack);
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // LEGACY SEARCH (still useful occasionally)
  // ---------------------------------------------------------------------------
  Future<List<String>> searchDrugNames(String query) async {
    final results = await searchDrugNamesWithAliases(query);
    return results.map((r) => r.displayName).toList();
  }

  // ---------------------------------------------------------------------------
  // LOAD ALL DRUG NAMES FOR AUTOCOMPLETE
  // ---------------------------------------------------------------------------
  Future<List<String>> getAllDrugNames() async {
    final cached = _cache.get<List<String>>(CacheKeys.allDrugNames);
    if (cached != null) return cached;
    try {
      final response = await _client
          .from('drug_profiles')
          .select('name, pretty_name')
          .order('pretty_name')
          .limit(500);
      final rows = response as List<dynamic>;
      final names = <String>{};
      for (final row in rows) {
        final pretty = row['pretty_name'] as String?;
        final name = row['name'] as String?;
        final chosen = pretty ?? name;
        if (chosen != null && chosen.trim().isNotEmpty) {
          names.add(chosen.trim());
        }
      }
      final sorted = names.toList()..sort();
      _cache.set(CacheKeys.allDrugNames, sorted, ttl: CacheService.longTTL);
      return sorted;
    } catch (e, stack) {
      ErrorHandler.logError('DrugProfileService.getAllDrugNames', e, stack);
      return [];
    }
  }
}

// ---------------------------------------------------------------------------
// ⭐ INTERNAL FUZZY MATCHING UTILITIES
// ---------------------------------------------------------------------------
class _ScoredResult {
  final DrugSearchResult result;
  final double score;
  _ScoredResult(this.result, this.score);
}

double _scoreFuzzyMatch(String query, String text) {
  if (text.startsWith(query)) return 5.0;
  if (text.contains(query)) return 3.5;
  final dist = _damerauLevenshtein(query, text);
  final maxLen = max(query.length, text.length);
  final similarity = 1 - (dist / maxLen);
  if (similarity < 0.45) return 0;
  return similarity * 3.0;
}

int _damerauLevenshtein(String a, String b) {
  final m = a.length;
  final n = b.length;
  if (m == 0) return n;
  if (n == 0) return m;
  final matrix = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
  for (var i = 0; i <= m; i++) {
    matrix[i][0] = i;
  }
  for (var j = 0; j <= n; j++) {
    matrix[0][j] = j;
  }
  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      matrix[i][j] = min(
        min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1),
        matrix[i - 1][j - 1] + cost,
      );
      if (i > 1 && j > 1 && a[i - 1] == b[j - 2] && a[i - 2] == b[j - 1]) {
        matrix[i][j] = min(matrix[i][j], matrix[i - 2][j - 2] + cost);
      }
    }
  }
  return matrix[m][n];
}
