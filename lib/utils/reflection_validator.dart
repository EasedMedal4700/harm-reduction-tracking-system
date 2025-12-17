import '../models/reflection_model.dart';
import '../features/reflection/reflection_exceptions.dart';

/// Validator for reflection data
class ReflectionValidator {
  /// Validate a reflection model before saving
  static void validateReflection(ReflectionModel model) {
    final errors = <String, String>{};

    // Validate effectiveness range
    if (model.effectiveness < 0 || model.effectiveness > 10) {
      errors['effectiveness'] = 'Must be between 0 and 10';
    }

    // Validate sleep hours
    if (model.sleepHours < 0 || model.sleepHours > 24) {
      errors['sleepHours'] = 'Must be between 0 and 24 hours';
    }

    // Validate sleep quality
    if (model.sleepQuality.isNotEmpty) {
      final validQualities = ['Poor', 'Fair', 'Good', 'Excellent'];
      if (!validQualities.contains(model.sleepQuality)) {
        errors['sleepQuality'] = 'Must be one of: ${validQualities.join(", ")}';
      }
    }

    // Validate energy level
    if (model.energyLevel.isNotEmpty) {
      final validLevels = ['Low', 'Neutral', 'High'];
      if (!validLevels.contains(model.energyLevel)) {
        errors['energyLevel'] = 'Must be one of: ${validLevels.join(", ")}';
      }
    }

    // Validate post use craving
    if (model.postUseCraving < 0 || model.postUseCraving > 10) {
      errors['postUseCraving'] = 'Must be between 0 and 10';
    }

    // Validate coping effectiveness
    if (model.copingEffectiveness < 0 || model.copingEffectiveness > 10) {
      errors['copingEffectiveness'] = 'Must be between 0 and 10';
    }

    // Validate overall satisfaction
    if (model.overallSatisfaction < 0 || model.overallSatisfaction > 10) {
      errors['overallSatisfaction'] = 'Must be between 0 and 10';
    }

    if (errors.isNotEmpty) {
      throw ReflectionValidationException(errors);
    }
  }

  /// Validate raw JSON data before parsing
  static void validateRawData(Map<String, dynamic> json) {
    final errors = <String, String>{};

    // Check for required fields
    if (json['reflection_id'] == null && json['id'] == null) {
      errors['id'] = 'Reflection ID is required';
    }

    // Note: reflections table uses created_at (timestamp), not date field
    if (json['created_at'] == null) {
      errors['created_at'] = 'Created date field is required';
    }

    if (errors.isNotEmpty) {
      throw ReflectionValidationException(errors);
    }
  }

  /// Check if a reflection ID is valid
  static bool isValidReflectionId(String? id) {
    if (id == null || id.isEmpty) return false;
    final parsed = int.tryParse(id);
    return parsed != null && parsed > 0;
  }

  /// Sanitize notes text
  static String sanitizeNotes(String? notes) {
    if (notes == null || notes.isEmpty) return '';
    // Remove excessive whitespace and trim
    return notes.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Validate related entries list
  static List<String> validateRelatedEntries(dynamic entries) {
    if (entries == null) return [];
    
    if (entries is List) {
      return entries
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    
    if (entries is String && entries.isNotEmpty) {
      return entries
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    
    return [];
  }
}
