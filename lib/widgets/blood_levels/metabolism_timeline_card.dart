import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/blood_levels_service.dart';
import '../../services/decay_service.dart';
import '../../constants/drug_theme.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
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

      // Use ONLY the filtered drugs from widget.drugLevels (respects include/exclude filters)
      final filteredDrugNames = widget.drugLevels
          .map((level) => level.drugName)
          .toList();

      // Fetch doses for each FILTERED drug
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? UIColors.darkNeonTeal
        : UIColors.lightAccentRed;

    if (_loading) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: ThemeConstants.space16,
          vertical: ThemeConstants.space8,
        ),
        padding: EdgeInsets.all(ThemeConstants.cardPaddingLarge),
        decoration: isDark
            ? UIColors.createGlassmorphism(
                accentColor: accentColor,
                radius: ThemeConstants.cardRadius,
              )
            : BoxDecoration(
                color: UIColors.lightSurface,
                borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
                boxShadow: UIColors.createSoftShadow(),
              ),
        child: Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    if (_timelineDoses.isEmpty) {
      return _buildEmptyState(isDark);
    }

    // Generate normalized curves for all drugs
    final decayService = DecayService();
    final lineBarsData = <LineChartBarData>[];
    final legendItems = <Map<String, dynamic>>[];

    // Loop through ALL drugs in timeline (including future doses)
    for (final drugName in _timelineDoses.keys) {
      final doses = _timelineDoses[drugName];
      if (doses == null || doses.isEmpty) continue;

      // Try to find drug level info from widget, or use defaults
      final drugLevel = widget.drugLevels.firstWhere(
        (level) => level.drugName.toLowerCase() == drugName.toLowerCase(),
        orElse: () => DrugLevel(
          drugName: drugName,
          totalDose: 0,
          totalRemaining: 0,
          lastDose: 0,
          lastUse: DateTime.now(),
          halfLife: _getDefaultHalfLife(drugName),
          doses: [],
          activeWindow: 24,
          maxDuration: 12,
          categories: [],
        ),
      );

      // Generate normalized intensity curve (0-100%)
      final curvePoints = decayService.generateNormalizedCurve(
        doses: doses,
        halfLife: drugLevel.halfLife,
        referenceTime: widget.referenceTime,
        hoursBack: widget.hoursBack,
        hoursForward: widget.hoursForward,
        drugName: drugName,
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
      return _buildEmptyState(isDark);
    }

    // Calculate max Y value
    final maxY = TimelineChartConfig.calculateMaxY(
      lineBarsData,
      widget.adaptiveScale,
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ThemeConstants.space16,
        vertical: ThemeConstants.space8,
      ),
      padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.timeline, color: accentColor, size: 18),
              SizedBox(width: ThemeConstants.space8),
              Text(
                'Metabolism Timeline',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontBold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space8),

          // Legend
          TimelineLegend(items: legendItems),
          SizedBox(height: ThemeConstants.space12),

          // Chart
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: TimelineChartConfig.buildGridData(maxY, isDark),
                titlesData: TimelineChartConfig.buildTitlesData(
                  maxY: maxY,
                  hoursBack: widget.hoursBack,
                  hoursForward: widget.hoursForward,
                  isDark: isDark,
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxY,
                lineBarsData: lineBarsData,
                extraLinesData: TimelineChartConfig.buildNowLine(isDark),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: isDark
                        ? UIColors.darkSurface.withValues(alpha: 0.9)
                        : UIColors.lightSurface.withValues(alpha: 0.9),
                    getTooltipItems: (touchedSpots) {
                      return TimelineChartConfig.buildTooltipItems(
                        touchedSpots,
                        lineBarsData,
                        legendItems,
                        isDark,
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

  Widget _buildEmptyState(bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ThemeConstants.space16,
        vertical: ThemeConstants.space8,
      ),
      padding: EdgeInsets.all(ThemeConstants.cardPaddingLarge),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: isDark
                  ? UIColors.darkNeonTeal
                  : UIColors.lightAccentRed,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timeline_outlined,
              size: 48,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
            SizedBox(height: ThemeConstants.space12),
            Text(
              'No dose data to display',
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                color: isDark
                    ? UIColors.darkTextSecondary
                    : UIColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get default half-life for a drug name
  double _getDefaultHalfLife(String drugName) {
    const halfLives = <String, double>{
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

    return halfLives[drugName.toLowerCase()] ?? 4.0; // Default to 4 hours
  }
}
