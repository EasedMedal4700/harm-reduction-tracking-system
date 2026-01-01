// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Tab for displaying drug use entries. Uses ActivityCard and ActivityEmptyState. No hardcoded values.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../models/activity_models.dart';
import 'activity_card.dart';
import 'activity_empty_state.dart';

class ActivityDrugUseTab extends StatelessWidget {
  final List<ActivityDrugUseEntry> entries;
  final void Function(ActivityDrugUseEntry) onEntryTap;
  final Future<void> Function() onRefresh;
  const ActivityDrugUseTab({
    super.key,
    required this.entries,
    required this.onEntryTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final sp = context.spacing;
    if (entries.isEmpty) {
      return const ActivityEmptyState(
        icon: Icons.medication_outlined,
        title: 'No Drug Use Records',
        subtitle: 'Your recent drug use entries will appear here',
      );
    }
    return RefreshIndicator(
      color: th.accent.primary,
      backgroundColor: th.colors.surface,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.all(sp.lg),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return ActivityCard(
            title: entry.name,
            subtitle: '${entry.dose} • ${entry.place}',
            timestamp: entry.time,
            icon: Icons.medication,
            // Replaces DrugCategoryColors.stimulant with theme accent
            accentColor: th.accent.primary,
            badge: entry.isMedicalPurpose ? 'Medical' : null,
            onTap: () => onEntryTap(entry),
          );
        },
      ),
    );
  }
}
