// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Dialog for deleting entries. No hardcoded values.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import '../../../common/buttons/common_primary_button.dart';
import '../../log_entry/models/log_entry_form_data.dart';
import '../../log_entry/log_entry_service.dart';

class DeleteConfirmationDialog {
  static Future<void> show(BuildContext context, LogEntryFormData state) async {
    final nav = ProviderScope.containerOf(context).read(navigationProvider);
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.surface,
        title: Text(
          'Delete Entry?',
          style: th.text.heading3.copyWith(color: c.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this drug use entry? This action cannot be undone.',
          style: th.text.body.copyWith(color: c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => nav.pop(false),
            child: Text(
              'Cancel',
              style: th.text.labelLarge.copyWith(color: ac.primary),
            ),
          ),
          CommonPrimaryButton(
            onPressed: () => nav.pop(true),
            label: 'Delete',
            backgroundColor: c.error,
            textColor: c.textInverse,
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        final service = LogEntryService();
        await service.deleteLogEntry(state.entryId);
        if (context.mounted) {
          nav.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Entry deleted successfully'),
              backgroundColor: c.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete entry: $e'),
              backgroundColor: c.error,
            ),
          );
        }
      }
    }
  }
}
