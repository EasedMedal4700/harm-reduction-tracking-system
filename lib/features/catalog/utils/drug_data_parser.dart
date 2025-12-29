// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Utility.
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

  /// Convert string to Title Case
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }
}
