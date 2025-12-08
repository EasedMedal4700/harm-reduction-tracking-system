// MIGRATION COMPLETE — Fully theme-based.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/theme/app_theme_extension.dart';
import 'severity_badge.dart';

/// Bottom sheet dialog showing detailed error log information
class ErrorLogDetailDialog extends StatelessWidget {
  final Map<String, dynamic> log;

  const ErrorLogDetailDialog({
    required this.log,
    super.key,
  });

  Map<String, dynamic>? _parseExtraData(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String && data.isNotEmpty) {
      try {
        return jsonDecode(data) as Map<String, dynamic>?;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    final createdAtString = log['created_at']?.toString();
    final createdAt =
        createdAtString != null ? DateTime.tryParse(createdAtString) : null;

    final extra = _parseExtraData(log['extra_data']);
    final severity = log['severity'] as String? ?? 'medium';
    final errorCode = log['error_code'] as String? ?? '';

    return DraggableScrollableSheet(
      expand: false,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: t.colors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(t.spacing.lg),
            ),
            border: Border.all(color: t.colors.border),
          ),
          child: Padding(
            padding: EdgeInsets.all(t.spacing.lg),
            child: ListView(
              controller: controller,
              children: [
                /// Header
                Row(
                  children: [
                    Icon(Icons.bug_report, color: t.colors.error),
                    SizedBox(width: t.spacing.sm),
                    Expanded(
                      child: Text(
                        log['error_message'] ?? 'Unknown error',
                        style: t.typography.heading4.copyWith(
                          color: t.colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: t.spacing.md),

                /// Severity + Error Code
                Row(
                  children: [
                    SeverityBadge(severity: severity, compact: false),
                    if (errorCode.isNotEmpty) ...[
                      SizedBox(width: t.spacing.sm),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: t.spacing.sm,
                          vertical: t.spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: t.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(t.spacing.xs),
                        ),
                        child: Text(
                          errorCode,
                          style: t.typography.caption.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: t.colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: t.spacing.md),

                /// Metadata
                _buildKeyValue(
                  context,
                  'Created',
                  createdAt != null
                      ? DateFormat('MMM dd, yyyy HH:mm:ss')
                          .format(createdAt.toLocal())
                      : 'Unknown',
                ),
                _buildKeyValue(context, 'Platform', log['platform'] ?? 'Unknown'),
                _buildKeyValue(context, 'OS Version', log['os_version'] ?? 'Unknown'),
                _buildKeyValue(context, 'Device', log['device_model'] ?? 'Unknown'),
                _buildKeyValue(context, 'App Version', log['app_version'] ?? 'Unknown'),
                _buildKeyValue(context, 'Screen', log['screen_name'] ?? 'Unknown'),

                SizedBox(height: t.spacing.md),

                /// Stacktrace Section
                Text(
                  'Stacktrace',
                  style: t.typography.bodyBold.copyWith(
                    color: t.colors.textPrimary,
                  ),
                ),
                SizedBox(height: t.spacing.xs),

                Container(
                  padding: EdgeInsets.all(t.spacing.md),
                  decoration: BoxDecoration(
                    color: t.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(t.spacing.md),
                    border: Border.all(color: t.colors.border),
                  ),
                  child: SelectableText(
                    log['stacktrace'] ?? 'Unavailable',
                    style: t.typography.caption.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: t.colors.textPrimary,
                    ),
                  ),
                ),

                /// Extra Data Section
                if (extra != null) ...[
                  SizedBox(height: t.spacing.lg),
                  Text(
                    'Extra Data',
                    style: t.typography.bodyBold.copyWith(
                      color: t.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: t.spacing.xs),
                  Container(
                    padding: EdgeInsets.all(t.spacing.md),
                    decoration: BoxDecoration(
                      color: t.colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(t.spacing.md),
                      border: Border.all(color: t.colors.border),
                    ),
                    child: SelectableText(
                      const JsonEncoder.withIndent('  ').convert(extra),
                      style: t.typography.caption.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: t.colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeyValue(
    BuildContext context,
    String label,
    String value,
  ) {
    final t = context.theme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: t.typography.bodyBold.copyWith(
                color: t.colors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: t.typography.body.copyWith(
                color: t.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
