import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/old_common/drawer_menu.dart';
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
import '../controllers/log_entry_controller.dart';
import '../constants/theme/app_theme_constants.dart';
import '../constants/colors/app_colors_dark.dart';
import '../constants/colors/app_colors_light.dart';
import '../common/cards/common_card.dart';
import '../common/text/common_section_header.dart';
import '../common/inputs/textarea.dart';
import '../common/buttons/common_primary_button.dart';
import '../common/layout/common_spacer.dart';
import '../common/layout/common_bottom_bar.dart';

/// Riverpod-ready Log Entry Page
/// UI state (controllers, form key, animation) lives in widget
/// Domain state (substance, dose, etc.) lives in LogEntryState
/// Business logic lives in LogEntryController
/// 
/// MIGRATION NOTE: When moving to Riverpod, replace Provider with:
/// ```
/// final state = ref.watch(logEntryProvider);
/// ref.read(logEntryProvider.notifier).setSubstance(value);
/// ```
class QuickLogEntryPage extends StatefulWidget {
  const QuickLogEntryPage({super.key});

  @override
  State<QuickLogEntryPage> createState() => _QuickLogEntryPageState();
}

class _QuickLogEntryPageState extends State<QuickLogEntryPage>
    with SingleTickerProviderStateMixin {
  late final LogEntryState _state;
  late final LogEntryController _controller;
  
  // UI-only state (Riverpod-ready: these stay in widget)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();
  final _doseCtrl = TextEditingController();
  final _substanceCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _state = LogEntryState();
    _controller = LogEntryController();
    
    // Setup fade-in animation (UI concern)
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
    
    // Sync controllers with state
    _notesCtrl.addListener(() => _state.setNotes(_notesCtrl.text));
    _doseCtrl.addListener(() {
      final value = double.tryParse(_doseCtrl.text);
      if (value != null) _state.setDose(value);
    });
    _substanceCtrl.addListener(() => _state.setSubstance(_substanceCtrl.text));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notesCtrl.dispose();
    _doseCtrl.dispose();
    _substanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fix validation errors before saving.');
      return;
    }

    // Run validations
    final substanceValidation = await _controller.validateSubstance(_state.data);
    if (!substanceValidation.isValid) {
      _showErrorDialog(substanceValidation.title!, substanceValidation.message!);
      return;
    }

    final roaValidation = _controller.validateROA(_state.data);
    if (roaValidation.needsConfirmation) {
      final confirmed = await _showConfirmDialog(
        roaValidation.title!,
        roaValidation.message!,
      );
      if (!confirmed) return;
    }

    final emotionsValidation = _controller.validateEmotions(_state.data);
    if (emotionsValidation.needsConfirmation) {
      final confirmed = await _showConfirmDialog(
        emotionsValidation.title!,
        emotionsValidation.message!,
      );
      if (!confirmed) return;
    }

    final cravingValidation = _controller.validateCraving(_state.data);
    if (cravingValidation.needsConfirmation) {
      final confirmed = await _showConfirmDialog(
        cravingValidation.title!,
        cravingValidation.message!,
      );
      if (!confirmed) return;
    }

    // Save
    setState(() => _isSaving = true);
    
    final result = await _controller.saveLogEntry(_state.data);
    
    setState(() => _isSaving = false);

    if (result.isSuccess) {
      _showSnackBar(result.message, duration: const Duration(seconds: 4));
      _resetForm();
    } else {
      _showSnackBar(result.message);
    }
  }

  void _resetForm() {
    _state.resetForm();
    _notesCtrl.clear();
    _doseCtrl.clear();
    _substanceCtrl.clear();
    _formKey.currentState?.reset();
  }

  void _showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: duration ?? const Duration(seconds: 2)),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result ?? false;
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
                    key: _formKey,
                    child: Column(
                      children: [
                        _LogEntryScrollView(
                          state: state,
                          notesCtrl: _notesCtrl,
                          doseCtrl: _doseCtrl,
                          substanceCtrl: _substanceCtrl,
                        ),
                        _SaveButton(onSave: _handleSave),
                      ],
                    ),
                  ),
                ),
                if (_isSaving) const _SavingOverlay(),
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
  final TextEditingController notesCtrl;
  final TextEditingController doseCtrl;
  final TextEditingController substanceCtrl;

  const _LogEntryScrollView({
    required this.state,
    required this.notesCtrl,
    required this.doseCtrl,
    required this.substanceCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppThemeConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CoreSection(
              state: state,
              doseCtrl: doseCtrl,
              substanceCtrl: substanceCtrl,
            ),
            if (state.isSimpleMode) 
              _SimpleModeSection(state: state)
            else 
              _DetailedModeSection(state: state),
            _NotesSection(
              state: state,
              notesCtrl: notesCtrl,
            ),
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
  final TextEditingController doseCtrl;
  final TextEditingController substanceCtrl;

  const _CoreSection({
    required this.state,
    required this.doseCtrl,
    required this.substanceCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Substance
        SubstanceHeaderCard(
          substance: state.substance,
          substanceCtrl: substanceCtrl,
          onSubstanceChanged: state.setSubstance,
        ),
        CommonSpacer.vertical(AppThemeConstants.spaceXl),
        
        // Dosage
        DosageCard(
          dose: state.dose,
          unit: state.unit,
          units: const ['μg', 'mg', 'g', 'pills', 'ml'],
          doseCtrl: doseCtrl,
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
  final TextEditingController notesCtrl;

  const _NotesSection({
    required this.state,
    required this.notesCtrl,
  });

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
            controller: notesCtrl,
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
  final VoidCallback onSave;

  const _SaveButton({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return CommonBottomBar(
      child: CommonPrimaryButton(
        onPressed: onSave,
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