// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to new AppTheme system.
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';

/// Configuration and builders for the metabolism timeline chart.
class TimelineChartConfig {
  /// Builds the titles/labels for the chart axes
  static FlTitlesData buildTitlesData({
    required BuildContext context,
    required double maxY,
    required int hoursBack,
    required int hoursForward,
  }) {
    final c = context.colors;
    final tx = context.text;
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          interval: 24,
          getTitlesWidget: (value, meta) =>
              _buildBottomTitle(context, value, hoursBack, hoursForward),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: maxY / 4,
          reservedSize: 40,
          getTitlesWidget: (value, meta) => Text(
            '${value.toStringAsFixed(0)}%',
            style: tx.caption.copyWith(color: c.textSecondary),
          ),
        ),
      ),
    );
  }

  static Widget _buildBottomTitle(
    BuildContext context,
    double value,
    int hoursBack,
    int hoursForward,
  ) {
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final int hour = value.toInt();
    // Edge markers
    if (hour == -hoursBack) {
      return Text(
        '-${hoursBack}h',
        style: tx.caption.copyWith(color: c.textSecondary),
      );
    }
    if (hour == hoursForward) {
      return Text(
        '+${hoursForward}h',
        style: tx.caption.copyWith(color: c.textSecondary),
      );
    }
    // NOW label
    if (hour == 0) {
      return Text(
        'Now',
        style: tx.caption.copyWith(
          color: ac.primary,
          fontWeight: tx.bodyBold.fontWeight,
        ),
      );
    }
    // ±24h
    if (hour == 24 || hour == -24) {
      return Text(
        hour > 0 ? '+24h' : '-24h',
        style: tx.caption.copyWith(color: c.textSecondary),
      );
    }
    return const SizedBox.shrink();
  }

  /// Builds the grid configuration
  static FlGridData buildGridData(BuildContext context, double maxY) {
    final c = context.colors;
    final bd = context.borders;
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: maxY / 4,
      getDrawingHorizontalLine: (value) =>
          FlLine(color: c.border.withValues(alpha: 0.25), strokeWidth: bd.thin),
    );
  }

  /// Builds the “NOW” vertical line
  static ExtraLinesData buildNowLine(BuildContext context) {
    final ac = context.accent;
    final bd = context.borders;
    final tx = context.text;
    return ExtraLinesData(
      verticalLines: [
        VerticalLine(
          x: 0,
          color: ac.primary.withValues(alpha: 0.5),
          strokeWidth: bd.medium,
          dashArray: [5, 5],
          label: VerticalLineLabel(
            show: true,
            alignment: context.shapes.alignmentTopCenter,
            style: tx.labelSmall.copyWith(
              color: ac.primary,
              fontWeight: tx.bodyBold.fontWeight,
            ),
            labelResolver: (line) => 'NOW',
          ),
        ),
      ],
    );
  }

  /// Calculates the max Y scale
  static double calculateMaxY(
    List<LineChartBarData> lineBarsData,
    bool adaptiveScale,
  ) {
    if (lineBarsData.isEmpty) return 100;
    double maxValue = 0;
    for (final line in lineBarsData) {
      for (final spot in line.spots) {
        if (spot.y > maxValue) maxValue = spot.y;
      }
    }
    if (adaptiveScale) {
      return (maxValue * 1.3).clamp(20.0, 200.0);
    }
    // Fixed 100% scale
    return maxValue < 100 ? 100 : (maxValue * 1.3).clamp(100.0, 200.0);
  }

  /// Tooltip builder
  static List<LineTooltipItem> buildTooltipItems(
    BuildContext context,
    List<LineBarSpot> touchedSpots,
    List<Map<String, dynamic>> legendItems,
  ) {
    final c = context.colors;
    final tx = context.text;
    return touchedSpots.map((spot) {
      final hour = spot.x.toInt();
      final y = spot.y;
      final timeLabel = hour == 0
          ? 'Now'
          : (hour > 0 ? '+${hour}h' : '${hour}h');
      final index = spot.barIndex;
      if (index < 0 || index >= legendItems.length) {
        return LineTooltipItem(
          'Unknown\n$timeLabel: ${y.toStringAsFixed(0)}%',
          tx.caption.copyWith(color: c.textPrimary),
        );
      }
      final name = legendItems[index]['name'] as String;
      final color = legendItems[index]['color'] as Color;
      return LineTooltipItem(
        '$name\n$timeLabel: ${y.toStringAsFixed(0)}%',
        tx.caption.copyWith(color: color),
      );
    }).toList();
  }
}
