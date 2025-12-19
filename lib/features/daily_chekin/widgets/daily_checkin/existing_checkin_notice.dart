import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard.
import 'package:flutter/material.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

class ExistingCheckinNotice extends StatelessWidget {
  const ExistingCheckinNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;

    return CommonCard(
      padding: EdgeInsets.all(sp.md),
      backgroundColor: c.error.withValues(alpha: 0.1),
      borderColor: c.error.withValues(alpha: 0.3),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: c.error,
            size: 20,
          ),
          const CommonSpacer.horizontal(16),
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


