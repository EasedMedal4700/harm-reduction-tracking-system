/// Reusable parsing utilities for converting dynamic JSON values to typed Dart values
class ParsingUtils {
  /// Parses a dynamic value to double, returns 0.0 if parsing fails
  static double parseDouble(dynamic v) =>
      double.tryParse(v?.toString() ?? '') ?? 0.0;

  /// Parses a dynamic value to int, returns 0 if parsing fails
  static int parseInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  /// Converts dynamic value to `List<String>`
  ///
  /// Supports:
  /// - List types (converted to string list)
  /// - String types (split by comma/semicolon or spaces)
  /// - null (returns empty list)
  ///
  /// [splitBySpace] if true, splits by whitespace instead of comma/semicolon
  static List<String> toList(dynamic v, {bool splitBySpace = false}) {
    if (v == null) return [];
    if (v is List) {
      return v
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (v is String && v.isNotEmpty) {
      try {
        final pattern = splitBySpace ? RegExp(r'\s+') : RegExp(r'[;,]');
        return v
            .split(pattern)
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  /// Converts dynamic value to `Map<String, List<String>>`
  ///
  /// Supports:
  /// - Map types (keys converted to strings, values to string lists)
  /// - String/List types (converted to {'default': [...]} map)
  /// - null (returns empty map)
  static Map<String, List<String>> toMap(dynamic v) {
    if (v == null) return {};
    if (v is Map) {
      return v.map(
        (k, val) => MapEntry(
          k.toString(),
          (val is List)
              ? val.map((e) => e.toString()).toList()
              : [val.toString()],
        ),
      );
    }
    // Fallback: treat as single-key list if string/list
    final list = toList(v);
    return list.isEmpty ? {} : {'default': list};
  }

  /// Parses timezone offset from various formats
  ///
  /// Supports:
  /// - "+05:30" or "-05:30" format
  /// - "+0530" format (without colon)
  /// - Numeric values (5.5, -8, etc.)
  ///
  /// Returns offset in hours (e.g., 5.5 for +05:30)
  static double parseTimezone(dynamic v) {
    if (v == null) return 0.0;
    final str = v.toString();
    final match = RegExp(r'([+-])(\d{1,2}):?(\d{2})').firstMatch(str);
    if (match != null) {
      final sign = match.group(1) == '-' ? -1 : 1;
      final hours = int.parse(match.group(2)!);
      final minutes = int.parse(match.group(3)!);
      return sign * (hours + minutes / 60.0);
    }
    return double.tryParse(str) ?? 0.0;
  }
}
