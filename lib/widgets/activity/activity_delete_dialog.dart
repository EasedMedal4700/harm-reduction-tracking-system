// MIGRATION — Clean, theme-compliant version

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class ActivityDeleteDialog extends StatelessWidget {
  final String entryType;

  const ActivityDeleteDialog({
    super.key,
    required this.entryType,
  });

  static Future<bool> show(BuildContext context, String entryType) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ActivityDeleteDialog(entryType: entryType),
    );

    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final t = context.theme;

    return AlertDialog(
      backgroundColor: c.surface,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sh.radiusMd),
        side: BorderSide(color: c.border),
      ),

      title: Text(
        'Delete Entry?',
        style: text.heading3.copyWith(color: c.text),
      ),

      content: Text(
        'Are you sure you want to delete this $entryType entry? This action cannot be undone.',
        style: text.body.copyWith(color: c.textSecondary),
      ),

      actions: [
        // Cancel Button
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: text.body.copyWith(color: c.text),
          ),
        ),

        // Delete Button
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: c.error,
            foregroundColor: c.onError,
            padding: EdgeInsets.symmetric(
              horizontal: sp.lg,
              vertical: sp.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sh.radiusSm),
            ),
            shadowColor: c.overlayHeavy,
            elevation: 4,
          ),
          child: Text(
            'Delete',
            style: text.body.copyWith(
              fontWeight: FontWeight.w600,
              color: c.onError,
            ),
          ),
        ),
      ],
    );
  }
}
