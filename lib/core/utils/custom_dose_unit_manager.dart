// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Local custom dose unit storage.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CustomDoseUnitManager {
  static const String _keyPrefix = 'custom_dose_unit_mg_';

  static String normalizeSubstanceKey(String substance) {
    return substance.trim().toLowerCase();
  }

  static String normalizeUnitKey(String unit) {
    return unit.trim().toLowerCase();
  }

  static String _prefsKey(String substance) {
    return '$_keyPrefix${normalizeSubstanceKey(substance)}';
  }

  static Map<String, double> readUnitToMg(
    SharedPreferences prefs,
    String substance,
  ) {
    final stored = prefs.getString(_prefsKey(substance));
    if (stored == null || stored.isEmpty) return const {};

    try {
      final decoded = jsonDecode(stored);
      if (decoded is! Map) return const {};

      final result = <String, double>{};
      for (final entry in decoded.entries) {
        final unit = normalizeUnitKey(entry.key.toString());
        final mg = _toDoubleOrNull(entry.value);
        if (unit.isEmpty || mg == null || mg <= 0) continue;
        result[unit] = mg;
      }
      return result;
    } catch (_) {
      return const {};
    }
  }

  static Future<void> writeUnitToMg(
    SharedPreferences prefs,
    String substance,
    Map<String, double> unitToMg,
  ) async {
    final normalized = <String, double>{};
    for (final entry in unitToMg.entries) {
      final unit = normalizeUnitKey(entry.key);
      final mg = entry.value;
      if (unit.isEmpty || mg <= 0) continue;
      normalized[unit] = mg;
    }

    await prefs.setString(_prefsKey(substance), jsonEncode(normalized));
  }

  static Future<void> deleteUnit(
    SharedPreferences prefs,
    String substance,
    String unit,
  ) async {
    final current = readUnitToMg(prefs, substance);
    final key = normalizeUnitKey(unit);
    if (!current.containsKey(key)) return;

    final updated = {...current}..remove(key);
    await writeUnitToMg(prefs, substance, updated);
  }

  static double? mgPerUnit(
    SharedPreferences prefs,
    String substance,
    String unit,
  ) {
    final map = readUnitToMg(prefs, substance);
    return map[normalizeUnitKey(unit)];
  }

  static double? _toDoubleOrNull(dynamic value) {
    if (value is num) return value.toDouble();
    if (value == null) return null;
    return double.tryParse(value.toString());
  }
}
