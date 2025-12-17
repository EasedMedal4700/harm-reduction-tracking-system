// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: COMPLETE
// Notes: Initial migration header added. Some theme/common usage, Riverpod ready.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

/// Riverpod-ready Save Button
/// Accepts callback instead of state
class SaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const SaveButton({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.theme;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(
          top: BorderSide(
            color: c.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.accent.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: sp.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sh.radiusMd),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save),
            SizedBox(width: sp.sm),
            Text(
              'Save Changes',
              style: t.text.button,
            ),
          ],
        ),
      ),
    );
  }
}

