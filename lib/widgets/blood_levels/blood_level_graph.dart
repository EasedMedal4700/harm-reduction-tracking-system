import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonTeal : UIColors.lightAccentRed;

    return Container(
      padding: EdgeInsets.all(ThemeConstants.cardPaddingLarge),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: UIColors.lightBorder,
                width: ThemeConstants.borderThin,
              ),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ThemeConstants.space8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: accentColor,
                  size: ThemeConstants.iconMedium,
                ),
              ),
              SizedBox(width: ThemeConstants.space12),
              Text(
                'Blood Level Curves',
                style: TextStyle(
                  fontSize: ThemeConstants.fontLarge,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space24),
          // Graph
          SizedBox(
            height: 300,
            child: substanceCurves.isEmpty
                ? _buildEmptyState(isDark)
                : _buildChart(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 64,
            color: isDark
                ? UIColors.darkTextSecondary.withValues(alpha: 0.3)
                : UIColors.lightTextSecondary.withValues(alpha: 0.3),
          ),
          SizedBox(height: ThemeConstants.space16),
          Text(
            'No active substances in selected timeframe',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(bool isDark) {
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
          color: color.withValues(alpha: isDark ? 0.15 : 0.1),
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
              getTitlesWidget: (value, meta) => _buildLeftTitle(value, meta, isDark),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) => _buildBottomTitle(value, meta, isDark),
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
            color: isDark
                ? UIColors.darkBorder
                : UIColors.lightBorder.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: isDark
                ? UIColors.darkBorder
                : UIColors.lightBorder.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
            width: 1,
          ),
        ),
        minY: 0,
        maxY: 120, // Allow slight overflow above 100%
        minX: startTime.millisecondsSinceEpoch.toDouble(),
        maxX: endTime.millisecondsSinceEpoch.toDouble(),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDark
                ? UIColors.darkSurfaceLight
                : UIColors.lightSurface,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final substance = substanceCurves.keys.elementAt(spot.barIndex);
                return LineTooltipItem(
                  '$substance\n${spot.y.toStringAsFixed(1)}%',
                  TextStyle(
                    color: isDark ? UIColors.darkText : UIColors.lightText,
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

  Widget _buildLeftTitle(double value, TitleMeta meta, bool isDark) {
    if (value == 0 || value == 100) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          '${value.toInt()}%',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomTitle(double value, TitleMeta meta, bool isDark) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final hoursDiff = date.difference(startTime).inHours;

    if (hoursDiff % 6 == 0) { // Show label every 6 hours
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          '${hoursDiff}h',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
