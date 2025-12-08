import 'package:flutter/material.dart';
import '../log_entry_cards/substance_header_card.dart';
import '../log_entry_cards/dosage_card.dart';
import '../log_entry_cards/route_of_administration_card.dart';
import '../log_entry_cards/feelings_card.dart';
import '../log_entry_cards/location_card.dart';
import '../log_entry_cards/time_of_use_card.dart';
import '../log_entry_cards/intention_craving_card.dart';
import '../log_entry_cards/triggers_card.dart';
import '../log_entry_cards/body_signals_card.dart';
import '../log_entry_cards/notes_card.dart';
// import '../log_entry_save_button.dart';

class LogEntryForm extends StatelessWidget {
  final bool isSimpleMode;

  final double dose;
  final String unit;
  final String substance;
  final String route;
  final List<String> feelings;
  final Map<String, List<String>> secondaryFeelings;
  final String location;
  final DateTime date;
  final int hour;
  final int minute;

  final bool isMedicalPurpose;
  final double cravingIntensity;
  final String? intention;
  final List<String> selectedTriggers;
  final List<String> selectedBodySignals;

  final TextEditingController notesCtrl;
  final TextEditingController? doseCtrl;
  final TextEditingController? substanceCtrl;

  final ValueChanged<double> onDoseChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<String> onSubstanceChanged;
  final ValueChanged<String> onRouteChanged;
  final ValueChanged<List<String>> onFeelingsChanged;
  final ValueChanged<Map<String, List<String>>> onSecondaryFeelingsChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<bool> onMedicalPurposeChanged;
  final ValueChanged<double> onCravingIntensityChanged;
  final ValueChanged<String?> onIntentionChanged;
  final ValueChanged<List<String>> onTriggersChanged;
  final ValueChanged<List<String>> onBodySignalsChanged;

  final VoidCallback onSave;
  final GlobalKey<FormState> formKey;

  const LogEntryForm({
    super.key,
    required this.isSimpleMode,
    required this.dose,
    required this.unit,
    required this.substance,
    required this.route,
    required this.feelings,
    required this.secondaryFeelings,
    required this.location,
    required this.date,
    required this.hour,
    required this.minute,
    required this.isMedicalPurpose,
    required this.cravingIntensity,
    required this.intention,
    required this.selectedTriggers,
    required this.selectedBodySignals,
    required this.notesCtrl,
    required this.formKey,
    required this.onDoseChanged,
    required this.onUnitChanged,
    required this.onSubstanceChanged,
    required this.onRouteChanged,
    required this.onFeelingsChanged,
    required this.onSecondaryFeelingsChanged,
    required this.onLocationChanged,
    required this.onDateChanged,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onMedicalPurposeChanged,
    required this.onCravingIntensityChanged,
    required this.onIntentionChanged,
    required this.onTriggersChanged,
    required this.onBodySignalsChanged,
    required this.onSave,
    this.substanceCtrl,
    this.doseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SubstanceHeaderCard(
                substance: substance,
                onSubstanceChanged: onSubstanceChanged,
                substanceCtrl: substanceCtrl,
              ),

              DosageCard(
                dose: dose,
                unit: unit,
                units: const ["mg", "g", "ml", "µg"],
                onDoseChanged: onDoseChanged,
                onUnitChanged: onUnitChanged,
                doseCtrl: doseCtrl,
              ),

              RouteOfAdministrationCard(
                route: route,
                onRouteChanged: onRouteChanged,
                availableROAs: const ["oral", "insufflated", "inhaled", "sublingual"],
              ),

              FeelingsCard(
                feelings: feelings,
                secondaryFeelings: secondaryFeelings,
                onFeelingsChanged: onFeelingsChanged,
                onSecondaryFeelingsChanged: onSecondaryFeelingsChanged,
              ),

              LocationCard(
                location: location,
                onLocationChanged: onLocationChanged,
              ),

              TimeOfUseCard(
                date: date,
                hour: hour,
                minute: minute,
                onDateChanged: onDateChanged,
                onHourChanged: onHourChanged,
                onMinuteChanged: onMinuteChanged,
              ),

              if (!isSimpleMode)
                IntentionCravingCard(
                  intention: intention,
                  cravingIntensity: cravingIntensity,
                  isMedicalPurpose: isMedicalPurpose,
                  onCravingIntensityChanged: onCravingIntensityChanged,
                  onIntentionChanged: onIntentionChanged,
                  onMedicalPurposeChanged: onMedicalPurposeChanged,
                ),

              TriggersCard(
                selectedTriggers: selectedTriggers,
                onTriggersChanged: onTriggersChanged,
              ),

              BodySignalsCard(
                selectedBodySignals: selectedBodySignals,
                onBodySignalsChanged: onBodySignalsChanged,
              ),

              NotesCard(notesCtrl: notesCtrl),
            ],
          ),
        ),
      ),
    );
  }
}
