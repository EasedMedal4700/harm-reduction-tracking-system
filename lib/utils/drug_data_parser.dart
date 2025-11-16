import 'dart:convert';

/// Utility class for parsing drug-related data
class DrugDataParser {
  /// Parse categories from various formats (List, JSON string, single string)
  static List<String> parseCategories(dynamic raw) {
    if (raw is List) {
      return raw.map((item) => item.toString()).toList();
    }
    
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.map((item) => item.toString()).toList();
        }
      } catch (_) {
        return [raw];
      }
    }
    
    return const ['Unknown'];
  }

  /// Normalize drug name (trim and lowercase)
  static String normalizeName(String name) => name.trim().toLowerCase();
}
