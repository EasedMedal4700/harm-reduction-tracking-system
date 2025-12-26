// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Tab for displaying reflections. Uses ActivityCard and ActivityEmptyState.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../models/activity_models.dart';
import 'activity_card.dart';
import 'activity_empty_state.dart';

class ActivityReflectionsTab extends StatelessWidget {
  final List<ActivityReflectionEntry> reflections;
  final void Function(ActivityReflectionEntry) onReflectionTap;
  final Future<void> Function() onRefresh;
  const ActivityReflectionsTab({
    super.key,
    required this.reflections,
    required this.onReflectionTap,
    required this.onRefresh,
  });

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
          final effectivenessLabel = reflection.effectiveness == null
              ? 'N/A'
              : '${reflection.effectiveness}/10';
          final sleepLabel = reflection.sleepHours == null
              ? 'N/A'
              : '${reflection.sleepHours}';
          return ActivityCard(
            title: 'Reflection Entry',
            subtitle:
                'Effectiveness: $effectivenessLabel • $sleepLabel hrs sleep',
            timestamp: reflection.createdAt,
            icon: Icons.self_improvement,
            accentColor: th.accent.secondary,
            onTap: () => onReflectionTap(reflection),
          );
        },
      ),
    );
  }
}
