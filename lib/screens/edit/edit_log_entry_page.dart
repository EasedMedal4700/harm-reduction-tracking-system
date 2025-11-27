import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/drawer_menu.dart';
import '../../states/log_entry_state.dart';
import '../../models/log_entry_model.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../widgets/edit_log_entry/edit_app_bar.dart';
import '../../widgets/edit_log_entry/save_button.dart';
import '../../widgets/edit_log_entry/delete_confirmation_dialog.dart';
import '../../widgets/edit_log_entry/loading_overlay.dart';
import '../../widgets/edit_log_entry/edit_form_content.dart';

class EditDrugUsePage extends StatefulWidget {
  final Map<String, dynamic> entry;
  const EditDrugUsePage({super.key, required this.entry});

  @override
  State<EditDrugUsePage> createState() => _EditDrugUsePageState();
}

class _EditDrugUsePageState extends State<EditDrugUsePage>
    with SingleTickerProviderStateMixin {
  late LogEntryState _state;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _state = LogEntryState();

    // Setup fade-in animation
    _animationController = AnimationController(
      duration: ThemeConstants.animationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _loadEntryData();
    _animationController.forward();
  }

  void _loadEntryData() {
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
    _state.entryId =
        widget.entry['use_id']?.toString() ??
        widget.entry['id']?.toString() ??
        '';
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
            backgroundColor: isDark
                ? UIColors.darkBackground
                : UIColors.lightBackground,
            appBar: EditLogEntryAppBar(
              isDark: isDark,
              state: state,
              onDelete: () => DeleteConfirmationDialog.show(context, state),
            ),
            drawer: const DrawerMenu(),
            body: Stack(
              children: [
                // Main form content
                Form(
                  key: state.formKey,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Scrollable content
                        Expanded(
                          child: EditFormContent(state: state),
                        ),

                        // Sticky bottom save button
                        SaveButton(isDark: isDark, state: state),
                      ],
                    ),
                  ),
                ),

                // Loading overlay
                LoadingOverlay(isLoading: state.isSaving),
              ],
            ),
          );
        },
      ),
    );
  }
}
