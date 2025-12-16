import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';



class ExistingCheckinNotice extends StatelessWidget {
  const ExistingCheckinNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          sh.radiusMd,
        ),
        border: Border.all(color: c.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: c.error,
            size: 20,
          ),
          SizedBox(width: sp.md),
          Expanded(
            child: Text(
              'Check-in already exists for this time.',
              style: text.bodyBold.copyWith(
                color: c.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


