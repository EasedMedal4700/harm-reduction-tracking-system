// MIGRATION:
// State: LEGACY
// Navigation: LEGACY
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Page for editing reflections. No hardcoded values.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_drawer.dart';
import '../reflection/widgets/edit_reflection_form.dart';
import 'widgets/reflection_app_bar.dart';
import 'package:mobile_drug_use_app/features/reflection/models/reflection_model.dart';
import '../reflection/reflection_service.dart';
import 'package:mobile_drug_use_app/core/utils/error_handler.dart';
import '../reflection/reflection_exceptions.dart';
import '../reflection/utils/reflection_validator.dart';

class EditReflectionPage extends StatefulWidget {
  final Map<String, dynamic> entry;
  final ReflectionService? reflectionService;
  const EditReflectionPage({
    super.key,
    required this.entry,
    this.reflectionService,
  });
  @override
  State<EditReflectionPage> createState() => _EditReflectionPageState();
}

class _EditReflectionPageState extends State<EditReflectionPage> {
  late ReflectionModel _model;
  bool _isSaving = false;
  bool _isLoading = true;
  late final ReflectionService _reflectionService;
  @override
  void initState() {
    super.initState();
    _reflectionService = widget.reflectionService ?? ReflectionService();
    _model = ReflectionModel.fromJson(widget.entry);
    _loadFullEntry();
  }

