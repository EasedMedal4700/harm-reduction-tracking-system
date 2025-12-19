
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to use local widgets which are now standardized.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/daily_checkin_provider.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

// Local widgets
import 'mood_selector.dart';
import 'emotion_selector.dart';
import 'notes_input.dart';
import 'save_button.dart';

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

  String _getTimeLabel(String time) {
    switch (time) {
      case "morning":
        return "Morning Check-In";
      case "afternoon":
        return "Afternoon Check-In";
      case "evening":
        return "Evening Check-In";
      default:
        return "Daily Check-In";
    }
  }

  IconData _getTimeIcon(String time) {
    switch (time) {
      case "morning":
        return Icons.wb_sunny_rounded;
      case "afternoon":
        return Icons.wb_cloudy_rounded;
      case "evening":
        return Icons.nightlight_round_rounded;
      default:
        return Icons.mood;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final spacing = t.spacing;

    return Dialog(
      backgroundColor: t.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(t.shapes.radiusLg),
      ),
      elevation: 0,
      child: Consumer<DailyCheckinProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(spacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ---------------------------------------------------------------------
                // HEADER
                // ---------------------------------------------------------------------
                Row(
                  children: [
                    Icon(
                      _getTimeIcon(provider.timeOfDay),
                      size: 32,
                      color:  t.accent.primary,
                    ),

                    SizedBox(width: spacing.md),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily Check-In",
                            style: t.text.heading3.copyWith(
                              color: t.colors.textPrimary,
                            ),
                          ),
                          Text(
                            _getTimeLabel(provider.timeOfDay),
                            style: t.typography.bodySmall.copyWith(
                              color: t.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: Icon(Icons.close, color: t.colors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const CommonSpacer.vertical(24),

                // ---------------------------------------------------------------------
                // MOOD SELECTOR
                // ---------------------------------------------------------------------
                MoodSelector(
                  selectedMood: provider.mood,
                  availableMoods: provider.availableMoods,
                  onMoodSelected: provider.setMood,
                ),

                const CommonSpacer.vertical(24),

                // ---------------------------------------------------------------------
                // EMOTION SELECTOR
                // ---------------------------------------------------------------------
                EmotionSelector(
                  selectedEmotions: provider.emotions,
                  availableEmotions: provider.availableEmotions,
                  onEmotionToggled: provider.toggleEmotion,
                ),

                const CommonSpacer.vertical(24),

                // ---------------------------------------------------------------------
                // NOTES INPUT
                // ---------------------------------------------------------------------
                NotesInput(
                  controller: _notesController,
                  onChanged: provider.setNotes,
                ),

                const CommonSpacer.vertical(24),

                // ---------------------------------------------------------------------
                // SAVE BUTTON
                // ---------------------------------------------------------------------
                SaveButton(
                  isSaving: provider.isSaving,
                  isDisabled: false, // Logic was implicit in button before, now explicit
                  onPressed: () async => provider.saveCheckin(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

