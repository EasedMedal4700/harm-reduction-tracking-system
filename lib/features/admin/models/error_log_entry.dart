// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Typed error log entry used for admin error analytics.

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_log_entry.freezed.dart';

@freezed
abstract class ErrorLogEntry with _$ErrorLogEntry {
  const factory ErrorLogEntry({
    String? id,
    String? uuidUserId,
    String? appVersion,
    String? platform,
    String? osVersion,
    String? deviceModel,
    String? screenName,
    String? errorMessage,
    String? errorCode,
    @Default('medium') String severity,
    String? stacktrace,
    dynamic extraData,
    DateTime? createdAt,
  }) = _ErrorLogEntry;

  const ErrorLogEntry._();

  static DateTime? _parseDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }

  Map<String, dynamic>? parseExtraDataAsMap() {
    final data = extraData;
    if (data is Map<String, dynamic>) return data;
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {}
    }
    return null;
  }

  factory ErrorLogEntry.fromServiceMap(Map<String, dynamic> map) {
    return ErrorLogEntry(
      id: map['id']?.toString(),
      uuidUserId: map['uuid_user_id']?.toString(),
      appVersion: map['app_version']?.toString(),
      platform: map['platform']?.toString(),
      osVersion: map['os_version']?.toString(),
      deviceModel: map['device_model']?.toString(),
      screenName: map['screen_name']?.toString(),
      errorMessage: map['error_message']?.toString(),
      errorCode: map['error_code']?.toString(),
      severity: (map['severity']?.toString() ?? 'medium'),
      stacktrace: map['stacktrace']?.toString(),
      extraData: map['extra_data'],
      createdAt: _parseDate(map['created_at']),
    );
  }
}
