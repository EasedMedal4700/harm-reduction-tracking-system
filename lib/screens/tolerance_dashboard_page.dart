import 'package:flutter/material.dart';
import '../models/tolerance_model.dart';
import '../services/tolerance_service.dart';
import '../services/user_service.dart';
import '../services/tolerance_engine_service.dart';
import '../utils/tolerance_calculator.dart';
import '../widgets/system_tolerance_widget.dart';
import '../widgets/tolerance/tolerance_summary_card.dart';
import '../widgets/tolerance/tolerance_stats_card.dart';
import '../widgets/tolerance/tolerance_notes_card.dart';
import '../widgets/tolerance/recent_uses_card.dart';
import '../widgets/tolerance/debug_substance_list.dart';
import '../constants/theme_constants.dart';
import '../constants/ui_colors.dart';

class ToleranceDashboardPage extends StatefulWidget {
  final String? initialSubstance;

  const ToleranceDashboardPage({super.key, this.initialSubstance});

  @override
  State<ToleranceDashboardPage> createState() => _ToleranceDashboardPageState();
}

class _ToleranceDashboardPageState extends State<ToleranceDashboardPage> {
  bool _isLoadingOptions = true;
  bool _isLoadingMetrics = false;
  int? _userId;
  List<String> _substances = [];
  String? _selectedSubstance;
  String? _errorMessage;

  ToleranceModel? _toleranceModel;
  List<UseEvent> _useEvents = [];
  double _currentTolerance = 0;
  double _daysUntilBaseline = 0;

  // System tolerance data
  SystemToleranceData? _systemToleranceData;
  bool _isLoadingSystemTolerance = false;
  // Debugging per-substance tolerance
  bool _showDebugSubstances = false;
  Map<String, double> _perSubstanceTolerances = {};
  bool _isLoadingPerSubstance = false;

  @override
  void initState() {
    super.initState();
    _loadSubstances();
    _loadSystemTolerance();
  }

