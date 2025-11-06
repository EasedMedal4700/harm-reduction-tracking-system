import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert'; // For JSON parsing

class SubstanceRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchSubstancesCatalog() async {
    final response = await _client.from('drug_profiles').select('name, pretty_name, categories, properties');
    final data = (response as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
    
    // Parse JSON fields
    return data.map((item) {
      return {
        'name': item['name'] ?? '',
        'pretty_name': item['pretty_name'] ?? item['name'] ?? '',
        'categories': item['categories'] is List ? item['categories'] : json.decode(item['categories'] ?? '[]'),
        'description': item['properties'] != null && item['properties']['summary'] != null
            ? item['properties']['summary']
            : 'No description available.',
        'is_common': item['is_user_created'] == 0, // Add this: true if not user-created
      };
    }).toList();
  }
}