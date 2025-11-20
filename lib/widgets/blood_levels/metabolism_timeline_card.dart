import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/blood_levels_service.dart';
import '../../services/decay_service.dart';
import '../../constants/drug_theme.dart';

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
    final maxY = _calculateMaxY(lineBarsData);
    
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
          _buildLegend(legendItems),
          const SizedBox(height: 12),
          
          // Chart
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: _buildTitlesData(maxY),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxY,
                lineBarsData: lineBarsData,
                // Vertical "Now" line
                extraLinesData: ExtraLinesData(
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
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
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
  
  Widget _buildLegend(List<Map<String, dynamic>> legendItems) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: legendItems.length,
        itemBuilder: (context, index) {
          final item = legendItems[index];
          return Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: item['color'] as Color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  't½: ${(item['halfLife'] as double).toStringAsFixed(1)}h',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  FlTitlesData _buildTitlesData(double maxY) {
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
            final hour = value.toInt();
            
            // Show labels at key points
            if (hour == -widget.hoursBack) {
              return Text(
                '-${widget.hoursBack}h',
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
            if (hour == widget.hoursForward) {
              return Text(
                '+${widget.hoursForward}h',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              );
            }
            
            return const Text('');
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
  
  double _calculateMaxY(List<LineChartBarData> lineBarsData) {
    if (lineBarsData.isEmpty) return 100.0;
    
    double maxValue = 0.0;
    for (final lineData in lineBarsData) {
      for (final spot in lineData.spots) {
        if (spot.y > maxValue) maxValue = spot.y;
      }
    }
    
    if (widget.adaptiveScale) {
      // Add 30% padding for better visualization
      return (maxValue * 1.3).clamp(20.0, 200.0);
    } else {
      // Fixed scale: minimum 100% or higher if needed
      return maxValue < 100 ? 100.0 : (maxValue * 1.3).clamp(100.0, 200.0);
    }
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
