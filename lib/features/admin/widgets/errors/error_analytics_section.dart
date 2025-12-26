// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Fully theme-based, no deprecated typography or colors.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:intl/intl.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
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
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final totalErrors = errorAnalytics['total_errors'] ?? 0;
    final last24h = errorAnalytics['last_24h'] ?? 0;
    final platformBreakdown = _getBreakdown('platform_breakdown');
    final screenBreakdown = _getBreakdown('screen_breakdown');
    final messageBreakdown = _getBreakdown('message_breakdown');
    final severityBreakdown = _getBreakdown('severity_breakdown');
    final errorCodeBreakdown = _getBreakdown('error_code_breakdown');
    final recentLogs = _getBreakdown('recent_logs');
    return CommonCard(
      borderRadius: sh.radiusMd,
      padding: EdgeInsets.all(sp.lg),
      showBorder: false,
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          /// HEADER
          Row(
            children: [
              Icon(Icons.error_outline, color: c.error),
              SizedBox(width: sp.sm),
              Text(
                'Error Monitoring',
                style: tx.heading3.copyWith(color: c.textPrimary),
              ),
              const Spacer(),
              Semantics(
                button: true,
                enabled: !isClearingErrors,
                label: isClearingErrors ? 'Clearing logs' : 'Clean Logs',
                child: TextButton.icon(
                  onPressed: () {
                    if (!isClearingErrors) onCleanLogs();
                  },
                  icon: const Icon(Icons.cleaning_services_outlined),
                  label: Text(
                    'Clean Logs',
                    style: tx.button.copyWith(color: c.textPrimary),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sp.md),

          /// STAT CHIPS
          Wrap(
            spacing: sp.md,
            runSpacing: sp.md,
            children: [
              _buildErrorStatChip(
                context,
                label: 'Total Errors',
                value: totalErrors.toString(),
                icon: Icons.warning_amber_outlined,
                color: c.error,
              ),
              _buildErrorStatChip(
                context,
                label: 'Last 24h',
                value: last24h.toString(),
                icon: Icons.timer_outlined,
                color: c.warning,
              ),
              _buildErrorStatChip(
                context,
                label: 'Tracked Screens',
                value: screenBreakdown.length.toString(),
                icon: Icons.devices_other,
                color: c.info,
              ),
            ],
          ),
          SizedBox(height: sp.lg),

          /// BREAKDOWN SECTIONS
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
          SizedBox(height: sp.lg),

          /// RECENT LOGS
          Text(
            'Recent Events',
            style: tx.heading4.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: sp.sm),
          if (recentLogs.isEmpty)
            Text(
              'No recent error logs available.',
              style: tx.bodySmall.copyWith(color: c.textSecondary),
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
                final severity = log['severity']?.toString() ?? 'medium';
                final errorCode = log['error_code']?.toString() ?? '';
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SeverityBadge(severity: severity, compact: true),
                  onTap: () => onShowLogDetails(log),
                  title: Row(
                    children: [
                      if (errorCode.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: sp.xs,
                            vertical: sp.xs,
                          ),
                          decoration: BoxDecoration(
                            color: c.surfaceVariant,
                            borderRadius: BorderRadius.circular(sh.radiusSm),
                          ),
                          child: Text(
                            errorCode,
                            style: tx.overline.copyWith(
                              fontWeight: tx.bodyBold.fontWeight,
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: sp.sm),
                      ],
                      Expanded(
                        child: Text(
                          log['error_message'] ?? 'Unknown error',
                          overflow: AppLayout.textOverflowEllipsis,
                          maxLines: 2,
                          style: tx.body.copyWith(color: c.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${log['platform'] ?? 'unknown'} • '
                    '${log['screen_name'] ?? 'Unknown screen'}\n'
                    '$timestamp',
                    style: tx.caption.copyWith(color: c.textSecondary),
                  ),
                  trailing: Column(
                    mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
                    children: [
                      Icon(Icons.devices, color: c.textSecondary),
                      Text(
                        log['device_model'] ?? 'unavailable',
                        style: tx.caption.copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
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
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      width: context.sizes.cardWidthMd,
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(sh.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Icon(icon, color: color),
          SizedBox(height: sp.sm),
          Text(value, style: tx.heading3.copyWith(color: c.textPrimary)),
          Text(label, style: tx.bodySmall.copyWith(color: c.textSecondary)),
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
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(title, style: tx.bodyBold.copyWith(color: c.textPrimary)),
        SizedBox(height: sp.sm),
        ...data
            .take(5)
            .map(
              (item) => Padding(
                padding: EdgeInsets.symmetric(vertical: sp.xs),
                child: Row(
                  mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
                  children: [
                    Expanded(
                      child: useSeverityBadge
                          ? SeverityBadge(
                              severity: item[labelKey]?.toString() ?? 'medium',
                              compact: false,
                            )
                          : Text(
                              item[labelKey]?.toString() ?? 'Unknown',
                              overflow: AppLayout.textOverflowEllipsis,
                              style: tx.body.copyWith(color: c.textPrimary),
                            ),
                    ),
                    Text(
                      '${item[countKey] ?? 0} hits',
                      style: tx.bodyBold.copyWith(color: c.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
        SizedBox(height: sp.lg),
      ],
    );
  }
}
