import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final createdAtString = log['created_at']?.toString();
    final createdAt =
        createdAtString != null ? DateTime.tryParse(createdAtString) : null;
    final extra = _parseExtraData(log['extra_data']);
    final severity = log['severity'] as String? ?? 'medium';
    final errorCode = log['error_code'] as String? ?? '';

    return DraggableScrollableSheet(
      expand: false,
      builder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: controller,
            children: [
              Row(
                children: [
                  const Icon(Icons.bug_report, color: Colors.deepOrange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      log['error_message'] ?? 'Unknown error',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SeverityBadge(severity: severity, compact: false),
                  if (errorCode.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        errorCode,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              _buildKeyValue(
                  'Created',
                  createdAt != null
                      ? DateFormat('MMM dd, yyyy HH:mm:ss')
                          .format(createdAt.toLocal())
                      : 'Unknown'),
              _buildKeyValue('Platform', log['platform'] ?? 'Unknown'),
              _buildKeyValue('OS Version', log['os_version'] ?? 'Unknown'),
              _buildKeyValue('Device', log['device_model'] ?? 'Unknown'),
              _buildKeyValue('App Version', log['app_version'] ?? 'Unknown'),
              _buildKeyValue('Screen', log['screen_name'] ?? 'Unknown'),
              const SizedBox(height: 12),
              Text(
                'Stacktrace',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  log['stacktrace'] ?? 'Unavailable',
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ),
              if (extra != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Extra Data',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    const JsonEncoder.withIndent('  ').convert(extra),
                    style:
                        const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildKeyValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
