import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/daily_checkin_provider.dart';

class DailyCheckinScreen extends StatefulWidget {
  const DailyCheckinScreen({super.key});

  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DailyCheckinProvider>();
      provider.initialize();
      provider.checkExistingCheckin();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-In'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/checkin-history');
            },
            tooltip: 'View History',
          ),
        ],
      ),
      body: Consumer<DailyCheckinProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date selector
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date'),
                    subtitle: Text(
                      '${provider.selectedDate.year}-${provider.selectedDate.month.toString().padLeft(2, '0')}-${provider.selectedDate.day.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: provider.selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        provider.setSelectedDate(date);
                        provider.checkExistingCheckin();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Time of day selection
                const Text(
                  'Time of Day',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'morning',
                      label: Text('Morning'),
                      icon: Icon(Icons.wb_sunny),
                    ),
                    ButtonSegment(
                      value: 'afternoon',
                      label: Text('Midday'),
                      icon: Icon(Icons.wb_cloudy),
                    ),
                    ButtonSegment(
                      value: 'evening',
                      label: Text('Evening'),
                      icon: Icon(Icons.nightlight_round),
                    ),
                  ],
                  selected: {provider.timeOfDay},
                  onSelectionChanged: (Set<String> newSelection) {
                    provider.setTimeOfDay(newSelection.first);
                    provider.checkExistingCheckin();
                  },
                ),
                const SizedBox(height: 24),

                // Existing check-in notice
                if (provider.existingCheckin != null)
                  Card(
                    color: Colors.blue.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You already have a check-in for this time. Your changes will update it.',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (provider.existingCheckin != null) const SizedBox(height: 16),

                // Mood selection
                const Text(
                  'How are you feeling overall?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: provider.availableMoods.map((mood) {
                    final isSelected = provider.mood == mood;
                    return ChoiceChip(
                      label: Text(mood),
                      selected: isSelected,
                      onSelected: (_) => provider.setMood(mood),
                      selectedColor: _getMoodColor(mood),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Emotions selection
                const Text(
                  'Select your emotions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: provider.availableEmotions.map((emotion) {
                    final isSelected = provider.emotions.contains(emotion);
                    return FilterChip(
                      label: Text(emotion),
                      selected: isSelected,
                      onSelected: (_) => provider.toggleEmotion(emotion),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Notes
                const Text(
                  'Notes (optional)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'How was your day? Any thoughts or observations?',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: provider.setNotes,
                ),
                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: provider.isSaving
                        ? null
                        : () => provider.saveCheckin(context),
                    icon: provider.isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      provider.isSaving
                          ? 'Saving...'
                          : provider.existingCheckin != null
                              ? 'Update Check-In'
                              : 'Save Check-In',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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
