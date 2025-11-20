import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Configuration and builders for the metabolism timeline chart
class TimelineChartConfig {
  /// Builds the titles/labels for the chart axes
  static FlTitlesData buildTitlesData({
    required double maxY,
    required int hoursBack,
    required int hoursForward,
  }) {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          interval: 24,
          getTitlesWidget: (value, meta) {
            return _buildBottomTitle(value, hoursBack, hoursForward);
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: maxY / 4,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(
              '${value.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }

  static Widget _buildBottomTitle(double value, int hoursBack, int hoursForward) {
    final hour = value.toInt();

    if (hour == -hoursBack) {
      return Text(
        '-${hoursBack}h',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      );
    }
    if (hour == 0) {
      return const Text(
        'Now',
        style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
      );
    }
    if (hour == 24 || hour == -24) {
      return Text(
        hour > 0 ? '+24h' : '-24h',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      );
    }
    if (hour == hoursForward) {
      return Text(
        '+${hoursForward}h',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      );
    }

    return const Text('');
  }

  /// Builds the grid configuration
  static FlGridData buildGridData(double maxY) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: maxY / 4,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.1),
          strokeWidth: 0.5,
        );
      },
    );
  }

  /// Builds the "NOW" vertical line
  static ExtraLinesData buildNowLine() {
    return ExtraLinesData(
      verticalLines: [
        VerticalLine(
          x: 0,
          color: Colors.red.withOpacity(0.5),
          strokeWidth: 2,
          dashArray: [5, 5],
          label: VerticalLineLabel(
            show: true,
            alignment: Alignment.topCenter,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            labelResolver: (line) => 'NOW',
          ),
        ),
      ],
    );
  }

  /// Calculates the max Y value for the chart
  static double calculateMaxY(
    List<LineChartBarData> lineBarsData,
    bool adaptiveScale,
  ) {
    if (lineBarsData.isEmpty) return 100.0;

    double maxValue = 0.0;
    for (final lineData in lineBarsData) {
      for (final spot in lineData.spots) {
        if (spot.y > maxValue) maxValue = spot.y;
      }
    }

    if (adaptiveScale) {
      // Add 30% padding for better visualization
      return (maxValue * 1.3).clamp(20.0, 200.0);
    } else {
      // Fixed scale: minimum 100% or higher if needed
      return maxValue < 100 ? 100.0 : (maxValue * 1.3).clamp(100.0, 200.0);
    }
  }

  /// Builds tooltip items for touched spots
  static List<LineTooltipItem> buildTooltipItems(
    List<LineBarSpot> touchedSpots,
    List<LineChartBarData> lineBarsData,
    List<Map<String, dynamic>> legendItems,
  ) {
    return touchedSpots.map((spot) {
      final hour = spot.x.toInt();
      final intensity = spot.y;
      final timeLabel = hour == 0
          ? 'Now'
          : hour > 0
              ? '+${hour}h'
              : '${hour}h';

      // Find which drug this spot belongs to
      final drugIndex = lineBarsData.indexOf(
        lineBarsData.firstWhere(
          (line) => line.spots.any((s) => s == spot),
          orElse: () => lineBarsData.first,
        ),
      );

      final drugName = legendItems[drugIndex]['name'] as String;
      final drugColor = legendItems[drugIndex]['color'] as Color;

      return LineTooltipItem(
        '$drugName\n$timeLabel: ${intensity.toStringAsFixed(0)}%',
        TextStyle(
          color: drugColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
    }).toList();
  }
}
