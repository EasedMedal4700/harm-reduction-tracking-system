import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/drug_category_colors.dart';
import '../constants/blood_levels_theme.dart';
import '../services/auth_service.dart';
import '../main.dart';

class BloodLevelsScreen extends StatefulWidget {
  const BloodLevelsScreen({super.key});

  @override
  State<BloodLevelsScreen> createState() => _BloodLevelsScreenState();
}

class _BloodLevelsScreenState extends State<BloodLevelsScreen> {
  List<Map<String, dynamic>> _drugUseData = [];
  Map<String, dynamic> _drugProfiles = {};
  bool _isLoading = true;
  String _error = '';

  // Filter state (similar to analytics)
  final List<String> _includedDrugs = [];
  final List<String> _excludedDrugs = [];
  final List<String> _includedCategories = [];
  final List<String> _excludedCategories = [];

  // Time machine feature - selected date/time for viewing historical data
  DateTime _selectedTime = DateTime.now();

  // Expanded card state
  final Set<String> _expandedCards = {};

  // Chart customization state
  int _chartPastHours = 24;
  int _chartFutureHours = 48;
  bool _chartAdaptiveMax = true;

  // Modern futuristic medical UI theme colors

  /// Get color for drug category using shared palette
  Color _getCategoryColor(String drugName) {
    final drugData = _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
    final drugProfile = drugData[drugName] as Map<String, dynamic>?;

    if (drugProfile != null) {
      final categories = drugProfile['categories'] as List<dynamic>? ?? [];
      for (final category in categories) {
        final categoryStr = category.toString();
        if (categoryStr.isEmpty) continue;
        final normalized = categoryStr.trim().toLowerCase();
        final palette = DrugCategoryColors.map;
        if (palette.containsKey(normalized)) {
          return palette[normalized]!;
        }
      }
    }

    return DrugCategoryColors.defaultColor;
  }

  /// Get dosage thresholds for normalization (returns [threshold, light, common, strong, heavy] in mg)
  List<double>? _getDosageThresholds(String drugName) {
    final drugData = _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
    final drugProfile = drugData[drugName] as Map<String, dynamic>?;

    if (drugProfile != null) {
      final formattedDose =
          drugProfile['formatted_dose'] as Map<String, dynamic>? ?? {};

      // Try different administration routes (Oral preferred)
      final routePreference = [
        'Oral',
        'Insufflated',
        'Rectal',
        'IM',
        'IV',
        'value',
      ];

      for (final route in routePreference) {
        if (formattedDose.containsKey(route)) {
          final routeData = formattedDose[route];
          if (routeData is Map<String, dynamic>) {
            // Extract threshold values
            final threshold = _parseDoseValue(routeData['threshold']);
            final light = _parseDoseValue(routeData['light']);
            final common = _parseDoseValue(routeData['common']);
            final strong = _parseDoseValue(routeData['strong']);
            final heavy = _parseDoseValue(routeData['heavy']);

            if (strong != null && strong > 0) {
              return [
                threshold ?? 0.0,
                light ?? 0.0,
                common ?? 0.0,
                strong,
                heavy ?? (strong * 1.5),
              ];
            }
          }
        }
      }
    }

    // Fallback: Use known thresholds for common drugs
    final knownThresholds = <String, List<double>>{
      'methylphenidate': [5.0, 10.0, 20.0, 40.0, 60.0], // mg
      'amphetamine': [5.0, 10.0, 20.0, 30.0, 50.0], // mg
      'cocaine': [10.0, 20.0, 40.0, 80.0, 120.0], // mg
      'mdma': [50.0, 75.0, 100.0, 150.0, 200.0], // mg
      'lsd': [0.02, 0.05, 0.1, 0.15, 0.25], // mg (20-250µg)
      'psilocybin': [1.0, 2.0, 3.0, 5.0, 7.0], // mg
      'cannabis': [2.5, 5.0, 10.0, 20.0, 30.0], // mg THC
      'alcohol': [
        5000.0,
        10000.0,
        15000.0,
        20000.0,
        30000.0,
      ], // mg (5-30g ethanol)
      'caffeine': [50.0, 100.0, 200.0, 400.0, 600.0], // mg
      'nicotine': [0.5, 1.0, 2.0, 4.0, 6.0], // mg
    };

    final drugLower = drugName.toLowerCase();
    return knownThresholds[drugLower];
  }

  /// Parse dose value from various formats (e.g., "10 mg", "5-10 mg", "10")
  double? _parseDoseValue(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();

    final valueStr = value.toString();
    final doseRegExp = RegExp(r'(\d+(?:\.\d+)?)');
    final match = doseRegExp.firstMatch(valueStr);
    return match != null ? double.tryParse(match.group(1)!) : null;
  }

  /// Normalize dose to intensity percentage using dosage thresholds
  double _normalizeDoseToIntensity(double doseMg, String drugName) {
    final thresholds = _getDosageThresholds(drugName);
    if (thresholds == null || thresholds[3] == 0) {
      // No threshold data available, return dose as-is (assuming mg scale)
      return doseMg.clamp(0.0, 200.0); // Cap at 200% for unknown drugs
    }

    final strongThreshold = thresholds[3]; // "strong" is the 100% baseline
    final normalized = (doseMg / strongThreshold) * 100.0;

    // Allow values above 100% for heavy doses, but cap at 200%
    return normalized.clamp(0.0, 200.0);
  }

  // Helper function to convert technical errors to user-friendly messages
  String _getUserFriendlyErrorMessage(dynamic error) {
    if (error == null) return 'An unexpected error occurred';

    final errorString = error.toString().toLowerCase();

    // Network and connectivity errors
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('unreachable')) {
      return 'Connection problem. Please check your internet and try again.';
    }

    // Authentication errors
    if (errorString.contains('unauthorized') ||
        errorString.contains('authentication') ||
        errorString.contains('login') ||
        errorString.contains('session')) {
      return 'Please log in again to continue.';
    }

    // Database/server errors
    if (errorString.contains('server') ||
        errorString.contains('database') ||
        errorString.contains('supabase') ||
        errorString.contains('500') ||
        errorString.contains('503')) {
      return 'Server is temporarily unavailable. Please try again in a few minutes.';
    }

    // Permission errors
    if (errorString.contains('permission') ||
        errorString.contains('forbidden') ||
        errorString.contains('403')) {
      return 'You don\'t have permission to perform this action.';
    }

    // Validation errors
    if (errorString.contains('validation') ||
        errorString.contains('invalid') ||
        errorString.contains('required')) {
      return 'Please check your information and try again.';
    }

    // Duplicate entry errors
    if (errorString.contains('duplicate') ||
        errorString.contains('unique') ||
        errorString.contains('already exists')) {
      return 'This entry already exists. Please use a different name or check your data.';
    }

    // Rate limiting
    if (errorString.contains('rate') ||
        errorString.contains('too many') ||
        errorString.contains('429')) {
      return 'Too many requests. Please wait a moment and try again.';
    }

