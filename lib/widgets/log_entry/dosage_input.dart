// MIGRATION
// filepath: lib/widgets/log_entry/dosage_input.dart
import 'package:flutter/material.dart';
import '../../utils/entry_validation.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';

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
    _controller = TextEditingController(text: _formatDose(widget.dose));
  }

  String _formatDose(double dose) {
    if (dose == 0.0) return '0.0';
    if (dose == dose.roundToDouble()) return dose.toInt().toString();
    return dose.toString();
  }

  @override
  void didUpdateWidget(DosageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dose != widget.dose && !_isUserEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final oldPos = _controller.selection;
        _controller.text = _formatDose(widget.dose);

        final newLength = _controller.text.length;
        if (oldPos.baseOffset <= newLength) {
          _controller.selection = oldPos;
        } else {
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: newLength),
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

  void _increment() {
    _isUserEditing = false;
    widget.onDoseChanged((widget.dose + 1).clamp(0, 99999));
  }

  void _decrement() {
    _isUserEditing = false;
    widget.onDoseChanged((widget.dose - 1).clamp(0, 99999));
  }

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(title: "Dosage"),

          const SizedBox(height: AppThemeConstants.spaceMd),

          Row(
            children: [
              IconButton(
                iconSize: AppThemeConstants.iconMd,
                padding: EdgeInsets.all(AppThemeConstants.spaceSm),
                icon: const Icon(Icons.remove),
                onPressed: _decrement,
              ),

              Expanded(
                child: TextFormField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: ValidationUtils.validateDosage,
                  onTap: () => _isUserEditing = true,
                  onChanged: (v) {
                    _isUserEditing = true;
                    final value = double.tryParse(v);
                    if (value != null) {
                      widget.onDoseChanged(value);
                    }
                  },
                  onEditingComplete: () => _isUserEditing = false,
                ),
              ),

              IconButton(
                iconSize: AppThemeConstants.iconMd,
                padding: EdgeInsets.all(AppThemeConstants.spaceSm),
                icon: const Icon(Icons.add),
                onPressed: _increment,
              ),

              SizedBox(width: AppThemeConstants.spaceMd),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeConstants.spaceSm,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.unit,
                    items: widget.units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (v) => widget.onUnitChanged(v!),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
