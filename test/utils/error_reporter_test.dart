import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/core/utils/error_reporter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('ErrorReporter', () {
    group('mapSeverity', () {
      test('maps null subtype errors to critical', () {
        final error = Exception("type 'Null' is not a subtype of type 'int'");
        final severity = ErrorReporter.mapSeverity(error, null);
        expect(severity, ErrorSeverity.critical);
      });

      test('maps assertion failures to critical', () {
        final error = Exception('Assertion failed: something went wrong');
        final severity = ErrorReporter.mapSeverity(error, null);
        expect(severity, ErrorSeverity.critical);
      });

      test('maps database errors to high severity', () {
        final error = PostgrestException(
          message: 'Database error',
          code: '500',
        );
        final severity = ErrorReporter.mapSeverity(error, null);
        expect(severity, ErrorSeverity.high);
      });

      test('maps connection errors to high severity', () {
        final error = Exception('Connection timeout');
        final severity = ErrorReporter.mapSeverity(error, null);
        expect(severity, ErrorSeverity.high);
      });

      test('maps authentication errors to high severity', () {
        final error = Exception('Unauthorized access');
        final severity = ErrorReporter.mapSeverity(error, null);
        expect(severity, ErrorSeverity.high);
      });

      test('maps format errors to medium severity', () {
        final error = FormatException('Invalid format');
        final severity = ErrorReporter.mapSeverity(error, null);
        expect(severity, ErrorSeverity.medium);
      });

      test('maps parse errors to medium severity', () {
        final error = Exception('Failed to parse JSON');
        final severity = ErrorReporter.mapSeverity(error, null);
        expect(severity, ErrorSeverity.medium);
      });

      test('maps validation errors to medium severity', () {
        final error = Exception('Invalid input data');
        final severity = ErrorReporter.mapSeverity(error, null);
        expect(severity, ErrorSeverity.medium);
      });

      test('maps generic errors to medium severity by default', () {
        final error = Exception('Something happened');
        final severity = ErrorReporter.mapSeverity(error, null);
        expect(severity, ErrorSeverity.medium);
      });
    });

    group('generateErrorCode', () {
      test('generates DB_* codes for database errors', () {
        final error = PostgrestException(message: 'Error', code: '23505');
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, 'DB_23505');
      });

      test('generates TYPE_ERROR for type errors', () {
        final error = TypeError();
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, 'TYPE_ERROR');
      });

      test('generates NULL_CAST for null cast errors', () {
        final error = Exception(
          "type 'Null' is not a subtype of type 'int' in type cast",
        );
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, 'NULL_CAST');
      });

      test('generates AUTH_ERROR for authentication errors', () {
        final error = Exception('Unauthorized: invalid token');
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, 'AUTH_ERROR');
      });

      test('generates CONNECTION_ERROR for connection errors', () {
        final error = Exception('Connection failed');
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, 'CONNECTION_ERROR');
      });

      test('generates FORMAT_ERROR for format errors', () {
        final error = FormatException('Failed to format');
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, 'FORMAT_ERROR');
      });

      test('generates PARSE_ERROR for parsing errors', () {
        final error = Exception('Failed to parse JSON');
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, 'PARSE_ERROR');
      });

      test('generates VALIDATION_ERROR for validation errors', () {
        final error = Exception('Invalid input: validation failed');
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, 'VALIDATION_ERROR');
      });

      test('generates API_FAILURE for API errors', () {
        final error = Exception('API request failed with status 500');
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, 'API_FAILURE');
      });

      test('generates _EXCEPTION for unrecognized errors', () {
        final error = Exception('Something weird happened');
        final code = ErrorReporter.generateErrorCode(error);
        expect(code, '_EXCEPTION');
      });
    });

    group('ErrorSeverity enum', () {
      test('has correct string values', () {
        expect(ErrorSeverity.low.value, 'low');
        expect(ErrorSeverity.medium.value, 'medium');
        expect(ErrorSeverity.high.value, 'high');
        expect(ErrorSeverity.critical.value, 'critical');
      });
    });
  });
}
