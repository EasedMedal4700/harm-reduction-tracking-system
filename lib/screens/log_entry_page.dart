import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/log_entry_cards/substance_header_card.dart';
import '../widgets/log_entry_cards/dosage_card.dart';
import '../widgets/log_entry_cards/route_of_administration_card.dart';
import '../widgets/log_entry_cards/feelings_card.dart';
import '../widgets/log_entry_cards/time_of_use_card.dart';
import '../widgets/log_entry_cards/location_card.dart';
import '../widgets/log_entry_cards/intention_craving_card.dart';
import '../widgets/log_entry_cards/triggers_card.dart';
import '../widgets/log_entry_cards/body_signals_card.dart';
import '../widgets/log_entry_cards/medical_purpose_card.dart';
import '../widgets/log_entry_page/log_entry_app_bar.dart';
import '../states/log_entry_state.dart';
import '../constants/theme/app_theme_constants.dart';
import '../constants/colors/app_colors_dark.dart';
import '../constants/colors/app_colors_light.dart';
import '../common/cards/common_card.dart';
import '../common/text/common_section_header.dart';
import '../common/inputs/common_textarea.dart';
import '../common/buttons/common_primary_button.dart';
import '../common/layout/common_spacer.dart';
import '../common/layout/common_bottom_bar.dart';

class QuickLogEntryPage extends StatefulWidget {
  const QuickLogEntryPage({super.key});

  @override
  State<QuickLogEntryPage> createState() => _QuickLogEntryPageState();
}

class _QuickLogEntryPageState extends State<QuickLogEntryPage>
    with SingleTickerProviderStateMixin {
  late final LogEntryState _state;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _state = LogEntryState();
    
    // Setup fade-in animation
    _animationController = AnimationController(
      duration: AppThemeConstants.animationNormal,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ChangeNotifierProvider<LogEntryState>.value(
      value: _state,
      child: Consumer<LogEntryState>(
        builder: (context, state, child) {
          return Scaffold(
            backgroundColor: isDark ? AppColorsDark.background : AppColorsLight.background,
            appBar: LogEntryAppBar(
              isSimpleMode: state.isSimpleMode,
              onSimpleModeChanged: state.setIsSimpleMode,
            ),
            drawer: const DrawerMenu(),
            body: Stack(
              children: [
                _FadeInWrapper(
                  animation: _fadeAnimation,
                  child: Form(
                    key: state.formKey,
                    child: Column(
                      children: [
                        _LogEntryScrollView(state: state),
                        _SaveButton(state: state),
                      ],
                    ),
                  ),
                ),
                if (state.isSaving) const _SavingOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// PRIVATE WIDGETS - UI Structure Extraction
// ============================================================================

/// Wrapper for fade-in animation on page load
class _FadeInWrapper extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _FadeInWrapper({
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

/// Main scrollable content area with all form sections
class _LogEntryScrollView extends StatelessWidget {
  final LogEntryState state;

  const _LogEntryScrollView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppThemeConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CoreSection(state: state),
            if (state.isSimpleMode) 
              _SimpleModeSection(state: state)
            else 
              _DetailedModeSection(state: state),
            _NotesSection(state: state),
            const SizedBox(height: 80), // Extra padding for bottom button
          ],
        ),
      ),
    );
  }
}

/// Core fields shown in both simple and detailed modes
class _CoreSection extends StatelessWidget {
  final LogEntryState state;

  const _CoreSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Substance
        SubstanceHeaderCard(
          substance: state.substance,
          substanceCtrl: state.substanceCtrl,
          onSubstanceChanged: state.setSubstance,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        // Dosage
        DosageCard(
          dose: state.dose,
          unit: state.unit,
          units: const ['μg', 'mg', 'g', 'pills', 'ml'],
          doseCtrl: state.doseCtrl,
          onDoseChanged: state.setDose,
          onUnitChanged: state.setUnit,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        // Route of Administration
        RouteOfAdministrationCard(
          route: state.route,
          onRouteChanged: state.setRoute,
          availableROAs: state.getAvailableROAs(),
          isROAValidated: (roa) => state.substanceDetails != null && state.isROAValidated(roa),
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        // Feelings
        FeelingsCard(
          feelings: state.feelings,
          secondaryFeelings: state.secondaryFeelings,
          onFeelingsChanged: state.setFeelings,
          onSecondaryFeelingsChanged: state.setSecondaryFeelings,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
      ],
    );
  }
}

/// Simple mode section with medical purpose and basic fields
class _SimpleModeSection extends StatelessWidget {
  final LogEntryState state;

  const _SimpleModeSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MedicalPurposeCard(
          isMedicalPurpose: state.isMedicalPurpose,
          onChanged: state.setIsMedicalPurpose,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        TimeOfUseCard(
          date: state.date,
          hour: state.hour,
          minute: state.minute,
          onDateChanged: state.setDate,
          onHourChanged: state.setHour,
          onMinuteChanged: state.setMinute,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        LocationCard(
          location: state.location,
          onLocationChanged: state.setLocation,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
      ],
    );
  }
}

/// Detailed mode section with all advanced fields
class _DetailedModeSection extends StatelessWidget {
  final LogEntryState state;

  const _DetailedModeSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TimeOfUseCard(
          date: state.date,
          hour: state.hour,
          minute: state.minute,
          onDateChanged: state.setDate,
          onHourChanged: state.setHour,
          onMinuteChanged: state.setMinute,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        LocationCard(
          location: state.location,
          onLocationChanged: state.setLocation,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        IntentionCravingCard(
          intention: state.intention,
          cravingIntensity: state.cravingIntensity,
          isMedicalPurpose: state.isMedicalPurpose,
          onIntentionChanged: state.setIntention,
          onCravingIntensityChanged: state.setCravingIntensity,
          onMedicalPurposeChanged: state.setIsMedicalPurpose,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        TriggersCard(
          selectedTriggers: state.triggers,
          onTriggersChanged: state.setTriggers,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        BodySignalsCard(
          selectedBodySignals: state.bodySignals,
          onBodySignalsChanged: state.setBodySignals,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
      ],
    );
  }
}

/// Notes section with text area
class _NotesSection extends StatelessWidget {
  final LogEntryState state;

  const _NotesSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: 'Additional Notes',
            subtitle: 'Any other details worth recording',
          ),
          CommonSpacer.vertical(AppThemeConstants.spaceMd),
          CommonTextarea(
            controller: state.notesCtrl,
            hintText: 'Enter any additional notes...',
            maxLines: 5,
            minLines: 3,
          ),
        ],
      ),
    );
  }
}

/// Save button at bottom of screen
class _SaveButton extends StatelessWidget {
  final LogEntryState state;

  const _SaveButton({required this.state});

  @override
  Widget build(BuildContext context) {
    return CommonBottomBar(
      child: CommonPrimaryButton(
        onPressed: () => state.save(context),
        label: 'Save Entry',
        icon: Icons.save,
      ),
    );
  }
}

/// Loading overlay shown during save operation
class _SavingOverlay extends StatelessWidget {
  const _SavingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}