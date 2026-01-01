// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Custom exceptions for reflection.
/// Custom exceptions for reflection-related operations
class ReflectionException implements Exception {
  final String message;
  final String? details;
  final dynamic originalError;
  ReflectionException(this.message, {this.details, this.originalError});
  @override
  String toString() {
    if (details != null) {
      return 'ReflectionException: $message\nDetails: $details';
    }
    return 'ReflectionException: $message';
  }
}

class ReflectionNotFoundException extends ReflectionException {
  final String reflectionId;
  ReflectionNotFoundException(this.reflectionId)
    : super(
        'Reflection not found',
        details: 'Could not find reflection with ID: $reflectionId',
      );
}

class ReflectionValidationException extends ReflectionException {
  final Map<String, String> validationErrors;
  ReflectionValidationException(this.validationErrors)
    : super(
        'Validation failed',
        details: validationErrors.entries
            .map((e) => '${e.key}: ${e.value}')
            .join('\n'),
      );
}

class ReflectionSaveException extends ReflectionException {
  ReflectionSaveException(super.message, {super.details, super.originalError});
}

class ReflectionFetchException extends ReflectionException {
  ReflectionFetchException(super.message, {super.details, super.originalError});
}

class ReflectionParseException extends ReflectionException {
  final Map<String, dynamic>? rawData;
  ReflectionParseException(super.message, {this.rawData, super.details});
}

class DatabaseConnectionException extends ReflectionException {
  DatabaseConnectionException({String? details})
    : super('Database connection error', details: details);
}
