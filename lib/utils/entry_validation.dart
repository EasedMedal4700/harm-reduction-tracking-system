import '../constants/drug_use_catalog.dart';

class ValidationUtils {
  // Validator for dosage (positive number)
  static String? validateDosage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a dosage';
    }
    final num = double.tryParse(value);
    if (num == null || num <= 0) {
      return 'Dosage must be a positive number';
    }
    return null;
  }

  // Validator for substance (not empty)
  static String? validateSubstance(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a substance';
    }
    return null;
  }

  // Additional check for substance (can be called in _save)
  static bool isSubstanceValid(String substance) {
    return DrugUseCatalog.substances.contains(substance);
  }
}