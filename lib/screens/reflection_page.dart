import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../common/old_common/drawer_menu.dart';
import '../services/log_entry_service.dart';
import '../providers/reflection_provider.dart';
import '../widgets/reflection/reflection_form.dart';
import '../widgets/reflection/reflection_selection.dart';



class ReflectionPage extends StatefulWidget {
  const ReflectionPage({super.key});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final LogEntryService _entryService = LogEntryService();
  List<Map<String, dynamic>> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load entries: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? UIColors.darkBackground
        : UIColors.lightBackground;
    final surfaceColor = isDark ? UIColors.darkSurface : UIColors.lightSurface;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;

    return Consumer<ReflectionProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              'Reflect on Recent Entries',
              style: TextStyle(
                fontWeight: ThemeConstants.fontBold,
                color: textColor,
              ),
            ),
            backgroundColor: surfaceColor,
            elevation: 0,
            centerTitle: true,
            leading: provider.showForm
                ? IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => provider.setShowForm(false),
                  )
                : null,
            actions: provider.showForm
                ? [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        onPressed: provider.isSaving
                            ? null
                            : () => provider.save(context),
                        style: TextButton.styleFrom(
                          foregroundColor: isDark
                              ? UIColors.darkNeonPurple
                              : UIColors.lightAccentPurple,
                        ),
                        child: provider.isSaving
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDark
                                        ? UIColors.darkNeonPurple
                                        : UIColors.lightAccentPurple,
                                  ),
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ]
                : null,
          ),
          drawer: const DrawerMenu(),
          body: RefreshIndicator(
            onRefresh: _loadEntries,
            child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark
                          ? UIColors.darkNeonPurple
                          : UIColors.lightAccentPurple,
                    ),
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
                          copingStrategies:
                              provider.reflection.copingStrategies,
                          onCopingStrategiesChanged: (value) =>
                              provider.updateReflection(
                                provider.reflection..copingStrategies = value,
                              ),
                          copingEffectiveness:
                              provider.reflection.copingEffectiveness,
                          onCopingEffectivenessChanged: (value) =>
                              provider.updateReflection(
                                provider.reflection
                                  ..copingEffectiveness = value,
                              ),
                          overallSatisfaction:
                              provider.reflection.overallSatisfaction,
                          onOverallSatisfactionChanged: (value) =>
                              provider.updateReflection(
                                provider.reflection
                                  ..overallSatisfaction = value,
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
      },
    );
  }
}



