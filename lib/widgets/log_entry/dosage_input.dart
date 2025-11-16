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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.dose.toStringAsFixed(1));
  }

  @override
  void didUpdateWidget(DosageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dose != widget.dose) {
      // Schedule text update after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.text = widget.dose.toStringAsFixed(1); // Use toStringAsFixed for consistency
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
          onPressed: () => widget.onDoseChanged((widget.dose - 1).clamp(0, 9999)),
        ),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(labelText: 'Dosage'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: ValidationUtils.validateDosage,
            controller: _controller,
            onChanged: (v) => widget.onDoseChanged(double.tryParse(v) ?? widget.dose),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => widget.onDoseChanged(widget.dose + 1),
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
