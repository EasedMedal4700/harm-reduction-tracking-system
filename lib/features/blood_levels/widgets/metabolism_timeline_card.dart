// MIGRATION COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: READY
// Notes: Uses AppTheme extensions (colors, spacing, shapes, typography).
//        Uses CommonCard for container. Ready for Riverpod integration.
//        Fully updated for new TimelineChartConfig signatures.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/data/graph_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../models/blood_levels_models.dart';
import '../models/blood_levels_timeline_request.dart';
import '../providers/blood_levels_providers.dart';
import '../providers/decay_providers.dart';
import '../../../constants/data/drug_categories.dart';
import '../../../common/cards/common_card.dart';
import 'timeline_chart_config.dart' as chart_config;
import 'timeline_legend.dart';

/// Card displaying metabolism timeline graph with decay curves for multiple drugs
class MetabolismTimelineCard extends ConsumerWidget {
  final List<DrugLevel> drugLevels;
  final int hoursBack;
  final int hoursForward;
  final bool adaptiveScale;
  final DateTime referenceTime;
  const MetabolismTimelineCard({
    required this.drugLevels,
    required this.hoursBack,
    required this.hoursForward,
    required this.adaptiveScale,
    required this.referenceTime,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tx = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final accentColor = context.accent.primary;

    final request = BloodLevelsTimelineRequest(
      drugNames: drugLevels.map((level) => level.drugName).toList(),
      referenceTime: referenceTime,
      hoursBack: hoursBack,
      hoursForward: hoursForward,
    );

    final timelineDosesAsync = ref.watch(
      bloodLevelsTimelineDosesProvider(request),
    );

    if (timelineDosesAsync.isLoading) {
      return CommonCard(
        padding: EdgeInsets.all(sp.lg),
        child: Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    final timelineDoses = timelineDosesAsync.value ?? {};
    if (timelineDoses.isEmpty) {
      return _buildEmptyState(context);
    }

    // ----- Build curves -----
    final decayService = ref.read(decayServiceProvider);
    final lineBarsData = <LineChartBarData>[];
    final legendItems = <Map<String, dynamic>>[];
    final drugsByCategory = <String, List<String>>{};
    for (final drugName in timelineDoses.keys) {
      DrugLevel? drugLevel;
      try {
        drugLevel = drugLevels.firstWhere(
          (level) => level.drugName.toLowerCase() == drugName.toLowerCase(),
        );
      } catch (_) {
        drugLevel = null;
      }

      if (drugLevel == null) continue;

      final category = drugLevel.categories.isNotEmpty
          ? drugLevel.categories.first
          : 'placeholder';
      drugsByCategory.putIfAbsent(category, () => []).add(drugName);
    }

    for (final drugName in timelineDoses.keys) {
      final doses = timelineDoses[drugName];
      if (doses == null || doses.isEmpty) continue;

      DrugLevel? drugLevel;
      try {
        drugLevel = drugLevels.firstWhere(
          (level) => level.drugName.toLowerCase() == drugName.toLowerCase(),
        );
      } catch (_) {
        drugLevel = null;
      }
      if (drugLevel == null) continue;

      final curvePoints = decayService.generateNormalizedCurve(
        doses: doses,
        halfLife: drugLevel.halfLife,
        referenceTime: referenceTime,
        hoursBack: hoursBack,
        hoursForward: hoursForward,
        drugName: drugName,
        drugProfile: drugLevel.formattedDose != null
            ? {'formatted_dose': drugLevel.formattedDose}
            : null,
        stepHours: GraphConstants.defaultStepHours,
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
          curveSmoothness: GraphConstants.defaultCurveSmoothness,
          color: drugColor,
          barWidth: GraphConstants.thinBarWidth,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: context.shapes.alignmentTopCenter,
              end: context.shapes.alignmentBottomCenter,
              colors: [
                drugColor.withValues(alpha: context.opacities.border),
                drugColor.withValues(alpha: context.opacities.selected),
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
      adaptiveScale,
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
                style: tx.bodySmall.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
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
                  hoursBack: hoursBack,
                  hoursForward: hoursForward,
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
    final c = context.colors;
    final tx = context.text;
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
              style: tx.bodySmall.copyWith(color: c.textSecondary),
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
}
