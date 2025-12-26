// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Data model.
/// Model for error log entry
class ErrorLog {
  final int id;
  final String? userId;
  final String? appVersion;
  final String? platform;
  final String? osVersion;
  final String? deviceModel;
  final String? screenName;
  final String errorMessage;
  final String? errorCode;
  final String severity; // low, medium, high, critical
  final String? stacktrace;
  final Map<String, dynamic>? extraData;
  final DateTime createdAt;
  const ErrorLog({
    required this.id,
    this.userId,
    this.appVersion,
    this.platform,
    this.osVersion,
    this.deviceModel,
    this.screenName,
    required this.errorMessage,
    this.errorCode,
    required this.severity,
    this.stacktrace,
    this.extraData,
    required this.createdAt,
  });
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
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
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
class ColorInfo {
  final int colorValue;
  final String name;
  const ColorInfo(this.colorValue, this.name);
  static const critical = ColorInfo(0xFFD32F2F, 'Red');
  static const high = ColorInfo(0xFFF57C00, 'Orange');
  static const medium = ColorInfo(0xFFFBC02D, 'Yellow');
  static const low = ColorInfo(0xFF1976D2, 'Blue');
}

/// Icon information for severity
class IconInfo {
  final int iconCodePoint;
  final String name;
  const IconInfo(this.iconCodePoint, this.name);
  static const critical = IconInfo(0xe645, 'error'); // Icons.error
  static const high = IconInfo(0xe002, 'warning'); // Icons.warning
  static const medium = IconInfo(0xe88e, 'info'); // Icons.info
  static const low = IconInfo(0xe86f, 'check_circle'); // Icons.check_circle
}
