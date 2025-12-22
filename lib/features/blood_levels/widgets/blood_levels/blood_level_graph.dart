// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSectionHeader. No Riverpod.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';

import 'package:fl_chart/fl_chart.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';

import '../../services/pharmacokinetics_service.dart';

class BloodLevelGraph extends StatelessWidget {
  final Map<String, List<PKPoint>> substanceCurves;
  final Map<String, Color> substanceColors;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, Map<DoseTier, DoseRange>> substanceTiers;

  const BloodLevelGraph({
    super.key,
    required this.substanceCurves,
    required this.substanceColors,
    required this.startTime,
    required this.endTime,
    required this.substanceTiers,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(title: 'Blood Level Curves'),
          CommonSpacer.vertical(context.spacing.xl),

          SizedBox(
            height: context.sizes.heightLg,
            child: substanceCurves.isEmpty
                ? _buildEmptyState(context)
                : _buildChart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;

    return Center(
      child: Column(
        mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: context.sizes.icon2xl,
            color: c.textSecondary.withValues(alpha: context.opacities.medium),
          ),
          SizedBox(height: sp.lg),
          Text(
            'No active substances in selected timeframe',
            style: text.body.copyWith(color: c.textSecondary),
            textAlign: AppLayout.textAlignCenter,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final text = context.text;
    final c = context.colors;

    final lines = substanceCurves.entries.map((entry) {
      final substance = entry.key;
      final points = entry.value;
      final color = substanceColors[substance] ?? context.accent.primary;

      return LineChartBarData(
        spots: points
            .map(
              (p) => FlSpot(
                p.time.millisecondsSinceEpoch.toDouble(),
                p.percentage,
              ),
            )
            .toList(),
        isCurved: true,
        color: color,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: color.withValues(alpha: context.opacities.veryLow),
        ),
      );
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: lines,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: (value, meta) =>
                  _buildLeftTitle(value, meta, context),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) =>
                  _buildBottomTitle(value, meta, context),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) => FlLine(
            color: c.border.withValues(alpha: context.opacities.slow),
            strokeWidth: context.borders.thin,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: c.border.withValues(alpha: context.opacities.slow),
            strokeWidth: context.borders.thin,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: c.border, width: context.borders.thin),
        ),
        minY: 0,
        maxY: 120,
        minX: startTime.millisecondsSinceEpoch.toDouble(),
        maxX: endTime.millisecondsSinceEpoch.toDouble(),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: c.surface,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final substance = substanceCurves.keys.elementAt(spot.barIndex);
                return LineTooltipItem(
                  '$substance\n${spot.y.toStringAsFixed(1)}%',
                  TextStyle(
                    color: c.textPrimary,
                    fontWeight: text.bodyBold.fontWeight,
                    fontSize: context.text.label.fontSize,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value, TitleMeta meta, BuildContext context) {
    final c = context.colors;
    final text = context.text;

    if (value == 0 || value == 100) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          '${value.toInt()}%',
          style: TextStyle(
            fontSize: context.text.bodySmall.fontSize,
            color: c.textSecondary,
            fontWeight: text.bodyMedium.fontWeight,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomTitle(double value, TitleMeta meta, BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final hoursDiff = date.difference(startTime).inHours;

    if (hoursDiff % 6 == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          '${hoursDiff}h',
          style: TextStyle(
            fontSize: context.text.bodySmall.fontSize,
            color: c.textSecondary,
            fontWeight: text.bodyMedium.fontWeight,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
