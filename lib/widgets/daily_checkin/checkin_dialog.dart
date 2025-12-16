
// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Uses some new theme/common, but not fully migrated.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/daily_checkin_provider.dart';
import '../../common/inputs/mood_selector.dart';
import '../../common/inputs/emotion_selector.dart';
import '../../common/inputs/input_field.dart';

import '../../constants/theme/app_theme_extension.dart';

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

                SizedBox(height: spacing.xl),

                // ---------------------------------------------------------------------
                // MOOD SELECTOR
                // ---------------------------------------------------------------------
                MoodSelector(
                  selectedMood: provider.mood,
                  availableMoods: provider.availableMoods,
                  onMoodSelected: provider.setMood,
                ),

                SizedBox(height: spacing.xl),

                // ---------------------------------------------------------------------
                // EMOTION SELECTOR
                // ---------------------------------------------------------------------
                EmotionSelector(
                  selectedEmotions: provider.emotions,
                  availableEmotions: provider.availableEmotions,
                  onEmotionToggled: provider.toggleEmotion,
                ),

                SizedBox(height: spacing.xl),

                // ---------------------------------------------------------------------
                // NOTES INPUT
                // ---------------------------------------------------------------------
                CommonInputField(
                  controller: _notesController,
                  hintText: "Add notes...",
                  maxLines: 4,
                  onChanged: provider.setNotes,
                ),

                SizedBox(height: spacing.xl),

                // ---------------------------------------------------------------------
                // SAVE BUTTON
                // ---------------------------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isSaving
                        ? null
                        : () async => provider.saveCheckin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.accent.primary,
                      foregroundColor: t.colors.textInverse,
                      padding: EdgeInsets.symmetric(vertical: spacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                      ),
                      elevation: 0,
                    ),
                    child: provider.isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Save Check-In",
                            style: t.text.labelLarge.copyWith(
                              color: t.colors.textInverse,
                            ),
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
}

