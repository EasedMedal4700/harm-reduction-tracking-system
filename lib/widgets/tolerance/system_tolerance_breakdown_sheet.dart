// MIGRATION

import 'package:flutter/material.dart';
import '../../services/tolerance_engine_service.dart';
import '../../services/user_service.dart';
import '../../constants/theme/app_theme_extension.dart';

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
      final userId = UserService.getCurrentUserId();
      final data = await ToleranceEngineService.getBucketBreakdown(
        userId: userId,
        bucketName: widget.bucketName,
      );
      if (!mounted) return;
      setState(() {
        _contributions = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(t.shapes.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// --- Drag handle ---
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: t.spacing.md,
                bottom: t.spacing.sm,
              ),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.textSecondary.withOpacity(0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          /// --- Header ---
          Padding(
            padding: EdgeInsets.all(t.spacing.lg),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(t.spacing.sm),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                  ),
                  child: Icon(
                    _getBucketIcon(widget.bucketName),
                    color: widget.accentColor,
                    size: 26,
                  ),
                ),
                SizedBox(width: t.spacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatBucketName(widget.bucketName),
                        style: t.typography.heading3.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      Text(
                        '${widget.currentPercent.toStringAsFixed(1)}% Load',
                        style: t.typography.bodyBold.copyWith(
                          color: widget.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(color: c.divider, height: 1),

          /// --- Content ---
          Flexible(
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _contributions.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(t.spacing.xl),
                        child: Text(
                          'No recent contributors found.',
                          style: t.typography.bodySmall.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(t.spacing.lg),
                        itemCount: _contributions.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: t.spacing.lg),
                        itemBuilder: (_, index) {
                          return _buildContributionRow(
                            context,
                            _contributions[index],
                          );
                        },
                      ),
          ),

          SizedBox(height: t.spacing.xl),
        ],
      ),
    );
  }

  Widget _buildContributionRow(
    BuildContext context,
    ToleranceContribution item,
  ) {
    final t = context.theme;
    final c = context.colors;

    return Row(
      children: [
        /// --- Left side: Name + progress bar ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.substanceName,
                style: t.typography.bodyBold.copyWith(
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: t.spacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(t.shapes.radiusSm),
                child: LinearProgressIndicator(
                  value: item.percentContribution / 100,
                  backgroundColor: c.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.accentColor),
                  minHeight: 7,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: t.spacing.lg),

        /// --- Right side: percentage ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${item.percentContribution.toStringAsFixed(1)}%',
              style: t.typography.bodyBold.copyWith(
                color: c.textPrimary,
              ),
            ),
            Text(
              'Impact',
              style: t.typography.caption.copyWith(
                color: c.textSecondary,
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
