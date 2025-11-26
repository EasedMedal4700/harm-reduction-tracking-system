import 'package:flutter/material.dart';
import '../widgets/common/drawer_menu.dart';
import '../models/tolerance_model.dart';
import '../models/tolerance_bucket.dart';
import '../models/bucket_definitions.dart';
import '../services/tolerance_service.dart';
import '../services/user_service.dart';
import '../services/tolerance_engine_service.dart';
import '../services/bucket_tolerance_service.dart';
import '../utils/tolerance_calculator.dart';
import '../utils/bucket_tolerance_calculator.dart' as bucket_calc;
import '../widgets/tolerance/system_bucket_card.dart';
import '../widgets/tolerance/bucket_detail_section.dart';
import '../widgets/tolerance/tolerance_stats_card.dart';
import '../widgets/tolerance/tolerance_notes_card.dart';
import '../widgets/tolerance/recent_uses_card.dart';
import '../widgets/tolerance/debug_substance_list.dart';
import '../widgets/tolerance/tolerance_disclaimer.dart';
import '../widgets/tolerance/unified_bucket_tolerance_widget.dart';
import '../widgets/system_tolerance_widget.dart';
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
  int? _userId;
  List<String> _substances = [];
  String? _selectedSubstance;
  String? _errorMessage;

  ToleranceModel? _toleranceModel;
  List<UseEvent> _useEvents = [];
  double _currentTolerance = 0;
  double _daysUntilBaseline = 0;

  // Bucket-based tolerance data
  BucketToleranceModel? _bucketToleranceModel;
  Map<String, bucket_calc.BucketToleranceResult>? _bucketResults;
  List<bucket_calc.UseEvent> _bucketUseEvents = [];

  // System tolerance data
  SystemToleranceData? _systemToleranceData;
  
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

  @override
  void initState() {
    super.initState();
    _loadSubstances();
    _loadSystemTolerance();
  }

  Future<void> _loadSystemTolerance() async {
    try {
      final data = await loadSystemToleranceData();
      if (mounted) {
        setState(() {
          _systemToleranceData = data;
          // Auto-select first non-zero bucket
          _selectedBucket = _findFirstActiveBucket(data);
        });
        // Compute substance contributions after loading system data
        await _computeSubstanceContributions();
      }
    } catch (e) {
      // Silently fail - system tolerance is optional
      debugPrint('System tolerance load failed: $e');
    }
  }
  
  String? _findFirstActiveBucket(SystemToleranceData data) {
    for (final bucket in BucketDefinitions.orderedBuckets) {
      final percent = data.percents[bucket] ?? 0.0;
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
      // Fetch all tolerance models and use events
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
        
        // Calculate bucket tolerance for this substance
        final bucketModel = await BucketToleranceService.fetchToleranceModel(substanceName);
        if (bucketModel == null) {
          print('  ⚠️  No bucket model found - skipping');
          continue;
        }
        
        final standardUnitMg = await BucketToleranceService.fetchStandardUnitMg(substanceName);
        if (standardUnitMg <= 0) {
          print('  ⚠️  Invalid standard unit (${standardUnitMg}mg) - skipping');
          continue;
        }
        print('  📏 Standard unit: ${standardUnitMg}mg');
        
        final useEvents = substanceEvents.map((log) => bucket_calc.UseEvent(
          timestamp: log.timestamp,
          doseMg: log.doseUnits,  // doseUnits field contains mg dose
          substance: substanceName,
        )).toList();
        
        final bucketResults = bucket_calc.BucketToleranceCalculator.calculateSubstanceTolerance(
          model: bucketModel,
          useEvents: useEvents,
          standardUnitMg: standardUnitMg,
          currentTime: DateTime.now(),
        );
        
        // Add contributions to each bucket
        print('  🎯 Bucket Results:');
        for (final bucketEntry in bucketResults.entries) {
          final bucketType = bucketEntry.key;
          final result = bucketEntry.value;
          final tolerancePercent = (result.tolerance * 100).clamp(0.0, 100.0);  // tolerance field, not tolerancePercent
          
          print('    - $bucketType: ${tolerancePercent.toStringAsFixed(1)}% (raw: ${result.tolerance.toStringAsFixed(4)}, active: ${result.isActive})');
          
          // ERROR DETECTION: Warn if tolerance seems unrealistic (before clamping)
          if (result.tolerance * 100 > 100) {
            print('\n    ╔════════════════════════════════════════════════════════╗');
            print('    ║  ⚠️⚠️⚠️  UNREALISTIC TOLERANCE DETECTED!  ⚠️⚠️⚠️   ║');
            print('    ╠════════════════════════════════════════════════════════╣');
            print('    ║  Substance: $substanceName');
            print('    ║  Bucket: $bucketType');
            print('    ║  Tolerance: ${tolerancePercent.toStringAsFixed(1)}%');
            print('    ║  Raw value: ${result.tolerance.toStringAsFixed(6)}');
            print('    ║  Events: ${substanceEvents.length}');
            print('    ║  Standard unit: ${standardUnitMg}mg');
            print('    ║  ');
            print('    ║  This indicates a calculation error!');
            print('    ║  Tolerance should cap around 100% with log model.');
            print('    ╚════════════════════════════════════════════════════════╝\n');
          }
          
          if (tolerancePercent > 0.1) {  // Only show contributions > 0.1%
            contributions.putIfAbsent(bucketType, () => {});
            contributions[bucketType]![substanceName] = tolerancePercent;
            
            // Check if substance is currently active
            if (result.isActive) {
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
      
      // Aggregate bucket totals from substance contributions
      final Map<String, double> bucketTotals = {};
      final Map<String, ToleranceSystemState> bucketStates = {};
      
      for (final bucket in contributions.keys) {
        final total = contributions[bucket]!.values.fold(0.0, (sum, val) => sum + val);
        bucketTotals[bucket] = total.clamp(0.0, 100.0);
        
        // Classify state based on total percentage
        if (total < 20) {
          bucketStates[bucket] = ToleranceSystemState.recovered;
        } else if (total < 40) {
          bucketStates[bucket] = ToleranceSystemState.lightStress;
        } else if (total < 60) {
          bucketStates[bucket] = ToleranceSystemState.moderateStrain;
        } else if (total < 80) {
          bucketStates[bucket] = ToleranceSystemState.highStrain;
        } else {
          bucketStates[bucket] = ToleranceSystemState.depleted;
        }
      }
      
      // Update system tolerance data with calculated values
      if (mounted) {
        setState(() {
          _substanceContributions = contributions;
          _substanceActiveStates = activeStates;
          _systemToleranceData = SystemToleranceData(bucketTotals, bucketStates);
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

    final toleranceData = await ToleranceService.fetchToleranceData(substance);
    final useEvents = await ToleranceService.fetchUseEvents(
      substanceName: substance,
      userId: _userId!,
      daysBack: 30,
    );

    // Also fetch bucket-based tolerance model and calculate bucket results
    BucketToleranceModel? bucketModel;
    Map<String, bucket_calc.BucketToleranceResult>? bucketResults;
    List<bucket_calc.UseEvent> bucketUseEvents = [];
    
    try {
      bucketModel = await BucketToleranceService.fetchToleranceModel(substance);
      if (bucketModel != null) {
        // Fetch standard unit for dose normalization
        final standardUnitMg = await BucketToleranceService.fetchStandardUnitMg(substance);
        
        if (standardUnitMg > 0) {
          bucketUseEvents = useEvents.map((e) => bucket_calc.UseEvent(
            timestamp: e.timestamp,
            doseMg: e.dose, // Old model uses 'dose' field
            substance: substance,
          )).toList();
          
          bucketResults = bucket_calc.BucketToleranceCalculator.calculateSubstanceTolerance(
            model: bucketModel,
            useEvents: bucketUseEvents,
            standardUnitMg: standardUnitMg,
            currentTime: DateTime.now(),
          );
        }
      }
    } catch (e) {
      // Bucket system is optional - if it fails, continue with old system
      debugPrint('Bucket tolerance calculation failed: $e');
    }

    if (!mounted) return;

    if (toleranceData == null) {
      setState(() {
        _toleranceModel = null;
        _useEvents = useEvents;
        _currentTolerance = 0;
        _daysUntilBaseline = 0;
        _bucketToleranceModel = bucketModel;
        _bucketResults = bucketResults;
        _errorMessage = 'No tolerance data available for $substance.';
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
      _bucketToleranceModel = bucketModel;
      _bucketResults = bucketResults;
      _bucketUseEvents = bucketUseEvents;
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
      drawer: const DrawerMenu(),
      body: _isLoadingOptions
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    )
                  else
                    _buildContent(),
                ],
              ),
            ),
    );
  }

  Widget _buildContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 0. Safety Disclaimer (TOP - CRITICAL)
        const CompactToleranceDisclaimer(),
        const SizedBox(height: ThemeConstants.cardSpacing),

        // 1. System Tolerance Overview (ALL 7 BUCKETS)
        _buildSystemOverview(isDark),
        const SizedBox(height: ThemeConstants.cardSpacing),

        // 2. Bucket Details (Selected bucket with contributing substances)
        if (_selectedBucket != null)
          _buildBucketDetails(isDark),
        
        if (_selectedBucket != null)
          const SizedBox(height: ThemeConstants.cardSpacing),

        // 3. Substance Detail (existing unified widget - only if substance selected)
        if (_selectedSubstance != null && _bucketToleranceModel != null && _bucketResults != null)
          UnifiedBucketToleranceWidget(
            bucketResults: _bucketResults!,
            model: _bucketToleranceModel!,
            substanceName: _selectedSubstance!,
            useEvents: _bucketUseEvents,
            systemTolerances: _systemToleranceData?.percents,
            systemStates: _systemToleranceData?.states,
          ),

        if (_selectedSubstance != null && _bucketToleranceModel != null && _bucketResults != null)
          const SizedBox(height: ThemeConstants.cardSpacing),

        // 4. Key Metrics (Bottom)
        if (_errorMessage != null)
          Card(
            color: isDark ? UIColors.darkSurface : Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: isDark ? UIColors.darkTextSecondary : Colors.black54,
                ),
              ),
            ),
          )
        else if (_toleranceModel != null) ...[
          ToleranceStatsCard(
            toleranceModel: _toleranceModel!,
            daysUntilBaseline: _daysUntilBaseline,
            recentUseCount: _useEvents.length,
          ),
          const SizedBox(height: ThemeConstants.cardSpacing),
          ToleranceNotesCard(notes: _toleranceModel!.notes),
        ],

        if (_useEvents.isNotEmpty) ...[
          const SizedBox(height: ThemeConstants.cardSpacing),
          RecentUsesCard(useEvents: _useEvents),
        ],

        // Debug: Per-substance tolerances
        if (_showDebugSubstances) ...[
          const SizedBox(height: ThemeConstants.cardSpacing),
          DebugSubstanceList(
            perSubstanceTolerances: _perSubstanceTolerances,
            isLoading: _isLoadingPerSubstance,
          ),
        ],
      ],
    );
  }

  Widget _buildSystemOverview(bool isDark) {
    // Render all 7 canonical buckets in order
    final orderedBuckets = BucketDefinitions.orderedBuckets;
    final systemData = _systemToleranceData;
    
    if (systemData == null) {
      // Loading state
      return Card(
        color: isDark ? UIColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
          side: BorderSide(
            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'System Tolerance Overview',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
        ),
        const SizedBox(height: ThemeConstants.space12),
        
        // Horizontal scrollable bucket cards
        SizedBox(
          height: 140, // Fixed height for cards
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: orderedBuckets.length,
            separatorBuilder: (context, index) => const SizedBox(width: ThemeConstants.space12),
            itemBuilder: (context, index) {
              final bucketType = orderedBuckets[index];
              final tolerancePercent = (systemData.percents[bucketType] ?? 0.0).clamp(0.0, 100.0);
              final state = systemData.states[bucketType] ?? ToleranceSystemState.recovered;
              
              // Check if any substance is active for this bucket
              final isActive = _substanceActiveStates.entries.any((entry) {
                // Would need to check if this substance contributes to this bucket
                // For now, just check if there are contributions
                final contributions = _substanceContributions[bucketType];
                return contributions != null && contributions.isNotEmpty;
              });
              
              return SystemBucketCard(
                bucketType: bucketType,
                tolerancePercent: tolerancePercent,
                state: state,
                isActive: isActive,
                isSelected: _selectedBucket == bucketType,
                onTap: () {
                  setState(() {
                    _selectedBucket = bucketType;
                  });
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
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildBucketDetails(bool isDark) {
    if (_selectedBucket == null || _systemToleranceData == null) {
      return const SizedBox.shrink();
    }
    
    final bucketType = _selectedBucket!;
    final systemData = _systemToleranceData!;
    final systemTolerancePercent = (systemData.percents[bucketType] ?? 0.0).clamp(0.0, 100.0);
    final state = systemData.states[bucketType] ?? ToleranceSystemState.recovered;
    final substanceContributions = _substanceContributions[bucketType] ?? {};
    
    return Container(
      key: _bucketDetailKey,
      child: BucketDetailSection(
        bucketType: bucketType,
        systemTolerancePercent: systemTolerancePercent,
        state: state,
        substanceContributions: substanceContributions,
        substanceActiveStates: _substanceActiveStates,
        selectedSubstance: _selectedSubstance,
        onSubstanceSelected: (substanceName) {
          setState(() => _selectedSubstance = substanceName);
          _loadMetrics(substanceName);
        },
      ),
    );
  }
}

