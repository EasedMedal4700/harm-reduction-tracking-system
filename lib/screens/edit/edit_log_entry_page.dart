import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/drawer_menu.dart';
import '../../states/log_entry_state.dart';
import '../../widgets/log_entry/log_entry_form.dart';
import '../../models/log_entry_model.dart';

class EditDrugUsePage extends StatefulWidget {
  final Map<String, dynamic> entry;
  const EditDrugUsePage({super.key, required this.entry});

  @override
  State<EditDrugUsePage> createState() => _EditDrugUsePageState();
}

class _EditDrugUsePageState extends State<EditDrugUsePage> {
  late LogEntryState _state;

  @override
  void initState() {
    super.initState();
    _state = LogEntryState();

    final LogEntry model = LogEntry.fromJson(widget.entry);

    // prefills
    _state.prefillDose(model.dosage);
    _state.prefillSubstance(model.substance); // sets controller.text once
    _state.unit = model.unit;
    _state.route = model.route;
    _state.location = model.location;
    _state.notesCtrl.text = model.notes ?? '';
    // set date/time from parsed datetime (model.datetime already parsed from DB)
    _state.setDate(model.datetime);
    _state.setHour(model.datetime.hour);
    _state.setMinute(model.datetime.minute);
    // Add pre-fills for other fields
    _state.feelings = model.feelings;
    _state.secondaryFeelings = model.secondaryFeelings;
    _state.triggers = model.triggers;
    _state.bodySignals = model.bodySignals;
    _state.isMedicalPurpose = model.isMedicalPurpose;
    _state.cravingIntensity = model.cravingIntensity;
    _state.intention = model.intention;

    // keep entry id for update
    _state.entryId = widget.entry['use_id']?.toString() ?? widget.entry['id']?.toString() ?? '';
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
          title: const Text('Edit Drug Use'),
        ),
        drawer: const DrawerMenu(),
        body: Consumer<LogEntryState>(
          builder: (context, state, child) => LogEntryForm(
            isSimpleMode: state.isSimpleMode,
            dose: state.dose,
            unit: state.unit,
            substance: state.substance,
            substanceCtrl: state.substanceCtrl, // Add this
            doseCtrl: state.doseCtrl, // Add this
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
            intention: state.intention ?? '-- Select Intention--',
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
      ),
    );
  }
}