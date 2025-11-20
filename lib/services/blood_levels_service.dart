import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/error_handler.dart';

/// Service for calculating drug blood levels and metabolism
class BloodLevelsService {
  /// Calculate remaining drug levels from usage data
  Future<Map<String, DrugLevel>> calculateLevels({
    DateTime? referenceTime,
  }) async {
    final now = referenceTime ?? DateTime.now();
    
    try {
      ErrorHandler.logDebug('BloodLevelsService', 'Fetching drug use data');
      
      // RLS handles user filtering
      final response = await Supabase.instance.client
          .from('drug_use')
          .select('name, dose, start_time')
          .order('start_time', ascending: false);
      
      final drugUseData = response as List<dynamic>;
      final levels = <String, DrugLevel>{};
      
      for (final entry in drugUseData) {
        final drugName = (entry['name'] as String?)?.toLowerCase() ?? '';
        if (drugName.isEmpty) continue;
        
        final doseString = entry['dose']?.toString() ?? '';
        final startTime = DateTime.tryParse(entry['start_time']?.toString() ?? '');
        if (startTime == null || startTime.isAfter(now)) continue;
        
        final doseMg = _parseDose(doseString);
        ErrorHandler.logDebug('BloodLevelsService', 'Entry: $drugName, dose: "$doseString" -> ${doseMg}mg, time: $startTime');
        
        if (doseMg <= 0) continue;
        
        final hoursElapsed = now.difference(startTime).inMinutes / 60.0;
        final halfLife = _getHalfLife(drugName);
        final remaining = doseMg * pow(0.5, hoursElapsed / halfLife);
        
        // Only include if >1% remaining
        final percentage = (remaining / doseMg) * 100;
        if (percentage < 1.0) continue;
        
        if (!levels.containsKey(drugName)) {
          levels[drugName] = DrugLevel(
            drugName: drugName,
            totalDose: 0,
            totalRemaining: 0,
            lastDose: doseMg,  // Set to first dose (most recent due to ordering)
            lastUse: startTime,
            halfLife: halfLife,
            doses: [],
          );
        }
        
        final currentLevel = levels[drugName]!;
        levels[drugName] = currentLevel.copyWith(
          totalDose: currentLevel.totalDose + doseMg,
          totalRemaining: currentLevel.totalRemaining + remaining,
          doses: [...currentLevel.doses, DoseEntry(
            dose: doseMg,
            startTime: startTime,
            remaining: remaining,
            hoursElapsed: hoursElapsed,
          )],
          // Update last dose if this is more recent
          lastDose: startTime.isAfter(currentLevel.lastUse) ? doseMg : null,
          lastUse: startTime.isAfter(currentLevel.lastUse) ? startTime : null,
        );
      }
      
      ErrorHandler.logInfo('BloodLevelsService', 'Found ${levels.length} active substances');
      return levels;
    } catch (e, stackTrace) {
      ErrorHandler.logError('BloodLevelsService.calculateLevels', e, stackTrace);
      rethrow;
    }
  }
  
  /// Parse dose from string like "10mg" or "5-10 mg"
  double _parseDose(String doseString) {
    final regex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = regex.firstMatch(doseString);
    return match != null ? double.tryParse(match.group(1)!) ?? 0.0 : 0.0;
  }
  
  /// Get estimated half-life for a drug (simplified version)
  double _getHalfLife(String drugName) {
    const halfLives = <String, double>{
      'methylphenidate': 3.5,
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
      'bromazolam': 14.0,  // Benzodiazepine with ~14h half-life
      '2-fdck': 3.0,  // Similar to ketamine
    };
    
    return halfLives[drugName.toLowerCase()] ?? 8.0; // Default 8h
  }
}

/// Data class for drug level information
class DrugLevel {
  final String drugName;
  final double totalDose;
  final double totalRemaining;
  final double lastDose;
  final DateTime lastUse;
  final double halfLife;
  final List<DoseEntry> doses;
  
  const DrugLevel({
    required this.drugName,
    required this.totalDose,
    required this.totalRemaining,
    required this.lastDose,
    required this.lastUse,
    required this.halfLife,
    required this.doses,
  });
  
  double get percentage => lastDose > 0 ? (totalRemaining / totalDose) * 100 : 0.0;
  
  DrugLevel copyWith({
    double? totalDose,
    double? totalRemaining,
    double? lastDose,
    DateTime? lastUse,
    List<DoseEntry>? doses,
  }) {
    return DrugLevel(
      drugName: drugName,
      totalDose: totalDose ?? this.totalDose,
      totalRemaining: totalRemaining ?? this.totalRemaining,
      lastDose: lastDose ?? this.lastDose,
      lastUse: lastUse ?? this.lastUse,
      halfLife: halfLife,
      doses: doses ?? this.doses,
    );
  }
}

/// Individual dose entry
class DoseEntry {
  final double dose;
  final DateTime startTime;
  final double remaining;
  final double hoursElapsed;
  
  const DoseEntry({
    required this.dose,
    required this.startTime,
    required this.remaining,
    required this.hoursElapsed,
  });
}
