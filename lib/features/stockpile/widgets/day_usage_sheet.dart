// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod complete.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/features/stockpile/controllers/day_usage_controller.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/day_usage_models.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';
import 'package:mobile_drug_use_app/common/feedback/common_loader.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';

const double _handleWidth = 40.0;

class DayUsageSheet extends ConsumerStatefulWidget {
  final String substanceName;
  final int weekdayIndex;
  final String dayName;
  final Color accentColor;
  const DayUsageSheet({
    super.key,
    required this.substanceName,
    required this.weekdayIndex,
    required this.dayName,
    required this.accentColor,
  });
  @override
  ConsumerState<DayUsageSheet> createState() => _DayUsageSheetState();
}

class _DayUsageSheetState extends ConsumerState<DayUsageSheet> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final th = context.theme;

    final asyncEntries = ref.watch(
      dayUsageControllerProvider(
        substanceName: widget.substanceName,
        weekdayIndex: widget.weekdayIndex,
      ),
    );

    ref.listen<AsyncValue<List<DayUsageEntry>>>(
      dayUsageControllerProvider(
        substanceName: widget.substanceName,
        weekdayIndex: widget.weekdayIndex,
      ),
      (prev, next) {
        final prevErr = prev?.asError?.error;
        final nextErr = next.asError?.error;
        if (nextErr != null && prevErr != nextErr) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load usage data: $nextErr')),
            );
          });
        }
      },
    );

    final allEntries = asyncEntries.value ?? const <DayUsageEntry>[];
    final displayEntries = _showAll || allEntries.length <= 10
        ? allEntries
        : allEntries.take(10).toList();
    return Container(
      decoration: BoxDecoration(
        color: th.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(th.shapes.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: th.spacing.sm),
            width: _handleWidth,
            height: th.spacing.xs,
            decoration: BoxDecoration(
              color: th.colors.border,
              borderRadius: BorderRadius.circular(th.shapes.radiusXs / 2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(th.spacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(th.spacing.xs),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.accentColor,
                            widget.accentColor.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(th.shapes.radiusMd),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: th.isDark
                            ? th.colors.textPrimary
                            : th.colors.surface,
                        size: th.sizes.iconMd,
                      ),
                    ),
                    CommonSpacer(width: th.spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                        children: [
                          Text(
                            widget.substanceName,
                            style: th.typography.heading3.copyWith(
                              fontWeight: tx.bodyBold.fontWeight,
                            ),
                          ),
                          Text(
                            '${widget.dayName} Usage History',
                            style: th.typography.body.copyWith(
                              color: th.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: th.colors.textSecondary,
                    ),
                  ],
                ),
                CommonSpacer(height: th.spacing.xs),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: th.spacing.sm,
                    vertical: th.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(th.shapes.radiusMd),
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${allEntries.length} ${allEntries.length == 1 ? 'use' : 'uses'} on ${widget.dayName}s',
                    style: th.typography.bodySmall.copyWith(
                      fontWeight: tx.bodyBold.fontWeight,
                      color: widget.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List of entries
          if (asyncEntries.isLoading)
            Padding(
              padding: EdgeInsets.all(th.spacing.xl),
              child: const CommonLoader(),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: th.spacing.lg),
                itemCount: displayEntries.length,
                itemBuilder: (context, index) {
                  final entry = displayEntries[index];
                  final startTime = entry.startTime;
                  final dose = entry.dose;
                  final route = entry.route;
                  final isMedical = entry.isMedical;
                  return Container(
                    margin: EdgeInsets.only(bottom: th.spacing.xs),
                    padding: EdgeInsets.all(th.spacing.sm),
                    decoration: BoxDecoration(
                      color: th.colors.background.withValues(
                        alpha: th.isDark ? 0.5 : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(th.shapes.radiusMd),
                      border: Border.all(color: th.colors.border),
                    ),
                    child: Row(
                      children: [
                        // Time
                        SizedBox(
                          width: 60,
                          child: Column(
                            crossAxisAlignment:
                                AppLayout.crossAxisAlignmentStart,
                            children: [
                              Text(
                                DateFormat('HH:mm').format(startTime),
                                style: th.typography.body.copyWith(
                                  fontWeight: tx.bodyBold.fontWeight,
                                  color: widget.accentColor,
                                ),
                              ),
                              Text(
                                DateFormat('MMM d').format(startTime),
                                style: th.typography.caption.copyWith(
                                  color: th.colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CommonSpacer(width: th.spacing.sm),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                AppLayout.crossAxisAlignmentStart,
                            children: [
                              Text(
                                dose,
                                style: th.typography.body.copyWith(
                                  fontWeight: tx.bodyBold.fontWeight,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.route,
                                    size: th.sizes.iconSm,
                                    color: th.colors.textSecondary,
                                  ),
                                  CommonSpacer(width: th.spacing.xs / 2),
                                  Text(
                                    route,
                                    style: th.typography.bodySmall.copyWith(
                                      color: th.colors.textSecondary,
                                    ),
                                  ),
                                  if (isMedical) ...[
                                    CommonSpacer(width: th.spacing.xs),
                                    Icon(
                                      Icons.medical_services,
                                      size: th.sizes.iconSm,
                                      color: th.colors.success,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          // "Show All" button if more than 10
          if (!_showAll && allEntries.length > 10)
            Padding(
              padding: EdgeInsets.all(th.spacing.md),
              child: CommonPrimaryButton(
                onPressed: () {
                  setState(() {
                    _showAll = true;
                  });
                },
                backgroundColor: widget.accentColor,
                textColor: th.isDark
                    ? th.colors.textPrimary
                    : th.colors.surface,
                label: 'Show All ${allEntries.length} Uses',
              ),
            ),
          CommonSpacer(height: th.spacing.md),
        ],
      ),
    );
  }
}
