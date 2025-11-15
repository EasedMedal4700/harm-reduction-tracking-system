import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/drawer_menu.dart';
import '../../providers/reflection_provider.dart';
import '../../widgets/reflection/reflection_form.dart';
import '../../models/reflection_model.dart';

class EditReflectionPage extends StatefulWidget {
  final Map<String, dynamic> entry;
  const EditReflectionPage({super.key, required this.entry});

  @override
  State<EditReflectionPage> createState() => _EditReflectionPageState();
}

class _EditReflectionPageState extends State<EditReflectionPage> {
  late ReflectionProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ReflectionProvider();

    final ReflectionModel model = ReflectionModel.fromJson(widget.entry);

    // Pre-fill all fields
    _provider.setNotes(model.notes ?? '');
    _provider.setSelectedReflections(model.selectedReflections);
    _provider.setDate(model.date);
    _provider.setHour(model.hour);
    _provider.setMinute(model.minute);
    _provider.setEffectiveness(model.effectiveness);
    _provider.setSleepHours(model.sleepHours);
    _provider.setSleepQuality(model.sleepQuality);
    _provider.setNextDayMood(model.nextDayMood);
    _provider.setEnergyLevel(model.energyLevel);
    _provider.setSideEffects(model.sideEffects);
    _provider.setPostUseCraving(model.postUseCraving);
    _provider.setCopingStrategies(model.copingStrategies);
    _provider.setCopingEffectiveness(model.copingEffectiveness);
    _provider.setOverallSatisfaction(model.overallSatisfaction);
    _provider.entryId = widget.entry['id']?.toString() ?? '';
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReflectionProvider>.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Reflection'),
        ),
        drawer: const DrawerMenu(),
        body: Consumer<ReflectionProvider>(
          builder: (context, provider, child) => ReflectionForm(
            selectedCount: provider.selectedReflections.length,
            notes: provider.notesCtrl.text,
            effectiveness: provider.effectiveness,
            onEffectivenessChanged: provider.setEffectiveness,
            sleepHours: provider.sleepHours,
            onSleepHoursChanged: provider.setSleepHours,
            sleepQuality: provider.sleepQuality,
            onSleepQualityChanged: provider.setSleepQuality,
            nextDayMood: provider.nextDayMood,
            onNextDayMoodChanged: provider.setNextDayMood,
            energyLevel: provider.energyLevel,
            onEnergyLevelChanged: provider.setEnergyLevel,
            sideEffects: provider.sideEffects,
            onSideEffectsChanged: provider.setSideEffects,
            postUseCraving: provider.postUseCraving,
            onPostUseCravingChanged: provider.setPostUseCraving,
            copingStrategies: provider.copingStrategies,
            onCopingStrategiesChanged: provider.setCopingStrategies,
            copingEffectiveness: provider.copingEffectiveness,
            onCopingEffectivenessChanged: provider.setCopingEffectiveness,
            overallSatisfaction: provider.overallSatisfaction,
            onOverallSatisfactionChanged: provider.setOverallSatisfaction,
            onNotesChanged: provider.setNotes,
          ),
        ),
      ),
    );
  }
}