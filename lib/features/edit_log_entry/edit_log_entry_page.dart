// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Page for editing log entries. Uses CommonPrimaryButton. No hardcoded values.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/OLD_DONT_USE/OLD_THEME_DONT_USE.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

import '../../common/old_common/drawer_menu.dart';
import '../../models/log_entry_model.dart';
import '../../models/log_entry_form_data.dart';
import '../log_entry/log_entry_controller.dart';

import 'widgets/edit_log_entry/edit_app_bar.dart';
import 'widgets/edit_log_entry/loading_overlay.dart';
import '../log_entry/widgets/log_entry/log_entry_form.dart';
import '../../common/layout/common_bottom_bar.dart';
import '../../common/buttons/common_primary_button.dart';

class EditDrugUsePage extends StatefulWidget {
  final Map<String, dynamic> entry;
  const EditDrugUsePage({super.key, required this.entry});

  @override
  State<EditDrugUsePage> createState() => _EditDrugUsePageState();
}

class _EditDrugUsePageState extends State<EditDrugUsePage>
    with SingleTickerProviderStateMixin {
  late final LogEntryController _controller;
  late LogEntryFormData _formData;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesCtrl;
  late final TextEditingController _doseCtrl;
  late final TextEditingController _substanceCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = LogEntryController();
    
    final LogEntry model = LogEntry.fromJson(widget.entry);
    _formData = _convertToFormData(model);
    
    _notesCtrl = TextEditingController(text: _formData.notes);
    _doseCtrl = TextEditingController(text: _formData.dose.toString());
    _substanceCtrl = TextEditingController(text: _formData.substance);
    
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
    
    _notesCtrl.addListener(() {
      setState(() => _formData = _formData.copyWith(notes: _notesCtrl.text));
    });
    _doseCtrl.addListener(() {
      final val = double.tryParse(_doseCtrl.text);
      if (val != null) {
        setState(() => _formData = _formData.copyWith(dose: val));
      }
    });
    _substanceCtrl.addListener(() {
      final text = _substanceCtrl.text;
      setState(() => _formData = _formData.copyWith(substance: text));
      _loadSubstanceDetails(text);
    });

    // Initial load
    _loadSubstanceDetails(_formData.substance);
  }

  LogEntryFormData _convertToFormData(LogEntry model) {
    return LogEntryFormData(
      isSimpleMode: true,
      substance: model.substance,
      dose: model.dosage,
      unit: model.unit,
      route: model.route,
      feelings: model.feelings,
      secondaryFeelings: model.secondaryFeelings,
      location: model.location,
      date: model.datetime,
      hour: model.datetime.hour,
      minute: model.datetime.minute,
      isMedicalPurpose: model.isMedicalPurpose,
      cravingIntensity: model.cravingIntensity,
      intention: model.intention,
      triggers: model.triggers,
      bodySignals: model.bodySignals,
      notes: model.notes ?? '',
      substanceDetails: null,
      entryId: widget.entry['use_id']?.toString() ?? widget.entry['id']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notesCtrl.dispose();
    _doseCtrl.dispose();
    _substanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSubstanceDetails(String substanceName) async {
    if (substanceName.isEmpty) {
      setState(() {
        _formData = _formData.copyWith(substanceDetails: null);
      });
      return;
    }

    final details = await _controller.loadSubstanceDetails(substanceName);
    if (mounted) {
      setState(() {
        _formData = _formData.copyWith(substanceDetails: details);
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fix validation errors before saving.');
      return;
    }

    final substanceValidation = await _controller.validateSubstance(_formData);
    if (!substanceValidation.isValid) {
      _showErrorDialog(substanceValidation.title!, substanceValidation.message!);
      return;
    }

    final roaValidation = _controller.validateROA(_formData);
    if (roaValidation.needsConfirmation) {
      final confirmed = await _showConfirmDialog(
        roaValidation.title!,
        roaValidation.message!,
      );
      if (!confirmed) return;
    }

    final emotionsValidation = _controller.validateEmotions(_formData);
    if (emotionsValidation.needsConfirmation) {
      final confirmed = await _showConfirmDialog(
        emotionsValidation.title!,
        emotionsValidation.message!,
      );
      if (!confirmed) return;
    }

    final cravingValidation = _controller.validateCraving(_formData);
    if (cravingValidation.needsConfirmation) {
      final confirmed = await _showConfirmDialog(
        cravingValidation.title!,
        cravingValidation.message!,
      );
      if (!confirmed) return;
    }

    setState(() => _isSaving = true);
    
    final result = await _controller.saveLogEntry(_formData);
    
    setState(() => _isSaving = false);

    if (result.isSuccess) {
      _showSnackBar(result.message, duration: const Duration(seconds: 4));
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } else {
      _showSnackBar(result.message);
    }
  }

  Future<void> _handleDelete() async {
    final c = context.colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: c.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isSaving = true);
      _showSnackBar('Delete functionality not yet implemented');
      setState(() => _isSaving = false);
    }
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
    final c = context.colors;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: EditLogEntryAppBar(
        formData: _formData,
        onDelete: _handleDelete,
        onSimpleModeChanged: (value) {
          setState(() => _formData = _formData.copyWith(isSimpleMode: value));
        },
      ),
      drawer: const DrawerMenu(),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(sp.lg),
                    child: LogEntryForm(
                      formKey: _formKey,
                      isSimpleMode: _formData.isSimpleMode,
                      dose: _formData.dose,
                      unit: _formData.unit,
                      substance: _formData.substance,
                      route: _formData.route,
                      feelings: _formData.feelings,
                      secondaryFeelings: _formData.secondaryFeelings,
                      location: _formData.location,
                      date: _formData.date,
                      hour: _formData.hour,
                      minute: _formData.minute,
                      isMedicalPurpose: _formData.isMedicalPurpose,
                      cravingIntensity: _formData.cravingIntensity,
                      intention: _formData.intention,
                      selectedTriggers: _formData.triggers,
                      selectedBodySignals: _formData.bodySignals,
                      notesCtrl: _notesCtrl,
                      doseCtrl: _doseCtrl,
                      substanceCtrl: _substanceCtrl,
                      onDoseChanged: (v) => setState(() => _formData = _formData.copyWith(dose: v)),
                      onUnitChanged: (v) => setState(() => _formData = _formData.copyWith(unit: v)),
                      onSubstanceChanged: (v) => setState(() => _formData = _formData.copyWith(substance: v)),
                      onRouteChanged: (v) => setState(() => _formData = _formData.copyWith(route: v)),
                      onFeelingsChanged: (v) => setState(() => _formData = _formData.copyWith(feelings: v)),
                      onSecondaryFeelingsChanged: (v) => setState(() => _formData = _formData.copyWith(secondaryFeelings: v)),
                      onLocationChanged: (v) => setState(() => _formData = _formData.copyWith(location: v)),
                      onDateChanged: (v) => setState(() => _formData = _formData.copyWith(date: v)),
                      onHourChanged: (v) => setState(() => _formData = _formData.copyWith(hour: v)),
                      onMinuteChanged: (v) => setState(() => _formData = _formData.copyWith(minute: v)),
                      onMedicalPurposeChanged: (v) => setState(() => _formData = _formData.copyWith(isMedicalPurpose: v)),
                      onCravingIntensityChanged: (v) => setState(() => _formData = _formData.copyWith(cravingIntensity: v)),
                      onIntentionChanged: (v) => setState(() => _formData = _formData.copyWith(intention: v)),
                      onTriggersChanged: (v) => setState(() => _formData = _formData.copyWith(triggers: v)),
                      onBodySignalsChanged: (v) => setState(() => _formData = _formData.copyWith(bodySignals: v)),
                      onSave: _handleSave,
                      showSaveButton: false,
                    ),
                  ),
                ),

                CommonBottomBar(
                  child: CommonPrimaryButton(
                    onPressed: _handleSave,
                    label: 'Save Changes',
                    icon: Icons.save,
                  ),
                ),
              ],
            ),
          ),

          LoadingOverlay(isLoading: _isSaving),
        ],
      ),
    );
  }
}