  Future<void> _loadFullEntry() async {
    setState(() => _isLoading = true);
    try {
      final id =
          widget.entry['reflection_id']?.toString() ??
          widget.entry['id']?.toString() ??
          '';
      ErrorHandler.logDebug(
        'EditReflectionPage',
        'Loading reflection with ID: $id',
      );
      if (id.isEmpty) {
        throw ReflectionFetchException(
          'Missing reflection ID',
          details: 'Entry data does not contain reflection_id or id field',
        );
      }
      final fetched = await _reflectionService.fetchReflectionById(id);
      if (fetched == null) {
        throw ReflectionNotFoundException(id);
      }
      ErrorHandler.logDebug(
        'EditReflectionPage',
        'Loaded reflection - selectedReflections: ${fetched.selectedReflections}, notes length: ${fetched.notes?.length ?? 0}',
      );
      if (mounted) {
        setState(() => _model = fetched);
      }
    } on ReflectionException catch (e) {
      ErrorHandler.logError('EditReflectionPage._loadFullEntry', e);
      if (mounted) {
        ErrorHandler.showErrorDialog(
          context,
          title: 'Failed to Load Reflection',
          message: e.message,
          details: e.details,
          onRetry: _loadFullEntry,
        );
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError('EditReflectionPage._loadFullEntry', e, stackTrace);
      if (mounted) {
        ErrorHandler.showErrorDialog(
          context,
          title: 'Unexpected Error',
          message: 'An unexpected error occurred while loading the reflection.',
          details: e.toString(),
          onRetry: _loadFullEntry,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return; // Prevent double-save
    setState(() => _isSaving = true);
    try {
      ErrorHandler.logDebug(
        'EditReflectionPage',
        'Saving changes for reflection: ${_model.id}',
      );
      // Validate the model before saving
      ReflectionValidator.validateReflection(_model);
      final reflectionData = {
        'notes': ReflectionValidator.sanitizeNotes(_model.notes),
        'related_entries': _model.selectedReflections,
        'effectiveness': _model.effectiveness.round(),
        'sleep_hours': _model.sleepHours,
        'sleep_quality': _model.sleepQuality,
        'next_day_mood': _model.nextDayMood,
        'energy_level': _model.energyLevel,
        'side_effects': _model.sideEffects,
        'post_use_craving': _model.postUseCraving.round(),
        'coping_strategies': _model.copingStrategies,
        'coping_effectiveness': _model.copingEffectiveness.round(),
        'overall_satisfaction': _model.overallSatisfaction.round(),
      };
      ErrorHandler.logDebug(
        'EditReflectionPage',
        'Update data prepared with ${reflectionData.keys.length} fields',
      );
      await _reflectionService.updateReflection(
        _model.id ?? '',
        reflectionData,
      );
      if (mounted) {
        ErrorHandler.showSuccessSnackbar(
          context,
          message: 'Reflection updated successfully!',
        );
        Navigator.pop(context, true);
      }
    } on ReflectionValidationException catch (e) {
      ErrorHandler.logError('EditReflectionPage._saveChanges', e);
      if (mounted) {
        ErrorHandler.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please fix the following errors:',
          details: e.details,
        );
      }
    } on ReflectionException catch (e) {
      ErrorHandler.logError('EditReflectionPage._saveChanges', e);
      if (mounted) {
        ErrorHandler.showErrorDialog(
          context,
          title: 'Failed to Save',
          message: e.message,
          details: e.details,
          onRetry: _saveChanges,
        );
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError('EditReflectionPage._saveChanges', e, stackTrace);
      if (mounted) {
        ErrorHandler.showErrorDialog(
          context,
          title: 'Unexpected Error',
          message: 'An unexpected error occurred while saving.',
          details: e.toString(),
          onRetry: _saveChanges,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // Helper method to update model with new field value
  void _updateModel<T>({
    double? effectiveness,
    double? sleepHours,
    String? sleepQuality,
    String? nextDayMood,
    String? energyLevel,
    String? sideEffects,
    double? postUseCraving,
    String? copingStrategies,
    double? copingEffectiveness,
    double? overallSatisfaction,
    String? notes,
  }) {
    setState(() {
      _model = ReflectionModel(
        id: _model.id,
        notes: notes ?? _model.notes,
        selectedReflections: _model.selectedReflections,
        date: _model.date,
        hour: _model.hour,
        minute: _model.minute,
        effectiveness: effectiveness ?? _model.effectiveness,
        sleepHours: sleepHours ?? _model.sleepHours,
        sleepQuality: sleepQuality ?? _model.sleepQuality,
        nextDayMood: nextDayMood ?? _model.nextDayMood,
        energyLevel: energyLevel ?? _model.energyLevel,
        sideEffects: sideEffects ?? _model.sideEffects,
        postUseCraving: postUseCraving ?? _model.postUseCraving,
        copingStrategies: copingStrategies ?? _model.copingStrategies,
        copingEffectiveness: copingEffectiveness ?? _model.copingEffectiveness,
        overallSatisfaction: overallSatisfaction ?? _model.overallSatisfaction,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ac = context.accent;
    return Scaffold(
      backgroundColor: c.background,
      appBar: ReflectionAppBar(isSaving: _isSaving, onSave: _saveChanges),
      drawer: const CommonDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: ac.primary))
          : EditReflectionForm(
              selectedCount: _model.selectedReflections.length,
              effectiveness: _model.effectiveness,
              onEffectivenessChanged: (value) =>
                  _updateModel(effectiveness: value),
              sleepHours: _model.sleepHours,
              onSleepHoursChanged: (value) => _updateModel(sleepHours: value),
              sleepQuality: _model.sleepQuality.isEmpty
                  ? 'Good'
                  : _model.sleepQuality,
              onSleepQualityChanged: (value) =>
                  _updateModel(sleepQuality: value),
              nextDayMood: _model.nextDayMood,
              onNextDayMoodChanged: (value) => _updateModel(nextDayMood: value),
              energyLevel: _model.energyLevel.isEmpty
                  ? 'Neutral'
                  : _model.energyLevel,
              onEnergyLevelChanged: (value) => _updateModel(energyLevel: value),
              sideEffects: _model.sideEffects,
              onSideEffectsChanged: (value) => _updateModel(sideEffects: value),
              postUseCraving: _model.postUseCraving,
              onPostUseCravingChanged: (value) =>
                  _updateModel(postUseCraving: value),
              copingStrategies: _model.copingStrategies,
              onCopingStrategiesChanged: (value) =>
                  _updateModel(copingStrategies: value),
              copingEffectiveness: _model.copingEffectiveness,
              onCopingEffectivenessChanged: (value) =>
                  _updateModel(copingEffectiveness: value),
              overallSatisfaction: _model.overallSatisfaction,
              onOverallSatisfactionChanged: (value) =>
                  _updateModel(overallSatisfaction: value),
              notes: _model.notes ?? '',
              onNotesChanged: (value) => _updateModel(notes: value),
              onSave: _saveChanges,
            ),
    );
  }
}
