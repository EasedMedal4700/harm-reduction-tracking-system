// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Logic controller for log entry.

import '../../models/log_entry_form_data.dart';
import '../../models/log_entry_model.dart';
import '../../services/timezone_service.dart';
import 'log_entry_service.dart';
import '../../repo/substance_repository.dart';
import '../../repo/stockpile_repository.dart';
import '../../utils/drug_profile_utils.dart';

/// Pure business logic for log entry operations
/// Riverpod-ready: No BuildContext, no ChangeNotifier, no UI state
/// This will become a Riverpod Notifier in the future
class LogEntryController {
  final SubstanceRepository _substanceRepo;
  final StockpileRepository _stockpileRepo;
  final LogEntryService _logEntryService;
  final TimezoneService _timezoneService;

  LogEntryController({
    SubstanceRepository? substanceRepo,
    StockpileRepository? stockpileRepo,
    LogEntryService? logEntryService,
    TimezoneService? timezoneService,
  }) : _substanceRepo = substanceRepo ?? SubstanceRepository(),
       _stockpileRepo = stockpileRepo ?? StockpileRepository(),
       _logEntryService = logEntryService ?? LogEntryService(),
       _timezoneService = timezoneService ?? TimezoneService();

  /// Load substance details for ROA validation
  Future<Map<String, dynamic>?> loadSubstanceDetails(
    String substanceName,
  ) async {
    if (substanceName.isEmpty) return null;
    return await _substanceRepo.getSubstanceDetails(substanceName);
  }

  /// Get available ROAs for substance (base 4 + substance-specific)
  List<String> getAvailableROAs(Map<String, dynamic>? substanceDetails) {
    const baseROAs = ['oral', 'insufflated', 'inhaled', 'sublingual'];
    final dbROAs = _substanceRepo.getAvailableROAs(substanceDetails);
    return {...baseROAs, ...dbROAs}.toList();
  }

  /// Check if a specific ROA is validated in DB for this substance
  bool isROAValidated(String roa, Map<String, dynamic>? substanceDetails) {
    return _substanceRepo.isROAValid(roa, substanceDetails);
  }

  /// Validate substance exists in database
  Future<ValidationResult> validateSubstance(LogEntryFormData data) async {
    if (data.substance.isEmpty) {
      return ValidationResult.error(
        'Missing Substance',
        'Please select a substance before saving.',
      );
    }

    final details = await loadSubstanceDetails(data.substance);
    if (details == null) {
      return ValidationResult.error(
        'Substance Not Found',
        'The substance "${data.substance}" was not found in the database. Please select a valid substance.',
      );
    }

    return ValidationResult.success();
  }

  /// Validate ROA with confirmation for unvalidated routes
  ValidationResult validateROA(LogEntryFormData data) {
    if (!isROAValidated(data.route, data.substanceDetails)) {
      final substanceName =
          data.substanceDetails?['pretty_name'] ?? data.substance;
      return ValidationResult.warning(
        'Unvalidated Route',
        'The route "${data.route}" is not validated for $substanceName. Are you sure you want to continue?',
      );
    }
    return ValidationResult.success();
  }

  /// Validate emotions required for non-medical use
  ValidationResult validateEmotions(LogEntryFormData data) {
    if (!data.isMedicalPurpose && data.feelings.isEmpty) {
      return ValidationResult.warning(
        'No Emotions Selected',
        'Are you sure? No emotions selected for non-medical use.',
      );
    }
    return ValidationResult.success();
  }

  /// Validate craving required for non-medical detailed mode
  ValidationResult validateCraving(LogEntryFormData data) {
    if (!data.isMedicalPurpose &&
        !data.isSimpleMode &&
        data.cravingIntensity < 1) {
      return ValidationResult.warning(
        'No Craving Intensity',
        'Are you sure? Craving intensity is 0 for non-medical use.',
      );
    }
    return ValidationResult.success();
  }

  /// Save log entry to database
  Future<SaveResult> saveLogEntry(LogEntryFormData data) async {
    try {
      final entry = LogEntry(
        substance: DrugProfileUtils.toTitleCase(data.substance),
        dosage: data.dose,
        unit: data.unit,
        route: data.route,
        feelings: data.feelings,
        secondaryFeelings: data.secondaryFeelings,
        datetime: data.selectedDateTime,
        location: data.location,
        notes: data.notes.trim(),
        timezoneOffset: _timezoneService.getTimezoneOffset(),
        isMedicalPurpose: data.isMedicalPurpose,
        cravingIntensity: data.cravingIntensity,
        intention: data.intention ?? '-- Select Intention--',
        triggers: data.triggers,
        bodySignals: data.bodySignals,
        people: [],
      );

      if (data.entryId.isNotEmpty) {
        await _logEntryService.updateLogEntry(data.entryId, entry.toJson());
      } else {
        await _logEntryService.saveLogEntry(entry);
      }

      // Update stockpile
      final stockpileResult = await _updateStockpile(data);

      return SaveResult.success(
        message: stockpileResult ?? 'Entry saved successfully!',
      );
    } catch (e) {
      return SaveResult.error('Save failed: ${e.toString()}');
    }
  }

  /// Update stockpile after successful save
  Future<String?> _updateStockpile(LogEntryFormData data) async {
    try {
      final doseInMg = DrugProfileUtils.convertToMg(
        data.dose,
        data.unit,
        data.substanceDetails,
      );

      await _stockpileRepo.subtractFromStockpile(data.substance, doseInMg);

      final updatedStockpile = await _stockpileRepo.getStockpile(
        data.substance,
      );
      if (updatedStockpile != null) {
        return 'Entry saved! Stockpile updated: -${doseInMg.toStringAsFixed(1)}mg (${updatedStockpile.currentAmountMg.toStringAsFixed(1)}mg remaining)';
      }
      return null;
    } catch (e) {
      return 'Entry saved! (Stockpile update failed: ${e.toString()})';
    }
  }
}

/// Result of validation operations
class ValidationResult {
  final bool isValid;
  final bool needsConfirmation;
  final String? title;
  final String? message;

  const ValidationResult._({
    required this.isValid,
    required this.needsConfirmation,
    this.title,
    this.message,
  });

  factory ValidationResult.success() {
    return const ValidationResult._(isValid: true, needsConfirmation: false);
  }

  factory ValidationResult.error(String title, String message) {
    return ValidationResult._(
      isValid: false,
      needsConfirmation: false,
      title: title,
      message: message,
    );
  }

  factory ValidationResult.warning(String title, String message) {
    return ValidationResult._(
      isValid: true,
      needsConfirmation: true,
      title: title,
      message: message,
    );
  }
}

/// Result of save operations
class SaveResult {
  final bool isSuccess;
  final String message;

  const SaveResult._({required this.isSuccess, required this.message});

  factory SaveResult.success({required String message}) {
    return SaveResult._(isSuccess: true, message: message);
  }

  factory SaveResult.error(String message) {
    return SaveResult._(isSuccess: false, message: message);
  }
}
