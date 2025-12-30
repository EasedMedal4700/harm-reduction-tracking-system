// MIGRATION:
// State: MODERN (UI-only)
// Navigation: CENTRALIZED
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI-only dialog; state via DailyCheckinController.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
// Local widgets
import 'mood_selector.dart';
import 'emotion_selector.dart';
import 'notes_input.dart';
import 'save_button.dart';
import '../providers/daily_checkin_providers.dart';
import '../models/daily_checkin_state.dart';

class DailyCheckinDialog extends ConsumerStatefulWidget {
  const DailyCheckinDialog({super.key});
  @override
  ConsumerState<DailyCheckinDialog> createState() => _DailyCheckinDialogState();
}

class _DailyCheckinDialogState extends ConsumerState<DailyCheckinDialog> {
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
    final th = context.theme;
    final spacing = th.spacing;

    ref.listen(dailyCheckinControllerProvider.select((s) => s.notes), (
      previous,
      next,
    ) {
      if (_notesController.text == next) return;
      _notesController.text = next;
    });

    ref.listen(dailyCheckinControllerProvider, (previous, next) {
      final event = next.uiEvent;
      event.map(
        snackbar: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
              backgroundColor: e.isError ? th.colors.error : th.colors.success,
              duration: context.animations.toast,
            ),
          );
          ref.read(dailyCheckinControllerProvider.notifier).clearUiEvent();
        },
        close: (_) {
          ref.read(dailyCheckinControllerProvider.notifier).clearUiEvent();
        },
        none: (_) {},
      );
    });

    final state = ref.watch(dailyCheckinControllerProvider);
    return Dialog(
      backgroundColor: th.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(th.shapes.radiusLg),
      ),
      elevation: th.sizes.elevationNone,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          children: [
            // ---------------------------------------------------------------------
            // HEADER
            // ---------------------------------------------------------------------
            Row(
              children: [
                Icon(
                  _getTimeIcon(state.timeOfDay),
                  size: th.sizes.iconLg,
                  color: th.accent.primary,
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                    children: [
                      Text(
                        "Daily Check-In",
                        style: th.tx.heading3.copyWith(
                          color: th.colors.textPrimary,
                        ),
                      ),
                      Text(
                        _getTimeLabel(state.timeOfDay),
                        style: th.typography.bodySmall.copyWith(
                          color: th.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: th.colors.textSecondary),
                  onPressed: () =>
                      ref.read(dailyCheckinControllerProvider.notifier).close(),
                ),
              ],
            ),
            CommonSpacer.vertical(spacing.xl),
            // ---------------------------------------------------------------------
            // MOOD SELECTOR
            // ---------------------------------------------------------------------
            MoodSelector(
              selectedMood: state.mood,
              availableMoods: DailyCheckinController.availableMoods,
              onMoodSelected: ref
                  .read(dailyCheckinControllerProvider.notifier)
                  .setMood,
            ),
            CommonSpacer.vertical(spacing.xl),
            // ---------------------------------------------------------------------
            // EMOTION SELECTOR
            // ---------------------------------------------------------------------
            EmotionSelector(
              selectedEmotions: state.emotions,
              availableEmotions: DailyCheckinController.availableEmotions,
              onEmotionToggled: ref
                  .read(dailyCheckinControllerProvider.notifier)
                  .toggleEmotion,
            ),
            CommonSpacer.vertical(spacing.xl),
            // ---------------------------------------------------------------------
            // NOTES INPUT
            // ---------------------------------------------------------------------
            NotesInput(
              controller: _notesController,
              onChanged: ref
                  .read(dailyCheckinControllerProvider.notifier)
                  .setNotes,
            ),
            CommonSpacer.vertical(spacing.xl),
            // ---------------------------------------------------------------------
            // SAVE BUTTON
            // ---------------------------------------------------------------------
            SaveButton(
              isSaving: state.isSaving,
              isDisabled: state.existingCheckin != null,
              onPressed: () async => ref
                  .read(dailyCheckinControllerProvider.notifier)
                  .saveCheckin(),
            ),
          ],
        ),
      ),
    );
  }
}
