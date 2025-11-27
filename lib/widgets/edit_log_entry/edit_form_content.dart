import 'package:flutter/material.dart';
import '../../states/log_entry_state.dart';
import '../../constants/theme_constants.dart';
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

class EditFormContent extends StatelessWidget {
  final LogEntryState state;

  const EditFormContent({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Substance
          SubstanceHeaderCard(
            substance: state.substance,
            substanceCtrl: state.substanceCtrl,
            onSubstanceChanged: state.setSubstance,
          ),

          const SizedBox(height: ThemeConstants.cardSpacing),

          // Dosage
          DosageCard(
            dose: state.dose,
            unit: state.unit,
            units: const ['μg', 'mg', 'g', 'pills', 'ml'],
            doseCtrl: state.doseCtrl,
            onDoseChanged: state.setDose,
            onUnitChanged: state.setUnit,
          ),

          const SizedBox(height: ThemeConstants.cardSpacing),

          // Route of Administration
          RouteOfAdministrationCard(
            route: state.route,
            onRouteChanged: state.setRoute,
            availableROAs: state.getAvailableROAs(),
            isROAValidated: (roa) =>
                state.substanceDetails != null && state.isROAValidated(roa),
          ),

          const SizedBox(height: ThemeConstants.cardSpacing),

          // Feelings
          FeelingsCard(
            feelings: state.feelings,
            secondaryFeelings: state.secondaryFeelings,
            onFeelingsChanged: state.setFeelings,
            onSecondaryFeelingsChanged: state.setSecondaryFeelings,
          ),

          const SizedBox(height: ThemeConstants.cardSpacing),

          // Medical Purpose (simple mode only)
          if (state.isSimpleMode) ...[
            MedicalPurposeCard(
              isMedicalPurpose: state.isMedicalPurpose,
              onChanged: state.setIsMedicalPurpose,
            ),
            const SizedBox(height: ThemeConstants.cardSpacing),
          ],

          // Time of Use
          TimeOfUseCard(
            date: state.date,
            hour: state.hour,
            minute: state.minute,
            onDateChanged: state.setDate,
            onHourChanged: state.setHour,
            onMinuteChanged: state.setMinute,
          ),

          const SizedBox(height: ThemeConstants.cardSpacing),

          // Location
          LocationCard(
            location: state.location,
            onLocationChanged: state.setLocation,
          ),

          // Complex fields (only show in detailed mode)
          if (!state.isSimpleMode) ...[
            const SizedBox(height: ThemeConstants.cardSpacing),

            // Intention & Craving
            IntentionCravingCard(
              intention: state.intention,
              cravingIntensity: state.cravingIntensity,
              isMedicalPurpose: state.isMedicalPurpose,
              onIntentionChanged: state.setIntention,
              onCravingIntensityChanged: state.setCravingIntensity,
              onMedicalPurposeChanged: state.setIsMedicalPurpose,
            ),

            const SizedBox(height: ThemeConstants.cardSpacing),

            // Triggers
            TriggersCard(
              selectedTriggers: state.triggers,
              onTriggersChanged: state.setTriggers,
            ),

            const SizedBox(height: ThemeConstants.cardSpacing),

            // Body Signals
            BodySignalsCard(
              selectedBodySignals: state.bodySignals,
              onBodySignalsChanged: state.setBodySignals,
            ),
          ],

          const SizedBox(height: ThemeConstants.cardSpacing),

          // Notes
          NotesCard(notesCtrl: state.notesCtrl),

          // Extra padding for bottom button
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
