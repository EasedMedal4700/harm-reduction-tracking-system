// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Page for logging drug use. No hardcoded values.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/layout/common_drawer.dart';
import '../../common/feedback/common_loader.dart';
import 'widgets/log_entry/log_entry_form.dart';
import 'widgets/log_entry_page/log_entry_app_bar.dart';
import 'log_entry_state.dart';
import 'log_entry_controller.dart';

class QuickLogEntryPage extends StatefulWidget {
  final LogEntryController? controller;
  const QuickLogEntryPage({super.key, this.controller});
  @override
  State<QuickLogEntryPage> createState() => _QuickLogEntryPageState();
}

class _QuickLogEntryPageState extends State<QuickLogEntryPage>
    with SingleTickerProviderStateMixin {
  late final LogEntryState _state;
  late final LogEntryController _controller;
  AnimationController? _animationController;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();
  final _doseCtrl = TextEditingController();
  final _substanceCtrl = TextEditingController();
  bool _isSaving = false;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? LogEntryController();
    _state = LogEntryState(controller: _controller);
    // AnimationController will be initialized in didChangeDependencies
    // to safely access Theme context.
    _notesCtrl.addListener(() => _state.setNotes(_notesCtrl.text));
    _doseCtrl.addListener(() {
      final value = double.tryParse(_doseCtrl.text);
      if (value != null) _state.setDose(value);
    });
    _substanceCtrl.addListener(() => _state.setSubstance(_substanceCtrl.text));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animationController == null) {
      _animationController = AnimationController(
        duration: context.animations.normal,
        vsync: this,
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
      );
      _animationController!.forward();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
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
    final substanceValidation = await _controller.validateSubstance(
      _state.data,
    );
    if (!substanceValidation.isValid) {
      _showErrorDialog(
        substanceValidation.title!,
        substanceValidation.message!,
      );
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
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (result.isSuccess) {
      _showSnackBar(result.message, duration: context.animations.longSnackbar);
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
      SnackBar(
        content: Text(message),
        duration: duration ?? context.animations.snackbar,
      ),
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
    final c = context.colors;
    final sp = context.spacing;
    return ChangeNotifierProvider<LogEntryState>.value(
      value: _state,
      child: Consumer<LogEntryState>(
        builder: (context, state, child) {
          return Scaffold(
            backgroundColor: c.background,
            appBar: LogEntryAppBar(
              isSimpleMode: state.isSimpleMode,
              onSimpleModeChanged: state.setIsSimpleMode,
            ),
            drawer: const CommonDrawer(),
            body: Stack(
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(sp.md),
                    child: LogEntryForm(
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
                      isMedicalPurpose: state.isMedicalPurpose,
                      cravingIntensity: state.cravingIntensity,
                      intention: state.intention,
                      selectedTriggers: state.triggers,
                      selectedBodySignals: state.bodySignals,
                      notesCtrl: _notesCtrl,
                      doseCtrl: _doseCtrl,
                      substanceCtrl: _substanceCtrl,
                      formKey: _formKey,
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
                      onSave: _handleSave,
                    ),
                  ),
                ),
                if (_isSaving)
                  Container(color: c.overlayHeavy, child: const CommonLoader()),
              ],
            ),
          );
        },
      ),
    );
  }
}
