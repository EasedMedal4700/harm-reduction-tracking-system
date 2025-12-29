// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Account confirmation dialogs.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/buttons/common_primary_button.dart';
import '../../../common/layout/common_spacer.dart';
import 'account_dialogs.dart';

/// Shows confirmation dialog for delete data operation
void showDeleteDataConfirmation(
  BuildContext context,
  String password, {
  required VoidCallback onDownloadFirst,
  required VoidCallback onConfirmDelete,
}) {
  final c = context.colors;
  final sp = context.spacing;
  final sh = context.shapes;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning_amber,
            color: c.warning,
            size: context.sizes.icon2xl,
          ),
          CommonSpacer.horizontal(sp.md),
          const Expanded(child: Text('Are You Sure?')),
        ],
      ),
      content: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('This will permanently delete:', style: context.text.bodyBold),
          CommonSpacer.vertical(sp.md),
          WarningItem('All your drug use logs'),
          WarningItem('All your reflections'),
          WarningItem('All your cravings data'),
          WarningItem('All your tolerance data'),
          WarningItem('All your stockpile entries'),
          CommonSpacer.vertical(sp.lg),
          Container(
            padding: EdgeInsets.all(sp.md),
            decoration: BoxDecoration(
              color: c.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(sh.radiusSm),
              border: Border.all(color: c.info),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: c.info,
                  size: context.sizes.iconMd,
                ),
                CommonSpacer.horizontal(sp.sm),
                Expanded(
                  child: Text(
                    'Consider downloading your data first!',
                    style: context.text.body.copyWith(
                      fontWeight: context.text.body.fontWeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CommonSpacer.vertical(sp.md),
          Text(
            'Your account will remain active, but all your data will be gone forever.',
            style: context.text.body.copyWith(
              color: c.error,
              fontWeight: context.text.body.fontWeight,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            context.pop();
            onDownloadFirst();
          },
          style: TextButton.styleFrom(foregroundColor: c.info),
          child: const Text('Download Data First'),
        ),
        CommonPrimaryButton(
          onPressed: () {
            context.pop();
            onConfirmDelete();
          },
          label: 'Yes, Delete My Data',
          backgroundColor: c.warning,
          textColor: c.surface,
        ),
      ],
    ),
  );
}

/// Shows final typed confirmation for data deletion
void showFinalDeleteDataConfirmation(
  BuildContext context,
  String password, {
  required VoidCallback onConfirmDelete,
}) {
  final c = context.colors;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => TypedConfirmationDialog(
      title: 'Final Confirmation',
      confirmText: 'DELETE MY DATA',
      description: 'Type "DELETE MY DATA" to confirm:',
      buttonColor: c.warning,
      onConfirmed: () {
        Navigator.pop(context);
        onConfirmDelete();
      },
    ),
  );
}

/// Shows confirmation dialog for delete account operation
void showDeleteAccountConfirmation(
  BuildContext context,
  String password, {
  required VoidCallback onDownloadFirst,
  required VoidCallback onContinue,
}) {
  final c = context.colors;
  final sp = context.spacing;
  final sh = context.shapes;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: c.error.withValues(alpha: 0.1),
      title: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: c.error,
            size: context.sizes.icon2xl,
          ),
          CommonSpacer.horizontal(sp.md),
          const Expanded(child: Text('⚠️ DELETE ACCOUNT')),
        ],
      ),
      content: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'This will PERMANENTLY delete:',
            style: context.text.bodyBold.copyWith(color: c.error),
          ),
          CommonSpacer.vertical(sp.md),
          WarningItem('All your data and logs', isRed: true),
          WarningItem('All your settings and profile', isRed: true),
          WarningItem('Your account record', isRed: true),
          CommonSpacer.vertical(sp.sm),
          WarningItem(
            '⚠️ Login credentials remain (contact support to delete)',
          ),
          CommonSpacer.vertical(sp.lg),
          Container(
            padding: EdgeInsets.all(sp.md),
            decoration: BoxDecoration(
              color: c.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(sh.radiusSm),
              border: Border.all(
                color: c.warning,
                width: context.borders.medium,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.download,
                  color: c.warning,
                  size: context.sizes.iconMd,
                ),
                CommonSpacer.horizontal(sp.sm),
                Expanded(
                  child: Text(
                    'Download your data first so you can always come back!',
                    style: context.text.bodyBold,
                  ),
                ),
              ],
            ),
          ),
          CommonSpacer.vertical(sp.md),
          Text(
            'This action CANNOT be reversed. Your data will be gone forever.',
            style: context.text.bodySmall.copyWith(
              color: c.error,
              fontWeight: context.text.bodyBold.fontWeight,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            context.pop();
            onDownloadFirst();
          },
          style: TextButton.styleFrom(foregroundColor: c.info),
          child: const Text('Download Data First'),
        ),
        CommonPrimaryButton(
          onPressed: () {
            context.pop();
            onContinue();
          },
          label: 'I Understand, Continue',
          backgroundColor: c.error,
          textColor: c.surface,
        ),
      ],
    ),
  );
}

/// Shows final typed confirmation for account deletion
void showFinalDeleteAccountConfirmation(
  BuildContext context,
  String password, {
  required VoidCallback onConfirmDelete,
}) {
  final c = context.colors;
  final sp = context.spacing;
  final sh = context.shapes;

  bool userConfirmed = false;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: c.error.withValues(alpha: 0.1),
        title: Row(
          children: [
            Icon(Icons.warning, color: c.error, size: context.sizes.icon2xl),
            CommonSpacer.horizontal(sp.sm),
            const Expanded(child: Text('FINAL CONFIRMATION')),
          ],
        ),
        content: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            Text(
              'Type "DELETE MY ACCOUNT" to confirm account deletion:',
              style: context.text.bodyBold.copyWith(color: c.error),
            ),
            CommonSpacer.vertical(sp.md),
            TextField(
              decoration: InputDecoration(
                hintText: 'DELETE MY ACCOUNT',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  borderSide: BorderSide(
                    color: c.error,
                    width: context.borders.medium,
                  ),
                ),
              ),
              style: context.text.bodyBold,
              onChanged: (value) {
                setState(() {
                  userConfirmed = value.trim() == 'DELETE MY ACCOUNT';
                });
              },
            ),
            CommonSpacer.vertical(sp.lg),
            Text(
              '⚠️ This is your last chance to cancel!',
              style: context.text.bodyBold.copyWith(color: c.error),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          CommonPrimaryButton(
            onPressed: () {
              context.pop();
              onConfirmDelete();
            },
            isEnabled: userConfirmed,
            label: 'DELETE MY ACCOUNT FOREVER',
            backgroundColor: c.error,
            textColor: c.surface,
          ),
        ],
      ),
    ),
  );
}
