import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/error_logging_service.dart';

/// Error severity levels
enum ErrorSeverity {
  low('low'),
  medium('medium'),
  high('high'),
  critical('critical');

  const ErrorSeverity(this.value);
  final String value;
}

/// Centralized error reporter with severity mapping and error code generation
class ErrorReporter {
  ErrorReporter._();

  static final ErrorReporter instance = ErrorReporter._();
  static final ErrorLoggingService _loggingService = ErrorLoggingService.instance;

  SupabaseClient get _client => Supabase.instance.client;

  /// Map an error to a severity level
  static ErrorSeverity mapSeverity(dynamic error, StackTrace? stackTrace) {
    final errorString = error.toString().toLowerCase();

    // Critical errors - app-breaking issues
    if (errorString.contains('null') && errorString.contains('subtype')) {
      return ErrorSeverity.critical;
    }
    if (errorString.contains('assertion') && errorString.contains('failed')) {
      return ErrorSeverity.critical;
    }
    if (errorString.contains('unsupported operation')) {
      return ErrorSeverity.critical;
    }
    if (errorString.contains('state error')) {
      return ErrorSeverity.critical;
    }
    if (errorString.contains('no element')) {
      return ErrorSeverity.critical;
    }

    // High severity - major functionality broken
    if (errorString.contains('connection') || errorString.contains('timeout')) {
      return ErrorSeverity.high;
    }
    if (errorString.contains('unauthorized') || errorString.contains('forbidden')) {
      return ErrorSeverity.high;
    }
    if (errorString.contains('database') || errorString.contains('postgrest')) {
      return ErrorSeverity.high;
    }
    if (errorString.contains('authentication') || errorString.contains('auth')) {
      return ErrorSeverity.high;
    }
    if (error is PostgrestException) {
      return ErrorSeverity.high;
    }

    // Medium severity - feature degradation
    if (errorString.contains('format') && errorString.contains('exception')) {
      return ErrorSeverity.medium;
    }
    if (errorString.contains('parse') || errorString.contains('parsing')) {
      return ErrorSeverity.medium;
    }
    if (errorString.contains('invalid') || errorString.contains('validation')) {
      return ErrorSeverity.medium;
    }
    if (errorString.contains('not found') || errorString.contains('missing')) {
      return ErrorSeverity.medium;
    }
    if (error is FormatException || error is TypeError) {
      return ErrorSeverity.medium;
    }

    // Low severity - minor issues, user can continue
    if (errorString.contains('warning')) {
      return ErrorSeverity.low;
    }
    if (errorString.contains('deprecated')) {
      return ErrorSeverity.low;
    }
    if (errorString.contains('cache')) {
      return ErrorSeverity.low;
    }

    // Default to medium if unable to classify
    return ErrorSeverity.medium;
  }

  /// Generate error code from error type and message
  static String generateErrorCode(dynamic error) {
    final errorString = error.toString().toLowerCase();
    final errorType = error.runtimeType.toString().toUpperCase();

    // Type-based codes
    if (error is PostgrestException) {
      return 'DB_${error.code ?? 'ERROR'}';
    }
    if (error is FormatException) {
      return 'FORMAT_ERROR';
    }
    if (error is TypeError) {
      return 'TYPE_ERROR';
    }
    if (error is StateError) {
      return 'STATE_ERROR';
    }
    if (error is ArgumentError) {
      return 'ARG_ERROR';
    }
    if (error is RangeError) {
      return 'RANGE_ERROR';
    }
    if (error is TimeoutException) {
      return 'TIMEOUT';
    }

    // String pattern-based codes
    if (errorString.contains('null') && errorString.contains('subtype')) {
      return 'NULL_CAST';
    }
    if (errorString.contains('connection')) {
      return 'CONNECTION_ERROR';
    }
    if (errorString.contains('network')) {
      return 'NETWORK_ERROR';
    }
    if (errorString.contains('authentication') || errorString.contains('auth')) {
      return 'AUTH_ERROR';
    }
    if (errorString.contains('unauthorized')) {
      return 'UNAUTHORIZED';
    }
    if (errorString.contains('forbidden')) {
      return 'FORBIDDEN';
    }
    if (errorString.contains('not found')) {
      return 'NOT_FOUND';
    }
    if (errorString.contains('timeout')) {
      return 'TIMEOUT';
    }
    if (errorString.contains('parse') || errorString.contains('parsing')) {
      return 'PARSE_ERROR';
    }
    if (errorString.contains('validation')) {
      return 'VALIDATION_ERROR';
    }
    if (errorString.contains('permission')) {
      return 'PERMISSION_ERROR';
    }
    if (errorString.contains('database')) {
      return 'DATABASE_ERROR';
    }
    if (errorString.contains('api')) {
      return 'API_FAILURE';
    }
    if (errorString.contains('cache')) {
      return 'CACHE_ERROR';
    }

    // Fallback to generic type-based code
    return errorType.isEmpty ? 'UNKNOWN_ERROR' : errorType;
  }

  /// Report error with full context, severity, and error code
  Future<void> reportError({
    required dynamic error,
    StackTrace? stackTrace,
    String? screenName,
    String? context,
    Map<String, dynamic>? extraData,
    ErrorSeverity? forceSeverity,
    String? forceErrorCode,
  }) async {
    // Calculate severity and error code
    final severity = forceSeverity ?? mapSeverity(error, stackTrace);
    final errorCode = forceErrorCode ?? generateErrorCode(error);

    // Get current user
    final userId = _client.auth.currentUser?.id;

    // Get app and device info from ErrorLoggingService
    await _loggingService.init();

    // Build payload
    final payload = <String, dynamic>{
      'user_id': userId,
      'app_version': _loggingService.appVersion,
      'platform': _loggingService.platform,
      'os_version': _loggingService.osVersion,
      'device_model': _loggingService.deviceModel,
      'screen_name': screenName ?? _loggingService.currentScreen ?? 'unknown',
      'error_message': error.toString(),
      'error_code': errorCode,
      'severity': severity.value,
      'stacktrace': stackTrace?.toString(),
      'extra_data': {
        if (context != null) 'context': context,
        if (extraData != null) ...extraData,
        'error_type': error.runtimeType.toString(),
      },
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      await _client.from('error_logs').insert(payload);
      
      debugPrint('═' * 80);
      debugPrint('ERROR REPORTED: [$errorCode] ${severity.value.toUpperCase()}');
      debugPrint('Screen: ${payload['screen_name']}');
      if (context != null) debugPrint('Context: $context');
      debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('Stack: ${stackTrace.toString().split('\n').take(5).join('\n')}');
      debugPrint('═' * 80);
    } catch (insertError, insertStackTrace) {
      debugPrint('Failed to report error to Supabase: $insertError');
      debugPrint('Original error: $error');
      if (kDebugMode) {
        debugPrint('Insert stack trace: $insertStackTrace');
      }
    }
  }

  /// Quick error report with just error and optional screen
  Future<void> report(
    dynamic error, [
    StackTrace? stackTrace,
    String? screenName,
  ]) async {
    return reportError(
      error: error,
      stackTrace: stackTrace,
      screenName: screenName,
    );
  }

  /// Report error with context string
  Future<void> reportWithContext(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
  ]) async {
    return reportError(
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Wrap a function with automatic error reporting
  Future<T> guard<T>(
    Future<T> Function() body, {
    String? operationName,
    String? screenName,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      return await body();
    } catch (error, stackTrace) {
      await reportError(
        error: error,
        stackTrace: stackTrace,
        screenName: screenName,
        context: operationName,
        extraData: extraData,
      );
      rethrow;
    }
  }
}
