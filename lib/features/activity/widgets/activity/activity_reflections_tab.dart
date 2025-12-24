// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Tab for displaying reflections. Uses ActivityCard and ActivityEmptyState.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'activity_card.dart';
import 'activity_empty_state.dart';

class ActivityReflectionsTab extends StatelessWidget {
  final List reflections;
  final Function(Map<String, dynamic>) onReflectionTap;
  final Future<void> Function() onRefresh;
  const ActivityReflectionsTab({
    super.key,
    required this.reflections,
    required this.onReflectionTap,
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
    final th = context.theme;
    final sp = context.spacing;
    if (reflections.isEmpty) {
      return const ActivityEmptyState(
        icon: Icons.notes_outlined,
        title: 'No Reflections',
        subtitle: 'Your reflection entries will appear here',
      );
    }
    return RefreshIndicator(
      color: th.accent.secondary,
      backgroundColor: th.colors.surface,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.all(sp.lg),
        itemCount: reflections.length,
        itemBuilder: (context, index) {
          final reflection = reflections[index];
          final timestamp = _parseTimestamp(reflection['created_at']);
          final effectiveness = reflection['effectiveness'] ?? 0;
          return ActivityCard(
            title: 'Reflection Entry',
            subtitle:
                'Effectiveness: $effectiveness/10 • ${reflection['sleep_hours'] ?? 'N/A'} hrs sleep',
            timestamp: timestamp,
            icon: Icons.self_improvement,
            accentColor: th.accent.secondary,
            onTap: () => onReflectionTap(reflection),
          );
        },
      ),
    );
  }
}
