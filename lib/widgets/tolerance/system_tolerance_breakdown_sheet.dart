import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';
import '../../services/tolerance_engine_service.dart';
import '../../services/user_service.dart';

class SystemToleranceBreakdownSheet extends StatefulWidget {
  final String bucketName;
  final double currentPercent;
  final Color accentColor;

  const SystemToleranceBreakdownSheet({
    required this.bucketName,
    required this.currentPercent,
    required this.accentColor,
    super.key,
  });

  @override
  State<SystemToleranceBreakdownSheet> createState() =>
      _SystemToleranceBreakdownSheetState();
}

class _SystemToleranceBreakdownSheetState
    extends State<SystemToleranceBreakdownSheet> {
  bool _isLoading = true;
  List<ToleranceContribution> _contributions = [];

  @override
  void initState() {
    super.initState();
    _loadBreakdown();
  }

  Future<void> _loadBreakdown() async {
    try {
      final userId = await UserService.getIntegerUserId();
      final data = await ToleranceEngineService.getBucketBreakdown(
        userId: userId,
        bucketName: widget.bucketName,
      );
      if (mounted) {
        setState(() {
          _contributions = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? UIColors.darkBackground
        : UIColors.lightBackground;
    final surfaceColor = isDark ? UIColors.darkSurface : UIColors.lightSurface;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusExtraLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getBucketIcon(widget.bucketName),
                    color: widget.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatBucketName(widget.bucketName),
                        style: TextStyle(
                          fontSize: ThemeConstants.fontXLarge,
                          fontWeight: ThemeConstants.fontBold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '${widget.currentPercent.toStringAsFixed(1)}% Load',
                        style: TextStyle(
                          fontSize: ThemeConstants.fontMedium,
                          color: widget.accentColor,
                          fontWeight: ThemeConstants.fontSemiBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          Flexible(
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _contributions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No recent contributors found.',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(
                      ThemeConstants.cardPaddingMedium,
                    ),
                    itemCount: _contributions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = _contributions[index];
                      return _buildContributionRow(
                        item,
                        textColor,
                        secondaryTextColor,
                        surfaceColor,
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContributionRow(
    ToleranceContribution item,
    Color textColor,
    Color secondaryTextColor,
    Color surfaceColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.substanceName,
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: item.percentContribution / 100,
                  backgroundColor: surfaceColor,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.accentColor),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${item.percentContribution.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                fontWeight: ThemeConstants.fontBold,
                color: textColor,
              ),
            ),
            Text(
              'Impact',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getBucketIcon(String bucket) {
    switch (bucket.toLowerCase()) {
      case 'gaba':
        return Icons.psychology;
      case 'stimulant':
        return Icons.bolt;
      case 'serotonin':
        return Icons.sentiment_satisfied_alt;
      case 'opioid':
        return Icons.medication;
      case 'nmda':
        return Icons.blur_on;
      case 'cannabinoid':
        return Icons.eco;
      default:
        return Icons.science;
    }
  }

  String _formatBucketName(String bucket) {
    switch (bucket.toLowerCase()) {
      case 'gaba':
        return 'GABA System';
      case 'stimulant':
        return 'Stimulant System';
      case 'serotonin':
        return 'Serotonin System';
      case 'opioid':
        return 'Opioid System';
      case 'nmda':
        return 'NMDA System';
      case 'cannabinoid':
        return 'Cannabinoid System';
      default:
        return bucket.toUpperCase();
    }
  }
}
