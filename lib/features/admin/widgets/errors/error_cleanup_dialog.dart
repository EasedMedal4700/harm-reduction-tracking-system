// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Fully theme-compliant; dialog state via local state.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/common/inputs/input_field.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';
import 'package:mobile_drug_use_app/common/inputs/switch_tile.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';
import 'package:mobile_drug_use_app/common/buttons/common_outlined_button.dart';

import '../../models/error_cleanup_filters.dart';

/// Dialog for cleaning/filtering error logs with various options
class ErrorCleanupDialog extends ConsumerStatefulWidget {
  final List<String> platformOptions;
  final List<String> screenOptions;
  const ErrorCleanupDialog({
    required this.platformOptions,
    required this.screenOptions,
    super.key,
  });
  @override
  ConsumerState<ErrorCleanupDialog> createState() => _ErrorCleanupDialogState();
}

class _ErrorCleanupDialogState extends ConsumerState<ErrorCleanupDialog> {
  final _daysController = TextEditingController();
  bool _deleteAll = false;
  String? _platform;
  String? _screen;

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
    final nav = ref.read(navigationProvider);

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
        CommonOutlinedButton(
          label: 'Cancel',
          height: context.sizes.buttonHeightSm,
          onPressed: () => nav.pop<ErrorCleanupFilters?>(null),
          color: c.textSecondary,
          borderColor: c.border,
        ),
        CommonPrimaryButton(
          onPressed: () {
            final days = int.tryParse(_daysController.text);
            nav.pop(
              ErrorCleanupFilters(
                deleteAll: _deleteAll,
                olderThanDays: days,
                platform: _platform,
                screenName: _screen,
              ),
            );
          },
          label: 'Confirm',
          height: context.sizes.buttonHeightSm,
        ),
      ],
    );
  }
}
