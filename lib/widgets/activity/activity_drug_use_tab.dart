import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../constants/drug_theme.dart';
import 'activity_card.dart';
import 'activity_empty_state.dart';

class ActivityDrugUseTab extends StatelessWidget {
  final List entries;
  final bool isDark;
  final Function(Map<String, dynamic>) onEntryTap;
  final Future<void> Function() onRefresh;

  const ActivityDrugUseTab({
    super.key,
    required this.entries,
    required this.isDark,
    required this.onEntryTap,
    required this.onRefresh,
  });

  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is DateTime) return timestamp;
    try {
      return DateTime.parse(timestamp.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return ActivityEmptyState(
        icon: Icons.medication_outlined,
        title: 'No Drug Use Records',
        subtitle: 'Your recent drug use entries will appear here',
        isDark: isDark,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(ThemeConstants.space16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final timestamp = _parseTimestamp(entry['start_time'] ?? entry['time']);
          
          return ActivityCard(
            title: entry['name'] ?? 'Unknown Substance',
            subtitle: '${entry['dose'] ?? 'Unknown dose'} • ${entry['place'] ?? 'No location'}',
            timestamp: timestamp,
            icon: Icons.medication,
            accentColor: DrugCategoryColors.stimulant,
            badge: entry['is_medical_purpose'] == true ? 'Medical' : null,
            onTap: () => onEntryTap(entry),
          );
        },
      ),
    );
  }
}
