import 'package:flutter/material.dart';
import '../../common/old_common/drawer_menu.dart';
import '../../models/log_entry_model.dart';
import '../../models/log_entry_form_data.dart';
import '../../controllers/log_entry_controller.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../constants/colors/app_colors_dark.dart';
import '../../constants/colors/app_colors_light.dart';
import '../../widgets/edit_log_entry/edit_app_bar.dart';
import '../../widgets/edit_log_entry/loading_overlay.dart';
import '../../widgets/edit_log_entry/edit_form_content.dart';
import '../../common/layout/common_bottom_bar.dart';
import '../../common/buttons/common_primary_button.dart';

/// Riverpod-ready Edit Log Entry Page
/// UI state (controllers, form key, animation) lives in widget
/// Domain state lives in local LogEntryFormData
/// Business logic lives in LogEntryController
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
  
  // UI-only state (Riverpod-ready: these stay in widget)
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
    
    // Load existing entry data
    final LogEntry model = LogEntry.fromJson(widget.entry);
    _formData = _convertToFormData(model);
    
    // Initialize controllers from loaded data
    _substanceCtrl = TextEditingController(text: _formData.substance);
    _doseCtrl = TextEditingController(text: _formData.dose.toString());
    _notesCtrl = TextEditingController(text: _formData.notes);
    
    // Setup fade-in animation
    _animationController = AnimationController(
      duration: AppThemeConstants.animationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
    
    // Sync controllers with form data
    _substanceCtrl.addListener(() {
      setState(() => _formData = _formData.copyWith(substance: _substanceCtrl.text));
      _loadSubstanceDetails(_substanceCtrl.text);
    });
    _doseCtrl.addListener(() {
      final value = double.tryParse(_doseCtrl.text);
      if (value != null) {
        setState(() => _formData = _formData.copyWith(dose: value));
      }
    });
    _notesCtrl.addListener(() {
      setState(() => _formData = _formData.copyWith(notes: _notesCtrl.text));
    });
    
    // Load initial substance details for ROA validation
    if (_formData.substance.isNotEmpty) {
      _loadSubstanceDetails(_formData.substance);
    }
  }
  
  /// Convert LogEntry model to LogEntryFormData
  LogEntryFormData _convertToFormData(LogEntry model) {
    return LogEntryFormData(
      substance: model.substance,
      dose: model.dosage,
      unit: model.unit,
      route: model.route,
      location: model.location,
      notes: model.notes ?? '',
      date: model.datetime,
      hour: model.datetime.hour,
      minute: model.datetime.minute,
      feelings: model.feelings,
      secondaryFeelings: model.secondaryFeelings,
      triggers: model.triggers,
      bodySignals: model.bodySignals,
      isMedicalPurpose: model.isMedicalPurpose,
      cravingIntensity: model.cravingIntensity,
      intention: model.intention,
      entryId: widget.entry['use_id']?.toString() ??
          widget.entry['id']?.toString() ??
          '',
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _substanceCtrl.dispose();
    _doseCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fix validation errors before saving.');
      return;
    }

    // Run validations
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

    // Save
    setState(() => _isSaving = true);
    
    final result = await _controller.saveLogEntry(_formData);
    
    setState(() => _isSaving = false);

    if (result.isSuccess) {
      _showSnackBar(result.message, duration: const Duration(seconds: 4));
      if (mounted) {
        Navigator.of(context).pop(true); // Return to previous screen
      }
    } else {
      _showSnackBar(result.message);
    }
  }

  /// Load substance details for ROA validation
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

  Future<void> _handleDelete() async {
    // TODO: Implement delete logic using controller
    _showSnackBar('Delete functionality not yet implemented');
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

    return Scaffold(
      backgroundColor: isDark
          ? AppColorsDark.background
          : AppColorsLight.background,
      appBar: EditLogEntryAppBar(
        isDark: isDark,
        formData: _formData,
        onDelete: _handleDelete,
        onSimpleModeChanged: (value) {
          setState(() => _formData = _formData.copyWith(isSimpleMode: value));
        },
      ),
      drawer: const DrawerMenu(),
      body: Stack(
        children: [
          // Main form content
          Form(
            key: _formKey,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Scrollable content
                  Expanded(
                    child: EditFormContent(
                      formData: _formData,
                      substanceCtrl: _substanceCtrl,
                      doseCtrl: _doseCtrl,
                      notesCtrl: _notesCtrl,
                      onFormDataChanged: (newData) {
                        setState(() => _formData = newData);
                      },
                    ),
                  ),

                  // Sticky bottom save button (match Create page UI)
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
          ),

          // Loading overlay
          LoadingOverlay(isLoading: _isSaving),
        ],
      ),
    );
  }
}
