// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Utility.
import '../constants/data/drug_use_catalog.dart';

class ValidationUtils {
  // Public constants for error messages (can be reused)
  static const String emptyDosageError = 'Please enter a dosage';
  static const String invalidDosageError =
      'Dosage must be a positive number between 0.01 and 1000';
  static const String emptySubstanceError = 'Please enter a substance';
  static const String unrecognizedSubstanceError = 'Substance not recognized';
  // Lazy-loaded set for efficiency (initialized on first use)
  static Set<String>? _substancesSet;
  static Set<String> get _getSubstancesSet {
    _substancesSet ??= DrugUseCatalog.substances.toSet();
    return _substancesSet!;
  }

  // Generic validator for required fields (with trimming)
  static String? validateRequired(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  // Validator for dosage (with range and trimming)
  static String? validateDosage(String? value) {
    final trimmed = value?.trim();
    final requiredError = validateRequired(trimmed, emptyDosageError);
    if (requiredError != null) return requiredError;
    final num = double.tryParse(trimmed!);
    if (num == null || num <= 0 || num > 1000) {
      return invalidDosageError;
    }
    return null;
  }

  // Validator for substance (with trimming and set check)
  static String? validateSubstance(String? value) {
    final trimmed = value?.trim();
    final requiredError = validateRequired(trimmed, emptySubstanceError);
    if (requiredError != null) return requiredError;
    if (!_getSubstancesSet.contains(trimmed)) {
      return unrecognizedSubstanceError;
    }
    return null;
  }

  // Additional check for substance
  static bool isSubstanceValid(String substance) {
    return _getSubstancesSet.contains(substance.trim());
  }

  // New: Validator for route (checks against catalog)
  static String? validateRoute(String? value) {
    final trimmed = value?.trim();
    final requiredError = validateRequired(trimmed, 'Please select a route');
    if (requiredError != null) return requiredError;
    if (!DrugUseCatalog.consumptionMethods.any(
      (method) => method['name'] == trimmed,
    )) {
      return 'Invalid route';
    }
    return null;
  }

  // New: Validator for feeling (checks against catalog)
  static String? validateFeeling(String? value) {
    final trimmed = value?.trim();
    final requiredError = validateRequired(trimmed, 'Please select a feeling');
    if (requiredError != null) return requiredError;
    if (!DrugUseCatalog.primaryEmotions.any(
      (emotion) => emotion['name'] == trimmed,
    )) {
      return 'Invalid feeling';
    }
    return null;
  }
}
