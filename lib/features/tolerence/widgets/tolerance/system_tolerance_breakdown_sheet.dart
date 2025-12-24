// System Tolerance Breakdown Sheet Widget
//
// Created: 2024-03-15
// Last Modified: 2025-01-23
//
// Purpose:
// Displays a bottom sheet showing detailed breakdown of substances contributing
// to a specific neurochemical bucket's tolerance load. Shows each substance's
// percentage contribution with visual progress bars.
//
// Features:
// - Drag handle for swipe-to-dismiss gesture
// - Bucket header with icon, name, and current tolerance percentage
// - Loading state during data fetch
// - Empty state when no contributors found
// - Scrollable list of contributing substances
// - Progress bars showing each substance's impact percentage
// - Bucket-specific icon mapping (GABA, Stimulant, Serotonin, etc.)
// - Accent color theming per bucket
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully modernized theme API. StatefulWidget kept due to async loading state.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../services/tolerance_engine_service.dart';
import '../../../../services/user_service.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/feedback/common_loader.dart';

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
    // THEME ACCESS
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    final sz = context.sizes;
    // BOTTOM SHEET CONTAINER
    return Container(
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(sh.radiusLg)),
      ),
      child: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          // DRAG HANDLE - Visual indicator for swipe gesture
          Center(
            child: Container(
              margin: EdgeInsets.only(top: sp.md, bottom: sp.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.textSecondary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(sh.radiusXs / 2),
              ),
            ),
          ),
          // HEADER - Bucket icon, name, and tolerance percentage
          Padding(
            padding: EdgeInsets.all(sp.lg),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(sp.sm),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                  ),
                  child: Icon(
                    _getBucketIcon(widget.bucketName),
                    color: widget.accentColor,
                    size: sz.iconMd,
                  ),
                ),
                CommonSpacer.horizontal(sp.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                    children: [
                      Text(
                        _formatBucketName(widget.bucketName),
                        style: tx.heading3.copyWith(color: c.textPrimary),
                      ),
                      Text(
                        '${widget.currentPercent.toStringAsFixed(1)}% Load',
                        style: tx.bodyBold.copyWith(color: widget.accentColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: c.divider, height: 1),
          // CONTENT - Loading, empty, or contribution list
          Flexible(
            child: _isLoading
                // Loading state
                ? Padding(
                    padding: EdgeInsets.all(sp.xl2),
                    child: const Center(child: CommonLoader()),
                  )
                : _contributions.isEmpty
                // Empty state
                ? Padding(
                    padding: EdgeInsets.all(sp.xl),
                    child: Text(
                      'No recent contributors found.',
                      style: tx.bodySmall.copyWith(color: c.textSecondary),
                    ),
                  )
                // Contribution list
                : ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(sp.lg),
                    itemCount: _contributions.length,
                    separatorBuilder: (_, __) => CommonSpacer.vertical(sp.lg),
                    itemBuilder: (_, index) {
                      return _buildContributionRow(
                        context,
                        _contributions[index],
                      );
                    },
                  ),
          ),
          CommonSpacer.vertical(sp.xl),
        ],
      ),
    );
  }

  /// Builds a single contribution row showing substance name, progress bar,
  /// and percentage impact on the bucket.
  Widget _buildContributionRow(
    BuildContext context,
    ToleranceContribution item,
  ) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Row(
      children: [
        // LEFT SIDE - Substance name and progress bar
        Expanded(
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text(
                item.substanceName,
                style: tx.bodyBold.copyWith(color: c.textPrimary),
              ),
              CommonSpacer.vertical(sp.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(sh.radiusSm),
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
        CommonSpacer.horizontal(sp.lg),
        // RIGHT SIDE - Percentage impact
        Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentEnd,
          children: [
            Text(
              '${item.percentContribution.toStringAsFixed(1)}%',
              style: tx.bodyBold.copyWith(color: c.textPrimary),
            ),
            Text('Impact', style: tx.caption.copyWith(color: c.textSecondary)),
          ],
        ),
      ],
    );
  }

  /// Maps bucket name to appropriate icon.
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

  /// Formats bucket name for display (e.g., 'gaba' → 'GABA System').
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
