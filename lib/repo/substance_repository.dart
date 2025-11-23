import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert'; // For JSON parsing

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
      final response = await _client
          .from('drug_profiles')
          .select('name, pretty_name, formatted_dose')
          .eq('name', substanceName)
          .maybeSingle();

      if (response == null) return null;

      return {
        'name': response['name'] ?? '',
        'pretty_name': response['pretty_name'] ?? response['name'] ?? '',
        'formatted_dose': response['formatted_dose'] != null
            ? (response['formatted_dose'] is Map
                  ? response['formatted_dose']
                  : json.decode(response['formatted_dose']))
            : {},
      };
    } catch (e) {
      print('Error fetching substance details: $e');
      return null;
    }
  }

  /// Extract available ROAs from formatted_dose field
  /// Returns list of available routes (lowercase) or empty list if none found
  List<String> getAvailableROAs(Map<String, dynamic>? substanceDetails) {
    if (substanceDetails == null) return [];

    final formattedDose =
        substanceDetails['formatted_dose'] as Map<String, dynamic>?;
    if (formattedDose == null || formattedDose.isEmpty) return [];

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
