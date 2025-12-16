import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/simple_fields.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/complex_fields.dart';

class LogEntryForm extends StatefulWidget {
  final bool isSimpleMode;
  final VoidCallback onToggleMode;
  final VoidCallback onSave;
  final bool isLoading;
  
  // Controllers and state passed down
  final TextEditingController substanceController;
  final TextEditingController dosageController;
  final TextEditingController notesController;
  final TextEditingController locationController;
  final TextEditingController peopleController;
  final TextEditingController costController;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String? selectedFeeling;
  final String? selectedRoa;
  final List<String> roaOptions;
  final List<String> substanceOptions;
  
  // Callbacks
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final ValueChanged<String> onFeelingSelected;
  final ValueChanged<String?> onRoaChanged;

  const LogEntryForm({
    super.key,
    required this.isSimpleMode,
    required this.onToggleMode,
    required this.onSave,
    this.isLoading = false,
    required this.substanceController,
    required this.dosageController,
    required this.notesController,
    required this.locationController,
    required this.peopleController,
    required this.costController,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedFeeling,
    required this.selectedRoa,
    required this.roaOptions,
    required this.substanceOptions,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onFeelingSelected,
    required this.onRoaChanged,
  });

  @override
  State<LogEntryForm> createState() => _LogEntryFormState();
}

class _LogEntryFormState extends State<LogEntryForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final acc = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mode Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.isSimpleMode ? 'Simple Mode' : 'Detailed Mode',
                style: TextStyle(
                  color: c.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: !widget.isSimpleMode,
                onChanged: (_) => widget.onToggleMode(),
                activeTrackColor: acc.primary,
              ),
            ],
          ),
          SizedBox(height: sp.md),

          // Fields based on mode
          if (widget.isSimpleMode)
            SimpleFields(
              substanceController: widget.substanceController,
              dosageController: widget.dosageController,
              selectedDate: widget.selectedDate,
              selectedTime: widget.selectedTime,
              selectedFeeling: widget.selectedFeeling,
              substanceOptions: widget.substanceOptions,
              onDateChanged: widget.onDateChanged,
              onTimeChanged: widget.onTimeChanged,
              onFeelingSelected: widget.onFeelingSelected,
            )
          else
            Column(
              children: [
                SimpleFields(
                  substanceController: widget.substanceController,
                  dosageController: widget.dosageController,
                  selectedDate: widget.selectedDate,
                  selectedTime: widget.selectedTime,
                  selectedFeeling: widget.selectedFeeling,
                  substanceOptions: widget.substanceOptions,
                  onDateChanged: widget.onDateChanged,
                  onTimeChanged: widget.onTimeChanged,
                  onFeelingSelected: widget.onFeelingSelected,
                ),
                SizedBox(height: sp.md),
                const Divider(),
                SizedBox(height: sp.md),
                ComplexFields(
                  notesController: widget.notesController,
                  locationController: widget.locationController,
                  peopleController: widget.peopleController,
                  costController: widget.costController,
                  selectedRoa: widget.selectedRoa,
                  roaOptions: widget.roaOptions,
                  onRoaChanged: widget.onRoaChanged,
                ),
              ],
            ),

          SizedBox(height: sp.xl),

          // Save Button
          ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: acc.primary,
              foregroundColor: c.textInverse,
              padding: EdgeInsets.symmetric(vertical: sp.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(sh.radiusMd),
              ),
              elevation: 2,
            ),
            child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(c.textInverse),
                    ),
                  )
                : const Text(
                    'Save Entry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
