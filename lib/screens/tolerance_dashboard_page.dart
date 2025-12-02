import 'package:flutter/material.dart';
import '../widgets/common/drawer_menu.dart';
import '../models/tolerance_model.dart';
import '../models/bucket_definitions.dart';
import '../services/tolerance_service.dart';
import '../services/user_service.dart';
import '../services/tolerance_engine_service.dart';
import '../services/debug_config.dart';
import '../utils/tolerance_calculator.dart';
import '../widgets/tolerance_dashboard/dashboard_content_widget.dart';
import '../widgets/tolerance_dashboard/empty_state_widget.dart';
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
  String? _userId;
  List<String> _substances = [];
  String? _selectedSubstance;
  String? _errorMessage;

  ToleranceModel? _toleranceModel;
  List<UseLogEntry> _useEvents = [];
  // Unified tolerance results
  ToleranceResult? _systemTolerance;
  ToleranceResult? _substanceTolerance;
  
  // Hierarchical UI state
  String? _selectedBucket; // Currently selected bucket for detail view
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _bucketDetailKey = GlobalKey();
  Map<String, Map<String, double>> _substanceContributions = {}; // bucket -> {substance -> contribution%}
  Map<String, bool> _substanceActiveStates = {}; // substance -> isActive
  
  // Debugging per-substance tolerance
  bool _showDebugSubstances = false;
  Map<String, double> _perSubstanceTolerances = {};
  bool _isLoadingPerSubstance = false;
  bool _showDebugPanel = false;

  @override
  void initState() {
    super.initState();
    _loadSubstances();
  }

  Future<void> _loadSystemTolerance() async {
    try {
      if (_userId == null) return;

      final data = await ToleranceEngineService.computeSystemTolerance(
        userId: _userId!,
        daysBack: 30,
      );
      if (mounted) {
        setState(() {
          _systemTolerance = data;
          _selectedBucket = _findFirstActiveBucket(data.bucketPercents);
        });
        // Compute substance contributions after loading system data
        await _computeSubstanceContributions();
      }
    } catch (e) {
      // Silently fail - system tolerance is optional
      debugPrint('System tolerance load failed: $e');
    }
  }
  
  String? _findFirstActiveBucket(Map<String, double> percents) {
    for (final bucket in BucketDefinitions.orderedBuckets) {
      final percent = percents[bucket] ?? 0.0;
      if (percent > 0.001) {
        return bucket;
      }
    }
    // Default to first bucket if all are zero
    return BucketDefinitions.orderedBuckets.first;
  }
  
  Future<void> _computeSubstanceContributions() async {
    if (_userId == null) return;
    
    print('\n════════════════════════════════════════════════════════');
    print('🔬 TOLERANCE CALCULATION DEBUG - ${DateTime.now()}');
    print('════════════════════════════════════════════════════════');
    
    try {
      final allModels = await ToleranceEngineService.fetchAllToleranceModels();
      final allUseLogs = await ToleranceEngineService.fetchUseLogs(
        userId: _userId!,
        daysBack: 30,
      );
      
      print('📊 Found ${allModels.length} substances with tolerance models');
      print('📊 Found ${allUseLogs.length} use log entries (30 days)');
      
      // Group by bucket
      final Map<String, Map<String, double>> contributions = {};
      final Map<String, bool> activeStates = {};
      
      for (final entry in allModels.entries) {
        final substanceName = entry.key;
        print('\n─────────────────────────────────────────────────────────');
        print('💊 Processing: $substanceName');
        
        // Get use events for this substance
        final substanceEvents = allUseLogs.where((log) => 
          log.substanceSlug == substanceName
        ).toList();
        
        if (substanceEvents.isEmpty) {
          print('  ⚠️  No use events found - skipping');
          continue;
        }
        
        print('  📅 Use events: ${substanceEvents.length}');
        for (final event in substanceEvents) {
          print('    - ${event.timestamp}: ${event.doseUnits}mg');
        }
        
        // Use unified tolerance engine for this substance's contributions
        final perSubstanceResult = ToleranceCalculatorFull.computeToleranceFull(
          useLogs: substanceEvents,
          toleranceModels: {substanceName: entry.value},
        );

        print('  🎯 Bucket Results (unified engine):');
        for (final bucketType in perSubstanceResult.bucketPercents.keys) {
          final tolerancePercent = perSubstanceResult.bucketPercents[bucketType] ?? 0.0;
          final rawLoad = perSubstanceResult.bucketRawLoads[bucketType] ?? 0.0;

          print('    - $bucketType: ${tolerancePercent.toStringAsFixed(1)}% (raw: ${rawLoad.toStringAsFixed(4)})');

          if (tolerancePercent > 0.1) {
            contributions.putIfAbsent(bucketType, () => {});
            contributions[bucketType]![substanceName] = tolerancePercent;
            if (rawLoad > 0.0) {
              activeStates[substanceName] = true;
            }
          }
        }
      }
      
      print('\n══════════════════════════════════════════════════════════');
      print('📈 FINAL BUCKET CONTRIBUTIONS:');
      for (final bucket in contributions.keys) {
        final total = contributions[bucket]!.values.fold(0.0, (sum, val) => sum + val);
        print('  $bucket (TOTAL: ${total.toStringAsFixed(1)}%):');
        for (final substance in contributions[bucket]!.entries) {
          final percent = substance.value;
          print('    - ${substance.key}: ${percent.toStringAsFixed(1)}%${percent > 100 ? ' ⚠️ UNREALISTIC!' : ''}');
        }
      }
      print('══════════════════════════════════════════════════════════\n');
      
      if (mounted) {
        setState(() {
          _substanceContributions = contributions;
          _substanceActiveStates = activeStates;
        });
      }
    } catch (e) {
      debugPrint('Failed to compute substance contributions: $e');
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
      final userId = UserService.getCurrentUserId();
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

      // Load system tolerance once we know the user
      await _loadSystemTolerance();
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

    final toleranceData = await ToleranceService.fetchToleranceData(substance);
    final useEventsRaw = await ToleranceService.fetchUseEvents(
      substanceName: substance,
      userId: _userId!,
      daysBack: 30,
    );

    // Convert UseEvent to UseLogEntry for unified engine
    final useEvents = useEventsRaw.map((event) => UseLogEntry(
      substanceSlug: event.substanceName,
      timestamp: event.timestamp,
      doseUnits: event.dose,
    )).toList();

    if (!mounted) return;

    if (toleranceData == null) {
      setState(() {
        _toleranceModel = null;
        _useEvents = useEvents;
        _substanceTolerance = null;
        _errorMessage = 'No tolerance data available for $substance.';
      });
      return;
    }

    // NEW ENGINE: compute tolerance
    final full = ToleranceCalculatorFull.computeToleranceFull(
      useLogs: useEvents,
      toleranceModels: { substance: toleranceData },
    );

    setState(() {
      _toleranceModel = toleranceData;
      _useEvents = useEvents;
      _substanceTolerance = full;
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
          // Debug toggle - only show when DEBUG_MODE=true in .env
          if (DebugConfig.instance.isDebugMode) ...[
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
            IconButton(
              icon: Icon(
                _showDebugPanel
                    ? Icons.developer_board
                    : Icons.developer_board_outlined,
              ),
              onPressed: () {
                setState(() => _showDebugPanel = !_showDebugPanel);
              },
              tooltip: 'Toggle tolerance debug panel',
            ),
          ],
        ],
      ),
      drawer: const DrawerMenu(),
      body: _isLoadingOptions
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
              child: _substances.isEmpty
                  ? EmptyStateWidget(isDark: isDark)
                  : _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DashboardContentWidget(
      toleranceModel: _toleranceModel,
      systemTolerance: _systemTolerance,
      substanceTolerance: _substanceTolerance,
      useEvents: _useEvents,
      errorMessage: _errorMessage,
      selectedSubstance: _selectedSubstance,
      selectedBucket: _selectedBucket,
      substanceContributions: _substanceContributions,
      substanceActiveStates: _substanceActiveStates,
      showDebugSubstances: _showDebugSubstances,
      showDebugPanel: _showDebugPanel,
      perSubstanceTolerances: _perSubstanceTolerances,
      isLoadingPerSubstance: _isLoadingPerSubstance,
      onSubstanceSelected: (substanceName) {
        setState(() => _selectedSubstance = substanceName);
        _loadMetrics(substanceName);
      },
      onBucketSelected: (bucketType) {
        setState(() => _selectedBucket = bucketType);
        // Scroll to bucket detail section
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = _bucketDetailKey.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      },
      bucketDetailKey: _bucketDetailKey,
      isDark: isDark,
    );
  }
}

