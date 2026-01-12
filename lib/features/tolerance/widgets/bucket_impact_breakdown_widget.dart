// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Widget for showing individual logs impact breakdown

import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../models/tolerance_models.dart';
import 'package:intl/intl.dart';

class BucketImpactBreakdownWidget extends StatelessWidget {
  final String bucketType;
  final List<UseLogEntry> relevantLogs;
  final Map<String, double> logImpacts;

  const BucketImpactBreakdownWidget({
    super.key,
    required this.bucketType,
    required this.relevantLogs,
    required this.logImpacts,
  });

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = th.colors;
    final sp = th.sp;
    final tx = th.text;

    if (relevantLogs.isEmpty) {
      return Center(
        child: Text(
          'No history available',
          style: tx.bodyMedium.copyWith(color: c.textSecondary),
        ),
      );
    }

    final sortedLogs = List<UseLogEntry>.from(relevantLogs)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: sp.xs),
          child: Text(
            'History Breakdown',
            style: tx.bodyBold.copyWith(color: c.textPrimary),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedLogs.length,
          separatorBuilder: (_, __) => CommonSpacer.vertical(sp.xs),
          itemBuilder: (context, index) {
            final log = sortedLogs[index];
            final impact = logImpacts[log.timestamp.toIso8601String()] ?? 0.0;

            // Format impact for display (e.g. "5.2%")
            final impactStr = '${impact.toStringAsFixed(1)}%';

            return _ImpactRow(
              log: log,
              impactStr: impactStr,
              isHighImpact: impact > 10.0,
            );
          },
        ),
      ],
    );
  }
}

class _ImpactRow extends StatelessWidget {
  final UseLogEntry log;
  final String impactStr;
  final bool isHighImpact;

  const _ImpactRow({
    required this.log,
    required this.impactStr,
    required this.isHighImpact,
  });

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = th.colors;
    final ac = th.accent;
    final sp = th.sp;
    final tx = th.text;

    final dateStr = DateFormat.MMMd().format(log.timestamp);
    final timeStr = DateFormat.jm().format(log.timestamp);

    return Container(
      padding: EdgeInsets.all(sp.sm),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(th.shapes.radiusSm),
        border: Border.all(
          color: c.border.withValues(alpha: isHighImpact ? 0.8 : 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${log.doseUnits} ${log.substanceSlug}', // ideally standardized unit
                  style: tx.bodyBold.copyWith(color: c.textPrimary),
                ),
                Text(
                  '$dateStr at $timeStr',
                  style: tx.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: sp.sm,
              vertical: sp.xs / 2,
            ),
            decoration: BoxDecoration(
              color: isHighImpact
                  ? c.error.withValues(alpha: 0.1)
                  : ac.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(th.shapes.radiusXs),
            ),
            child: Text(
              'm: $impactStr',
              style: tx.captionBold.copyWith(
                color: isHighImpact ? c.error : ac.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
