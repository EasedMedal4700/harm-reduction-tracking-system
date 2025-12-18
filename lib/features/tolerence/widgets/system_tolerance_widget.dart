
// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Uses some theme extensions, but not fully migrated or Riverpod integrated.

import 'package:flutter/material.dart';

import '../../../models/tolerance_model.dart';
import '../../../models/bucket_definitions.dart';
import '../../../services/tolerance_engine_service.dart';
import '../../../services/user_service.dart';

import '../../../constants/theme/app_theme_extension.dart';
import 'tolerance/system_tolerance_breakdown_sheet.dart';


/// Model for system tolerance
class SystemToleranceData {
  final Map<String, double> percents;
  final Map<String, ToleranceSystemState> states;

  SystemToleranceData(this.percents, this.states);
}

/// Load system tolerance data for the current user
Future<SystemToleranceData> loadSystemToleranceData() async {
  final userId = UserService.getCurrentUserId();
  final report = await ToleranceEngineService.getToleranceReport(
    userId: userId,
  );
  return SystemToleranceData(report.tolerances, report.states);
}

/// Main widget
class SystemToleranceWidget extends StatelessWidget {
  final SystemToleranceData data;

  const SystemToleranceWidget({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.spacing.lg),
        border: Border.all(
          color: t.colors.border,
          width: 1,
        ),
        boxShadow: t.cardShadow,
      ),
      padding: EdgeInsets.all(t.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            'System Tolerance',
            style: t.typography.heading4.copyWith(
              color: t.colors.textPrimary,
            ),
          ),

          SizedBox(height: t.spacing.lg),

          // ALL 7 BUCKETS
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: BucketDefinitions.orderedBuckets.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: t.colors.divider,
            ),
            itemBuilder: (context, index) {
              final bucket = BucketDefinitions.orderedBuckets[index];
              final percent = data.percents[bucket] ?? 0.0;
              final state =
                  data.states[bucket] ?? ToleranceSystemState.recovered;

              return _buildBucketRow(context, bucket, percent, state);
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ROW BUILDER
  // ---------------------------------------------------------------------------

  Widget _buildBucketRow(
    BuildContext context,
    String bucket,
    double percent,
    ToleranceSystemState state,
  ) {
    final t = context.theme;

    // Value color logic
    Color valueColor;
    if (percent < 10) {
      valueColor = t.colors.textSecondary;
    } else if (percent < 40) {
      valueColor = Colors.orangeAccent;
    } else {
      valueColor = Colors.redAccent;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(t.spacing.sm),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => SystemToleranceBreakdownSheet(
            bucketName: bucket,
            currentPercent: percent,
            accentColor: _getStateColor(state),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: t.spacing.md,
          horizontal: t.spacing.xs,
        ),
        child: Row(
          children: [
            Icon(
              _getBucketIcon(bucket),
              size: 20,
              color: t.colors.textSecondary,
            ),
            SizedBox(width: t.spacing.sm),

            // Bucket Name
            Expanded(
              child: Text(
                BucketDefinitions.getDisplayName(bucket),
                style: t.typography.body.copyWith(
                  color: t.colors.textPrimary,
                ),
              ),
            ),

            // Percent text
            Text(
              '${percent.toStringAsFixed(1)}%',
              style: t.typography.bodyBold.copyWith(color: valueColor),
            ),

            SizedBox(width: t.spacing.sm),

            // Badge
            _buildStateBadge(context, state),

            SizedBox(width: t.spacing.xs),

            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: t.colors.textSecondary.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BADGE BUILDER
  // ---------------------------------------------------------------------------

  Widget _buildStateBadge(BuildContext context, ToleranceSystemState state) {
    final t = context.theme;
    final color = _getStateColor(state);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        state.displayName,
        style: t.typography.captionBold.copyWith(color: color),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  IconData _getBucketIcon(String bucket) {
    final icon = BucketDefinitions.getIconName(bucket);
    switch (icon) {
      case 'psychology':
        return Icons.psychology;
      case 'bolt':
        return Icons.bolt;
      case 'favorite':
        return Icons.favorite;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'sentiment_satisfied_alt':
        return Icons.sentiment_satisfied_alt;
      case 'medication':
        return Icons.medication;
      case 'blur_on':
        return Icons.blur_on;
      case 'eco':
        return Icons.eco;
      default:
        return Icons.science;
    }
  }

  Color _getStateColor(ToleranceSystemState state) {
    switch (state) {
      case ToleranceSystemState.recovered:
        return Colors.greenAccent;
      case ToleranceSystemState.lightStress:
        return Colors.lightBlueAccent;
      case ToleranceSystemState.moderateStrain:
        return Colors.orangeAccent;
      case ToleranceSystemState.highStrain:
        return Colors.deepOrangeAccent;
      case ToleranceSystemState.depleted:
        return Colors.redAccent;
    }
  }
}
