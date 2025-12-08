// MIGRATION
import 'package:flutter/material.dart';
import '../../models/log_entry_form_data.dart';
import '../../widgets/log_entry_cards/substance_header_card.dart';
import '../../widgets/log_entry_cards/dosage_card.dart';
import '../../widgets/log_entry_cards/route_of_administration_card.dart';
import '../../widgets/log_entry_cards/feelings_card.dart';
import '../../widgets/log_entry_cards/time_of_use_card.dart';
import '../../widgets/log_entry_cards/location_card.dart';
import '../../widgets/log_entry_cards/intention_craving_card.dart';
import '../../widgets/log_entry_cards/triggers_card.dart';
import '../../widgets/log_entry_cards/body_signals_card.dart';
import '../../widgets/log_entry_cards/notes_card.dart';
import '../../widgets/log_entry_cards/medical_purpose_card.dart';

/// Riverpod-ready Edit Form Content
/// Accepts pure data and callbacks, no state management
class EditFormContent extends StatelessWidget {
  final LogEntryFormData formData;
  final TextEditingController substanceCtrl;
  final TextEditingController doseCtrl;
  final TextEditingController notesCtrl;
  final ValueChanged<LogEntryFormData> onFormDataChanged;

  const EditFormContent({
    super.key,
    required this.formData,
    required this.substanceCtrl,
    required this.doseCtrl,
    required this.notesCtrl,
    required this.onFormDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Substance
          SubstanceHeaderCard(
            substance: formData.substance,
            substanceCtrl: substanceCtrl,
            onSubstanceChanged: (value) {
              onFormDataChanged(formData.copyWith(substance: value));
            },
          ),

          const SizedBox(height: 24.0),

          // Dosage
          DosageCard(
            dose: formData.dose,
            unit: formData.unit,
            units: const ['μg', 'mg', 'g', 'pills', 'ml'],
            doseCtrl: doseCtrl,
            onDoseChanged: (value) {
              onFormDataChanged(formData.copyWith(dose: value));
            },
            onUnitChanged: (value) {
              onFormDataChanged(formData.copyWith(unit: value));
            },
          ),

          const SizedBox(height: 24.0),

          // Route of Administration
          RouteOfAdministrationCard(
            route: formData.route,
            onRouteChanged: (value) {
              onFormDataChanged(formData.copyWith(route: value));
            },
            availableROAs: _getAvailableROAs(),
            isROAValidated: (roa) => _isROAValidated(roa),
          ),

          const SizedBox(height: 24.0),

          // Feelings
          FeelingsCard(
            feelings: formData.feelings,
            secondaryFeelings: formData.secondaryFeelings,
            onFeelingsChanged: (value) {
              onFormDataChanged(formData.copyWith(feelings: value));
            },
            onSecondaryFeelingsChanged: (value) {
              onFormDataChanged(formData.copyWith(secondaryFeelings: value));
            },
          ),

          const SizedBox(height: 24.0),

          // Medical Purpose (simple mode only)
          if (formData.isSimpleMode) ...[
            MedicalPurposeCard(
              isMedicalPurpose: formData.isMedicalPurpose,
              onChanged: (value) {
                onFormDataChanged(formData.copyWith(isMedicalPurpose: value));
              },
            ),
            const SizedBox(height: 24.0),
          ],

          // Time of Use
          TimeOfUseCard(
            date: formData.date,
            hour: formData.hour,
            minute: formData.minute,
            onDateChanged: (value) {
              onFormDataChanged(formData.copyWith(date: value));
            },
            onHourChanged: (value) {
              onFormDataChanged(formData.copyWith(hour: value));
            },
            onMinuteChanged: (value) {
              onFormDataChanged(formData.copyWith(minute: value));
            },
          ),

          const SizedBox(height: 24.0),

          // Location
          LocationCard(
            location: formData.location,
            onLocationChanged: (value) {
              onFormDataChanged(formData.copyWith(location: value));
            },
          ),

          // Complex fields (only show in detailed mode)
          if (!formData.isSimpleMode) ...[
            const SizedBox(height: 24.0),

            // Intention & Craving
            IntentionCravingCard(
              intention: formData.intention,
              cravingIntensity: formData.cravingIntensity,
              isMedicalPurpose: formData.isMedicalPurpose,
              onIntentionChanged: (value) {
                onFormDataChanged(formData.copyWith(intention: value));
              },
              onCravingIntensityChanged: (value) {
                onFormDataChanged(formData.copyWith(cravingIntensity: value));
              },
              onMedicalPurposeChanged: (value) {
                onFormDataChanged(formData.copyWith(isMedicalPurpose: value));
              },
            ),

            const SizedBox(height: 24.0),

            // Triggers
            TriggersCard(
              selectedTriggers: formData.triggers,
              onTriggersChanged: (value) {
                onFormDataChanged(formData.copyWith(triggers: value));
              },
            ),

            const SizedBox(height: 24.0),

            // Body Signals
            BodySignalsCard(
              selectedBodySignals: formData.bodySignals,
              onBodySignalsChanged: (value) {
                onFormDataChanged(formData.copyWith(bodySignals: value));
              },
            ),
          ],

          const SizedBox(height: 24.0),

          // Notes
          NotesCard(notesCtrl: notesCtrl),

          // Extra padding for bottom button
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  List<String> _getAvailableROAs() {
    const baseROAs = ['oral', 'insufflated', 'inhaled', 'sublingual'];
    if (formData.substanceDetails == null) return baseROAs;
    
    // Get substance-specific ROAs from database
    final roas = formData.substanceDetails!['roas'] as Map<String, dynamic>?;
    if (roas == null) return baseROAs;
    
    return {...baseROAs, ...roas.keys}.toList();
  }

  bool _isROAValidated(String roa) {
    if (formData.substanceDetails == null) return false;
    
    final roas = formData.substanceDetails!['roas'] as Map<String, dynamic>?;
    return roas?.containsKey(roa) ?? false;
  }
}
