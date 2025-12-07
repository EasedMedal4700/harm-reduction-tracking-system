import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../repo/stockpile_repository.dart';
import '../../utils/drug_profile_utils.dart';

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

  final List<String> _units = ['mg', 'g', 'μg', 'pill', 'ml'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveStockpile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

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
            backgroundColor: UIColors.lightAccentGreen,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add stockpile: ${e.toString()}'),
            backgroundColor: UIColors.lightAccentRed,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkBackground : UIColors.lightBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusExtraLarge),
        ),
      ),
      padding: EdgeInsets.only(
        left: ThemeConstants.space20,
        right: ThemeConstants.space20,
        top: ThemeConstants.space20,
        bottom: MediaQuery.of(context).viewInsets.bottom + ThemeConstants.space20,
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
                        style: TextStyle(
                          fontSize: ThemeConstants.fontXLarge,
                          fontWeight: ThemeConstants.fontBold,
                          color: isDark ? UIColors.darkText : UIColors.lightText,
                        ),
                      ),
                      SizedBox(height: ThemeConstants.space4),
                      Text(
                        widget.substanceName,
                        style: TextStyle(
                          fontSize: ThemeConstants.fontMedium,
                          color: isDark
                              ? UIColors.darkTextSecondary
                              : UIColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                ),
              ],
            ),
            SizedBox(height: ThemeConstants.space24),

            // Amount input
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: TextStyle(
                color: isDark ? UIColors.darkText : UIColors.lightText,
                fontSize: ThemeConstants.fontMedium,
              ),
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount',
                prefixIcon: Icon(
                  Icons.inventory_2,
                  color: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  borderSide: BorderSide(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  borderSide: BorderSide(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  borderSide: BorderSide(
                    color: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
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
            SizedBox(height: ThemeConstants.space16),

            // Unit dropdown
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: InputDecoration(
                labelText: 'Unit',
                prefixIcon: Icon(
                  Icons.straighten,
                  color: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  borderSide: BorderSide(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  borderSide: BorderSide(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                  ),
                ),
              ),
              style: TextStyle(
                color: isDark ? UIColors.darkText : UIColors.lightText,
                fontSize: ThemeConstants.fontMedium,
              ),
              dropdownColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
              items: _units.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedUnit = value);
                }
              },
            ),
            SizedBox(height: ThemeConstants.space24),

            // Save button
            ElevatedButton(
              onPressed: _isSaving ? null : _saveStockpile,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ThemeConstants.space16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                ),
                elevation: 2,
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add),
                        SizedBox(width: ThemeConstants.space8),
                        Text(
                          'Add to Stockpile',
                          style: TextStyle(
                            fontSize: ThemeConstants.fontMedium,
                            fontWeight: ThemeConstants.fontSemiBold,
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
