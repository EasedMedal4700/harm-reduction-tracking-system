// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Converts stored dose strings (e.g. "1 pill") into mg.

import 'package:shared_preferences/shared_preferences.dart';

import 'custom_dose_unit_manager.dart';

class DoseStringToMg {
  static final RegExp _firstNumber = RegExp(r'(\d+(?:\.\d+)?)');

  static double parse({
    required SharedPreferences prefs,
    required String substance,
    required dynamic dose,
    double defaultValue = 0.0,
  }) {
    if (dose == null) return defaultValue;
    if (dose is num) return dose.toDouble();

    final raw = dose.toString().trim();
    if (raw.isEmpty) return defaultValue;

    final match = _firstNumber.firstMatch(raw);
    if (match == null) return defaultValue;

    final amount = double.tryParse(match.group(1)!) ?? defaultValue;
    if (amount <= 0) return defaultValue;

    final unit = _extractUnit(raw, match.end);

    // If no unit is present, fall back to the previous behavior (treat as mg).
    if (unit == null) return amount;

    final normalizedUnit = CustomDoseUnitManager.normalizeUnitKey(unit);
    if (normalizedUnit == 'mg') return amount;

    final mgPerUnit = CustomDoseUnitManager.mgPerUnit(
      prefs,
      substance,
      normalizedUnit,
    );

    // If we don't know this unit, keep legacy behavior (amount as mg).
    if (mgPerUnit == null || mgPerUnit <= 0) return amount;

    return amount * mgPerUnit;
  }

  static String? _extractUnit(String raw, int afterNumberIndex) {
    // Take what's after the first number and trim separators.
    var tail = raw.substring(afterNumberIndex).trim();
    if (tail.isEmpty) return null;

    // Handle cases like "10mg" (no space), "10 mg", "10   mg".
    // If tail begins with letters, treat the first token as unit.
    final unitMatch = RegExp(r'^([a-zA-Z]+)').firstMatch(tail);
    if (unitMatch != null) return unitMatch.group(1);

    // If tail begins with separators then letters (e.g. "- mg"), trim and retry.
    tail = tail.replaceFirst(RegExp(r'^[^a-zA-Z]+'), '').trim();
    if (tail.isEmpty) return null;

    final unitMatch2 = RegExp(r'^([a-zA-Z]+)').firstMatch(tail);
    return unitMatch2?.group(1);
  }
}
