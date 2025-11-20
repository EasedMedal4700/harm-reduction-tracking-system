import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/blood_levels_service.dart';
import '../../services/decay_service.dart';
import '../../constants/drug_theme.dart';
import 'timeline_chart_config.dart';
import 'timeline_legend.dart';

/// Card displaying metabolism timeline graph with decay curves for multiple drugs
class MetabolismTimelineCard extends StatefulWidget {
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
    // Reload if time window or drugs changed
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
      final service = BloodLevelsService();
      final Map<String, List<DoseEntry>> allDoses = {};
      
      // Fetch doses for each drug
      for (final drugLevel in widget.drugLevels) {
        final doses = await service.getDosesForTimeline(
          drugName: drugLevel.drugName,
          referenceTime: widget.referenceTime,
          hoursBack: widget.hoursBack,
          hoursForward: widget.hoursForward,
        );
        if (doses.isNotEmpty) {
          allDoses[drugLevel.drugName] = doses;
        }
      }
      
      if (mounted) {
        setState(() {
          _timelineDoses = allDoses;
          _loading = false;
        });
      }
    } catch (e) {
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
    if (_loading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_timelineDoses.isEmpty) {
      return _buildEmptyState();
    }
    
    // Generate normalized curves for all drugs
    final decayService = DecayService();
    final lineBarsData = <LineChartBarData>[];
    final legendItems = <Map<String, dynamic>>[];
    
    for (final drugLevel in widget.drugLevels) {
      final doses = _timelineDoses[drugLevel.drugName];
      if (doses == null || doses.isEmpty) continue;
      
      // Generate normalized intensity curve (0-100%)
      final curvePoints = decayService.generateNormalizedCurve(
        doses: doses,
        halfLife: drugLevel.halfLife,
        referenceTime: widget.referenceTime,
        hoursBack: widget.hoursBack,
        hoursForward: widget.hoursForward,
        drugName: drugLevel.drugName,
        stepHours: 2.0,
      );
      
      if (curvePoints.isEmpty) continue;
      
      // Convert to FlSpot (remainingMg now holds intensity %)
      final spots = curvePoints
          .map((p) => FlSpot(p.hours, p.remainingMg))
          .toList();
      
      // Get drug color
      final drugColor = drugLevel.categories.isNotEmpty
          ? DrugCategoryColors.colorFor(drugLevel.categories.first)
          : DrugCategoryColors.defaultColor;
      
      lineBarsData.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: drugColor,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                drugColor.withOpacity(0.4),
                drugColor.withOpacity(0.2),
                drugColor.withOpacity(0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      );
      
      legendItems.add({
        'name': drugLevel.drugName.toUpperCase(),
        'color': drugColor,
        'halfLife': drugLevel.halfLife,
      });
    }
    
    if (lineBarsData.isEmpty) {
      return _buildEmptyState();
    }
    
    // Calculate max Y value
    final maxY = TimelineChartConfig.calculateMaxY(
      lineBarsData,
      widget.adaptiveScale,
    );
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.timeline, color: Colors.cyan, size: 18),
              const SizedBox(width: 8),
              Text(
                'Metabolism Timeline',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Legend
          TimelineLegend(items: legendItems),
          const SizedBox(height: 12),
          
          // Chart
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: TimelineChartConfig.buildGridData(maxY),
                titlesData: TimelineChartConfig.buildTitlesData(
                  maxY: maxY,
                  hoursBack: widget.hoursBack,
                  hoursForward: widget.hoursForward,
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxY,
                lineBarsData: lineBarsData,
                extraLinesData: TimelineChartConfig.buildNowLine(),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return TimelineChartConfig.buildTooltipItems(
                        touchedSpots,
                        lineBarsData,
                        legendItems,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timeline_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No dose data to display',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
