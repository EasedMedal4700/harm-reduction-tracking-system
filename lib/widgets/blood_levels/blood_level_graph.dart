// MIGRATION
// Theme: COMPLETE
// Common: TODO (extract shared chart UI patterns? axis labels? empty state?)
// Riverpod: TODO (convert to ConsumerWidget + provider-driven data)
// Notes: Fully migrated to theme system. Still state-less but should use providers instead of passing maps.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final acc = context.accent;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: c.border,
          width: 1,
        ),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(sp.sm),
                decoration: BoxDecoration(
                  color: acc.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: acc.primary,
                  size: AppThemeConstants.iconMd,
                ),
              ),
              SizedBox(width: sp.md),
              Text(
                'Blood Level Curves',
                style: context.text.heading3,
              ),
            ],
          ),
          SizedBox(height: sp.xl),

          SizedBox(
            height: 300,
            child: substanceCurves.isEmpty
                ? _buildEmptyState(context)
                : _buildChart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 64,
            color: c.textSecondary.withValues(alpha: 0.3),
          ),
          SizedBox(height: sp.lg),
          Text(
            'No active substances in selected timeframe',
            style: text.body.copyWith(color: c.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final c = context.colors;

    final lines = substanceCurves.entries.map((entry) {
      final substance = entry.key;
      final points = entry.value;
      final color = substanceColors[substance] ?? Colors.blue;

      return LineChartBarData(
        spots: points
            .map((p) => FlSpot(
                  p.time.millisecondsSinceEpoch.toDouble(),
                  p.percentage,
                ))
            .toList(),
        isCurved: true,
        color: color,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: color.withValues(alpha: 0.12),
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
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) => FlLine(
            color: c.border.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: c.border.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: c.border,
            width: 1,
          ),
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
                final substance =
                    substanceCurves.keys.elementAt(spot.barIndex);
                return LineTooltipItem(
                  '$substance\n${spot.y.toStringAsFixed(1)}%',
                  TextStyle(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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

    if (value == 0 || value == 100) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          '${value.toInt()}%',
          style: TextStyle(
            fontSize: 11,
            color: c.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomTitle(double value, TitleMeta meta, BuildContext context) {
    final c = context.colors;
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final hoursDiff = date.difference(startTime).inHours;

    if (hoursDiff % 6 == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          '${hoursDiff}h',
          style: TextStyle(
            fontSize: 11,
            color: c.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}