  Future<void> _loadSystemTolerance() async {
    setState(() => _isLoadingSystemTolerance = true);
    try {
      final data = await loadSystemToleranceData();
      if (mounted) {
        setState(() {
          _systemToleranceData = data;
          _isLoadingSystemTolerance = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingSystemTolerance = false);
      }
    }
  }

  Future<void> _loadPerSubstanceTolerances() async {
    if (_userId == null) return;
    setState(() => _isLoadingPerSubstance = true);
    try {
      final values = await ToleranceEngineService.computePerSubstanceTolerances(
        userId: _userId!,
      );
      if (!mounted) return;
      setState(() {
        _perSubstanceTolerances = values;
        _isLoadingPerSubstance = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingPerSubstance = false);
    }
  }

  Future<void> _loadSubstances() async {
    setState(() {
      _isLoadingOptions = true;
      _errorMessage = null;
    });

    try {
      final userId = await UserService.getIntegerUserId();
      final options = await ToleranceService.fetchUserSubstances(userId);

      if (!mounted) return;

      setState(() {
        _userId = userId;
        _substances = options;
        _selectedSubstance =
            widget.initialSubstance ??
            (options.isNotEmpty ? options.first : null);
        _isLoadingOptions = false;
      });

      if (_selectedSubstance != null) {
        await _loadMetrics(_selectedSubstance!);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Unable to load your substances.';
        _isLoadingOptions = false;
      });
    }
  }

  Future<void> _loadMetrics(String substance) async {
    if (_userId == null) return;

    setState(() {
      _isLoadingMetrics = true;
      _errorMessage = null;
    });

    final toleranceData = await ToleranceService.fetchToleranceData(substance);
    final useEvents = await ToleranceService.fetchUseEvents(
      substanceName: substance,
      userId: _userId!,
      daysBack: 30,
    );

    if (!mounted) return;

    if (toleranceData == null) {
      setState(() {
        _toleranceModel = null;
        _useEvents = useEvents;
        _currentTolerance = 0;
        _daysUntilBaseline = 0;
        _errorMessage = 'No tolerance data available for $substance.';
        _isLoadingMetrics = false;
      });
      return;
    }

    final now = DateTime.now();
    final currentTolerance = ToleranceCalculator.toleranceScore(
      useEvents: useEvents,
      halfLifeHours: toleranceData.halfLifeHours,
      currentTime: now,
    );
    final daysUntilBaseline = ToleranceCalculator.daysUntilBaseline(
      currentTolerance: currentTolerance,
      toleranceDecayDays: toleranceData.toleranceDecayDays,
    );

    setState(() {
      _toleranceModel = toleranceData;
      _useEvents = useEvents;
      _currentTolerance = currentTolerance;
      _daysUntilBaseline = daysUntilBaseline;
      _isLoadingMetrics = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? UIColors.darkBackground
        : UIColors.lightBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Tolerance dashboard'),
        backgroundColor: isDark ? UIColors.darkSurface : Colors.white,
        elevation: 0,
        actions: [
          // Debug toggle
          IconButton(
            icon: Icon(
              _showDebugSubstances
                  ? Icons.bug_report
                  : Icons.bug_report_outlined,
            ),
            onPressed: () async {
              setState(() => _showDebugSubstances = !_showDebugSubstances);
              if (_showDebugSubstances) {
                await _loadPerSubstanceTolerances();
              }
            },
            tooltip: 'Toggle substance tolerance debug',
          ),
        ],
      ),
      body: _isLoadingOptions
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubstanceDropdown(isDark),

                  if (_substances.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: ThemeConstants.space16,
                      ),
                      child: Text(
                        'Log entries with substance names to see tolerance insights.',
                        style: TextStyle(
                          color: isDark
                              ? UIColors.darkTextSecondary
                              : UIColors.lightTextSecondary,
                        ),
                      ),
                    ),

                  const SizedBox(height: ThemeConstants.cardSpacing),

                  if (_isLoadingMetrics)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildContent(),
                ],
              ),
            ),
    );
  }

  Widget _buildSubstanceDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          key: ValueKey(_selectedSubstance),
          value: _selectedSubstance,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark
                ? UIColors.darkTextSecondary
                : UIColors.lightTextSecondary,
          ),
          dropdownColor: isDark ? UIColors.darkSurface : Colors.white,
          style: TextStyle(
            fontSize: ThemeConstants.fontMedium,
            fontWeight: ThemeConstants.fontMediumWeight,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
          hint: Text(
            'Select Substance',
            style: TextStyle(
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
          ),
          items: _substances
              .map((name) => DropdownMenuItem(value: name, child: Text(name)))
              .toList(),
          onChanged: (value) {
            setState(() => _selectedSubstance = value);
            if (value != null) {
              _loadMetrics(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedSubstance == null) {
      return const Center(
        child: Text('Select a substance to view tolerance data.'),
      );
    }

    return Column(
      children: [
        // 1. Current Tolerance (Top priority)
        if (_toleranceModel != null)
          ToleranceSummaryCard(currentTolerance: _currentTolerance),

        const SizedBox(height: ThemeConstants.cardSpacing),

        // 2. System Tolerance
        if (_isLoadingSystemTolerance)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else if (_systemToleranceData != null)
          SystemToleranceWidget(data: _systemToleranceData!),

        const SizedBox(height: ThemeConstants.cardSpacing),

        // 3. Key Metrics & Notes
        if (_errorMessage != null)
          Card(
            color: Theme.of(context).brightness == Brightness.dark
                ? UIColors.darkSurface
                : Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? UIColors.darkTextSecondary
                      : Colors.black54,
                ),
              ),
            ),
          ),

        if (_toleranceModel != null) ...[
          ToleranceStatsCard(
            toleranceModel: _toleranceModel!,
            daysUntilBaseline: _daysUntilBaseline,
            recentUseCount: _useEvents.length,
          ),
          const SizedBox(height: ThemeConstants.cardSpacing),
          ToleranceNotesCard(notes: _toleranceModel!.notes),
          const SizedBox(height: ThemeConstants.cardSpacing),
        ],

        // 4. Recent Uses
        RecentUsesCard(
          useEvents: _useEvents,
          substanceName: _selectedSubstance,
        ),

        // Debug per-substance tolerance table
        if (_showDebugSubstances) ...[
          const SizedBox(height: ThemeConstants.space12),
          DebugSubstanceList(
            perSubstanceTolerances: _perSubstanceTolerances,
            isLoading: _isLoadingPerSubstance,
          ),
        ],

        const SizedBox(height: ThemeConstants.space32),
      ],
    );
  }
}
