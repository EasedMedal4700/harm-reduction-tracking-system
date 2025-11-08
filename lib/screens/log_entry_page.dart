import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/log_entry/log_entry_form.dart';
import '../states/log_entry_state.dart';

class QuickLogEntryPage extends StatefulWidget {
  const QuickLogEntryPage({super.key});

  @override
  State<QuickLogEntryPage> createState() => _QuickLogEntryPageState();
}

class _QuickLogEntryPageState extends State<QuickLogEntryPage> {
  late final LogEntryState _state;

  @override
  void initState() {
    super.initState();
    _state = LogEntryState();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LogEntryState>.value(
      value: _state,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quick Log Entry'),
          actions: [
            const Text('Simple'),
            Consumer<LogEntryState>(
              builder: (context, state, child) => Switch(
                value: state.isSimpleMode,
                onChanged: state.setIsSimpleMode,
              ),
            ),
          ],
        ),
        drawer: const DrawerMenu(),
        body: Stack(
          children: [
            Consumer<LogEntryState>( // Wrap LogEntryForm in Consumer
              builder: (context, state, child) => LogEntryForm(
                isSimpleMode: state.isSimpleMode,
                dose: state.dose,
                unit: state.unit,
                substance: state.substance,
                route: state.route,
                feelings: state.feelings,
                secondaryFeelings: state.secondaryFeelings,
                location: state.location,
                date: state.date,
                hour: state.hour,
                minute: state.minute,
                notesCtrl: state.notesCtrl,
                formKey: state.formKey,
                isMedicalPurpose: state.isMedicalPurpose,
                cravingIntensity: state.cravingIntensity,
                intention: state.intention,
                selectedTriggers: state.triggers,
                selectedBodySignals: state.bodySignals,
                onDoseChanged: state.setDose,
                onUnitChanged: state.setUnit,
                onSubstanceChanged: state.setSubstance,
                onRouteChanged: state.setRoute,
                onFeelingsChanged: state.setFeelings,
                onSecondaryFeelingsChanged: state.setSecondaryFeelings,
                onLocationChanged: state.setLocation,
                onDateChanged: state.setDate,
                onHourChanged: state.setHour,
                onMinuteChanged: state.setMinute,
                onMedicalPurposeChanged: state.setIsMedicalPurpose,
                onCravingIntensityChanged: state.setCravingIntensity,
                onIntentionChanged: state.setIntention,
                onTriggersChanged: state.setTriggers,
                onBodySignalsChanged: state.setBodySignals,
                onSave: () => state.save(context),
              ),
            ),
            Consumer<LogEntryState>(
              builder: (context, state, child) => state.isSaving
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}