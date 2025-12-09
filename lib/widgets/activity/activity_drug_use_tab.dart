// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Fully theme-compliant. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'activity_card.dart';
import 'activity_empty_state.dart';

class ActivityDrugUseTab extends StatelessWidget {
  final List entries;
  final Function(Map<String, dynamic>) onEntryTap;
  final Future<void> Function() onRefresh;

  const ActivityDrugUseTab({
    super.key,
    required this.entries,
    required this.onEntryTap,
    required this.onRefresh,
  });

  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is DateTime) return timestamp;

    try {
      return DateTime.parse(timestamp.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;

    if (entries.isEmpty) {
      return const ActivityEmptyState(
        icon: Icons.medication_outlined,
        title: 'No Drug Use Records',
        subtitle: 'Your recent drug use entries will appear here',
      );
    }

    return RefreshIndicator(
      color: t.accent.primary,
      backgroundColor: t.colors.surface,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.all(sp.lg),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final timestamp =
              _parseTimestamp(entry['start_time'] ?? entry['time']);

          return ActivityCard(
            title: entry['name'] ?? 'Unknown Substance',
            subtitle:
                '${entry['dose'] ?? 'Unknown dose'} • ${entry['place'] ?? 'No location'}',
            timestamp: timestamp,
            icon: Icons.medication,
            // Replaces DrugCategoryColors.stimulant with theme accent
            accentColor: t.accent.primary,
            badge: entry['is_medical_purpose'] == true ? 'Medical' : null,
            onTap: () => onEntryTap(entry),
          );
        },
      ),
    );
  }
}
