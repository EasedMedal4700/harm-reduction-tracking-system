
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';

import '../home_redesign/stat_card.dart';

class HomeProgressStats extends StatelessWidget {
  const HomeProgressStats({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: ThemeConstants.cardSpacing,
      mainAxisSpacing: ThemeConstants.cardSpacing,
      childAspectRatio: 2.5,
      children: const [
        StatCard(
          icon: Icons.calendar_today,
          value: '127',
          label: 'Days Tracked',
          subtitle: 'Keep up the momentum!',
        ),
        StatCard(
          icon: Icons.note_alt,
          value: '12',
          label: 'Entries This Week',
          subtitle: '+3 from last week',
        ),
        StatCard(
          icon: Icons.psychology,
          value: '8',
          label: 'Active Reflections',
          subtitle: 'Recent insights',
          progress: 0.65,
        ),
      ],
    );
  }
}
