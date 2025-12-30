// MIGRATION:
// State: LEGACY
// Navigation: LEGACY
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Reflection page using legacy state.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/layout/common_drawer.dart';
import '../log_entry/log_entry_service.dart';
import 'providers/reflection_providers.dart';
import 'widgets/reflection_form.dart';
import 'widgets/reflection_selection.dart';

class ReflectionPage extends ConsumerStatefulWidget {
  final LogEntryService? logEntryService;
  const ReflectionPage({super.key, this.logEntryService});
  @override
  ConsumerState<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends ConsumerState<ReflectionPage> {
  late final LogEntryService _entryService;
  List<Map<String, dynamic>> _entries = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _entryService = widget.logEntryService ?? LogEntryService();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final entries = await _entryService.fetchRecentEntriesRaw();
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        final c = context.colors;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load entries: $e'),
            backgroundColor: c.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final ac = context.accent;
    final tx = context.text;
    final provider = ref.watch(reflectionControllerProvider);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          'Reflect on Recent Entries',
          style: tx.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: c.textPrimary,
          ),
        ),
        backgroundColor: c.surface,
        elevation: context.sizes.elevationNone,
        centerTitle: true,
        leading: provider.showForm
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: c.textPrimary),
                onPressed: () => provider.setShowForm(false),
              )
            : null,
        actions: provider.showForm
            ? [
                Padding(
                  padding: EdgeInsets.only(right: context.spacing.sm),
                  child: TextButton(
                    onPressed: provider.isSaving
                        ? null
                        : () => provider.save(context),
                    style: TextButton.styleFrom(foregroundColor: ac.primary),
                    child: provider.isSaving
                        ? SizedBox(
                            width: context.sizes.iconSm,
                            height: context.sizes.iconSm,
                            child: CircularProgressIndicator(
                              strokeWidth: context.borders.medium,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ac.primary,
                              ),
                            ),
                          )
                        : Text(
                            'Save',
                            style: tx.labelLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ]
            : null,
      ),
      drawer: const CommonDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadEntries,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ac.primary),
                ),
              )
            : SafeArea(
                child: provider.showForm
                    ? ReflectionForm(
                        selectedCount: provider.selectedIds.length,
                        effectiveness: provider.reflection.effectiveness,
                        onEffectivenessChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..effectiveness = value,
                            ),
                        sleepHours: provider.reflection.sleepHours,
                        onSleepHoursChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..sleepHours = value,
                            ),
                        sleepQuality: provider.reflection.sleepQuality,
                        onSleepQualityChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..sleepQuality = value,
                            ),
                        nextDayMood: provider.reflection.nextDayMood,
                        onNextDayMoodChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..nextDayMood = value,
                            ),
                        energyLevel: provider.reflection.energyLevel,
                        onEnergyLevelChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..energyLevel = value,
                            ),
                        sideEffects: provider.reflection.sideEffects,
                        onSideEffectsChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..sideEffects = value,
                            ),
                        postUseCraving: provider.reflection.postUseCraving,
                        onPostUseCravingChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..postUseCraving = value,
                            ),
                        copingStrategies: provider.reflection.copingStrategies,
                        onCopingStrategiesChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..copingStrategies = value,
                            ),
                        copingEffectiveness:
                            provider.reflection.copingEffectiveness,
                        onCopingEffectivenessChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..copingEffectiveness = value,
                            ),
                        overallSatisfaction:
                            provider.reflection.overallSatisfaction,
                        onOverallSatisfactionChanged: (value) =>
                            provider.updateReflection(
                              provider.reflection..overallSatisfaction = value,
                            ),
                        notes: provider.reflection.notes,
                        onNotesChanged: (value) => provider.updateReflection(
                          provider.reflection..notes = value,
                        ),
                      )
                    : ReflectionSelection(
                        entries: _entries,
                        selectedIds: provider.selectedIds,
                        onEntryChanged: provider.toggleEntry,
                        onNext: () => provider.setShowForm(true),
                      ),
              ),
      ),
    );
  }
}
