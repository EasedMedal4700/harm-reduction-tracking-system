// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to use CommonStatCard and AppTheme. Replaced GridView with Column to avoid magic aspect ratio.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import '../../../../common/cards/common_stat_card.dart';
import '../../../../common/layout/common_spacer.dart';

class HomeProgressStats extends StatelessWidget {
  const HomeProgressStats({super.key});
  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    return Column(
      children: [
        const CommonStatCard(
          icon: Icons.calendar_today,
          value: '127',
          title: 'Days Tracked',
          subtitle: 'Keep up the momentum!',
        ),
        CommonSpacer.vertical(sp.md),
        const CommonStatCard(
          icon: Icons.note_alt,
          value: '12',
          title: 'Entries This Week',
          subtitle: '+3 from last week',
        ),
        CommonSpacer.vertical(sp.md),
        const CommonStatCard(
          icon: Icons.psychology,
          value: '8',
          title: 'Active Reflections',
          subtitle: 'Recent insights',
        ),
      ],
    );
  }
}
