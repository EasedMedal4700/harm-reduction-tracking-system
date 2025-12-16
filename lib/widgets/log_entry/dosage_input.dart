import 'package:flutter/material.dart';
import '../../constants/theme/app_theme.dart';
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
    final t = AppTheme.of(context);

    return Container(
      padding: EdgeInsets.all(t.spacing.m),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusLg),
        border: Border.all(color: t.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dosage",
            style: t.typography.titleMedium.copyWith(
              color: t.colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: t.spacing.m),

          Row(
            children: [
              IconButton(
                iconSize: 24,
                padding: EdgeInsets.all(t.spacing.xs),
                icon: Icon(Icons.remove, color: t.colors.primary),
                onPressed: _decrement,
                style: IconButton.styleFrom(
                  backgroundColor: t.colors.surfaceContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(t.shapes.radiusM)),
                ),
              ),

              SizedBox(width: t.spacing.s),

              Expanded(
                child: TextFormField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: t.typography.headlineSmall.copyWith(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(t.shapes.radiusM),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: t.spacing.s, horizontal: t.spacing.s),
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

              SizedBox(width: t.spacing.s),

              IconButton(
                iconSize: 24,
                padding: EdgeInsets.all(t.spacing.xs),
                icon: Icon(Icons.add, color: t.colors.primary),
                onPressed: _increment,
                style: IconButton.styleFrom(
                  backgroundColor: t.colors.surfaceContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(t.shapes.radiusM)),
                ),
              ),

              SizedBox(width: t.spacing.m),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: t.spacing.s,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(t.shapes.radiusM),
                  border: Border.all(
                    color: t.colors.outline,
                  ),
                  color: t.colors.surfaceContainerLow,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.unit,
                    items: widget.units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u, style: t.typography.bodyLarge)))
                        .toList(),
                    onChanged: (v) => widget.onUnitChanged(v!),
                    icon: Icon(Icons.arrow_drop_down, color: t.colors.onSurfaceVariant),
                    dropdownColor: t.colors.surfaceContainer,
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
