import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/tolerance_model.dart';

/// Card displaying a list of recent substance use events
class RecentUsesCard extends StatelessWidget {
  final List<UseEvent> useEvents;
  final String? substanceName;

  const RecentUsesCard({
    required this.useEvents,
    this.substanceName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (useEvents.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            substanceName != null
                ? 'No recent use events recorded for $substanceName.'
                : 'No recent use events recorded.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final recentEvents = useEvents.take(5).toList();
    final formatter = DateFormat('MMM d · HH:mm');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent use events', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...recentEvents.map(
              (event) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(formatter.format(event.timestamp)),
                subtitle: Text('${event.dose.toStringAsFixed(1)} units'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
