import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/daily_checkin_provider.dart';
import '../daily_checkin/checkin_dialog.dart';

/// Banner widget that displays daily check-in status and prompts
class DailyCheckinBanner extends StatefulWidget {
  const DailyCheckinBanner({super.key});

  @override
  State<DailyCheckinBanner> createState() => _DailyCheckinBannerState();
}

class _DailyCheckinBannerState extends State<DailyCheckinBanner> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<DailyCheckinProvider>();
      provider.initialize();
      provider.checkExistingCheckin();
    });
  }

  String _getTimeOfDayGreeting(String timeOfDay) {
    switch (timeOfDay) {
      case 'morning':
        return 'Good Morning';
      case 'afternoon':
        return 'Good Afternoon';
      case 'evening':
        return 'Good Evening';
      default:
        return 'Hello';
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
        return Icons.mood;
    }
  }

  void _showCheckinDialog(BuildContext context, DailyCheckinProvider provider) {
    showDialog(
      context: context,
      builder: (dialogContext) => ChangeNotifierProvider.value(
        value: provider,
        child: const DailyCheckinDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DailyCheckinProvider>(
      builder: (context, provider, child) {
        final hasCheckedIn = provider.existingCheckin != null;
        
        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasCheckedIn
                    ? [Colors.green.shade100, Colors.green.shade50]
                    : [Colors.blue.shade100, Colors.blue.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with icon and title
                Row(
                  children: [
                    Icon(
                      _getTimeIcon(provider.timeOfDay),
                      size: 32,
                      color: hasCheckedIn ? Colors.green.shade700 : Colors.blue.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Check-In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: hasCheckedIn ? Colors.green.shade900 : Colors.blue.shade900,
                            ),
                          ),
                          Text(
                            _getTimeOfDayGreeting(provider.timeOfDay),
                            style: TextStyle(
                              fontSize: 14,
                              color: hasCheckedIn ? Colors.green.shade700 : Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Content based on check-in status
                if (hasCheckedIn) 
                  _buildCheckedInContent(provider)
                else 
                  _buildPromptContent(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckedInContent(DailyCheckinProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'You\'ve already checked in for ${provider.timeOfDay}. Great job tracking your wellness!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Mood: ${provider.existingCheckin!.mood}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.green.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildPromptContent(BuildContext context, DailyCheckinProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling today?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Track your wellness throughout the day.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showCheckinDialog(context, provider),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Check-In Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
