// MIGRATION:
// State: MODERN
// Navigation: LEGACY
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Reflection page using modern Riverpod state.
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
            content: Text('Failed to load entries: '),
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

    final state = ref.watch(reflectionControllerProvider);
    final notifier = ref.read(reflectionControllerProvider.notifier);

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
        leading: state.showForm
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: c.textPrimary),
                onPressed: () => notifier.setShowForm(false),
              )
            : null,
        actions: state.showForm
            ? [
                Padding(
                  padding: EdgeInsets.only(right: context.spacing.sm),
                  child: TextButton(
                    onPressed: state.isSaving
                        ? null
                        : () async {
                            try {
                              await notifier.save();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Reflection saved successfully!',
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error saving reflection: '),
                                  ),
                                );
                              }
                            }
                          },
                    style: TextButton.styleFrom(foregroundColor: ac.primary),
                    child: state.isSaving
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
                child: state.showForm
                    ? ReflectionForm(
                        selectedCount: state.selectedIds.length,
                        effectiveness: state.reflection.effectiveness,
                        onEffectivenessChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(effectiveness: value),
                            ),
                        sleepHours: state.reflection.sleepHours,
                        onSleepHoursChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(sleepHours: value),
                            ),
                        sleepQuality: state.reflection.sleepQuality,
                        onSleepQualityChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(sleepQuality: value),
                            ),
                        nextDayMood: state.reflection.nextDayMood,
                        onNextDayMoodChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(nextDayMood: value),
                            ),
                        energyLevel: state.reflection.energyLevel,
                        onEnergyLevelChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(energyLevel: value),
                            ),
                        sideEffects: state.reflection.sideEffects,
                        onSideEffectsChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(sideEffects: value),
                            ),
                        postUseCraving: state.reflection.postUseCraving,
                        onPostUseCravingChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(postUseCraving: value),
                            ),
                        copingStrategies: state.reflection.copingStrategies,
                        onCopingStrategiesChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(
                                copingStrategies: value,
                              ),
                            ),
                        copingEffectiveness:
                            state.reflection.copingEffectiveness,
                        onCopingEffectivenessChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(
                                copingEffectiveness: value,
                              ),
                            ),
                        overallSatisfaction:
                            state.reflection.overallSatisfaction,
                        onOverallSatisfactionChanged: (value) =>
                            notifier.updateReflection(
                              state.reflection.copyWith(
                                overallSatisfaction: value,
                              ),
                            ),
                        notes: state.reflection.notes,
                        onNotesChanged: (value) => notifier.updateReflection(
                          state.reflection.copyWith(notes: value),
                        ),
                      )
                    : ReflectionSelection(
                        entries: _entries,
                        selectedIds: state.selectedIds,
                        onEntryChanged: notifier.toggleEntry,
                        onNext: () => notifier.setShowForm(true),
                      ),
              ),
      ),
    );
  }
}
