// ignore_for_file: deprecated_member_use
// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Fully theme-compliant, no deprecated API
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/inputs/input_field.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';
import 'package:mobile_drug_use_app/common/inputs/switch_tile.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';

/// Dialog for cleaning/filtering error logs with various options
class ErrorCleanupDialog extends StatefulWidget {
  final List<String> platformOptions;
  final List<String> screenOptions;
  const ErrorCleanupDialog({
    required this.platformOptions,
    required this.screenOptions,
    super.key,
  });
  @override
  State<ErrorCleanupDialog> createState() => _ErrorCleanupDialogState();
}

class _ErrorCleanupDialogState extends State<ErrorCleanupDialog> {
  final _daysController = TextEditingController();
  String? _platform;
  String? _screen;
  bool _deleteAll = false;
  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    return AlertDialog(
      backgroundColor: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sh.radiusMd),
        side: BorderSide(color: c.border),
      ),

      /// TITLE
      title: Text(
        'Clean Error Logs',
        style: tx.heading3.copyWith(color: c.textPrimary),
      ),

      /// CONTENT
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            /// DELETE ALL SWITCH
            CommonSwitchTile(
              value: _deleteAll,
              onChanged: (value) => setState(() => _deleteAll = value),
              title: 'Delete entire table',
              subtitle: 'This action cannot be undone',
            ),
            if (!_deleteAll) ...[
              /// DAYS FIELD
              CommonInputField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                labelText: 'Older than (days)',
                hintText: 'e.g., 30',
              ),
              SizedBox(height: sp.md),

              /// PLATFORM DROPDOWN
              CommonDropdown<String>(
                value: _platform,
                items: widget.platformOptions,
                hintText: 'Platform (optional)',
                itemLabel: (v) => v,
                onChanged: (val) => setState(() => _platform = val),
              ),
              SizedBox(height: sp.md),

              /// SCREEN DROPDOWN
              CommonDropdown<String>(
                value: _screen,
                items: widget.screenOptions,
                hintText: 'Screen (optional)',
                itemLabel: (v) => v,
                onChanged: (val) => setState(() => _screen = val),
              ),
            ],
          ],
        ),
      ),

      /// ACTION BUTTONS
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            'Cancel',
            style: tx.button.copyWith(color: c.textSecondary),
          ),
        ),
        CommonPrimaryButton(
          onPressed: () {
            final days = int.tryParse(_daysController.text);
            Navigator.of(context).pop({
              'deleteAll': _deleteAll,
              'olderThanDays': days,
              'platform': _platform,
              'screen': _screen,
            });
          },
          label: 'Confirm',
        ),
      ],
    );
  }
}
