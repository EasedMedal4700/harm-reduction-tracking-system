// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\widgets\log_entry\dosage_input.dart
import 'package:flutter/material.dart';
import '../../utils/entry_validation.dart';

class DosageInput extends StatefulWidget {
  final double dose;
  final String unit;
  final List<String> units;
  final ValueChanged<double> onDoseChanged;
  final ValueChanged<String> onUnitChanged;

  const DosageInput({
    super.key,
    required this.dose,
    required this.unit,
    required this.units,
    required this.onDoseChanged,
    required this.onUnitChanged,
  });

  @override
  State<DosageInput> createState() => _DosageInputState();
}

class _DosageInputState extends State<DosageInput> {
  late TextEditingController _controller;
  bool _isUserEditing = false;

  @override
  void initState() {
    super.initState();
    // Remove trailing zeros for cleaner display
    _controller = TextEditingController(text: _formatDose(widget.dose));
  }

  String _formatDose(double dose) {
    // Remove unnecessary trailing zeros
    if (dose == dose.roundToDouble()) {
      return dose.toInt().toString();
    }
    return dose.toString();
  }

  @override
  void didUpdateWidget(DosageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update text if the value changed externally (not from user typing)
    if (oldWidget.dose != widget.dose && !_isUserEditing) {
      // Schedule text update after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final currentSelection = _controller.selection;
        _controller.text = _formatDose(widget.dose);
        // Restore cursor position if text length allows
        if (currentSelection.baseOffset <= _controller.text.length) {
          _controller.selection = currentSelection;
        } else {
          // Move cursor to end if previous position is out of bounds
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            _isUserEditing = false;
            widget.onDoseChanged((widget.dose - 1).clamp(0, 9999));
          },
        ),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(labelText: 'Dosage'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: ValidationUtils.validateDosage,
            controller: _controller,
            onTap: () {
              // Mark that user is actively editing
              _isUserEditing = true;
            },
            onChanged: (v) {
              _isUserEditing = true;
              final parsedValue = double.tryParse(v);
              if (parsedValue != null) {
                widget.onDoseChanged(parsedValue);
              }
            },
            onEditingComplete: () {
              // User finished editing
              _isUserEditing = false;
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _isUserEditing = false;
            widget.onDoseChanged(widget.dose + 1);
          },
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: widget.unit,
          items: widget.units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
          onChanged: (v) => widget.onUnitChanged(v!),
        ),
      ],
    );
  }
}
