import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
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
    final t = context.theme;

    if (reflections.isEmpty) {
      return ActivityEmptyState(
        icon: Icons.notes_outlined,
        title: 'No Reflections',
        subtitle: 'Your reflection entries will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.all(t.spacing.lg),
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
            accentColor: t.accent.secondary, // replaces fixed purple
            badge: null,
            onTap: () => onReflectionTap(reflection),
          );
        },
      ),
    );
  }
}
