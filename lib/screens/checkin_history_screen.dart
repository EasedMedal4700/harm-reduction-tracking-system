import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/daily_checkin_provider.dart';
import '../models/daily_checkin_model.dart';

class CheckinHistoryScreen extends StatefulWidget {
  const CheckinHistoryScreen({super.key});

  @override
  State<CheckinHistoryScreen> createState() => _CheckinHistoryScreenState();
}

class _CheckinHistoryScreenState extends State<CheckinHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyCheckinProvider>().loadRecentCheckins();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In History'),
      ),
      body: Consumer<DailyCheckinProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.recentCheckins.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No check-ins yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start tracking your daily mood!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.recentCheckins.length,
            itemBuilder: (context, index) {
              final checkin = provider.recentCheckins[index];
              return _CheckinCard(checkin: checkin);
            },
          );
        },
      ),
    );
  }
}

class _CheckinCard extends StatelessWidget {
  final DailyCheckin checkin;

  const _CheckinCard({required this.checkin});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and time of day
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(_getTimeIcon(checkin.timeOfDay), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(checkin.checkinDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    checkin.timeOfDay.toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Mood
            Row(
              children: [
                const Text(
                  'Mood: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getMoodColor(checkin.mood),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    checkin.mood,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Emotions
            if (checkin.emotions.isNotEmpty) ...[
              const Text(
                'Emotions:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: checkin.emotions.map((emotion) {
                  return Chip(
                    label: Text(emotion, style: const TextStyle(fontSize: 12)),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],

            // Notes
            if (checkin.notes != null && checkin.notes!.isNotEmpty) ...[
              const Text(
                'Notes:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                checkin.notes!,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkinDate = DateTime(date.year, date.month, date.day);

    if (checkinDate == today) {
      return 'Today';
    } else if (checkinDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  IconData _getTimeIcon(String timeOfDay) {
    switch (timeOfDay) {
      case 'morning':
        return Icons.wb_sunny;
      case 'afternoon':
        return Icons.wb_cloudy;
      case 'evening':
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Great':
        return Colors.green.shade200;
      case 'Good':
        return Colors.lightGreen.shade200;
      case 'Okay':
        return Colors.yellow.shade200;
      case 'Struggling':
        return Colors.orange.shade200;
      case 'Poor':
        return Colors.red.shade200;
      default:
        return Colors.grey.shade200;
    }
  }
}
