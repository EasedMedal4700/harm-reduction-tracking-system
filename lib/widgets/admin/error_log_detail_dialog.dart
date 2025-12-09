// MIGRATION COMPLETE — Fully theme-based, correct typography & colors.
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
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;
    final sh = context.shapes;

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
            color: c.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(sh.radiusLg),
            ),
            border: Border.all(color: c.border),
          ),
          child: Padding(
            padding: EdgeInsets.all(sp.lg),
            child: ListView(
              controller: controller,
              children: [
                /// HEADER
                Row(
                  children: [
                    Icon(Icons.bug_report, color: c.error),
                    SizedBox(width: sp.sm),
                    Expanded(
                      child: Text(
                        log['error_message'] ?? 'Unknown error',
                        style: text.heading4.copyWith(color: c.text),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: sp.md),

                /// SEVERITY + ERROR CODE
                Row(
                  children: [
                    SeverityBadge(severity: severity, compact: false),
                    if (errorCode.isNotEmpty) ...[
                      SizedBox(width: sp.sm),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sp.sm,
                          vertical: sp.xs,
                        ),
                        decoration: BoxDecoration(
                          color: c.surfaceBright,
                          borderRadius: BorderRadius.circular(sh.radiusSm),
                        ),
                        child: Text(
                          errorCode,
                          style: text.caption.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: c.text,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: sp.md),

                /// METADATA
                _buildKeyValue(
                  context,
                  'Created',
                  createdAt != null
                      ? DateFormat('MMM dd, yyyy HH:mm:ss')
                          .format(createdAt.toLocal())
                      : 'Unknown',
                ),
                _buildKeyValue(context, 'Platform', log['platform'] ?? 'Unknown'),
                _buildKeyValue(
                    context, 'OS Version', log['os_version'] ?? 'Unknown'),
                _buildKeyValue(
                    context, 'Device', log['device_model'] ?? 'Unknown'),
                _buildKeyValue(
                    context, 'App Version', log['app_version'] ?? 'Unknown'),
                _buildKeyValue(
                    context, 'Screen', log['screen_name'] ?? 'Unknown'),

                SizedBox(height: sp.md),

                /// STACKTRACE
                Text(
                  'Stacktrace',
                  style: text.bodyBold.copyWith(color: c.text),
                ),
                SizedBox(height: sp.xs),

                Container(
                  padding: EdgeInsets.all(sp.md),
                  decoration: BoxDecoration(
                    color: c.surfaceBright,
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                    border: Border.all(color: c.border),
                  ),
                  child: SelectableText(
                    log['stacktrace'] ?? 'Unavailable',
                    style: text.caption.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: c.text,
                    ),
                  ),
                ),

                /// EXTRA DATA
                if (extra != null) ...[
                  SizedBox(height: sp.lg),
                  Text(
                    'Extra Data',
                    style: text.bodyBold.copyWith(color: c.text),
                  ),
                  SizedBox(height: sp.xs),
                  Container(
                    padding: EdgeInsets.all(sp.md),
                    decoration: BoxDecoration(
                      color: c.surfaceBright,
                      borderRadius: BorderRadius.circular(sh.radiusMd),
                      border: Border.all(color: c.border),
                    ),
                    child: SelectableText(
                      const JsonEncoder.withIndent('  ').convert(extra),
                      style: text.caption.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: c.text,
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
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sp.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: text.bodyBold.copyWith(color: c.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: text.body.copyWith(color: c.text),
            ),
          ),
        ],
      ),
    );
  }
}
