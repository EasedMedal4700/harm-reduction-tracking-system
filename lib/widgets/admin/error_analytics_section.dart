import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'severity_badge.dart';

/// Error analytics dashboard widget for admin panel
class ErrorAnalyticsSection extends StatelessWidget {
  final Map<String, dynamic> errorAnalytics;
  final bool isClearingErrors;
  final VoidCallback onCleanLogs;
  final Function(Map<String, dynamic>) onShowLogDetails;

  const ErrorAnalyticsSection({
    required this.errorAnalytics,
    required this.isClearingErrors,
    required this.onCleanLogs,
    required this.onShowLogDetails,
    super.key,
  });

  List<Map<String, dynamic>> _getBreakdown(String key) {
    final raw = errorAnalytics[key];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  @override
  Widget build(BuildContext context) {
    final totalErrors = errorAnalytics['total_errors'] ?? 0;
    final last24h = errorAnalytics['last_24h'] ?? 0;
    final platformBreakdown = _getBreakdown('platform_breakdown');
    final screenBreakdown = _getBreakdown('screen_breakdown');
    final messageBreakdown = _getBreakdown('message_breakdown');
    final severityBreakdown = _getBreakdown('severity_breakdown');
    final errorCodeBreakdown = _getBreakdown('error_code_breakdown');
    final recentLogs = _getBreakdown('recent_logs');

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.deepOrange),
                const SizedBox(width: 8),
                const Text(
                  'Error Monitoring',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: isClearingErrors ? null : onCleanLogs,
                  icon: const Icon(Icons.cleaning_services_outlined),
                  label: const Text('Clean Logs'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildErrorStatChip(
                  label: 'Total Errors',
                  value: totalErrors.toString(),
                  icon: Icons.warning_amber_outlined,
                  color: Colors.red.shade600,
                ),
                _buildErrorStatChip(
                  label: 'Last 24h',
                  value: last24h.toString(),
                  icon: Icons.timer_outlined,
                  color: Colors.orange.shade600,
                ),
                _buildErrorStatChip(
                  label: 'Tracked Screens',
                  value: screenBreakdown.length.toString(),
                  icon: Icons.devices_other,
                  color: Colors.blueGrey.shade600,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (platformBreakdown.isNotEmpty)
              _buildBreakdownSection(
                context: context,
                title: 'Top Platforms',
                data: platformBreakdown,
                labelKey: 'platform',
                countKey: 'count',
              ),
            if (screenBreakdown.isNotEmpty)
              _buildBreakdownSection(
                context: context,
                title: 'Top Screens',
                data: screenBreakdown,
                labelKey: 'screen_name',
                countKey: 'count',
              ),
            if (messageBreakdown.isNotEmpty)
              _buildBreakdownSection(
                context: context,
                title: 'Frequent Errors',
                data: messageBreakdown,
                labelKey: 'error_message',
                countKey: 'count',
              ),
            if (severityBreakdown.isNotEmpty)
              _buildBreakdownSection(
                context: context,
                title: 'By Severity',
                data: severityBreakdown,
                labelKey: 'severity',
                countKey: 'count',
                useSeverityBadge: true,
              ),
            if (errorCodeBreakdown.isNotEmpty)
              _buildBreakdownSection(
                context: context,
                title: 'By Error Code',
                data: errorCodeBreakdown,
                labelKey: 'error_code',
                countKey: 'count',
              ),
            const SizedBox(height: 16),
            Text(
              'Recent Events',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (recentLogs.isEmpty)
              const Text(
                'No recent error logs available.',
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                children: recentLogs.map((log) {
                  final createdRaw = log['created_at'];
                  final createdAt = createdRaw is String
                      ? DateTime.tryParse(createdRaw)
                      : createdRaw is DateTime
                          ? createdRaw
                          : null;
                  final timestamp = createdAt != null
                      ? DateFormat('MMM dd, HH:mm').format(createdAt)
                      : 'Unknown time';
                  final severity = log['severity'] as String? ?? 'medium';
                  final errorCode = log['error_code'] as String? ?? '';

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SeverityBadge(severity: severity, compact: true),
                    title: Row(
                      children: [
                        if (errorCode.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              errorCode,
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            log['error_message'] ?? 'Unknown error',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      '${log['platform'] ?? 'unknown'} • ${log['screen_name'] ?? 'Unknown screen'}\n$timestamp',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.devices),
                        Text(
                          log['device_model'] ?? 'unavailable',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    onTap: () => onShowLogDetails(log),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorStatChip({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildBreakdownSection({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> data,
    required String labelKey,
    required String countKey,
    bool useSeverityBadge = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...data.take(5).map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: useSeverityBadge
                      ? SeverityBadge(
                          severity: item[labelKey]?.toString() ?? 'medium',
                          compact: false,
                        )
                      : Text(
                          item[labelKey]?.toString() ?? 'Unknown',
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                Text(
                  '${item[countKey] ?? 0} hits',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
