// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Uses Riverpod controller; widgets emit intent only.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/layout/common_drawer.dart';
import 'widgets/readonly_field.dart';
import 'widgets/time_of_day_indicator.dart';
import 'widgets/existing_checkin_notice.dart';
import 'widgets/mood_selector.dart';
import 'widgets/emotion_selector.dart';
import 'widgets/notes_input.dart';
import 'widgets/save_button.dart';
import 'providers/daily_checkin_providers.dart';
import 'models/daily_checkin_state.dart';

class DailyCheckinScreen extends ConsumerStatefulWidget {
  const DailyCheckinScreen({super.key});
  @override
  ConsumerState<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends ConsumerState<DailyCheckinScreen> {
  final TextEditingController _notesController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dailyCheckinControllerProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;

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
              backgroundColor: e.isError ? c.error : c.success,
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
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          'Daily Check-In',
          style: th.typography.heading3.copyWith(color: c.textPrimary),
        ),
        backgroundColor: c.surface,
        elevation: th.sizes.elevationNone,
        centerTitle: true,
        iconTheme: IconThemeData(color: c.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              ref.read(dailyCheckinControllerProvider.notifier).openHistory();
            },
            tooltip: 'View History',
          ),
        ],
      ),
      drawer: const CommonDrawer(),
      body: RefreshIndicator(
        color: ac.primary,
        backgroundColor: c.surface,
        onRefresh: () async {
          await ref
              .read(dailyCheckinControllerProvider.notifier)
              .checkExistingCheckin();
        },
        child: state.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ac.primary),
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(sp.lg),
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    // Date & Time (Read-Only)
                    Row(
                      children: [
                        Expanded(
                          child: ReadOnlyField(
                            icon: Icons.calendar_today,
                            label: 'Date',
                            value: state.selectedDate == null
                                ? ''
                                : '${state.selectedDate!.year}-${state.selectedDate!.month.toString().padLeft(2, '0')}-${state.selectedDate!.day.toString().padLeft(2, '0')}',
                          ),
                        ),
                        SizedBox(width: sp.lg),
                        Expanded(
                          child: ReadOnlyField(
                            icon: Icons.access_time,
                            label: 'Time',
                            value: state.selectedTime == null
                                ? ''
                                : '${state.selectedTime!.hour.toString().padLeft(2, '0')}:${state.selectedTime!.minute.toString().padLeft(2, '0')}',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sp.xl),
                    // Time of Day Indicator (Full Width)
                    TimeOfDayIndicator(currentTimeOfDay: state.timeOfDay),
                    SizedBox(height: sp.xl),
                    // Existing check-in notice
                    if (state.existingCheckin != null) ...[
                      const ExistingCheckinNotice(),
                      SizedBox(height: sp.xl),
                    ],
                    // Mood Selection
                    MoodSelector(
                      selectedMood: state.mood,
                      availableMoods: DailyCheckinController.availableMoods,
                      onMoodSelected: ref
                          .read(dailyCheckinControllerProvider.notifier)
                          .setMood,
                    ),
                    SizedBox(height: sp.xl2),
                    // Emotions Selection
                    EmotionSelector(
                      selectedEmotions: state.emotions,
                      availableEmotions:
                          DailyCheckinController.availableEmotions,
                      onEmotionToggled: ref
                          .read(dailyCheckinControllerProvider.notifier)
                          .toggleEmotion,
                    ),
                    SizedBox(height: sp.xl2),
                    // Notes
                    NotesInput(
                      controller: _notesController,
                      onChanged: ref
                          .read(dailyCheckinControllerProvider.notifier)
                          .setNotes,
                    ),
                    SizedBox(height: sp.xl2),
                    // Save Button
                    SaveButton(
                      isSaving: state.isSaving,
                      isDisabled: state.existingCheckin != null,
                      onPressed: () => ref
                          .read(dailyCheckinControllerProvider.notifier)
                          .saveCheckin(),
                    ),
                    SizedBox(height: sp.xl2),
                  ],
                ),
              ),
      ),
    );
  }
}
