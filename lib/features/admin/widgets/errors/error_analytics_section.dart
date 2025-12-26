// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Fully theme-based, no deprecated typography or colors.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:intl/intl.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/buttons/common_outlined_button.dart';

import '../../models/error_analytics.dart';
import '../../models/error_log_entry.dart';
import '../../models/label_count.dart';
import 'severity_badge.dart';

/// Error analytics dashboard widget for admin panel
class ErrorAnalyticsSection extends StatelessWidget {
  final ErrorAnalytics analytics;
  final bool isClearingErrors;
  final VoidCallback onCleanLogs;
  final void Function(ErrorLogEntry) onShowLogDetails;
  const ErrorAnalyticsSection({
    required this.analytics,
    required this.isClearingErrors,
    required this.onCleanLogs,
    required this.onShowLogDetails,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final totalErrors = analytics.totalErrors;
    final last24h = analytics.last24h;
    final platformBreakdown = analytics.platformBreakdown;
    final screenBreakdown = analytics.screenBreakdown;
    final messageBreakdown = analytics.messageBreakdown;
    final severityBreakdown = analytics.severityBreakdown;
    final errorCodeBreakdown = analytics.errorCodeBreakdown;
    final recentLogs = analytics.recentLogs;
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
                child: CommonOutlinedButton(
                  label: 'Clean Logs',
                  icon: Icons.cleaning_services_outlined,
                  height: context.sizes.buttonHeightSm,
                  isEnabled: !isClearingErrors,
                  onPressed: onCleanLogs,
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
            ),
          if (screenBreakdown.isNotEmpty)
            _buildBreakdownSection(
              context: context,
              title: 'Top Screens',
              data: screenBreakdown,
            ),
          if (messageBreakdown.isNotEmpty)
            _buildBreakdownSection(
              context: context,
              title: 'Frequent Errors',
              data: messageBreakdown,
            ),
          if (severityBreakdown.isNotEmpty)
            _buildBreakdownSection(
              context: context,
              title: 'By Severity',
              data: severityBreakdown,
              useSeverityBadge: true,
            ),
          if (errorCodeBreakdown.isNotEmpty)
            _buildBreakdownSection(
              context: context,
              title: 'By Error Code',
              data: errorCodeBreakdown,
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
                final createdAt = log.createdAt;
                final timestamp = createdAt != null
                    ? DateFormat('MMM dd, HH:mm').format(createdAt)
                    : 'Unknown time';
                final severity = log.severity;
                final errorCode = log.errorCode ?? '';
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
                          log.errorMessage ?? 'Unknown error',
                          overflow: AppLayout.textOverflowEllipsis,
                          maxLines: 2,
                          style: tx.body.copyWith(color: c.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${log.platform ?? 'unknown'} • '
                    '${log.screenName ?? 'Unknown screen'}\n'
                    '$timestamp',
                    style: tx.caption.copyWith(color: c.textSecondary),
                  ),
                  trailing: Column(
                    mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
                    children: [
                      Icon(Icons.devices, color: c.textSecondary),
                      Text(
                        log.deviceModel ?? 'unavailable',
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
        color: color.withValues(alpha: context.opacities.veryLow),
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
    required List<LabelCount> data,
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
                          ? SeverityBadge(severity: item.label, compact: false)
                          : Text(
                              item.label,
                              overflow: AppLayout.textOverflowEllipsis,
                              style: tx.body.copyWith(color: c.textPrimary),
                            ),
                    ),
                    Text(
                      '${item.count} hits',
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
