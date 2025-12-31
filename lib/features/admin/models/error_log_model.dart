// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_log_model.freezed.dart';

/// Model for error log entry
@freezed
abstract class ErrorLog with _$ErrorLog {
  const factory ErrorLog({
    @Default(0) int id,
    String? userId,
    String? appVersion,
    String? platform,
    String? osVersion,
    String? deviceModel,
    String? screenName,
    @Default('Unknown error') String errorMessage,
    String? errorCode,
    @Default('medium') String severity,
    String? stacktrace,
    Map<String, dynamic>? extraData,
    required DateTime createdAt,
  }) = _ErrorLog;

  const ErrorLog._();

  factory ErrorLog.fromJson(Map<String, dynamic> json) {
    return ErrorLog(
      id: json['id'] as int? ?? 0,
      userId: json['uuid_user_id'] as String?,
      appVersion: json['app_version'] as String?,
      platform: json['platform'] as String?,
      osVersion: json['os_version'] as String?,
      deviceModel: json['device_model'] as String?,
      screenName: json['screen_name'] as String?,
      errorMessage: json['error_message'] as String? ?? 'Unknown error',
      errorCode: json['error_code'] as String?,
      severity: json['severity'] as String? ?? 'medium',
      stacktrace: json['stacktrace'] as String?,
      extraData: json['extra_data'] as Map<String, dynamic>?,
      createdAt: json['created_at'] is String
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : (json['created_at'] as DateTime?) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid_user_id': userId,
      'app_version': appVersion,
      'platform': platform,
      'os_version': osVersion,
      'device_model': deviceModel,
      'screen_name': screenName,
      'error_message': errorMessage,
      'error_code': errorCode,
      'severity': severity,
      'stacktrace': stacktrace,
      'extra_data': extraData,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get severity color
  static ColorInfo getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return ColorInfo.critical;
      case 'high':
        return ColorInfo.high;
      case 'medium':
        return ColorInfo.medium;
      case 'low':
        return ColorInfo.low;
      default:
        return ColorInfo.medium;
    }
  }

  /// Get severity icon
  static IconInfo getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return IconInfo.critical;
      case 'high':
        return IconInfo.high;
      case 'medium':
        return IconInfo.medium;
      case 'low':
        return IconInfo.low;
      default:
        return IconInfo.medium;
    }
  }
}

/// Color information for severity
@freezed
abstract class ColorInfo with _$ColorInfo {
  const factory ColorInfo({required int colorValue, required String name}) =
      _ColorInfo;

  const ColorInfo._();

  static const critical = ColorInfo(colorValue: 0xFFD32F2F, name: 'Red');
  static const high = ColorInfo(colorValue: 0xFFF57C00, name: 'Orange');
  static const medium = ColorInfo(colorValue: 0xFFFBC02D, name: 'Yellow');
  static const low = ColorInfo(colorValue: 0xFF1976D2, name: 'Blue');
}

/// Icon information for severity
@freezed
abstract class IconInfo with _$IconInfo {
  const factory IconInfo({required int iconCodePoint, required String name}) =
      _IconInfo;

  const IconInfo._();

  static const critical = IconInfo(iconCodePoint: 0xe645, name: 'error');
  static const high = IconInfo(iconCodePoint: 0xe002, name: 'warning');
  static const medium = IconInfo(iconCodePoint: 0xe88e, name: 'info');
  static const low = IconInfo(iconCodePoint: 0xe86f, name: 'check_circle');
}
