// MIGRATION COMPLETE — All theme-based.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/theme/app_theme_extension.dart';
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
    final t = context.theme;

    final totalErrors = errorAnalytics['total_errors'] ?? 0;
    final last24h = errorAnalytics['last_24h'] ?? 0;
    final platformBreakdown = _getBreakdown('platform_breakdown');
    final screenBreakdown = _getBreakdown('screen_breakdown');
    final messageBreakdown = _getBreakdown('message_breakdown');
    final severityBreakdown = _getBreakdown('severity_breakdown');
    final errorCodeBreakdown = _getBreakdown('error_code_breakdown');
    final recentLogs = _getBreakdown('recent_logs');

    return Container(
      decoration: t.cardDecoration(),
      child: Padding(
        padding: EdgeInsets.all(t.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Icon(Icons.error_outline, color: t.colors.error),
                SizedBox(width: t.spacing.sm),
                Text(
                  'Error Monitoring',
                  style: t.typography.heading3.copyWith(
                    color: t.colors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: isClearingErrors ? null : onCleanLogs,
                  icon: const Icon(Icons.cleaning_services_outlined),
                  label: Text(
                    'Clean Logs',
                    style: t.typography.button.copyWith(
                      color: t.colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: t.spacing.md),

            /// Top Stats Chips
            Wrap(
              spacing: t.spacing.md,
              runSpacing: t.spacing.md,
              children: [
                _buildErrorStatChip(
                  context,
                  label: 'Total Errors',
                  value: totalErrors.toString(),
                  icon: Icons.warning_amber_outlined,
                  color: t.colors.error,
                ),
                _buildErrorStatChip(
                  context,
                  label: 'Last 24h',
                  value: last24h.toString(),
                  icon: Icons.timer_outlined,
                  color: t.colors.warning,
                ),
                _buildErrorStatChip(
                  context,
                  label: 'Tracked Screens',
                  value: screenBreakdown.length.toString(),
                  icon: Icons.devices_other,
                  color: t.colors.info,
                ),
              ],
            ),

            SizedBox(height: t.spacing.lg),

            /// Breakdown sections
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

            SizedBox(height: t.spacing.lg),

            /// Recent Logs
            Text(
              'Recent Events',
              style: t.typography.heading4.copyWith(
                color: t.colors.textPrimary,
              ),
            ),
            SizedBox(height: t.spacing.sm),

            if (recentLogs.isEmpty)
              Text(
                'No recent error logs available.',
                style: t.typography.bodySmall.copyWith(
                  color: t.colors.textSecondary,
                ),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: t.spacing.xs,
                              vertical: t.spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: t.colors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(t.spacing.xs),
                            ),
                            child: Text(
                              errorCode,
                              style: t.typography.overline.copyWith(
                                fontWeight: FontWeight.bold,
                                color: t.colors.textPrimary,
                              ),
                            ),
                          ),
                          SizedBox(width: t.spacing.sm),
                        ],
                        Expanded(
                          child: Text(
                            log['error_message'] ?? 'Unknown error',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: t.typography.body.copyWith(
                              color: t.colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      '${log['platform'] ?? 'unknown'} • ${log['screen_name'] ?? 'Unknown screen'}\n$timestamp',
                      style: t.typography.caption.copyWith(
                        color: t.colors.textSecondary,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.devices, color: t.colors.textSecondary),
                        Text(
                          log['device_model'] ?? 'unavailable',
                          style: t.typography.caption.copyWith(
                            color: t.colors.textSecondary,
                          ),
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

  Widget _buildErrorStatChip(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final t = context.theme;

    return Container(
      width: 160,
      padding: EdgeInsets.all(t.spacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(t.spacing.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          SizedBox(height: t.spacing.sm),
          Text(
            value,
            style: t.typography.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          Text(
            label,
            style: t.typography.bodySmall.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
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
    final t = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: t.typography.bodyBold.copyWith(
            color: t.colors.textPrimary,
          ),
        ),
        SizedBox(height: t.spacing.sm),
        ...data.take(5).map(
          (item) => Padding(
            padding: EdgeInsets.symmetric(vertical: t.spacing.xs),
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
                          style: t.typography.body.copyWith(
                            color: t.colors.textPrimary,
                          ),
                        ),
                ),
                Text(
                  '${item[countKey] ?? 0} hits',
                  style: t.typography.bodyBold.copyWith(
                    color: t.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: t.spacing.lg),
      ],
    );
  }
}
