import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/daily_checkin_provider.dart';
import 'mood_selector.dart';
import 'emotion_selector.dart';
import 'notes_input.dart';

/// Dialog for daily check-in with mood, emotions, and notes
class DailyCheckinDialog extends StatefulWidget {
  const DailyCheckinDialog({super.key});

  @override
  State<DailyCheckinDialog> createState() => _DailyCheckinDialogState();
}

class _DailyCheckinDialogState extends State<DailyCheckinDialog> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _getTimeOfDayLabel(String timeOfDay) {
    switch (timeOfDay) {
      case 'morning':
        return 'Morning Check-In';
      case 'afternoon':
        return 'Afternoon Check-In';
      case 'evening':
        return 'Evening Check-In';
      default:
        return 'Check-In';
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Consumer<DailyCheckinProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        _getTimeIcon(provider.timeOfDay),
                        size: 28,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Check-In',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _getTimeOfDayLabel(provider.timeOfDay),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Mood selection
                  MoodSelector(
                    selectedMood: provider.mood,
                    availableMoods: provider.availableMoods,
                    onMoodSelected: provider.setMood,
                  ),
                  const SizedBox(height: 24),

                  // Emotions selection
                  EmotionSelector(
                    selectedEmotions: provider.emotions,
                    availableEmotions: provider.availableEmotions,
                    onEmotionToggled: provider.toggleEmotion,
                  ),
                  const SizedBox(height: 24),

                  // Notes
                  NotesInput(
                    controller: _notesController,
                    onChanged: provider.setNotes,
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: provider.isSaving
                          ? null
                          : () async {
                              await provider.saveCheckin(context);
                            },
                      icon: provider.isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: Text(provider.isSaving ? 'Saving...' : 'Save Check-In'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
