// MIGRATION COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: READY
// Notes: Uses AppTheme extensions (colors, spacing, shapes, typography).
//        Uses CommonCard for container. Ready for Riverpod integration.
//        Fully updated for new TimelineChartConfig signatures.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../constants/theme/app_theme_extension.dart';
import '../../services/blood_levels_service.dart';
import '../../../../services/decay_service.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../common/cards/common_card.dart';
import 'timeline_chart_config.dart' as chart_config;
import 'timeline_legend.dart';

/// Card displaying metabolism timeline graph with decay curves for multiple drugs
class MetabolismTimelineCard extends StatefulWidget {
  final List<DrugLevel> drugLevels;
  final int hoursBack;
  final int hoursForward;
  final bool adaptiveScale;
  final DateTime referenceTime;
  final BloodLevelsService? service;

  const MetabolismTimelineCard({
    required this.drugLevels,
    required this.hoursBack,
    required this.hoursForward,
    required this.adaptiveScale,
    required this.referenceTime,
    this.service,
    super.key,
  });

  @override
  State<MetabolismTimelineCard> createState() => _MetabolismTimelineCardState();
}

class _MetabolismTimelineCardState extends State<MetabolismTimelineCard> {
  Map<String, List<DoseEntry>> _timelineDoses = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTimelineDoses();
  }

  @override
  void didUpdateWidget(MetabolismTimelineCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hoursBack != widget.hoursBack ||
        oldWidget.hoursForward != widget.hoursForward ||
        oldWidget.drugLevels.length != widget.drugLevels.length ||
        oldWidget.referenceTime != widget.referenceTime) {
      _loadTimelineDoses();
    }
  }

  Future<void> _loadTimelineDoses() async {
    setState(() => _loading = true);

    try {
      final service = widget.service ?? BloodLevelsService();
      final Map<String, List<DoseEntry>> allDoses = {};

      final filteredDrugNames = widget.drugLevels
          .map((level) => level.drugName)
          .toList();

      for (final drugName in filteredDrugNames) {
        final doses = await service.getDosesForTimeline(
          drugName: drugName,
          referenceTime: widget.referenceTime,
          hoursBack: widget.hoursBack,
          hoursForward: widget.hoursForward,
        );

        if (doses.isNotEmpty) {
          allDoses[drugName] = doses;
        }
      }

      if (mounted) {
        setState(() {
          _timelineDoses = allDoses;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _timelineDoses = {};
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final accentColor = context.accent.primary;

    if (_loading) {
      return CommonCard(
        padding: EdgeInsets.all(sp.lg),
        child: Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    if (_timelineDoses.isEmpty) {
      return _buildEmptyState(context);
    }

    // ----- Build curves -----
    final decayService = DecayService();
    final lineBarsData = <LineChartBarData>[];
    final legendItems = <Map<String, dynamic>>[];

    final drugsByCategory = <String, List<String>>{};
    for (final drugName in _timelineDoses.keys) {
      final drugLevel = widget.drugLevels.firstWhere(
        (level) => level.drugName.toLowerCase() == drugName.toLowerCase(),
        orElse: () => DrugLevel(
          drugName: drugName,
          totalDose: 0,
          totalRemaining: 0,
          lastDose: 0,
          lastUse: DateTime.now(),
          halfLife: _getDefaultHalfLife(drugName),
          doses: const [],
          activeWindow: 24,
          maxDuration: 12,
          categories: const [],
        ),
      );

      final category = drugLevel.categories.isNotEmpty
          ? drugLevel.categories.first
          : 'placeholder';

      drugsByCategory.putIfAbsent(category, () => []).add(drugName);
    }

    for (final drugName in _timelineDoses.keys) {
      final doses = _timelineDoses[drugName];
      if (doses == null || doses.isEmpty) continue;

      final drugLevel = widget.drugLevels.firstWhere(
        (level) => level.drugName.toLowerCase() == drugName.toLowerCase(),
        orElse: () => DrugLevel(
          drugName: drugName,
          totalDose: 0,
          totalRemaining: 0,
          lastDose: 0,
          lastUse: DateTime.now(),
          halfLife: _getDefaultHalfLife(drugName),
          doses: const [],
          activeWindow: 24,
          maxDuration: 12,
          categories: const [],
        ),
      );

      final curvePoints = decayService.generateNormalizedCurve(
        doses: doses,
        halfLife: drugLevel.halfLife,
        referenceTime: widget.referenceTime,
        hoursBack: widget.hoursBack,
        hoursForward: widget.hoursForward,
        drugName: drugName,
        drugProfile: drugLevel.formattedDose != null
            ? {'formatted_dose': drugLevel.formattedDose}
            : null,
        stepHours: 2.0,
      );

      if (curvePoints.isEmpty) continue;

      final spots = curvePoints
          .map((p) => FlSpot(p.hours, p.remainingMg))
          .toList();

      final category = drugLevel.categories.isNotEmpty
          ? drugLevel.categories.first
          : 'placeholder';
      final group = drugsByCategory[category] ?? [];
      final indexInCategory = group.indexOf(drugName);

      final drugColor = _getVariantColorForSubstance(
        category,
        indexInCategory,
        group.length,
      );

      lineBarsData.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: drugColor,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: context.shapes.alignmentTopCenter,
              end: context.shapes.alignmentBottomCenter,
              colors: [
                drugColor.withValues(alpha: 0.4),
                drugColor.withValues(alpha: 0.2),
                drugColor.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      );

      legendItems.add({
        'name': drugName.toUpperCase(),
        'color': drugColor,
        'halfLife': drugLevel.halfLife,
      });
    }

    if (lineBarsData.isEmpty) {
      return _buildEmptyState(context);
    }

    final maxY = chart_config.TimelineChartConfig.calculateMaxY(
      lineBarsData,
      widget.adaptiveScale,
    );

    return CommonCard(
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // ----- Header -----
          Row(
            children: [
              Icon(
                Icons.timeline,
                color: accentColor,
                size: context.sizes.iconSm,
              ),
              SizedBox(width: sp.sm),
              Text(
                'Metabolism Timeline',
                style: context.text.bodySmall.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
                  color: accentColor,
                  letterSpacing: context.sizes.letterSpacingSm,
                ),
              ),
            ],
          ),
          SizedBox(height: sp.sm),

          // ----- Legend -----
          TimelineLegend(items: legendItems),
          SizedBox(height: sp.md),

          // ----- Chart -----
          SizedBox(
            height: context.sizes.heightLg,
            child: LineChart(
              LineChartData(
                gridData: chart_config.TimelineChartConfig.buildGridData(
                  context,
                  maxY,
                ),
                titlesData: chart_config.TimelineChartConfig.buildTitlesData(
                  context: context,
                  maxY: maxY,
                  hoursBack: widget.hoursBack,
                  hoursForward: widget.hoursForward,
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxY,
                lineBarsData: lineBarsData,
                extraLinesData: chart_config.TimelineChartConfig.buildNowLine(
                  context,
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: c.surface.withValues(alpha: 0.96),
                    getTooltipItems: (spots) =>
                        chart_config.TimelineChartConfig.buildTooltipItems(
                          context,
                          spots,
                          legendItems,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;

    return CommonCard(
      padding: EdgeInsets.all(sp.lg),
      child: Center(
        child: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            Icon(
              Icons.timeline_outlined,
              size: context.sizes.iconXl,
              color: c.textSecondary,
            ),
            SizedBox(height: sp.md),
            Text(
              'No dose data to display',
              style: context.text.bodySmall.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Color _getVariantColorForSubstance(
    String category,
    int index,
    int totalInCategory,
  ) {
    final baseColor = DrugCategoryColors.colorFor(category);

    if (totalInCategory <= 1) return baseColor;

    final hsl = HSLColor.fromColor(baseColor);
    final ratio = index / (totalInCategory - 1);

    final newLightness = (hsl.lightness + ((ratio * 0.4) - 0.2)).clamp(
      0.3,
      0.8,
    );
    final newSaturation = (hsl.saturation + ((ratio * 0.2) - 0.1)).clamp(
      0.5,
      1.0,
    );

    return hsl
        .withLightness(newLightness)
        .withSaturation(newSaturation)
        .toColor();
  }

  double _getDefaultHalfLife(String drugName) {
    const halfLives = {
      'methylphenidate': 3.5,
      'dexedrine': 10.0,
      'amphetamine': 10.0,
      'cocaine': 1.0,
      'mdma': 8.0,
      'lsd': 3.0,
      'psilocybin': 2.5,
      'cannabis': 24.0,
      'thc': 24.0,
      'caffeine': 5.0,
      'nicotine': 2.0,
      'alcohol': 5.0,
      'ketamine': 2.5,
      'dxm': 3.0,
    };

    return halfLives[drugName.toLowerCase()] ?? 4.0;
  }
}
