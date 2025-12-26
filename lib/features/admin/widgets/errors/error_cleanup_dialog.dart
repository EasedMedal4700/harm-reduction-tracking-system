// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Fully theme-compliant; dialog state via Riverpod.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/inputs/input_field.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';
import 'package:mobile_drug_use_app/common/inputs/switch_tile.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';
import 'package:mobile_drug_use_app/common/buttons/common_outlined_button.dart';

import '../../models/error_cleanup_filters.dart';

final _deleteAllProvider = StateProvider.autoDispose<bool>((ref) => false);
final _platformProvider = StateProvider.autoDispose<String?>((ref) => null);
final _screenProvider = StateProvider.autoDispose<String?>((ref) => null);

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

    final deleteAll = ref.watch(_deleteAllProvider);
    final platform = ref.watch(_platformProvider);
    final screen = ref.watch(_screenProvider);

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
              value: deleteAll,
              onChanged: (value) =>
                  ref.read(_deleteAllProvider.notifier).state = value,
              title: 'Delete entire table',
              subtitle: 'This action cannot be undone',
            ),
            if (!deleteAll) ...[
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
                value: platform,
                items: widget.platformOptions,
                hintText: 'Platform (optional)',
                itemLabel: (v) => v,
                onChanged: (val) =>
                    ref.read(_platformProvider.notifier).state = val,
              ),
              SizedBox(height: sp.md),

              /// SCREEN DROPDOWN
              CommonDropdown<String>(
                value: screen,
                items: widget.screenOptions,
                hintText: 'Screen (optional)',
                itemLabel: (v) => v,
                onChanged: (val) =>
                    ref.read(_screenProvider.notifier).state = val,
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
          onPressed: () => context.pop<ErrorCleanupFilters?>(null),
          color: c.textSecondary,
          borderColor: c.border,
        ),
        CommonPrimaryButton(
          onPressed: () {
            final days = int.tryParse(_daysController.text);
            context.pop(
              ErrorCleanupFilters(
                deleteAll: deleteAll,
                olderThanDays: days,
                platform: platform,
                screenName: screen,
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
