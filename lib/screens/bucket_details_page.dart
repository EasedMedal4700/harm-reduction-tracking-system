import 'package:flutter/material.dart';
import '../models/bucket_definitions.dart';
import '../models/tolerance_model.dart';
import '../constants/theme_constants.dart';
import '../constants/ui_colors.dart';

/// Detailed page showing bucket-specific tolerance information
/// Displays: decay graph, contributing uses, notes, days to baseline
class BucketDetailsPage extends StatelessWidget {
  final String bucketType;
  final NeuroBucket bucket;
  final double tolerancePercent; // 0–100
  final double rawLoad;
  final List<UseLogEntry> contributingUses;
  final double daysToBaseline;
  final String? substanceNotes;

  const BucketDetailsPage({
    super.key,
    required this.bucketType,
    required this.bucket,
    required this.tolerancePercent,
    required this.rawLoad,
    required this.contributingUses,
    required this.daysToBaseline,
    this.substanceNotes,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? UIColors.darkBackground : UIColors.lightBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(BucketDefinitions.getDisplayName(bucketType)),
        backgroundColor: isDark ? UIColors.darkSurface : Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ThemeConstants.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildHeaderCard(isDark),
            SizedBox(height: ThemeConstants.space16),

            // Description
            _buildDescriptionCard(isDark),
            SizedBox(height: ThemeConstants.space16),

            // Current status
            _buildStatusCard(isDark),
            SizedBox(height: ThemeConstants.space16),

            // Decay timeline (visual representation)
            _buildDecayTimelineCard(isDark),
            SizedBox(height: ThemeConstants.space16),

            // Contributing uses
            if (contributingUses.isNotEmpty) ...[
              _buildContributingUsesCard(isDark),
              SizedBox(height: ThemeConstants.space16),
            ],

            // Substance-specific notes
            if (substanceNotes != null && substanceNotes!.isNotEmpty) ...[
              _buildNotesCard(isDark),
              SizedBox(height: ThemeConstants.space16),
            ],

            // Days to baseline
            _buildBaselineCard(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ThemeConstants.space12),
            decoration: BoxDecoration(
              color: _getColorForTolerance(tolerancePercent / 100.0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
            ),
            child: Icon(
              _getBucketIcon(),
              color: _getColorForTolerance(tolerancePercent / 100.0),
              size: 32,
            ),
          ),
          SizedBox(width: ThemeConstants.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  BucketDefinitions.getDisplayName(bucketType),
                  style: TextStyle(
                    fontSize: ThemeConstants.fontLarge,
                    fontWeight: ThemeConstants.fontBold,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                  ),
                ),
                SizedBox(height: ThemeConstants.space4),
                Text(
                  '${tolerancePercent.toStringAsFixed(1)}% Tolerance',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    fontWeight: ThemeConstants.fontSemiBold,
                    color: _getColorForTolerance(tolerancePercent / 100.0),
                  ),
                ),
              ],
            ),
          ),
          if (tolerancePercent > 0.1)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeConstants.space12,
                vertical: ThemeConstants.space8,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              ),
              child: Text(
                'ACTIVE',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontBold,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This System',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space12),
          Text(
            BucketDefinitions.getDescription(bucketType),
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Status',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          _buildStatRow(
            'Tolerance Level',
            '${tolerancePercent.toStringAsFixed(1)}%',
            isDark,
          ),
          _buildStatRow(
            'Raw Load',
            rawLoad.toStringAsFixed(4),
            isDark,
          ),
          _buildStatRow(
            'Bucket Weight',
            bucket.weight.toStringAsFixed(2),
            isDark,
          ),
          _buildStatRow(
            'Tolerance Type',
            bucket.toleranceType ?? 'unknown',
            isDark,
          ),
          _buildStatRow(
            'Status',
            tolerancePercent > 0.1 ? 'Active' : 'Inactive',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: ThemeConstants.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecayTimelineCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Decay Timeline',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          // Simple visual representation
          _buildDecayBar(isDark),
          SizedBox(height: ThemeConstants.space12),
          Text(
            tolerancePercent > 0.1
                ? 'Substance is currently active in your system. Tolerance will continue to build.'
                : 'Substance is no longer active. Tolerance is decaying naturally.',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecayBar(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: tolerancePercent.round().clamp(0, 100),
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: _getColorForTolerance(tolerancePercent / 100.0),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(ThemeConstants.radiusSmall),
                    right: tolerancePercent >= 100.0
                        ? Radius.circular(ThemeConstants.radiusSmall)
                        : Radius.zero,
                  ),
                ),
              ),
            ),
            if (tolerancePercent < 100.0)
              Expanded(
                flex: (100.0 - tolerancePercent).round().clamp(0, 100),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(ThemeConstants.radiusSmall),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: ThemeConstants.space8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0%',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
            ),
            Text(
              '100%',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContributingUsesCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contributing Uses',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space12),
          ...contributingUses.take(10).map((use) {
            final timeAgo = DateTime.now().difference(use.timestamp);
            return Padding(
              padding: EdgeInsets.only(bottom: ThemeConstants.space8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatTimeAgo(timeAgo),
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '${use.doseUnits.toStringAsFixed(1)} units',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      fontWeight: ThemeConstants.fontMediumWeight,
                      color: isDark ? UIColors.darkText : UIColors.lightText,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (contributingUses.length > 10)
            Text(
              '...and ${contributingUses.length - 10} more',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              SizedBox(width: ThemeConstants.space8),
              Text(
                'Notes',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space12),
          Text(
            substanceNotes!,
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaselineCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            size: 24,
          ),
          SizedBox(width: ThemeConstants.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Days to Baseline',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSmall,
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  ),
                ),
                SizedBox(height: ThemeConstants.space4),
                Text(
                  daysToBaseline < 0.1
                      ? 'At baseline'
                      : '${daysToBaseline.toStringAsFixed(1)} days',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    fontWeight: ThemeConstants.fontBold,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBucketIcon() {
    final iconName = BucketDefinitions.getIconName(bucketType);
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

  Color _getColorForTolerance(double tolerance) {
    if (tolerance < 0.25) return Colors.green;
    if (tolerance < 0.5) return Colors.yellow.shade700;
    if (tolerance < 0.75) return Colors.orange;
    return Colors.red;
  }

  String _formatTimeAgo(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
