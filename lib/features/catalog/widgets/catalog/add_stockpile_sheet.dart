// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO

import 'package:flutter/material.dart';
import '../../../../repo/stockpile_repository.dart';
import '../../../../utils/drug_profile_utils.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';
import 'package:mobile_drug_use_app/common/inputs/input_field.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';

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
            duration: t.animations.toast,
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
                      const CommonSpacer.vertical(4),
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
            const CommonSpacer.vertical(24),

            // Amount input
            CommonInputField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              labelText: 'Amount',
              hintText: 'Enter amount',
              prefixIcon: Icon(
                Icons.inventory_2,
                color: t.accent.primary,
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
            const CommonSpacer.vertical(16),

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
            CommonSpacer(height: t.spacing.xl),

            // Save button
            CommonPrimaryButton(
              onPressed: _saveStockpile,
              label: 'Add to Stockpile',
              isLoading: _isSaving,
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}
