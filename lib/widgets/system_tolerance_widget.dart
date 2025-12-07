import 'package:flutter/material.dart';
import '../models/tolerance_model.dart';
import '../models/bucket_definitions.dart';
import '../services/tolerance_engine_service.dart';
import '../services/user_service.dart';
import '../constants/deprecated/theme_constants.dart';
import '../constants/deprecated/ui_colors.dart';
import 'tolerance/system_tolerance_breakdown_sheet.dart';

/// Simple data holder for system tolerance display
class SystemToleranceData {
  final Map<String, double> percents;
  final Map<String, ToleranceSystemState> states;

  SystemToleranceData(this.percents, this.states);
}

/// Load system tolerance data for current user
Future<SystemToleranceData> loadSystemToleranceData() async {
  final userId = UserService.getCurrentUserId();
  final report = await ToleranceEngineService.getToleranceReport(
    userId: userId,
  );
  return SystemToleranceData(report.tolerances, report.states);
}

/// Widget to display system-wide tolerance with interactivity
class SystemToleranceWidget extends StatelessWidget {
  final SystemToleranceData data;

  const SystemToleranceWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? UIColors.darkSurface : Colors.white;
    final borderColor = isDark
        ? UIColors.darkBorder
        : Colors.black.withOpacity(0.05);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        side: BorderSide(color: borderColor),
      ),
      color: backgroundColor,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Tolerance',
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                fontWeight: ThemeConstants.fontBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            const SizedBox(height: ThemeConstants.space16),
            // CRITICAL: Render ALL 7 canonical buckets in order
            // Show "Recovered 0.0%" for buckets not in data
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: BucketDefinitions.orderedBuckets.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDark ? UIColors.darkDivider : UIColors.lightDivider,
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
      ),
    );
  }

  Widget _buildBucketRow(
    BuildContext context,
    String bucket,
    double percent,
    ToleranceSystemState state,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

    // Determine color based on intensity
    Color valueColor;
    if (percent < 10) {
      valueColor = secondaryTextColor; // Neutral
    } else if (percent < 40) {
      valueColor = Colors.orange; // Warning
    } else {
      valueColor = Colors.red; // Critical
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SystemToleranceBreakdownSheet(
            bucketName: bucket,
            currentPercent: percent,
            accentColor: _getStateColor(state),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // Icon
            Icon(_getBucketIcon(bucket), size: 20, color: secondaryTextColor),
            const SizedBox(width: 12),

            // Name
            Expanded(
              child: Text(
                _formatBucketName(bucket),
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontMediumWeight,
                  color: textColor,
                ),
              ),
            ),

            // Value
            Text(
              '${percent.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                fontWeight: ThemeConstants.fontBold,
                color: valueColor,
              ),
            ),
            const SizedBox(width: 8),

            // Badge
            _buildStateBadge(state, isDark),

            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: secondaryTextColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateBadge(ToleranceSystemState state, bool isDark) {
    if (state == ToleranceSystemState.recovered) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.green.withOpacity(0.1)
              : Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.green.withOpacity(0.3)
                : Colors.green.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Text(
          'Recovered',
          style: TextStyle(
            fontSize: 10,
            fontWeight: ThemeConstants.fontMediumWeight,
            color: isDark ? Colors.greenAccent : Colors.green[700],
          ),
        ),
      );
    }

    // For other states, we can just show the text or a different badge
    // But per requirements, we mainly wanted to replace "Recovered" text with a badge
    // Let's use badges for all for consistency

    Color color = _getStateColor(state);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        state.displayName,
        style: TextStyle(
          fontSize: 10,
          fontWeight: ThemeConstants.fontMediumWeight,
          color: color,
        ),
      ),
    );
  }

  IconData _getBucketIcon(String bucket) {
    final iconName = BucketDefinitions.getIconName(bucket);
    switch (iconName) {
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

  String _formatBucketName(String bucket) {
    return BucketDefinitions.getDisplayName(bucket);
  }

  Color _getStateColor(ToleranceSystemState state) {
    switch (state) {
      case ToleranceSystemState.recovered:
        return Colors.green;
      case ToleranceSystemState.lightStress:
        return Colors.blue;
      case ToleranceSystemState.moderateStrain:
        return Colors.orange;
      case ToleranceSystemState.highStrain:
        return Colors.deepOrange;
      case ToleranceSystemState.depleted:
        return Colors.red;
    }
  }
}
