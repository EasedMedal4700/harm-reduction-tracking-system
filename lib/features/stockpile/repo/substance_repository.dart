// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Repository.
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert'; // For JSON parsing
import '../../../common/logging/app_log.dart';

class SubstanceRepository {
  SupabaseClient get _client => Supabase.instance.client;
  Future<List<Map<String, dynamic>>> fetchSubstancesCatalog() async {
    final response = await _client
        .from('drug_profiles')
        .select(
          'name, pretty_name, categories, aliases, formatted_dose, formatted_duration, formatted_onset, formatted_aftereffects, properties',
        );
    final data = (response as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    // Parse JSON fields
    return data.map((item) {
      return {
        'name': item['name'] ?? '',
        'pretty_name': item['pretty_name'] ?? item['name'] ?? '',
        'categories': item['categories'] is List
            ? item['categories']
            : json.decode(item['categories'] ?? '[]'),
        'aliases': item['aliases'] is List
            ? item['aliases']
            : json.decode(item['aliases'] ?? '[]'),
        'formatted_dose': item['formatted_dose'],
        'formatted_duration': item['formatted_duration'],
        'formatted_onset': item['formatted_onset'],
        'formatted_aftereffects': item['formatted_aftereffects'],
        'properties': item['properties'],
        'description':
            item['properties'] != null && item['properties']['summary'] != null
            ? item['properties']['summary']
            : 'No description available.',
        'is_common':
            item['is_user_created'] == 0, // Add this: true if not user-created
      };
    }).toList();
  }

  /// Fetch substance details including formatted_dose for ROA validation
  /// Returns null if substance doesn't exist in DB
  Future<Map<String, dynamic>?> getSubstanceDetails(
    String substanceName,
  ) async {
    try {
      final input = substanceName.trim();
      if (input.isEmpty) return null;

      // Try to include category metadata when available. Some older schemas may
      // not expose these columns, so we fall back gracefully.
      const selectAttempts = <String>[
        'name, pretty_name, formatted_dose, aliases, categories, category',
        'name, pretty_name, formatted_dose, aliases, categories',
        'name, pretty_name, formatted_dose, aliases, category',
        'name, pretty_name, formatted_dose, aliases',
      ];

      Future<Map<String, dynamic>?> _maybeSingleWithSelect(
        String select,
      ) async {
        final response = await _client
            .from('drug_profiles')
            .select(select)
            .or('name.ilike.$input,pretty_name.ilike.$input')
            .maybeSingle();
        if (response != null) return response;
        return await _client.from('drug_profiles').select(select).contains(
          'aliases',
          [input],
        ).maybeSingle();
      }

      // Prefer exact-ish matches by canonical name or pretty name.
      // PostgREST `ilike` is case-insensitive pattern match; without wildcards
      // this behaves like case-insensitive equality.
      Map<String, dynamic>? aliasResponse;
      for (final select in selectAttempts) {
        try {
          aliasResponse = await _maybeSingleWithSelect(select);
          if (aliasResponse != null) break;
        } catch (_) {
          // Try next select shape.
        }
      }

      if (aliasResponse == null) return null;

      final categories = aliasResponse['categories'] is List
          ? aliasResponse['categories']
          : (aliasResponse['categories'] == null
                ? null
                : json.decode(aliasResponse['categories'] ?? '[]'));

      return {
        'name': aliasResponse['name'] ?? '',
        'pretty_name':
            aliasResponse['pretty_name'] ?? aliasResponse['name'] ?? '',
        'aliases': aliasResponse['aliases'] is List
            ? aliasResponse['aliases']
            : json.decode(aliasResponse['aliases'] ?? '[]'),
        'categories': categories,
        'category': aliasResponse['category'],
        'formatted_dose': aliasResponse['formatted_dose'] != null
            ? (aliasResponse['formatted_dose'] is Map
                  ? aliasResponse['formatted_dose']
                  : json.decode(aliasResponse['formatted_dose']))
            : {},
      };
    } catch (e) {
      AppLog.e('Error fetching substance details: $e');
      return null;
    }
  }

  /// Extract available ROAs from formatted_dose field
  /// Returns list of available routes (lowercase) or empty list if none found
  List<String> getAvailableROAs(Map<String, dynamic>? substanceDetails) {
    if (substanceDetails == null) return [];
    final formattedDoseRaw = substanceDetails['formatted_dose'];
    if (formattedDoseRaw == null) return [];
    // Handle both Map<dynamic, dynamic> and Map<String, dynamic>
    final Map<String, dynamic> formattedDose;
    if (formattedDoseRaw is Map<String, dynamic>) {
      formattedDose = formattedDoseRaw;
    } else if (formattedDoseRaw is Map) {
      formattedDose = Map<String, dynamic>.from(formattedDoseRaw);
    } else {
      return [];
    }
    if (formattedDose.isEmpty) return [];
    // Extract ROA keys and convert to lowercase (Oral -> oral, Insufflated -> insufflated, etc.)
    return formattedDose.keys
        .map((key) => key.toString().toLowerCase())
        .toList();
  }

  /// Check if a specific ROA is valid for a substance
  bool isROAValid(String roa, Map<String, dynamic>? substanceDetails) {
    final availableROAs = getAvailableROAs(substanceDetails);
    return availableROAs.contains(roa.toLowerCase());
  }
}
