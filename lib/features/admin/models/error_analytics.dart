// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Typed error analytics summary.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'error_log_entry.dart';
import 'label_count.dart';

part 'error_analytics.freezed.dart';

@freezed
class ErrorAnalytics with _$ErrorAnalytics {
  const factory ErrorAnalytics({
    @Default(0) int totalErrors,
    @Default(0) int last24h,
    @Default(<LabelCount>[]) List<LabelCount> platformBreakdown,
    @Default(<LabelCount>[]) List<LabelCount> screenBreakdown,
    @Default(<LabelCount>[]) List<LabelCount> messageBreakdown,
    @Default(<LabelCount>[]) List<LabelCount> severityBreakdown,
    @Default(<LabelCount>[]) List<LabelCount> errorCodeBreakdown,
    @Default(<ErrorLogEntry>[]) List<ErrorLogEntry> recentLogs,
  }) = _ErrorAnalytics;

  static List<LabelCount> _parseBreakdown(
    dynamic raw, {
    required String labelKey,
  }) {
    if (raw is! List) return const <LabelCount>[];
    return raw
        .whereType<Map>()
        .map((m) => Map<String, dynamic>.from(m))
        .map((m) {
          final label = (m[labelKey] ?? 'Unknown').toString();
          final count =
              (m['count'] as int?) ?? ((m['count'] as num?)?.toInt() ?? 0);
          return LabelCount(label: label, count: count);
        })
        .toList(growable: false);
  }

  static List<ErrorLogEntry> _parseRecentLogs(dynamic raw) {
    if (raw is! List) return const <ErrorLogEntry>[];
    return raw
        .whereType<Map>()
        .map((m) => Map<String, dynamic>.from(m))
        .map(ErrorLogEntry.fromServiceMap)
        .toList(growable: false);
  }

  factory ErrorAnalytics.fromServiceMap(Map<String, dynamic> map) {
    return ErrorAnalytics(
      totalErrors: (map['total_errors'] as int?) ?? 0,
      last24h: (map['last_24h'] as int?) ?? 0,
      platformBreakdown: _parseBreakdown(
        map['platform_breakdown'],
        labelKey: 'platform',
      ),
      screenBreakdown: _parseBreakdown(
        map['screen_breakdown'],
        labelKey: 'screen_name',
      ),
      messageBreakdown: _parseBreakdown(
        map['message_breakdown'],
        labelKey: 'error_message',
      ),
      severityBreakdown: _parseBreakdown(
        map['severity_breakdown'],
        labelKey: 'severity',
      ),
      errorCodeBreakdown: _parseBreakdown(
        map['error_code_breakdown'],
        labelKey: 'error_code',
      ),
      recentLogs: _parseRecentLogs(map['recent_logs']),
    );
  }
}
