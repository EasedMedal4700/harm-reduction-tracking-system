import 'package:flutter/material.dart';
import '../../../../repo/stockpile_repository.dart';
import '../../../../utils/drug_profile_utils.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';

class AddStockpileSheet extends StatefulWidget {
  final String substanceId;
  final String substanceName;
  final Map<String, dynamic>? substanceDetails;

  const AddStockpileSheet({
    super.key,
    required this.substanceId,
    required this.substanceName,
    this.substanceDetails,
  });

  @override
  State<AddStockpileSheet> createState() => _AddStockpileSheetState();
}

class _AddStockpileSheetState extends State<AddStockpileSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedUnit = 'mg';
  bool _isSaving = false;

  final _stockpileRepo = StockpileRepository();

  final List<String> _units = ['mg', 'g', 'pill', 'ml'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveStockpile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final t = context.theme;

    try {
      final amount = double.parse(_amountController.text);
      
      // Convert to mg
      final amountInMg = DrugProfileUtils.convertToMg(
        amount,
        _selectedUnit,
        widget.substanceDetails,
      );

      // Add to stockpile (unitMg is named parameter)
      await _stockpileRepo.addToStockpile(
        widget.substanceId,
        amountInMg,
        unitMg: 1.0, // Already converted to mg, so 1mg = 1mg
      );

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added ${amount.toStringAsFixed(1)}$_selectedUnit (${amountInMg.toStringAsFixed(1)}mg) to ${widget.substanceName} stockpile',
            ),
            backgroundColor: t.colors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add stockpile: ${e.toString()}'),
            backgroundColor: t.colors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(t.shapes.radiusXl),
        ),
      ),
      padding: EdgeInsets.only(
        left: t.spacing.lg,
        right: t.spacing.lg,
        top: t.spacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + t.spacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add to Stockpile',
                        style: t.typography.heading3.copyWith(
                          color: t.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: t.spacing.xs),
                      Text(
                        widget.substanceName,
                        style: t.typography.body.copyWith(
                          color: t.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: t.colors.textSecondary,
                ),
              ],
            ),
            SizedBox(height: t.spacing.xl),

            // Amount input
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: t.typography.body.copyWith(
                color: t.colors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount',
                prefixIcon: Icon(
                  Icons.inventory_2,
                  color: t.accent.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                  borderSide: BorderSide(
                    color: t.colors.border,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                  borderSide: BorderSide(
                    color: t.colors.border,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                  borderSide: BorderSide(
                    color: t.accent.primary,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid positive number';
                }
                return null;
              },
            ),
            SizedBox(height: t.spacing.md),

            // Unit dropdown
            CommonDropdown<String>(
              value: _selectedUnit,
              items: _units,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedUnit = value);
                }
              },
              hintText: 'Unit',
            ),
            SizedBox(height: t.spacing.xl),

            // Save button
            ElevatedButton(
              onPressed: _isSaving ? null : _saveStockpile,
              style: ElevatedButton.styleFrom(
                backgroundColor: t.accent.primary,
                foregroundColor: t.colors.textInverse,
                padding: EdgeInsets.symmetric(vertical: t.spacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                ),
                elevation: 2,
              ),
              child: _isSaving
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(t.colors.textInverse),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add),
                        SizedBox(width: t.spacing.sm),
                        Text(
                          'Add to Stockpile',
                          style: t.typography.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: t.colors.textInverse,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
