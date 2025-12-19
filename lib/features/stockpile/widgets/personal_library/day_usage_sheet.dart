// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/feedback/common_loader.dart';
import '../../../../common/buttons/common_primary_button.dart';

class DayUsageSheet extends StatefulWidget {
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
  State<DayUsageSheet> createState() => _DayUsageSheetState();
}

class _DayUsageSheetState extends State<DayUsageSheet> {
  List<Map<String, dynamic>> _allEntries = [];
  bool _loading = true;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final response = await Supabase.instance.client
          .from('drug_use')
          .select('start_time, dose, consumption, medical')
          .eq('name', widget.substanceName)
          .order('start_time', ascending: false);

      final entries = (response as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
          .toList();

      // Filter entries for the selected weekday (with 5am cutoff logic)
      final filteredEntries = entries.where((entry) {
        final startTime = DateTime.tryParse(
          entry['start_time']?.toString() ?? '',
        );
        if (startTime == null) return false;

        // Apply 5am cutoff for non-medical use
        final isMedical = entry['medical'] == true || entry['medical'] == 1;
        DateTime adjustedTime = startTime;

        if (!isMedical && startTime.hour < 5) {
          adjustedTime = startTime.subtract(const Duration(hours: 5));
        }

        return adjustedTime.weekday % 7 == widget.weekdayIndex;
      }).toList();

      setState(() {
        _allEntries = filteredEntries;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load usage data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final t = context.theme;
    final displayEntries = _showAll || _allEntries.length <= 10
        ? _allEntries
        : _allEntries.take(10).toList();

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(t.shapes.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: t.spacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: t.colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(t.spacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(t.spacing.xs),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.accentColor,
                            widget.accentColor.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          t.shapes.radiusMd,
                        ),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: t.sizes.iconMd,
                      ),
                    ),
                    CommonSpacer(width: t.spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                        children: [
                          Text(
                            widget.substanceName,
                            style: t.typography.heading3.copyWith(
                              fontWeight: text.bodyBold.fontWeight,
                            ),
                          ),
                          Text(
                            '${widget.dayName} Usage History',
                            style: t.typography.body.copyWith(
                              color: t.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: t.colors.textSecondary,
                    ),
                  ],
                ),
                CommonSpacer(height: t.spacing.xs),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: t.spacing.sm,
                    vertical: t.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      t.shapes.radiusMd,
                    ),
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${_allEntries.length} ${_allEntries.length == 1 ? 'use' : 'uses'} on ${widget.dayName}s',
                    style: t.typography.bodySmall.copyWith(
                      fontWeight: text.bodyBold.fontWeight,
                      color: widget.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of entries
          if (_loading)
            Padding(
              padding: EdgeInsets.all(t.spacing.xl),
              child: const CommonLoader(),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: t.spacing.lg,
                ),
                itemCount: displayEntries.length,
                itemBuilder: (context, index) {
                  final entry = displayEntries[index];
                  final startTime = DateTime.parse(entry['start_time']);
                  final dose = entry['dose']?.toString() ?? 'Unknown';
                  final route = entry['consumption']?.toString() ?? 'Unknown';
                  final isMedical =
                      entry['medical'] == true || entry['medical'] == 1;

                  return Container(
                    margin: EdgeInsets.only(bottom: t.spacing.xs),
                    padding: EdgeInsets.all(t.spacing.sm),
                    decoration: BoxDecoration(
                      color: t.colors.background.withValues(alpha: t.isDark ? 0.5 : 1.0),
                      borderRadius: BorderRadius.circular(
                        t.shapes.radiusMd,
                      ),
                      border: Border.all(
                        color: t.colors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Time
                        SizedBox(
                          width: 60,
                          child: Column(
                            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                            children: [
                              Text(
                                DateFormat('HH:mm').format(startTime),
                                style: t.typography.body.copyWith(
                                  fontWeight: text.bodyBold.fontWeight,
                                  color: widget.accentColor,
                                ),
                              ),
                              Text(
                                DateFormat('MMM d').format(startTime),
                                style: t.typography.caption.copyWith(
                                  color: t.colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CommonSpacer(width: t.spacing.sm),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                            children: [
                              Text(
                                dose,
                                style: t.typography.body.copyWith(
                                  fontWeight: text.bodyBold.fontWeight,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.route,
                                    size: t.sizes.iconSm,
                                    color: t.colors.textSecondary,
                                  ),
                                  CommonSpacer(width: t.spacing.xs / 2),
                                  Text(
                                    route,
                                    style: t.typography.bodySmall.copyWith(
                                      color: t.colors.textSecondary,
                                    ),
                                  ),
                                  if (isMedical) ...[
                                    CommonSpacer(width: t.spacing.xs),
                                    Icon(
                                      Icons.medical_services,
                                      size: t.sizes.iconSm,
                                      color: t.colors.success,
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
          if (!_showAll && _allEntries.length > 10)
            Padding(
              padding: EdgeInsets.all(t.spacing.md),
              child: CommonPrimaryButton(
                onPressed: () {
                  setState(() {
                    _showAll = true;
                  });
                },
                backgroundColor: widget.accentColor,
                textColor: Colors.white,
                label: 'Show All ${_allEntries.length} Uses',
              ),
            ),

          CommonSpacer(height: t.spacing.md),
        ],
      ),
    );
  }
}