    // Default fallback for unknown errors
    return 'Something went wrong. Please try again or contact support if the problem persists.';
  }

  @override
  void initState() {
    super.initState();
    _loadBloodLevelsData();
  }

  Future<void> _loadBloodLevelsData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final user = AuthService.currentUser;
      if (user == null) {
        setState(() {
          _error = 'Please log in to view blood levels';
          _isLoading = false;
        });
        return;
      }

      // Get user_id (same as analytics)
      int userId;
      try {
        final userResponse = await supabase
            .from('users')
            .select('user_id')
            .eq('email', user.email!)
            .single();
        userId = userResponse['user_id'] as int;
      } catch (e) {
        setState(() {
          _error = _getUserFriendlyErrorMessage(e);
          _isLoading = false;
        });
        return;
      }

      // Load drug use data
      final drugUseResponse = await supabase
          .from('drug_use')
          .select('*')
          .eq('user_id', userId)
          .order('start_time', ascending: false);

      // Load drug profiles with comprehensive data for advanced calculations
      final profilesResponse = await supabase
          .from('drug_profiles')
          .select(
            'name, pretty_name, properties, categories, formatted_onset, formatted_duration, formatted_dose',
          );

      // Build comprehensive drug data map
      final drugDataMap = <String, Map<String, dynamic>>{};
      for (final item in profilesResponse) {
        final name = item['name'] as String?;
        final prettyName = item['pretty_name'] as String?;
        final properties = item['properties'] as Map<String, dynamic>?;
        final categories = item['categories'] as List<dynamic>?;
        final formattedOnset = item['formatted_onset'] as Map<String, dynamic>?;
        final formattedDuration =
            item['formatted_duration'] as Map<String, dynamic>?;
        final formattedDose = item['formatted_dose'] as Map<String, dynamic>?;

        final drugInfo = {
          'properties': properties ?? {},
          'categories': categories ?? [],
          'formatted_onset': formattedOnset ?? {},
          'formatted_duration': formattedDuration ?? {},
          'formatted_dose': formattedDose ?? {},
        };

        if (name != null) {
          drugDataMap[name.toLowerCase()] = drugInfo;
        }
        if (prettyName != null) {
          drugDataMap[prettyName.toLowerCase()] = drugInfo;
        }
      }

      setState(() {
        _drugUseData = List<Map<String, dynamic>>.from(drugUseResponse);
        _drugProfiles = {
          'halfLives': <String, double>{}, // Will be populated by estimation
          'drugData': drugDataMap,
        };
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = _getUserFriendlyErrorMessage(error);
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredData() {
    return _drugUseData.where((entry) {
      final drugName = entry['name']?.toString().toLowerCase() ?? '';

      // Apply drug filters
      if (_includedDrugs.isNotEmpty && !_includedDrugs.contains(drugName)) {
        return false;
      }
      if (_excludedDrugs.contains(drugName)) {
        return false;
      }

      // Apply category filters (would need drug profile data)
      // For now, skip category filtering as we don't have that data loaded

      return true;
    }).toList();
  }

  Map<String, Map<String, dynamic>> _calculateRemainingLevels(
    List<Map<String, dynamic>> data, {
    DateTime? referenceTime,
  }) {
    final now = referenceTime ?? DateTime.now();
    final remainingLevels = <String, Map<String, dynamic>>{};

    for (final entry in data) {
      final drugName = entry['name']?.toString().toLowerCase() ?? '';
      final doseString = entry['dose']?.toString() ?? '';
      final startTime = DateTime.tryParse(
        entry['start_time']?.toString() ?? '',
      );
      if (startTime == null) continue;

      // Skip doses taken after the reference time (future doses)
      if (startTime.isAfter(now)) continue;

      // Parse dose from string like '10mg' or '5-10mg'
      final doseRegExp = RegExp(r'(\d+(?:\.\d+)?)');
      final doseMatch = doseRegExp.firstMatch(doseString);
      final dose = doseMatch != null
          ? double.tryParse(doseMatch.group(1)!) ?? 0.0
          : 0.0;
      if (dose <= 0) continue;

      final hoursElapsed = now.difference(startTime).inHours.toDouble();

      // NEW: Use onset+duration based activity determination instead of pharmacokinetic estimation
      final administrationMethod = entry['administration_method']?.toString();
      final activityDurationHours = _getActivityDurationHours(
        drugName,
        administrationMethod,
      );

      // If we have catalog timing data, use timeframe-based activity check
      // Otherwise use simple timeframe-based fallback for known substances
      double remaining;
      double halfLife;
      String method;

      if (activityDurationHours != null && activityDurationHours > 0) {
        // Timeframe-based: substance is active if within onset+duration window
        final isActive = hoursElapsed <= activityDurationHours;
        if (isActive) {
          // Use pharmacokinetic calculation for remaining amount
          final estimationResult = _estimateRemaining(
            dose,
            hoursElapsed,
            drugName,
          );
          remaining = estimationResult['remaining'] ?? 0.0;
          halfLife =
              estimationResult['halfLife'] ?? activityDurationHours / 5.0;
          method =
              'Catalog timing: ${activityDurationHours.toStringAsFixed(1)}h total activity window';
        } else {
          remaining = 0.0;
          halfLife = activityDurationHours / 5.0;
          method =
              'Catalog timing: ${activityDurationHours.toStringAsFixed(1)}h total activity window';
        }
      } else {
        // Fallback: Use simple timeframe-based activity for known substances
        final drugProfile =
            _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
        final profile = drugProfile[drugName] as Map<String, dynamic>?;
        final defaultActivityHours =
            _estimateEffectWindowHours(drugName, drugProfile: profile);

        final isActive = hoursElapsed <= defaultActivityHours;
        if (isActive) {
          // Use pharmacokinetic calculation for remaining amount
          final estimationResult = _estimateRemaining(
            dose,
            hoursElapsed,
            drugName,
          );
          remaining = estimationResult['remaining'] ?? 0.0;
          halfLife = estimationResult['halfLife'] ?? defaultActivityHours / 5.0;
        } else {
          remaining = 0.0;
          halfLife = defaultActivityHours / 5.0;
        }
        method =
            'Default timing: ${defaultActivityHours.toStringAsFixed(1)}h activity window';
      }

      // Debug print for each entry
      print(
        'DEBUG: $drugName - hoursElapsed: $hoursElapsed, activityDurationHours: $activityDurationHours, remaining: $remaining, method: $method',
      );

      if (!remainingLevels.containsKey(drugName)) {
        remainingLevels[drugName] = {
          'totalRemaining': 0.0,
          'totalOriginalDose': 0.0,
          'lastUse': startTime,
          'lastDose': dose,
          'lastDoseRemaining': remaining,
          'halfLife': halfLife,
          'halfLifeMethod': method,
          'entries': <Map<String, dynamic>>[],
        };
      }

      remainingLevels[drugName]!['totalRemaining'] += remaining;
      remainingLevels[drugName]!['totalOriginalDose'] =
          (remainingLevels[drugName]!['totalOriginalDose'] as double? ?? 0.0) +
          dose;
      remainingLevels[drugName]!['entries'].add({
        'dose': dose,
        'originalDoseString': doseString, // Keep the original dose with units
        'startTime': startTime,
        'hoursElapsed': hoursElapsed,
        'remaining': remaining,
      });

      // Update last dose info if this is more recent
      if (startTime.isAfter(remainingLevels[drugName]!['lastUse'])) {
        remainingLevels[drugName]!['lastUse'] = startTime;
        remainingLevels[drugName]!['lastDose'] = dose;
        remainingLevels[drugName]!['lastDoseRemaining'] = remaining;
      }
    }

    return remainingLevels;
  }

  /// Parse maximum value and unit from range string like "30-120 minutes" or "2-4 hours"
  Map<String, dynamic>? _parseMaxFromRangeWithUnit(
    String? rangeStr, [
    String defaultUnit = 'hours',
  ]) {
    if (rangeStr == null) return null;

    final parts = rangeStr.split('-');
    double? maxValue;
    String unit = defaultUnit; // use provided default

    if (parts.length == 2) {
      // Range like "30-120 minutes"
      final maxStr = parts[1].trim();
      final unitMatch = RegExp(
        r'(\d+(?:\.\d+)?)\s*(minutes?|hours?|min|h|hrs|m)?',
      ).firstMatch(maxStr);
      if (unitMatch != null) {
        maxValue = double.tryParse(unitMatch.group(1)!);
        final unitStr = unitMatch.group(2);
        if (unitStr != null) {
          unit =
              unitStr.toLowerCase().contains('h') ||
                  unitStr.toLowerCase().contains('hour')
              ? 'hours'
              : 'minutes';
        }
      } else {
        maxValue = double.tryParse(maxStr);
      }
    } else {
      // Single value like "60 minutes" or just "60"
      final unitMatch = RegExp(
        r'(\d+(?:\.\d+)?)\s*(minutes?|hours?|min|h|hrs|m)?',
      ).firstMatch(rangeStr.trim());
      if (unitMatch != null) {
        maxValue = double.tryParse(unitMatch.group(1)!);
        final unitStr = unitMatch.group(2);
        if (unitStr != null) {
          unit =
              unitStr.toLowerCase().contains('h') ||
                  unitStr.toLowerCase().contains('hour')
              ? 'hours'
              : 'minutes';
        }
      } else {
        maxValue = double.tryParse(rangeStr.trim());
      }
    }

    if (maxValue == null) return null;

    return {'value': maxValue, 'unit': unit};
  }

  /// Parse value and unit from either string range or numeric value with separate unit
  Map<String, dynamic>? _parseValueWithUnit(
    dynamic value,
    String? globalUnit,
    String defaultUnit,
  ) {
    if (value == null) return null;

    if (value is num) {
      // Numeric value with separate unit
      final unit = globalUnit ?? defaultUnit;
      return {'value': value.toDouble(), 'unit': unit};
    } else if (value is String) {
      // String range or single value with embedded unit
      return _parseMaxFromRangeWithUnit(value, defaultUnit);
    }

    return null;
  }

  /// Extract max onset + max duration in hours for activity determination
  double? _getActivityDurationHours(
    String drugName,
    String? administrationMethod,
  ) {
    final drugData = _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
    final drugProfile = drugData[drugName] as Map<String, dynamic>?;

    if (drugProfile == null) {
      return null;
    }

    final formattedOnset =
        drugProfile['formatted_onset'] as Map<String, dynamic>?;
    final formattedDuration =
        drugProfile['formatted_duration'] as Map<String, dynamic>?;

    if (formattedOnset == null || formattedDuration == null) {
      return null;
    }

    // Try administration method first, then fallbacks
    final methodKeys = [
      administrationMethod,
      'Oral_IR',
      'Oral_ER',
      'Oral',
      'Insufflated',
      'IV',
      'IM',
      'Rectal',
      'value', // fallback
    ];

    String? onsetKey;
    String? durationKey;

    for (final key in methodKeys) {
      if (key != null) {
        if (formattedOnset.containsKey(key)) onsetKey = key;
        if (formattedDuration.containsKey(key)) durationKey = key;
      }
    }

    if (onsetKey == null || durationKey == null) return null;

    final onsetValue = formattedOnset[onsetKey];
    final durationValue = formattedDuration[durationKey];

    // Parse max values and units from ranges or numeric values
    final onsetResult = _parseValueWithUnit(
      onsetValue,
      formattedOnset['_unit'],
      'minutes',
    );
    final durationResult = _parseValueWithUnit(
      durationValue,
      formattedDuration['_unit'],
      'hours',
    );

    if (onsetResult == null || durationResult == null) return null;

    final maxOnset = onsetResult['value'] as double;
    final onsetUnit = onsetResult['unit'] as String;
    final maxDuration = durationResult['value'] as double;
    final durationUnit = durationResult['unit'] as String;

    // Convert both to hours
    final onsetHours = onsetUnit.toLowerCase() == 'hours'
        ? maxOnset
        : maxOnset / 60.0;
    final durationHours = durationUnit.toLowerCase() == 'hours'
        ? maxDuration
        : maxDuration / 60.0;

    final totalHours = onsetHours + durationHours;
    return totalHours;
  }

  /// Advanced 3-tier half-life estimation system (matching Python analytics)
  Map<String, dynamic> _estimateRemaining(
    double doseMg,
    double hoursElapsed,
    String drugName,
  ) {
    final drugData = _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
    final drugProfile = drugData[drugName] as Map<String, dynamic>?;

    const double fallbackHalfLife = 12.0;
    double halfLife = fallbackHalfLife;
    double remaining = doseMg * pow(0.5, hoursElapsed / halfLife);
    String method = 'Default estimation (${fallbackHalfLife.toStringAsFixed(0)}h half-life)';
    bool resolved = false;

    // Tier 1: Real PubChem half-life from properties
    if (drugProfile != null) {
      final properties =
          drugProfile['properties'] as Map<String, dynamic>? ?? {};
      final halfLifeHours = properties['half_life_hours'];
      if (halfLifeHours is num && halfLifeHours > 0) {
        halfLife = halfLifeHours.toDouble();
        remaining = doseMg * pow(0.5, hoursElapsed / halfLife);
        method = 'Real half-life: ${halfLifeHours}h';
        resolved = true;
      }
    }

    // Tier 2: Duration-based estimation (leverages catalog durations)
    if (!resolved && drugProfile != null) {
      final categories = drugProfile['categories'] as List<dynamic>? ?? [];
      final skipDurationBased =
          categories.contains('Long-acting') ||
          categories.contains('Benzodiazepine') ||
          categories.contains('Opioid');

      final derivedHalfLife = _deriveHalfLife(drugName, drugProfile);
      if (!skipDurationBased &&
          derivedHalfLife != null &&
          derivedHalfLife > 0) {
        halfLife = derivedHalfLife.clamp(0.5, 72.0);
        remaining = doseMg * pow(0.5, hoursElapsed / halfLife);
        method =
            'Duration-based: ~${halfLife.toStringAsFixed(1)}h half-life (onset+duration)';
        resolved = true;
      }
    }

    // Tier 3: Category-based estimation
    if (!resolved) {
      final halfLifeRange = _getHalfLifeEstimate(drugName);
      if (halfLifeRange != null) {
        final minHl = halfLifeRange[0];
        final maxHl = halfLifeRange[1];
        halfLife = minHl.toDouble();
        remaining = doseMg * pow(0.5, hoursElapsed / halfLife);
        final categoryDesc = _getCategoryDescription(drugName, halfLifeRange);
        method = '$categoryDesc ($minHl-${maxHl}h half-life)';
        resolved = true;
      }
    }

    if (!resolved) {
      halfLife = fallbackHalfLife;
      remaining = doseMg * pow(0.5, hoursElapsed / halfLife);
      method = 'Default estimation (${fallbackHalfLife.toStringAsFixed(0)}h half-life)';
    }

    final effectWindowHours =
        _estimateEffectWindowHours(drugName, drugProfile: drugProfile);
    if (effectWindowHours > 0) {
      final adjustedWindow = max(effectWindowHours * 0.6, 1.0);
      final progress = (hoursElapsed / adjustedWindow).clamp(0.0, 1.0);
      final effectCurve = pow(1 - progress, 1.2).toDouble();
      final effectRemaining = doseMg * effectCurve;
      if (effectRemaining < remaining) {
        remaining = effectRemaining;
        method = '$method; effect window ${effectWindowHours.toStringAsFixed(1)}h';
      }
    }

    return {
      'remaining': remaining.clamp(0.0, doseMg),
      'halfLife': halfLife,
      'method': method,
    };
  }
  /// Extract duration from formatted_duration (similar to Python pick_duration_hours)
  double? _pickDurationHours(Map<String, dynamic> drugProfile) {
    final formattedDuration =
        drugProfile['formatted_duration'] as Map<String, dynamic>?;
    if (formattedDuration == null) return null;

    // Preferred routes in order
    const routePreference = [
      'Oral',
      'Insufflated',
      'Rectal',
      'IM',
      'IV',
      'value',
    ];

    // Try route-specific fields
    for (final route in routePreference) {
      if (formattedDuration.containsKey(route)) {
        final value = formattedDuration[route];
        if (value is String) {
          final parsed = _parseDurationRange(value);
          if (parsed != null) {
            return parsed;
          }
        } else if (value is num) {
          return _toHours(
            formattedDuration['_unit'] as String?,
            value.toDouble(),
          );
        }
      }
    }

    // Fallback: concatenate all non-unit values
    final payload = <String>[];
    formattedDuration.forEach((key, value) {
      if (key != '_unit' && value != null) {
        payload.add(value.toString());
      }
    });

    if (payload.isNotEmpty) {
      final combined = payload.join('|');
      return _parseDurationRange(combined);
    }

    return null;
  }

  /// Parse duration range like "3-5" or "8-16 hours"
  double? _parseDurationRange(String text) {
    final regExp = RegExp(r'(\d+(?:\.\d+)?)');
    final matches = regExp.allMatches(text);
    if (matches.isEmpty) return null;

    final values = matches
        .map((m) => double.tryParse(m.group(1)!))
        .whereType<double>()
        .toList();
    if (values.isEmpty) return null;

    // Return average of range
    return values.reduce((a, b) => a + b) / values.length;
  }

  double? _pickOnsetHours(Map<String, dynamic> drugProfile) {
    final formattedOnset =
        drugProfile['formatted_onset'] as Map<String, dynamic>?;
    if (formattedOnset == null) return null;

    const routePreference = [
      'Oral',
      'Insufflated',
      'Rectal',
      'IM',
      'IV',
      'Sublingual',
      'value',
    ];

    for (final route in routePreference) {
      if (formattedOnset.containsKey(route)) {
        final value = formattedOnset[route];
        if (value is String) {
          final parsed = _parseDurationRange(value);
          if (parsed != null) {
            return parsed;
          }
        } else if (value is num) {
          return _toHours(
            formattedOnset['_unit'] as String?,
            value.toDouble(),
          );
        }
      }
    }

    final payload = <String>[];
    formattedOnset.forEach((key, value) {
      if (key != '_unit' && value != null) {
        payload.add(value.toString());
      }
    });

    if (payload.isNotEmpty) {
      final combined = payload.join('|');
      return _parseDurationRange(combined);
    }

    return null;
  }

  /// Convert duration to hours based on unit
  double _toHours(String? unit, double value) {
    if (unit == null) return value;

    final unitLower = unit.toLowerCase();
    if (unitLower.contains('min')) {
      return value / 60.0;
    } else if (unitLower.contains('day')) {
      return value * 24.0;
    }
    // Default to hours
    return value;
  }

  /// Get half-life estimate range for a drug (returns [min, max] half-life in hours)
  List<double>? _getHalfLifeEstimate(String drugName) {
    final drugData = _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
    final drugProfile = drugData[drugName] as Map<String, dynamic>?;

    String? drugClass;
    List<dynamic> categories = const [];

    // Determine drug class from categories
    if (drugProfile != null) {
      categories = drugProfile['categories'] as List<dynamic>? ?? [];
      for (final category in categories) {
        final catLower = category.toString().toLowerCase();
        if (catLower == 'benzodiazepine') {
          drugClass = 'benzodiazepine';
          break;
        } else if (catLower == 'opioid') {
          drugClass = 'opioid';
          break;
        } else if (catLower == 'stimulant') {
          drugClass = 'stimulant';
          break;
        } else if (catLower == 'psychedelic') {
          drugClass = 'psychedelic';
          break;
        } else if (catLower == 'empathogen') {
          drugClass = 'empathogen';
          break;
        } else if (catLower == 'dissociative') {
          drugClass = 'dissociative';
          break;
        } else if (catLower == 'cannabinoid') {
          drugClass = 'cannabinoid';
          break;
        }
      }

      // Get duration for classification
      final onsetHours = _pickOnsetHours(drugProfile) ?? 0.5;
      final durationOnly = _pickDurationHours(drugProfile);
      if (durationOnly != null) {
        final combined = durationOnly + onsetHours;
        if (combined > 0) {
          return _classifyHalfLife(drugClass, combined);
        }
      } else if (onsetHours > 0.0) {
        return _classifyHalfLife(drugClass, onsetHours);
      }
    }

    final effectWindow =
        _estimateEffectWindowHours(drugName, drugProfile: drugProfile);
    if (effectWindow > 0) {
      return _classifyHalfLife(drugClass, effectWindow);
    }

    return _classifyHalfLife(drugClass, null);
  }

  List<double>? _classifyHalfLife(
    String? drugClass,
    double? windowHours,
  ) {
    final durationHours = windowHours;

    if (drugClass == 'benzodiazepine') {
      if (durationHours != null) {
        if (durationHours < 8) return [4, 8]; // short
        if (durationHours < 24) return [8, 15]; // intermediate
        return [20, 60]; // long
      }
      return [8, 15]; // default intermediate
    } else if (drugClass == 'opioid') {
      if (durationHours != null && durationHours < 6) {
        return [2, 6]; // short
      }
      return [24, 48]; // long
    } else if (drugClass == 'stimulant') {
      if (durationHours != null) {
        if (durationHours < 6) return [4, 6]; // cathinone-type
        if (durationHours < 12) return [8, 12]; // amphetamine-type
        return [12, 24]; // long-acting
      }
      return [8, 12]; // default amphetamine-type
    } else if (drugClass == 'psychedelic') {
      if (durationHours != null && durationHours < 6) {
        return [1, 3]; // tryptamine
      }
      return [3, 5]; // phenethylamine
    } else if (drugClass == 'empathogen') {
      return [6, 10];
    } else if (drugClass == 'dissociative') {
      return [2, 5];
    } else if (drugClass == 'cannabinoid') {
      return [20, 30];
    }

    // Unknown category fallback
    return [4, 8];
  }

  double _estimateEffectWindowHours(
    String drugName, {
    Map<String, dynamic>? drugProfile,
  }) {
    final profiles =
        _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
    final profile = drugProfile ?? profiles[drugName] as Map<String, dynamic>?;

    double? durationHours =
        profile != null ? _pickDurationHours(profile) : null;
    double? onsetHours = profile != null ? _pickOnsetHours(profile) : null;

    if (durationHours != null || onsetHours != null) {
      final total =
          (durationHours ?? 0.0) + (onsetHours ?? 0.5); // assume 30m onset
      if (total > 0) return total;
    }

    final categories = profile?['categories'] as List<dynamic>? ?? [];
    return _categoryDefaultWindow(categories);
  }

  double _categoryDefaultWindow(List<dynamic> categories) {
    final normalized = categories
        .map((c) => c.toString().toLowerCase())
        .toList(growable: false);

    if (normalized.contains('benzodiazepine')) return 24.0;
    if (normalized.contains('psychedelic')) return 12.0;
    if (normalized.contains('cannabinoid')) return 6.0;
    if (normalized.contains('opioid')) return 6.0;
    if (normalized.contains('dissociative')) return 6.0;
    if (normalized.contains('empathogen')) return 8.0;
    if (normalized.contains('stimulant')) return 8.0;
    if (normalized.contains('supplement')) return 6.0;
    if (normalized.contains('nootropic')) return 8.0;
    return 8.0;
  }

  double? _deriveHalfLife(
    String drugName,
    Map<String, dynamic>? drugProfile,
  ) {
    final profiles =
        _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
    final profile = drugProfile ?? profiles[drugName] as Map<String, dynamic>?;

    if (profile == null) return null;

    final durationHours = _pickDurationHours(profile);
    final onsetHours = _pickOnsetHours(profile);

    if (durationHours != null || onsetHours != null) {
      final totalWindow =
          (durationHours ?? 0.0) + (onsetHours ?? 0.5); // assume 30 min onset
      if (totalWindow > 0) {
        return (totalWindow / 2).clamp(0.5, 72.0);
      }
    }

    final effectWindow =
        _estimateEffectWindowHours(drugName, drugProfile: profile);
    if (effectWindow > 0) {
      return (effectWindow / 2).clamp(0.5, 72.0);
    }

    return null;
  }

  /// Get descriptive category name for display
  String _getCategoryDescription(String drugName, List<double> halfLifeRange) {
    final drugData = _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
    final drugProfile = drugData[drugName] as Map<String, dynamic>?;

    String? drugClass;

    if (drugProfile != null) {
      final categories = drugProfile['categories'] as List<dynamic>? ?? [];
      for (final category in categories) {
        final catLower = category.toString().toLowerCase();
        if (catLower == 'benzodiazepine') {
          drugClass = 'benzodiazepine';
          break;
        } else if (catLower == 'opioid') {
          drugClass = 'opioid';
          break;
        } else if (catLower == 'stimulant') {
          drugClass = 'stimulant';
          break;
        } else if (catLower == 'psychedelic') {
          drugClass = 'psychedelic';
          break;
        } else if (catLower == 'empathogen') {
          drugClass = 'empathogen';
          break;
        } else if (catLower == 'dissociative') {
          drugClass = 'dissociative';
          break;
        } else if (catLower == 'cannabinoid') {
          drugClass = 'cannabinoid';
          break;
        }
      }
    }

    String formatDuration(double? dur) =>
        dur != null ? dur.toStringAsFixed(1) : 'unknown';

    // Create descriptive category name
    if (drugClass == 'benzodiazepine') {
      if (halfLifeRange[0] >= 20) {
        return 'Long-acting benzodiazepine (~$formatDuration(avgDuration)h duration)';
      } else if (halfLifeRange[0] >= 8) {
        return 'Intermediate-acting benzodiazepine (~$formatDuration(avgDuration)h duration)';
      } else {
        return 'Short-acting benzodiazepine (~$formatDuration(avgDuration)h duration)';
      }
    } else if (drugClass == 'opioid') {
      if (halfLifeRange[0] >= 24) {
        return 'Long-acting opioid (~$formatDuration(avgDuration)h duration)';
      } else {
        return 'Short-acting opioid (~$formatDuration(avgDuration)h duration)';
      }
    } else if (drugClass == 'stimulant') {
      if (halfLifeRange[0] >= 12) {
        return 'Long-acting stimulant (~$formatDuration(avgDuration)h duration)';
      } else if (halfLifeRange[0] >= 8) {
        return 'Intermediate-acting stimulant (~$formatDuration(avgDuration)h duration)';
      } else {
        return 'Short-acting stimulant (~$formatDuration(avgDuration)h duration)';
      }
    } else if (drugClass == 'psychedelic') {
      if (halfLifeRange[0] < 3) {
        return 'Short-duration psychedelic (~$formatDuration(avgDuration)h duration)';
      } else {
        return 'Long-duration psychedelic (~$formatDuration(avgDuration)h duration)';
      }
    } else if (drugClass == 'empathogen') {
      return 'Empathogen (~$formatDuration(avgDuration)h duration)';
    } else if (drugClass == 'dissociative') {
      return 'Dissociative (~$formatDuration(avgDuration)h duration)';
    } else if (drugClass == 'cannabinoid') {
      return 'Cannabinoid (~$formatDuration(avgDuration)h duration)';
    } else if (drugClass != null) {
      return '${drugClass[0].toUpperCase()}${drugClass.substring(1)} (~$formatDuration(avgDuration)h duration)';
    }

    return 'Unknown category (~$formatDuration(avgDuration)h duration)';
  }

  List<String> _getAvailableDrugs() {
    return _drugUseData
        .map((entry) => entry['name']?.toString().toLowerCase() ?? '')
        .toSet()
        .toList()
      ..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BloodLevelsTheme.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [BloodLevelsTheme.backgroundColor, BloodLevelsTheme.backgroundSecondary],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildFuturisticTopBar(),
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuturisticTopBar() {
    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BloodLevelsTheme.surfaceColor.withOpacity(0.9),
            BloodLevelsTheme.surfaceColor.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(color: BloodLevelsTheme.accentCyan.withOpacity(0.2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: BloodLevelsTheme.accentCyan.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BloodLevelsTheme.surfaceColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: BloodLevelsTheme.accentCyan.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: BloodLevelsTheme.accentCyan.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: BloodLevelsTheme.accentCyan,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),

          // App title section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [BloodLevelsTheme.accentCyan, BloodLevelsTheme.accentPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: BloodLevelsTheme.accentCyan.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.biotech, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'BioLevels',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: BloodLevelsTheme.accentCyan,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: BloodLevelsTheme.accentCyan.withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Real-Time Pharmacokinetic Monitor',
                  style: TextStyle(
                    fontSize: 12,
                    color: BloodLevelsTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Live indicator and clock
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: BloodLevelsTheme.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: BloodLevelsTheme.accentCyan.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing LIVE indicator
                AnimatedBuilder(
                  animation: AnimationController(
                    duration: const Duration(milliseconds: 1000),
                    vsync: Navigator.of(context),
                  )..repeat(reverse: true),
                  builder: (context, child) {
                    return Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: BloodLevelsTheme.accentCyan,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: BloodLevelsTheme.accentCyan.withOpacity(0.6),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: BloodLevelsTheme.accentCyan,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, color: BloodLevelsTheme.textSecondary, size: 14),
                const SizedBox(width: 4),
                Text(
                  timeString,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: BloodLevelsTheme.textPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return _isLoading
        ? Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [BloodLevelsTheme.backgroundColor, BloodLevelsTheme.backgroundSecondary],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF00F5FF),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Analyzing your system...',
                    style: TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : _error.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [BloodLevelsTheme.backgroundColor, BloodLevelsTheme.backgroundSecondary],
              ),
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: BloodLevelsTheme.accentRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: BloodLevelsTheme.accentRed.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: BloodLevelsTheme.accentRed, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      _error,
                      style: TextStyle(color: BloodLevelsTheme.textPrimary, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        : _buildBioLevelsDashboard();
  }

  Widget _buildBioLevelsDashboard() {
    final filteredData = _getFilteredData();
    final remainingLevels = _calculateRemainingLevels(
      filteredData,
      referenceTime: _selectedTime,
    );
    final availableDrugs = _getAvailableDrugs();

    // Filter out drugs with no individual dose having >=5 remaining
    final filteredRemainingLevels = Map.fromEntries(
      remainingLevels.entries.where((entry) {
        final data = entry.value;
        final entries = data['entries'] as List<Map<String, dynamic>>;
        return entries.any((entry) => (entry['remaining'] as double) >= 5.0);
      }),
    );

    // Debug print filtered results
    print('DEBUG: Total remaining levels: ${remainingLevels.length}');
    print(
      'DEBUG: Filtered remaining levels: ${filteredRemainingLevels.length}',
    );
    filteredRemainingLevels.forEach((drug, data) {
      final totalRemaining = data['totalRemaining'] as double;
      final entries = data['entries'] as List<Map<String, dynamic>>;
      final qualifyingEntries = entries
          .where((entry) => (entry['remaining'] as double) >= 5.0)
          .length;
      print(
        'DEBUG: $drug - totalRemaining: ${totalRemaining.toStringAsFixed(1)}, qualifying entries: $qualifyingEntries',
      );
    });

    // Get recent doses from past 24 hours
    final recentDoses = _getRecentDoses(filteredData, 24);

    // Check if screen width is small (mobile/tablet)
    final isSmallScreen = MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System Overview Section
          _buildModernSystemOverview(remainingLevels, recentDoses.length),
          const SizedBox(height: 24),

          // Risk Assessment Section
          _buildModernRiskAssessment(remainingLevels),
          const SizedBox(height: 24),

          // Main Dashboard Content
          if (isSmallScreen) ...[
            // Mobile/Tablet: Stacked layout
            _buildActiveSubstancesColumn(filteredRemainingLevels),
            const SizedBox(height: 20),
            _buildHistoricalDosesColumn(recentDoses, remainingLevels),
            const SizedBox(height: 20),
            _buildMetabolismTimelineSection(remainingLevels, filteredData),
          ] else ...[
            // Desktop: Two-column layout
            SizedBox(
              height: 400, // Fixed height for the two columns
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Active Substances (2/3 width)
                  Expanded(
                    flex: 2,
                    child: _buildActiveSubstancesColumn(
                      filteredRemainingLevels,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Right Column: Historical Doses (1/3 width)
                  Expanded(
                    flex: 1,
                    child: _buildHistoricalDosesColumn(
                      recentDoses,
                      remainingLevels,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Full-width Metabolism Timeline
            _buildMetabolismTimelineSection(remainingLevels, filteredData),
          ],

          const SizedBox(height: 24),
          // Advanced Filters
          _buildAdvancedFilters(availableDrugs),
        ],
      ),
    );
  }

  Widget _buildSystemOverview(
    Map<String, Map<String, dynamic>> remainingLevels,
  ) {
    final activeDrugs = remainingLevels.values.where((data) {
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage > 1;
    }).length;

    final pharmacologicalDrugs = remainingLevels.values.where((data) {
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage > 10;
    }).length;

    final recentUses = remainingLevels.values.where((data) {
      final lastUse = data['lastUse'] as DateTime;
      return _selectedTime.difference(lastUse).inHours < 24;
    }).length;

    // Calculate total active dose
    final totalActiveDose = remainingLevels.values.fold<double>(0.0, (
      sum,
      data,
    ) {
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage > 1 ? sum + lastDoseRemaining : sum;
    });

    final validTimes = remainingLevels.values
        .where((data) {
          final lastDose = data['lastDose'] as double;
          final lastDoseRemaining = data['lastDoseRemaining'] as double;
          final percentage = lastDose > 0
              ? (lastDoseRemaining / lastDose) * 100
              : 0.0;
          return percentage > 1;
        })
        .map((data) {
          final lastDose = data['lastDose'] as double;
          final lastDoseRemaining = data['lastDoseRemaining'] as double;
          final percentage = lastDose > 0
              ? (lastDoseRemaining / lastDose) * 100
              : 0.0;
          final halfLife = data['halfLife'] as double;
          final lastUse = data['lastUse'] as DateTime;
          final hoursElapsed = _selectedTime.difference(lastUse).inHours;

          final timeToClear = percentage > 0 && percentage < 100
              ? halfLife * (log(1.0) - log(percentage / 100)) / log(0.5)
              : percentage >= 100
              ? 0.0
              : double.infinity;
          return timeToClear - hoursElapsed;
        })
        .where((time) => time > 0 && time.isFinite)
        .toList();

    final avgTimeToClear = validTimes.isNotEmpty
        ? validTimes.reduce((a, b) => a + b) / validTimes.length
        : 0.0;

    String formatTime(double hours) {
      if (hours.isInfinite || hours.isNaN) return '∞';
      if (hours < 1) return '<1h';
      if (hours < 24) return '${hours.toStringAsFixed(0)}h';
      final days = (hours / 24).floor();
      return '${days}d';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BloodLevelsTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BloodLevelsTheme.textPrimary.withValues(alpha: 26)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCircularIndicator(
                  value: activeDrugs.toDouble(),
                  maxValue: remainingLevels.length.toDouble().clamp(
                    1,
                    double.infinity,
                  ),
                  label: 'Active',
                  subtitle: 'Substances',
                  color: BloodLevelsTheme.accentCyan,
                  icon: Icons.science,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCircularIndicator(
                  value: pharmacologicalDrugs.toDouble(),
                  maxValue: remainingLevels.length.toDouble().clamp(
                    1,
                    double.infinity,
                  ),
                  label: 'Strong',
                  subtitle: 'Effects',
                  color: BloodLevelsTheme.accentAmber,
                  icon: Icons.warning_amber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCircularIndicator(
                  value: recentUses.toDouble(),
                  maxValue: remainingLevels.length.toDouble().clamp(
                    1,
                    double.infinity,
                  ),
                  label: 'Recent',
                  subtitle: '24h',
                  color: BloodLevelsTheme.accentPurple,
                  icon: Icons.schedule,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCircularIndicator(
                  value: totalActiveDose.clamp(
                    0,
                    10,
                  ), // Normalize to 0-10 scale
                  maxValue: 10,
                  label: 'Total',
                  subtitle: 'Dose',
                  color: BloodLevelsTheme.accentRed,
                  icon: Icons.scale,
                  showValue: '${totalActiveDose.toStringAsFixed(1)}u',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BloodLevelsTheme.accentCyan.withValues(alpha: 13),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: BloodLevelsTheme.accentCyan.withValues(alpha: 26)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_bottom, color: BloodLevelsTheme.accentCyan, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Avg. Clear Time: ${formatTime(avgTimeToClear)}',
                  style: TextStyle(
                    color: BloodLevelsTheme.accentCyan,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIndicator({
    required double value,
    required double maxValue,
    required String label,
    required String subtitle,
    required Color color,
    required IconData icon,
    String? showValue,
  }) {
    final progress = maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: color.withValues(alpha: 26),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 4,
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: BloodLevelsTheme.surfaceColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 51),
                  width: 2,
                ),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          showValue ?? value.toStringAsFixed(0),
          style: TextStyle(
            color: BloodLevelsTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: BloodLevelsTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: BloodLevelsTheme.textSecondary.withValues(alpha: 179),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSubstancesGrid(
    Map<String, Map<String, dynamic>> filteredRemainingLevels,
  ) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: GridView.builder(
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: filteredRemainingLevels.length,
        itemBuilder: (context, index) {
          final entry = filteredRemainingLevels.entries.elementAt(index);
          return _buildEnhancedDrugCard(entry.key, entry.value);
        },
      ),
    );
  }

  Widget _buildEnhancedDrugCard(String drugName, Map<String, dynamic> data) {
    final lastDose = data['lastDose'] as double;
    final lastDoseRemaining = data['lastDoseRemaining'] as double;
    final percentage = lastDose > 0
        ? (lastDoseRemaining / lastDose) * 100
        : 0.0;
    final lastUse = data['lastUse'] as DateTime;
    final halfLife = data['halfLife'] as double;
    final hoursElapsed = _selectedTime.difference(lastUse).inHours.toDouble();

    // Calculate time remaining until <1%
    final timeToClear = percentage > 0.01
        ? halfLife * (log(1.0) - log(percentage / 100)) / log(0.5)
        : double.infinity;
    final timeRemaining = timeToClear.isFinite
        ? timeToClear - hoursElapsed
        : double.infinity;

    Color getStatusColor(double pct) {
      if (pct > 20) return BloodLevelsTheme.accentRed;
      if (pct > 10) return BloodLevelsTheme.accentAmber;
      if (pct > 5) return BloodLevelsTheme.accentAmber;
      if (pct > 1) return BloodLevelsTheme.accentCyan;
      return const Color(0xFF10B981);
    }

    Color getCategoryColor(String drugName) {
      final drugData = _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
      final drugProfile = drugData[drugName] as Map<String, dynamic>?;

      if (drugProfile != null) {
        final categories = drugProfile['categories'] as List<dynamic>? ?? [];
        for (final category in categories) {
          final catLower = category.toString().toLowerCase();
          if (catLower == 'stimulant') return BloodLevelsTheme.accentAmber;
          if (catLower == 'opioid') return BloodLevelsTheme.accentRed;
          if (catLower == 'psychedelic') return BloodLevelsTheme.accentPurple;
          if (catLower == 'benzodiazepine') return BloodLevelsTheme.accentCyan;
        }
      }
      return BloodLevelsTheme.accentCyan; // default
    }

    String getStatusText(double pct) {
      if (pct > 20) return 'High';
      if (pct > 10) return 'Moderate';
      if (pct > 5) return 'Low';
      if (pct > 1) return 'Trace';
      return 'Clear';
    }

    String formatTimeRemaining(double hours) {
      if (hours.isInfinite || hours.isNaN) return 'N/A';
      if (hours < 1) return '<1h';
      if (hours < 24) return '${hours.toStringAsFixed(0)}h';
      final days = (hours / 24).floor();
      return '${days}d';
    }

    final categoryColor = _getCategoryColor(drugName);

    return GestureDetector(
      onTap: () => _showDrugDetails(drugName, data),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: BloodLevelsTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BloodLevelsTheme.textPrimary.withValues(alpha: 26)),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(alpha: 26),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and percentage
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: getStatusColor(percentage).withValues(alpha: 51),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    drugName[0].toUpperCase(),
                    style: TextStyle(
                      color: getStatusColor(percentage),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drugName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: BloodLevelsTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        getStatusText(percentage),
                        style: TextStyle(
                          fontSize: 10,
                          color: getStatusColor(percentage),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(percentage).withValues(alpha: 26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: getStatusColor(percentage),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Progress bar with time remaining
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: BloodLevelsTheme.textPrimary.withValues(alpha: 26),
                borderRadius: BorderRadius.circular(1.5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (percentage / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: getStatusColor(percentage),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Sparkline chart (simplified)
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 13),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    color: categoryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Metabolism',
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Compact info row
            Row(
              children: [
                // Time remaining
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.hourglass_bottom,
                        size: 12,
                        color: BloodLevelsTheme.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        formatTimeRemaining(timeRemaining),
                        style: TextStyle(fontSize: 10, color: BloodLevelsTheme.textSecondary),
                      ),
                    ],
                  ),
                ),

                // Half-life
                Row(
                  children: [
                    Icon(Icons.timeline, size: 12, color: BloodLevelsTheme.textSecondary),
                    const SizedBox(width: 2),
                    Text(
                      '${halfLife.toStringAsFixed(1)}h',
                      style: TextStyle(fontSize: 10, color: BloodLevelsTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Concentration and last use
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${lastDoseRemaining.toStringAsFixed(2)}u',
                    style: TextStyle(
                      fontSize: 12,
                      color: BloodLevelsTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  lastUse.toLocal().toString().substring(5, 16),
                  style: TextStyle(fontSize: 9, color: BloodLevelsTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetabolismChart(
    Map<String, Map<String, dynamic>> remainingLevels,
    List<Map<String, dynamic>> drugUseData,
  ) {
    final now = _selectedTime;

    // Get active drugs (those with >1% remaining)
    final activeDrugs = remainingLevels.entries.where((entry) {
      final data = entry.value;
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage >= 1.0;
    }).toList();

    if (activeDrugs.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: BloodLevelsTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BloodLevelsTheme.textPrimary.withValues(alpha: 26)),
        ),
        child: const Center(
          child: Text(
            'No active substance data',
            style: TextStyle(color: Color(0xFFB8B8D1), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Create line data for each active drug
    final lineBarsData = <LineChartBarData>[];
    final legendItems = <Map<String, dynamic>>[];

    for (final drugEntry in activeDrugs) {
      final drugName = drugEntry.key;
      final drugData = drugEntry.value;
      final entries = drugData['entries'] as List<Map<String, dynamic>>;

      // Calculate decay curve for this drug by summing all individual doses
      final drugLineData = <FlSpot>[];
      for (int hour = -_chartPastHours; hour <= _chartFutureHours; hour += 2) {
        final timePoint = now.add(Duration(hours: hour));
        double totalRemainingAtTime = 0.0;

        // Sum contributions from all doses that are still active at this time point
        for (final entry in entries) {
          final dose = entry['dose'] as double;
          final startTime = entry['startTime'] as DateTime;
          final hoursElapsed = timePoint
              .difference(startTime)
              .inHours
              .toDouble();

          // Only calculate if this dose was taken before or at this time point
          if (hoursElapsed >= 0) {
            // Use the same half-life estimation for consistency
            final estimationResult = _estimateRemaining(
              dose,
              hoursElapsed,
              drugName,
            );
            final remaining = estimationResult['remaining'] ?? 0.0;
            totalRemainingAtTime += remaining;
          }
        }

        // Normalize to intensity percentage based on total remaining
        final normalizedIntensity = totalRemainingAtTime > 0
            ? _normalizeDoseToIntensity(totalRemainingAtTime, drugName)
            : 0.0;

        drugLineData.add(FlSpot(hour.toDouble(), normalizedIntensity));
      }

      final drugColor = _getCategoryColor(drugName);

      lineBarsData.add(
        LineChartBarData(
          spots: drugLineData,
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
                drugColor.withValues(alpha: 102), // 0.4 opacity
                drugColor.withValues(alpha: 51), // 0.2 opacity
                drugColor.withValues(alpha: 0), // 0 opacity
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      );

      legendItems.add({'name': drugName.toUpperCase(), 'color': drugColor});
    }

    // Calculate max Y value for scaling
    double maxY = 0.0;
    for (final lineData in lineBarsData) {
      for (final spot in lineData.spots) {
        if (spot.y > maxY) maxY = spot.y;
      }
    }
    maxY = maxY * 1.3; // Add 30% padding
    if (!_chartAdaptiveMax) {
      maxY = maxY < 100
          ? 100
          : maxY; // Ensure minimum of 100% when not adaptive
    }

    return Container(
      height:
          MediaQuery.of(context).size.height *
          0.35, // Increased height for legend
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: BloodLevelsTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BloodLevelsTheme.textPrimary.withValues(alpha: 26)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: BloodLevelsTheme.accentCyan, size: 18),
              const SizedBox(width: 6),
              Text(
                'Metabolism Timeline',
                style: TextStyle(
                  color: BloodLevelsTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Legend
          Container(
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
                        style: TextStyle(
                          color: BloodLevelsTheme.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: BloodLevelsTheme.textPrimary.withValues(alpha: 13),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
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
                        if (hour == -_chartPastHours) {
                          return Text(
                            '-${_chartPastHours}h',
                            style: TextStyle(
                              color: Color(0xFFB8B8D1),
                              fontSize: 10,
                            ),
                          );
                        }
                        if (hour == 0) {
                          return Text(
                            'Now',
                            style: TextStyle(
                              color: Color(0xFFB8B8D1),
                              fontSize: 10,
                            ),
                          );
                        }
                        if (hour == 24) {
                          return Text(
                            '+24h',
                            style: TextStyle(
                              color: Color(0xFFB8B8D1),
                              fontSize: 10,
                            ),
                          );
                        }
                        if (hour == _chartFutureHours) {
                          return Text(
                            '+${_chartFutureHours}h',
                            style: TextStyle(
                              color: Color(0xFFB8B8D1),
                              fontSize: 10,
                            ),
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
                          style: TextStyle(
                            color: Color(0xFFB8B8D1),
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxY,
                extraLinesData:
                    ExtraLinesData(), // Remove half-life markers for now
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final hour = spot.x.toInt();
                        final timeLabel = hour == 0
                            ? '0h'
                            : hour > 0
                            ? '+$hour h'
                            : '$hour h';

                        // Find which drug this spot belongs to
                        String drugName = 'Unknown';
                        Color drugColor = BloodLevelsTheme.accentCyan;
                        double totalAbsoluteDose = 0.0;

                        for (int i = 0; i < lineBarsData.length; i++) {
                          if (lineBarsData[i].spots.contains(spot)) {
                            drugName = legendItems[i]['name'] as String;
                            drugColor = legendItems[i]['color'] as Color;

                            // Calculate total absolute dose at this time point by summing all active doses
                            final drugEntry = activeDrugs[i];
                            final drugData = drugEntry.value;
                            final entries =
                                drugData['entries']
                                    as List<Map<String, dynamic>>;
                            final timePoint = now.add(Duration(hours: hour));

                            for (final entry in entries) {
                              final dose = entry['dose'] as double;
                              final startTime = entry['startTime'] as DateTime;
                              final hoursElapsed = timePoint
                                  .difference(startTime)
                                  .inHours
                                  .toDouble();

                              if (hoursElapsed >= 0) {
                                final estimationResult = _estimateRemaining(
                                  dose,
                                  hoursElapsed,
                                  drugEntry.key,
                                );
                                final remaining =
                                    estimationResult['remaining'] ?? 0.0;
                                totalAbsoluteDose += remaining;
                              }
                            }
                            break;
                          }
                        }

                        return LineTooltipItem(
                          '$drugName — Active: ${spot.y.toStringAsFixed(0)}% (${totalAbsoluteDose.toStringAsFixed(1)}u total) — Time: $timeLabel',
                          TextStyle(
                            color: drugColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList();
                    },
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                  ),
                  handleBuiltInTouches: true,
                  touchSpotThreshold: 20,
                ),
                clipData: FlClipData.all(),
                lineBarsData: lineBarsData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskGauge(Map<String, Map<String, dynamic>> remainingLevels) {
    // Calculate risk metrics
    final highRiskDrugs = remainingLevels.values.where((data) {
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage > 20;
    }).length;

    final moderateRiskDrugs = remainingLevels.values.where((data) {
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage > 10 && percentage <= 20;
    }).length;

    final totalActiveDose = remainingLevels.values.fold<double>(0.0, (
      sum,
      data,
    ) {
      return sum + (data['lastDoseRemaining'] as double);
    });

    String riskLevel;
    Color riskColor;
    String riskMessage;

    if (highRiskDrugs > 0) {
      riskLevel = 'High Risk';
      riskColor = const Color(0xFFEF4444);
      riskMessage =
          'Strong pharmacological effects present. Exercise caution with activities requiring full cognitive function.';
    } else if (moderateRiskDrugs > 0 || totalActiveDose > 5.0) {
      riskLevel = 'Moderate Risk';
      riskColor = const Color(0xFFF59E0B);
      riskMessage =
          'Noticeable effects may still be present. Consider timing for important activities.';
    } else if (remainingLevels.isNotEmpty) {
      riskLevel = 'Low Risk';
      riskColor = const Color(0xFF10B981);
      riskMessage =
          'Minimal residual effects. Generally safe for most activities.';
    } else {
      riskLevel = 'Clear';
      riskColor = const Color(0xFF10B981);
      riskMessage = 'System appears clear of active substances.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  highRiskDrugs > 0
                      ? Icons.warning
                      : moderateRiskDrugs > 0
                      ? Icons.info_outline
                      : Icons.check_circle,
                  color: riskColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      riskLevel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                    Text(
                      riskMessage,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xB3FFFFFF),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRiskMetric(
                  'Active Dose',
                  '${totalActiveDose.toStringAsFixed(2)}u',
                  'Total remaining',
                  const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRiskMetric(
                  'High Risk',
                  highRiskDrugs.toString(),
                  '>20% remaining',
                  const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRiskMetric(
                  'Moderate',
                  moderateRiskDrugs.toString(),
                  '10-20% remaining',
                  const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskMetric(
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 26)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 8, color: color.withValues(alpha: 179)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDrugCard(String drugName, Map<String, dynamic> data) {
    final isExpanded = _expandedCards.contains(drugName);
    final lastDose = data['lastDose'] as double;
    final lastDoseRemaining = data['lastDoseRemaining'] as double;
    final percentage = lastDose > 0
        ? (lastDoseRemaining / lastDose) * 100
        : 0.0;
    final lastUse = data['lastUse'] as DateTime;
    final halfLife = data['halfLife'] as double;
    final hoursElapsed = _selectedTime.difference(lastUse).inHours.toDouble();

    // Calculate time remaining until <1%
    final timeToClear = percentage > 0.01
        ? halfLife * (log(1.0) - log(percentage / 100)) / log(0.5)
        : double.infinity;
    final timeRemaining = timeToClear.isFinite
        ? timeToClear - hoursElapsed
        : double.infinity;

    Color getStatusColor(double pct) {
      if (pct > 10) return const Color(0xFFEF4444);
      if (pct > 5) return const Color(0xFFF59E0B);
      if (pct > 1) return const Color(0xFFF59E0B);
      return const Color(0xFF10B981);
    }

    String getStatusText(double pct) {
      if (pct > 10) return 'High';
      if (pct > 5) return 'Moderate';
      if (pct > 1) return 'Low';
      return 'Clear';
    }

    String formatTimeRemaining(double hours) {
      if (hours.isInfinite || hours.isNaN) return 'N/A';
      if (hours < 1) return '<1h';
      if (hours < 24) return '${hours.toStringAsFixed(0)}h';
      final days = (hours / 24).floor();
      return '${days}d';
    }

    // Get risk level for styling
    final riskLevel = percentage > 10
        ? 'high'
        : percentage > 5
        ? 'moderate'
        : percentage > 1
        ? 'low'
        : 'clear';
    final accentColor = getStatusColor(percentage);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Color(0xFF1B1E29), Color(0xFF14161F)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 77), // 0.3 opacity
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(
              alpha: riskLevel == 'high'
                  ? 51
                  : riskLevel == 'moderate'
                  ? 26
                  : 13,
            ), // Pulsing effect
            blurRadius: riskLevel == 'high'
                ? 8
                : riskLevel == 'moderate'
                ? 6
                : 4,
            spreadRadius: riskLevel == 'high' ? 1 : 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedCards.remove(drugName);
                } else {
                  _expandedCards.add(drugName);
                }
              });
            },
            child: Row(
              children: [
                // Icon with gradient background
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 102), // 0.4 opacity
                        accentColor.withValues(alpha: 51), // 0.2 opacity
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      drugName[0].toUpperCase(),
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Substance name and risk badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drugName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 26),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          getStatusText(percentage),
                          style: TextStyle(
                            fontSize: 10,
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Percentage display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 13),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Expansion indicator
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more, color: accentColor, size: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Centered Progress Section
          Center(
            child: Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D3A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (percentage / 100).clamp(0.0, 1.0),
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage > 10
                        ? const Color(0xFFEF4444)
                        : percentage > 5
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF10B981),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Footer with metadata
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Time remaining
              Row(
                children: [
                  const Text('⏱', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    formatTimeRemaining(timeRemaining),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB3B3B3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Active amount
              Row(
                children: [
                  const Text('💊', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    '${lastDoseRemaining.toStringAsFixed(2)}u',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Last dose
              Text(
                'Last: ${lastDose.toStringAsFixed(1)}u',
                style: const TextStyle(fontSize: 10, color: Color(0xFF888888)),
              ),
            ],
          ),

          // Expanded content
          if (isExpanded) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor.withValues(alpha: 26)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mini decay sparkline placeholder
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 13),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.show_chart, color: accentColor, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Metabolism Trend',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dose history
                  Text(
                    'Recent Doses',
                    style: TextStyle(
                      color: const Color(0xFFFFFFFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Show last few doses
                  ...(data['entries'] as List<dynamic>? ?? []).take(3).map((
                    entry,
                  ) {
                    final doseEntry = entry as Map<String, dynamic>;
                    final doseTime = doseEntry['startTime'] as DateTime;
                    final doseAmount = doseEntry['dose'] as double;
                    final timeAgo = _selectedTime.difference(doseTime);
                    final timeAgoStr = timeAgo.inHours < 24
                        ? '${timeAgo.inHours}h ago'
                        : '${timeAgo.inDays}d ago';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Text(
                            '${doseAmount.toStringAsFixed(1)}u',
                            style: const TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeAgoStr,
                            style: const TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Tap to view details
                  Center(
                    child: TextButton.icon(
                      onPressed: () => _showDrugDetails(drugName, data),
                      icon: Icon(
                        Icons.info_outline,
                        color: accentColor,
                        size: 16,
                      ),
                      label: Text(
                        'View Full Details',
                        style: TextStyle(color: accentColor, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDrugDetails(String drugName, Map<String, dynamic> data) {
    final lastDose = data['lastDose'] as double;
    final lastDoseRemaining = data['lastDoseRemaining'] as double;
    final percentage = lastDose > 0
        ? (lastDoseRemaining / lastDose) * 100
        : 0.0;
    final lastUse = data['lastUse'] as DateTime;
    final halfLife = data['halfLife'] as double;
    final halfLifeMethod =
        data['halfLifeMethod'] as String? ?? 'Default estimation';
    final entries = data['entries'] as List<Map<String, dynamic>>;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0x4DFFFFFF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: percentage > 10
                                  ? [
                                      const Color(0xFFEF4444),
                                      const Color(0xFFDC2626),
                                    ]
                                  : percentage > 5
                                  ? [
                                      const Color(0xFFF59E0B),
                                      const Color(0xFFD97706),
                                    ]
                                  : percentage > 1
                                  ? [
                                      const Color(0xFFF59E0B),
                                      const Color(0xFFD97706),
                                    ]
                                  : [
                                      const Color(0xFF10B981),
                                      const Color(0xFF059669),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            drugName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                drugName.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xE6FFFFFF),
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}% of last dose remaining',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xB3FFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Large progress indicator
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0x0DFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: percentage > 10
                                  ? const Color(0xFFEF4444)
                                  : percentage > 5
                                  ? const Color(0xFFF59E0B)
                                  : percentage > 1
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Remaining Activity',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xB3FFFFFF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0x1AFFFFFF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (percentage / 100).clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: percentage > 10
                                        ? [
                                            const Color(0xFFEF4444),
                                            const Color(0xFFDC2626),
                                          ]
                                        : percentage > 5
                                        ? [
                                            const Color(0xFFF59E0B),
                                            const Color(0xFFD97706),
                                          ]
                                        : percentage > 1
                                        ? [
                                            const Color(0xFFF59E0B),
                                            const Color(0xFFD97706),
                                          ]
                                        : [
                                            const Color(0xFF10B981),
                                            const Color(0xFF059669),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Details
                    _buildDetailRow(
                      'Last Dose',
                      '${lastDose.toStringAsFixed(1)} units',
                    ),
                    _buildDetailRow(
                      'Remaining',
                      '${lastDoseRemaining.toStringAsFixed(3)} units',
                    ),
                    _buildDetailRow(
                      'Half-life',
                      '${halfLife.toStringAsFixed(1)} hours',
                    ),
                    _buildDetailRow('Estimation Method', halfLifeMethod),
                    _buildDetailRow('Last Use', lastUse.toLocal().toString()),
                    const SizedBox(height: 24),
                    if (entries.length > 1) ...[
                      Text(
                        'Historical Doses',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xE6FFFFFF),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...entries
                          .skip(1)
                          .map(
                            (doseEntry) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0x0DFFFFFF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${doseEntry['originalDoseString']} at ${doseEntry['startTime'].toLocal().toString().substring(0, 16)}',
                                      style: const TextStyle(
                                        color: Color(0xFFCCCCCC),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${((doseEntry['remaining'] as double) / (doseEntry['dose'] as double) * 100).toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: const Color(0x99FFFFFF),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFilters(List<String> availableDrugs) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(
          0x1A1A1A,
        ), // Dark background for the entire filter section
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x2AFFFFFF)),
      ),
      child: ExpansionTile(
        title: Text(
          'Advanced Filters',
          style: TextStyle(
            color: const Color(0xE6FFFFFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Icon(Icons.filter_list, color: const Color(0xB3FFFFFF)),
        collapsedIconColor: const Color(0xB3FFFFFF),
        iconColor: const Color(0xB3FFFFFF),
        backgroundColor: const Color(
          0x1A1A1A,
        ), // Ensure expansion tile background is dark
        collapsedBackgroundColor: const Color(
          0x1A1A1A,
        ), // Ensure collapsed state is also dark
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0x1A1A1A), // Same dark background
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Include Drugs:',
                  style: TextStyle(
                    color: const Color(0xE6FFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableDrugs.map((drug) {
                    final isSelected = _includedDrugs.contains(drug);
                    return FilterChip(
                      label: Text(
                        drug.toUpperCase(),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(
                                  0xFF333333,
                                ), // Dark text for unselected chips
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF6366F1),
                      backgroundColor: const Color(
                        0xFFE0E0E0,
                      ), // Light background for unselected chips
                      side: BorderSide(color: const Color(0xFFCCCCCC)),
                      checkmarkColor: Colors.white,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _includedDrugs.add(drug);
                            _excludedDrugs.remove(drug);
                          } else {
                            _includedDrugs.remove(drug);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Exclude Drugs:',
                  style: TextStyle(
                    color: const Color(0xE6FFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableDrugs.map((drug) {
                    final isSelected = _excludedDrugs.contains(drug);
                    return FilterChip(
                      label: Text(
                        drug.toUpperCase(),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(
                                  0xFF333333,
                                ), // Dark text for unselected chips
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFFEF4444),
                      backgroundColor: const Color(
                        0xFFE0E0E0,
                      ), // Light background for unselected chips
                      side: BorderSide(color: const Color(0xFFCCCCCC)),
                      checkmarkColor: Colors.white,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _excludedDrugs.add(drug);
                            _includedDrugs.remove(drug);
                          } else {
                            _excludedDrugs.remove(drug);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      _includedDrugs.clear();
                      _excludedDrugs.clear();
                      _includedCategories.clear();
                      _excludedCategories.clear();
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Clear All Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: const Color(0xB3FFFFFF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: const Color(0xE6FFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Modern System Overview with futuristic stat cards
  Widget _buildModernSystemOverview(
    Map<String, Map<String, dynamic>> remainingLevels,
    int recentDosesCount,
  ) {
    final activeDrugs = remainingLevels.values.where((data) {
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage >= 1.0;
    }).length;

    final strongEffects = remainingLevels.values.where((data) {
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage >= 20.0;
    }).length;

    final totalDose = remainingLevels.values.fold<double>(0.0, (sum, data) {
      return sum + (data['lastDoseRemaining'] as double);
    });

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BloodLevelsTheme.surfaceColor,
            BloodLevelsTheme.surfaceColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: BloodLevelsTheme.accentCyan.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: BloodLevelsTheme.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Active Substances',
                  activeDrugs.toString(),
                  'substances',
                  BloodLevelsTheme.accentCyan,
                  Icons.science,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Strong Effects',
                  strongEffects.toString(),
                  'high dose',
                  BloodLevelsTheme.accentAmber,
                  Icons.warning_amber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Recent Doses',
                  recentDosesCount.toString(),
                  '24h window',
                  BloodLevelsTheme.accentPurple,
                  Icons.schedule,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Dose',
                  '${totalDose.toStringAsFixed(1)}u',
                  'remaining',
                  BloodLevelsTheme.accentRed,
                  Icons.scale,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color accentColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.1), accentColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: BloodLevelsTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: BloodLevelsTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Modern Risk Assessment with horizontal gradient bar
  Widget _buildModernRiskAssessment(
    Map<String, Map<String, dynamic>> remainingLevels,
  ) {
    // Calculate risk level based on active substances
    final highRisk = remainingLevels.values.where((data) {
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage > 20;
    }).length;

    final moderateRisk = remainingLevels.values.where((data) {
      final lastDose = data['lastDose'] as double;
      final lastDoseRemaining = data['lastDoseRemaining'] as double;
      final percentage = lastDose > 0
          ? (lastDoseRemaining / lastDose) * 100
          : 0.0;
      return percentage > 10 && percentage <= 20;
    }).length;

    double riskPosition;
    String riskLevel;
    Color riskColor;
    String warningMessage;

    if (highRisk > 0) {
      riskPosition = 0.8;
      riskLevel = 'HIGH';
      riskColor = BloodLevelsTheme.accentRed;
      warningMessage =
          'Elevated risk detected. Avoid redosing and monitor for adverse interactions.';
    } else if (moderateRisk > 0) {
      riskPosition = 0.5;
      riskLevel = 'MODERATE';
      riskColor = BloodLevelsTheme.accentAmber;
      warningMessage =
          'Moderate risk detected. Monitor for interactions and avoid redosing.';
    } else if (remainingLevels.isNotEmpty) {
      riskPosition = 0.2;
      riskLevel = 'LOW';
      riskColor = BloodLevelsTheme.accentGreen;
      warningMessage = 'Low risk level. Minimal residual effects expected.';
    } else {
      riskPosition = 0.0;
      riskLevel = 'CLEAR';
      riskColor = BloodLevelsTheme.accentGreen;
      warningMessage =
          'System clear. No active pharmacological substances detected.';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BloodLevelsTheme.surfaceColor, BloodLevelsTheme.surfaceColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: riskColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: riskColor.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Risk Assessment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: BloodLevelsTheme.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: riskColor.withOpacity(0.5)),
                ),
                child: Text(
                  riskLevel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: riskColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Risk gradient bar
          Container(
            height: 12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [BloodLevelsTheme.accentGreen, BloodLevelsTheme.accentAmber, BloodLevelsTheme.accentRed],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Risk indicator
                Positioned(
                  left:
                      MediaQuery.of(context).size.width * 0.7 * riskPosition -
                      8,
                  top: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: riskColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: riskColor.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LOW',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: BloodLevelsTheme.accentGreen,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'HIGH',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: BloodLevelsTheme.accentRed,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            warningMessage,
            style: TextStyle(fontSize: 12, color: BloodLevelsTheme.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  /// Modern Active Substances with vertical stack layout
  Widget _buildModernActiveSubstances(
    Map<String, Map<String, dynamic>> filteredRemainingLevels,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BloodLevelsTheme.surfaceColor, BloodLevelsTheme.surfaceColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BloodLevelsTheme.accentPurple.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Substances',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: BloodLevelsTheme.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),
          ...filteredRemainingLevels.entries.map(
            (entry) => _buildModernSubstanceCard(entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSubstanceCard(String drugName, Map<String, dynamic> data) {
    final lastDose = data['lastDose'] as double;
    final lastDoseRemaining = data['lastDoseRemaining'] as double;
    final percentage = lastDose > 0
        ? (lastDoseRemaining / lastDose) * 100
        : 0.0;
    final lastUse = data['lastUse'] as DateTime;
    final halfLife = data['halfLife'] as double;

    Color getRiskColor(double pct) {
      if (pct > 20) return BloodLevelsTheme.accentRed;
      if (pct > 10) return BloodLevelsTheme.accentAmber;
      return BloodLevelsTheme.accentCyan;
    }

    String getRiskTag(double pct) {
      if (pct > 20) return 'HIGH';
      if (pct > 10) return 'MODERATE';
      return 'LOW';
    }

    final riskColor = getRiskColor(percentage);
    final timeAgo = _selectedTime.difference(lastUse);
    final timeAgoStr = timeAgo.inHours < 24
        ? '${timeAgo.inHours}h ago'
        : '${timeAgo.inDays}d ago';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [riskColor.withOpacity(0.1), riskColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: riskColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Substance name and risk tag
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drugName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: BloodLevelsTheme.textPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        getRiskTag(percentage),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: riskColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Icons for time and dosage
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: BloodLevelsTheme.textSecondary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        timeAgoStr,
                        style: TextStyle(color: BloodLevelsTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.medication, color: BloodLevelsTheme.textSecondary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${lastDoseRemaining.toStringAsFixed(1)}u',
                        style: TextStyle(color: BloodLevelsTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              // Expand arrow
              Icon(Icons.expand_more, color: riskColor, size: 24),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Remaining in system',
                    style: TextStyle(
                      fontSize: 12,
                      color: BloodLevelsTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: riskColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: BloodLevelsTheme.textSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (percentage / 100).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [riskColor, riskColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: riskColor.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Historical Doses Sidebar
  Widget _buildHistoricalDosesSidebar(
    Map<String, Map<String, dynamic>> remainingLevels,
  ) {
    final recentEntries = <Map<String, dynamic>>[];

    remainingLevels.forEach((drugName, data) {
      final entries = data['entries'] as List<Map<String, dynamic>>;
      for (final entry in entries.take(3)) {
        recentEntries.add({
          'drugName': drugName,
          'dose': entry['dose'],
          'startTime': entry['startTime'],
          'remaining': entry['remaining'],
        });
      }
    });

    // Sort by time, most recent first
    recentEntries.sort(
      (a, b) =>
          (b['startTime'] as DateTime).compareTo(a['startTime'] as DateTime),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BloodLevelsTheme.surfaceColor, BloodLevelsTheme.surfaceColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BloodLevelsTheme.accentCyan.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Past 24 Hours',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: BloodLevelsTheme.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...recentEntries.take(6).map((entry) {
            final timeAgo = _selectedTime.difference(
              entry['startTime'] as DateTime,
            );
            final timeAgoStr = timeAgo.inHours < 24
                ? '${timeAgo.inHours}h ago'
                : '${timeAgo.inDays}d ago';
            final remainingPct =
                ((entry['remaining'] as double) /
                        (entry['dose'] as double) *
                        100)
                    .clamp(0.0, 100.0);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BloodLevelsTheme.surfaceColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BloodLevelsTheme.textSecondary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (entry['drugName'] as String).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: BloodLevelsTheme.textPrimary,
                          ),
                        ),
                        Text(
                          '${(entry['dose'] as double).toStringAsFixed(1)}u • $timeAgoStr',
                          style: TextStyle(fontSize: 10, color: BloodLevelsTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 4,
                    decoration: BoxDecoration(
                      color: BloodLevelsTheme.textSecondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: remainingPct / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: BloodLevelsTheme.accentCyan,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${remainingPct.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: BloodLevelsTheme.accentCyan,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Enhanced Metabolism Timeline Chart
  Widget _buildMetabolismTimeline(
    Map<String, Map<String, dynamic>> remainingLevels,
    List<Map<String, dynamic>> drugUseData,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BloodLevelsTheme.surfaceColor, BloodLevelsTheme.surfaceColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BloodLevelsTheme.accentPurple.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Metabolism Timeline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: BloodLevelsTheme.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                '${_chartPastHours + _chartFutureHours}h window',
                style: TextStyle(fontSize: 12, color: BloodLevelsTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Time Selection Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BloodLevelsTheme.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BloodLevelsTheme.accentCyan.withOpacity(0.2), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, color: BloodLevelsTheme.accentCyan, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Time Selection',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BloodLevelsTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Date picker
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedTime,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 7),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: BloodLevelsTheme.accentCyan,
                                    surface: BloodLevelsTheme.surfaceColor,
                                    onSurface: BloodLevelsTheme.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            setState(() {
                              _selectedTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                _selectedTime.hour,
                                _selectedTime.minute,
                              );
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: BloodLevelsTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: BloodLevelsTheme.accentCyan.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: BloodLevelsTheme.accentCyan,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedTime.day.toString().padLeft(2, '0')}/${_selectedTime.month.toString().padLeft(2, '0')}/${_selectedTime.year}',
                                style: TextStyle(
                                  color: BloodLevelsTheme.textPrimary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Time picker
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_selectedTime),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: BloodLevelsTheme.surfaceColor,
                                    hourMinuteColor: BloodLevelsTheme.accentCyan.withOpacity(
                                      0.2,
                                    ),
                                    hourMinuteTextColor: BloodLevelsTheme.textPrimary,
                                    dialHandColor: BloodLevelsTheme.accentCyan,
                                    dialBackgroundColor: BloodLevelsTheme.backgroundColor,
                                    dialTextColor: BloodLevelsTheme.textPrimary,
                                    entryModeIconColor: BloodLevelsTheme.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (time != null) {
                            setState(() {
                              _selectedTime = DateTime(
                                _selectedTime.year,
                                _selectedTime.month,
                                _selectedTime.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: BloodLevelsTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: BloodLevelsTheme.accentCyan.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: BloodLevelsTheme.accentCyan,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: BloodLevelsTheme.textPrimary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Reset to now button
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTime = DateTime.now();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: BloodLevelsTheme.accentCyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: BloodLevelsTheme.accentCyan.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(Icons.refresh, color: BloodLevelsTheme.accentCyan, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Time difference indicator
                Text(
                  _selectedTime.difference(DateTime.now()).inHours.abs() < 1
                      ? 'Viewing current time'
                      : _selectedTime.isBefore(DateTime.now())
                      ? '${-_selectedTime.difference(DateTime.now()).inHours} hours ago'
                      : '${_selectedTime.difference(DateTime.now()).inHours} hours in the future',
                  style: TextStyle(fontSize: 10, color: BloodLevelsTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Chart Window Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BloodLevelsTheme.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BloodLevelsTheme.accentAmber.withOpacity(0.2), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.timeline, color: BloodLevelsTheme.accentAmber, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Chart Window',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BloodLevelsTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Past hours control
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hours Back',
                            style: TextStyle(
                              fontSize: 12,
                              color: BloodLevelsTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _chartPastHours.toString(),
                                  style: TextStyle(
                                    color: BloodLevelsTheme.textPrimary,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber.withOpacity(0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber.withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: BloodLevelsTheme.surfaceColor,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (value) {
                                    final newValue = int.tryParse(value);
                                    if (newValue != null &&
                                        newValue > 0 &&
                                        newValue <= 168) {
                                      setState(() {
                                        _chartPastHours = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'h',
                                style: TextStyle(
                                  color: BloodLevelsTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Future hours control
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hours Forward',
                            style: TextStyle(
                              fontSize: 12,
                              color: BloodLevelsTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _chartFutureHours.toString(),
                                  style: TextStyle(
                                    color: BloodLevelsTheme.textPrimary,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber.withOpacity(0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber.withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: BloodLevelsTheme.surfaceColor,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (value) {
                                    final newValue = int.tryParse(value);
                                    if (newValue != null &&
                                        newValue > 0 &&
                                        newValue <= 168) {
                                      setState(() {
                                        _chartFutureHours = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'h',
                                style: TextStyle(
                                  color: BloodLevelsTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 8),
                // Quick preset buttons
                Text(
                  'Quick Presets:',
                  style: TextStyle(fontSize: 12, color: BloodLevelsTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildTimePresetButton('24h', 12, 12),
                    _buildTimePresetButton('48h', 24, 24),
                    _buildTimePresetButton('72h', 24, 48),
                    _buildTimePresetButton('1 Week', 72, 96),
                  ],
                ),
                const SizedBox(height: 12),
                // Y-axis scale control
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BloodLevelsTheme.surfaceColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: BloodLevelsTheme.accentPurple.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.vertical_align_top,
                        color: BloodLevelsTheme.accentPurple,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Y-Axis Scale:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: BloodLevelsTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      // Fixed 100% button
                      InkWell(
                        onTap: () {
                          setState(() {
                            _chartAdaptiveMax = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: !_chartAdaptiveMax
                                ? BloodLevelsTheme.accentPurple.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: !_chartAdaptiveMax
                                  ? BloodLevelsTheme.accentPurple
                                  : BloodLevelsTheme.accentPurple.withOpacity(0.3),
                              width: !_chartAdaptiveMax ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            '100% Fixed',
                            style: TextStyle(
                              color: !_chartAdaptiveMax
                                  ? BloodLevelsTheme.accentPurple
                                  : BloodLevelsTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: !_chartAdaptiveMax
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Adaptive button
                      InkWell(
                        onTap: () {
                          setState(() {
                            _chartAdaptiveMax = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _chartAdaptiveMax
                                ? BloodLevelsTheme.accentPurple.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _chartAdaptiveMax
                                  ? BloodLevelsTheme.accentPurple
                                  : BloodLevelsTheme.accentPurple.withOpacity(0.3),
                              width: _chartAdaptiveMax ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            'Adaptive',
                            style: TextStyle(
                              color: _chartAdaptiveMax
                                  ? BloodLevelsTheme.accentPurple
                                  : BloodLevelsTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: _chartAdaptiveMax
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Y-axis explanation
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    _chartAdaptiveMax
                        ? '• Adaptive: Y-axis adjusts to show all data optimally'
                        : '• Fixed: Y-axis locked to 0-100% for consistent comparison',
                    style: TextStyle(
                      fontSize: 10,
                      color: BloodLevelsTheme.textSecondary.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Total window indicator
                Text(
                  'Total window: ${_chartPastHours + _chartFutureHours} hours',
                  style: TextStyle(fontSize: 10, color: BloodLevelsTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Chart
          Container(
            height: 250,
            child: _buildMetabolismChart(remainingLevels, drugUseData),
          ),
          const SizedBox(height: 16),
          // Activity summary
          if (remainingLevels.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BloodLevelsTheme.accentPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BloodLevelsTheme.accentPurple.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.analytics, color: BloodLevelsTheme.accentPurple, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Current system activity: ${remainingLevels.entries.map((e) {
                      final data = e.value;
                      final lastDose = data['lastDose'] as double;
                      final lastDoseRemaining = data['lastDoseRemaining'] as double;
                      final percentage = lastDose > 0 ? (lastDoseRemaining / lastDose) * 100 : 0.0;
                      return '${percentage.toStringAsFixed(0)}%';
                    }).join(' ')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: BloodLevelsTheme.accentPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimePresetButton(String label, int pastHours, int futureHours) {
    final isSelected =
        _chartPastHours == pastHours && _chartFutureHours == futureHours;

    return InkWell(
      onTap: () {
        setState(() {
          _chartPastHours = pastHours;
          _chartFutureHours = futureHours;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? BloodLevelsTheme.accentAmber.withOpacity(0.2)
              : BloodLevelsTheme.surfaceColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? BloodLevelsTheme.accentAmber : BloodLevelsTheme.accentAmber.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? BloodLevelsTheme.accentAmber : BloodLevelsTheme.textSecondary,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Helper method to get recent doses from past X hours
  List<Map<String, dynamic>> _getRecentDoses(
    List<Map<String, dynamic>> drugUseData,
    int hoursBack,
  ) {
    // Always use current time for "recent" doses, not _selectedTime
    final now = DateTime.now();
    final cutoffTime = now.subtract(Duration(hours: hoursBack));

    final results =
        drugUseData.where((dose) {
          try {
            // Check both possible timestamp field names
            final timestamp = dose['start_time'] ?? dose['timestamp'];
            if (timestamp == null) return false;

            final doseTime = DateTime.parse(timestamp.toString());
            return doseTime.isAfter(cutoffTime) &&
                doseTime.isBefore(now.add(const Duration(minutes: 1)));
          } catch (e) {
            return false;
          }
        }).toList()..sort((a, b) {
          try {
            final timestampA = a['start_time'] ?? a['timestamp'];
            final timestampB = b['start_time'] ?? b['timestamp'];
            if (timestampA == null || timestampB == null) return 0;

            return DateTime.parse(
              timestampB.toString(),
            ).compareTo(DateTime.parse(timestampA.toString()));
          } catch (e) {
            return 0;
          }
        });

    return results;
  }

  // Active Substances Column (Left side, 2/3 width)
  Widget _buildActiveSubstancesColumn(
    Map<String, Map<String, dynamic>> filteredRemainingLevels,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BloodLevelsTheme.surfaceColor, BloodLevelsTheme.surfaceColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BloodLevelsTheme.accentCyan.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.biotech, color: BloodLevelsTheme.accentCyan, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Active Substances',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: BloodLevelsTheme.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: BloodLevelsTheme.accentCyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: BloodLevelsTheme.accentCyan.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${filteredRemainingLevels.length} active',
                    style: TextStyle(
                      fontSize: 12,
                      color: BloodLevelsTheme.accentCyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable substance cards
          Expanded(
            child: filteredRemainingLevels.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: BloodLevelsTheme.accentGreen,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Active Substances',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: BloodLevelsTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'All substances below 1% activity threshold',
                          style: TextStyle(fontSize: 12, color: BloodLevelsTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Column(
                      children: filteredRemainingLevels.entries
                          .map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildActiveSubstanceCard(
                                entry.key,
                                entry.value,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Historical Doses Column (Right side, 1/3 width)
  Widget _buildHistoricalDosesColumn(
    List<Map<String, dynamic>> recentDoses,
    Map<String, Map<String, dynamic>> remainingLevels,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BloodLevelsTheme.surfaceColor.withOpacity(0.6),
            BloodLevelsTheme.surfaceColor.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BloodLevelsTheme.accentAmber.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.history, color: BloodLevelsTheme.accentAmber, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Recent Doses',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BloodLevelsTheme.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  '24h',
                  style: TextStyle(fontSize: 11, color: BloodLevelsTheme.textSecondary),
                ),
              ],
            ),
          ),
          // Scrollable doses list
          Expanded(
            child: recentDoses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, color: BloodLevelsTheme.textSecondary, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          'No Recent Doses',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: BloodLevelsTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No doses in past 24h',
                          style: TextStyle(fontSize: 11, color: BloodLevelsTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      children: recentDoses
                          .map(
                            (dose) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildRecentDoseCard(
                                dose,
                                remainingLevels,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Metabolism Timeline Section (Full width below columns)
  Widget _buildMetabolismTimelineSection(
    Map<String, Map<String, dynamic>> remainingLevels,
    List<Map<String, dynamic>> drugUseData,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BloodLevelsTheme.surfaceColor, BloodLevelsTheme.surfaceColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BloodLevelsTheme.accentPurple.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: BloodLevelsTheme.accentPurple, size: 20),
              const SizedBox(width: 12),
              Text(
                'Metabolism Timeline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: BloodLevelsTheme.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                '${_chartPastHours + _chartFutureHours}h window',
                style: TextStyle(fontSize: 12, color: BloodLevelsTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Time Selection Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BloodLevelsTheme.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BloodLevelsTheme.accentCyan.withOpacity(0.2), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, color: BloodLevelsTheme.accentCyan, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Time Selection',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BloodLevelsTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Date picker
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedTime,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 7),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: BloodLevelsTheme.accentCyan,
                                    surface: BloodLevelsTheme.surfaceColor,
                                    onSurface: BloodLevelsTheme.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            setState(() {
                              _selectedTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                _selectedTime.hour,
                                _selectedTime.minute,
                              );
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: BloodLevelsTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: BloodLevelsTheme.accentCyan.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: BloodLevelsTheme.accentCyan,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedTime.day.toString().padLeft(2, '0')}/${_selectedTime.month.toString().padLeft(2, '0')}/${_selectedTime.year}',
                                style: TextStyle(
                                  color: BloodLevelsTheme.textPrimary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Time picker
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_selectedTime),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: BloodLevelsTheme.surfaceColor,
                                    hourMinuteColor: BloodLevelsTheme.accentCyan.withOpacity(
                                      0.2,
                                    ),
                                    hourMinuteTextColor: BloodLevelsTheme.textPrimary,
                                    dialHandColor: BloodLevelsTheme.accentCyan,
                                    dialBackgroundColor: BloodLevelsTheme.backgroundColor,
                                    dialTextColor: BloodLevelsTheme.textPrimary,
                                    entryModeIconColor: BloodLevelsTheme.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (time != null) {
                            setState(() {
                              _selectedTime = DateTime(
                                _selectedTime.year,
                                _selectedTime.month,
                                _selectedTime.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: BloodLevelsTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: BloodLevelsTheme.accentCyan.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: BloodLevelsTheme.accentCyan,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: BloodLevelsTheme.textPrimary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Reset to now button
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTime = DateTime.now();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: BloodLevelsTheme.accentCyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: BloodLevelsTheme.accentCyan.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(Icons.refresh, color: BloodLevelsTheme.accentCyan, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Time difference indicator
                Text(
                  _selectedTime.difference(DateTime.now()).inHours.abs() < 1
                      ? 'Viewing current time'
                      : _selectedTime.isBefore(DateTime.now())
                      ? '${-_selectedTime.difference(DateTime.now()).inHours} hours ago'
                      : '${_selectedTime.difference(DateTime.now()).inHours} hours in the future',
                  style: TextStyle(fontSize: 10, color: BloodLevelsTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Chart Window Controls (existing logic from _buildMetabolismTimeline)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BloodLevelsTheme.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BloodLevelsTheme.accentAmber.withOpacity(0.2), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.timeline, color: BloodLevelsTheme.accentAmber, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Chart Window',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BloodLevelsTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Past hours control
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hours Back',
                            style: TextStyle(
                              fontSize: 12,
                              color: BloodLevelsTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _chartPastHours.toString(),
                                  style: TextStyle(
                                    color: BloodLevelsTheme.textPrimary,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber.withOpacity(0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber.withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: BloodLevelsTheme.surfaceColor,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (value) {
                                    final newValue = int.tryParse(value);
                                    if (newValue != null &&
                                        newValue > 0 &&
                                        newValue <= 168) {
                                      setState(() {
                                        _chartPastHours = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'h',
                                style: TextStyle(
                                  color: BloodLevelsTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Future hours control
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hours Forward',
                            style: TextStyle(
                              fontSize: 12,
                              color: BloodLevelsTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _chartFutureHours.toString(),
                                  style: TextStyle(
                                    color: BloodLevelsTheme.textPrimary,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber.withOpacity(0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber.withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: BloodLevelsTheme.accentAmber,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: BloodLevelsTheme.surfaceColor,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (value) {
                                    final newValue = int.tryParse(value);
                                    if (newValue != null &&
                                        newValue > 0 &&
                                        newValue <= 168) {
                                      setState(() {
                                        _chartFutureHours = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'h',
                                style: TextStyle(
                                  color: BloodLevelsTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Quick preset buttons
                Text(
                  'Quick Presets:',
                  style: TextStyle(fontSize: 12, color: BloodLevelsTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildTimePresetButton('24h', 12, 12),
                    _buildTimePresetButton('48h', 24, 24),
                    _buildTimePresetButton('72h', 24, 48),
                    _buildTimePresetButton('1 Week', 72, 96),
                  ],
                ),
                const SizedBox(height: 12),
                // Y-axis scale control
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BloodLevelsTheme.surfaceColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: BloodLevelsTheme.accentPurple.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.vertical_align_top,
                        color: BloodLevelsTheme.accentPurple,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Y-Axis Scale:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: BloodLevelsTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      // Fixed 100% button
                      InkWell(
                        onTap: () {
                          setState(() {
                            _chartAdaptiveMax = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: !_chartAdaptiveMax
                                ? BloodLevelsTheme.accentPurple.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: !_chartAdaptiveMax
                                  ? BloodLevelsTheme.accentPurple
                                  : BloodLevelsTheme.accentPurple.withOpacity(0.3),
                              width: !_chartAdaptiveMax ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            '100% Fixed',
                            style: TextStyle(
                              color: !_chartAdaptiveMax
                                  ? BloodLevelsTheme.accentPurple
                                  : BloodLevelsTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: !_chartAdaptiveMax
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Adaptive button
                      InkWell(
                        onTap: () {
                          setState(() {
                            _chartAdaptiveMax = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _chartAdaptiveMax
                                ? BloodLevelsTheme.accentPurple.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _chartAdaptiveMax
                                  ? BloodLevelsTheme.accentPurple
                                  : BloodLevelsTheme.accentPurple.withOpacity(0.3),
                              width: _chartAdaptiveMax ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            'Adaptive',
                            style: TextStyle(
                              color: _chartAdaptiveMax
                                  ? BloodLevelsTheme.accentPurple
                                  : BloodLevelsTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: _chartAdaptiveMax
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Y-axis explanation
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    _chartAdaptiveMax
                        ? '• Adaptive: Y-axis adjusts to show all data optimally'
                        : '• Fixed: Y-axis locked to 0-100% for consistent comparison',
                    style: TextStyle(
                      fontSize: 10,
                      color: BloodLevelsTheme.textSecondary.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Total window indicator
                Text(
                  'Total window: ${_chartPastHours + _chartFutureHours} hours',
                  style: TextStyle(fontSize: 10, color: BloodLevelsTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Chart
          Container(
            height: 450,
            child: _buildMetabolismChart(remainingLevels, drugUseData),
          ),
        ],
      ),
    );
  }

  // Individual Active Substance Card
  Widget _buildActiveSubstanceCard(String drugName, Map<String, dynamic> data) {
    final lastDose = data['lastDose'] as double;
    final lastDoseRemaining = data['lastDoseRemaining'] as double;
    final lastUse = data['lastUse'] as DateTime;
    final percentage = lastDose > 0
        ? (lastDoseRemaining / lastDose) * 100
        : 0.0;

    final timeAgo = _selectedTime.difference(lastUse);
    final hoursAgo = timeAgo.inHours;
    final minutesAgo = timeAgo.inMinutes % 60;

    String timeString;
    if (hoursAgo > 0) {
      timeString = '${hoursAgo}h ${minutesAgo}m ago';
    } else {
      timeString = '${minutesAgo}m ago';
    }

    final categoryColor = _getCategoryColor(drugName);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor.withOpacity(0.05),
            categoryColor.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: categoryColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Text(
                  drugName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BloodLevelsTheme.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Activity Level',
                    style: TextStyle(fontSize: 12, color: BloodLevelsTheme.textSecondary),
                  ),
                  Text(
                    '${lastDoseRemaining.toStringAsFixed(1)} mg remaining',
                    style: TextStyle(fontSize: 11, color: BloodLevelsTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: BloodLevelsTheme.surfaceColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (percentage / 100).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [categoryColor, categoryColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Dose info
          Row(
            children: [
              Icon(Icons.medication, color: categoryColor, size: 16),
              const SizedBox(width: 6),
              Text(
                '${lastDose.toStringAsFixed(1)} mg',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: BloodLevelsTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Icon(Icons.access_time, color: BloodLevelsTheme.textSecondary, size: 14),
              const SizedBox(width: 4),
              Text(
                timeString,
                style: TextStyle(fontSize: 12, color: BloodLevelsTheme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Individual Recent Dose Card (compact version)
  Widget _buildRecentDoseCard(
    Map<String, dynamic> dose,
    Map<String, Map<String, dynamic>> remainingLevels,
  ) {
    final drugName =
        dose['name']?.toString().toLowerCase() ??
        dose['drug_name']?.toString().toLowerCase() ??
        'unknown';
    final doseString = dose['dose']?.toString() ?? '0 mg';
    final amount = doseString.replaceAll(' mg', '').replaceAll('mg', '');
    final doseMg = double.tryParse(amount) ?? 0.0;

    DateTime doseTime;
    try {
      final timestamp = dose['start_time'] ?? dose['timestamp'];
      if (timestamp == null) {
        doseTime = DateTime.now();
      } else {
        doseTime = DateTime.parse(timestamp.toString());
      }
    } catch (e) {
      doseTime = DateTime.now();
    }

    final timeAgo = DateTime.now().difference(doseTime);

    final hoursAgo = timeAgo.inHours;
    final minutesAgo = timeAgo.inMinutes % 60;

    String timeString;
    if (hoursAgo > 0) {
      timeString = '${hoursAgo}h ${minutesAgo}m ago';
    } else {
      timeString = '${minutesAgo}m ago';
    }

    // Calculate remaining percentage using the same logic as main calculation
    double remainingPercentage = 0.0;
    double currentRemaining = 0.0;
    try {
      final doseTime = dose['start_time'] ?? dose['timestamp'];
      if (doseTime != null) {
        final parsedDoseTime = DateTime.parse(doseTime.toString());
        final hoursSinceDose = DateTime.now()
            .difference(parsedDoseTime)
            .inHours
            .toDouble();

        // Use the same activity window logic as main calculation
        final administrationMethod = dose['administration_method']?.toString();
        final activityDurationHours = _getActivityDurationHours(
          drugName,
          administrationMethod,
        );

        if (activityDurationHours != null && activityDurationHours > 0) {
          // Timeframe-based: substance is active if within onset+duration window
          final isActive = hoursSinceDose <= activityDurationHours;
          if (isActive) {
            // Use pharmacokinetic calculation for remaining amount
            final estimationResult = _estimateRemaining(
              doseMg,
              hoursSinceDose,
              drugName,
            );
            currentRemaining = estimationResult['remaining'] ?? 0.0;
          } else {
            currentRemaining = 0.0;
          }
        } else {
          // Fallback: Use simple timeframe-based activity for known substances
          final drugProfile =
              _drugProfiles['drugData'] as Map<String, dynamic>? ?? {};
          final profile = drugProfile[drugName] as Map<String, dynamic>?;
          final defaultActivityHours =
              _estimateEffectWindowHours(drugName, drugProfile: profile);

          final isActive = hoursSinceDose <= defaultActivityHours;
          if (isActive) {
            // Use pharmacokinetic calculation for remaining amount
            final estimationResult = _estimateRemaining(
              doseMg,
              hoursSinceDose,
              drugName,
            );
            currentRemaining = estimationResult['remaining'] ?? 0.0;
          } else {
            currentRemaining = 0.0;
          }
        }

        // Calculate percentage remaining of original dose
        remainingPercentage = doseMg > 0
            ? (currentRemaining / doseMg) * 100
            : 0.0;
      }
    } catch (e) {
      // Fallback to 0 if calculation fails
      remainingPercentage = 0.0;
      currentRemaining = 0.0;
    }

    final categoryColor = _getCategoryColor(drugName);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BloodLevelsTheme.backgroundColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: categoryColor.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  drugName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BloodLevelsTheme.textPrimary,
                  ),
                ),
              ),
              if (remainingPercentage > 1) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${remainingPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          // Amount and time
          Row(
            children: [
              Icon(Icons.medication, color: categoryColor, size: 14),
              const SizedBox(width: 4),
              Text(
                '${currentRemaining.toStringAsFixed(1)} mg remaining',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: BloodLevelsTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                timeString,
                style: TextStyle(fontSize: 11, color: BloodLevelsTheme.textSecondary),
              ),
            ],
          ),
          // Small progress bar for remaining %
          if (remainingPercentage > 1) ...[
            const SizedBox(height: 6),
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: BloodLevelsTheme.surfaceColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (remainingPercentage / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
