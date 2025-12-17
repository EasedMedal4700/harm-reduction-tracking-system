// MIGRATION // Theme: [Not Applicable] // Common: [Not Applicable] // Riverpod: TODO
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
  ReflectionSaveException(String message, {String? details, dynamic originalError})
      : super(message, details: details, originalError: originalError);
}

class ReflectionFetchException extends ReflectionException {
  ReflectionFetchException(String message, {String? details, dynamic originalError})
      : super(message, details: details, originalError: originalError);
}

class ReflectionParseException extends ReflectionException {
  final Map<String, dynamic>? rawData;

  ReflectionParseException(String message, {this.rawData, String? details})
      : super(message, details: details);
}

class DatabaseConnectionException extends ReflectionException {
  DatabaseConnectionException({String? details})
      : super('Database connection error', details: details);
}
