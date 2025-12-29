// MIGRATION:
// State: LEGACY
// Navigation: CENTRALIZED
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Daily Checkin using Provider and GoRouter.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../common/layout/common_drawer.dart';
import 'widgets/readonly_field.dart';
import 'widgets/time_of_day_indicator.dart';
import 'widgets/existing_checkin_notice.dart';
import 'widgets/mood_selector.dart';
import 'widgets/emotion_selector.dart';
import 'widgets/notes_input.dart';
import 'widgets/save_button.dart';
import 'providers/daily_checkin_provider.dart';

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
      if (!mounted) return;
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
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
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
              context.push('/checkin-history');
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
          final provider = context.read<DailyCheckinProvider>();
          await provider.checkExistingCheckin();
        },
        child: Consumer<DailyCheckinProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ac.primary),
                ),
              );
            }
            return SingleChildScrollView(
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
                          value:
                              '${provider.selectedDate.year}-${provider.selectedDate.month.toString().padLeft(2, '0')}-${provider.selectedDate.day.toString().padLeft(2, '0')}',
                        ),
                      ),
                      SizedBox(width: sp.lg),
                      Expanded(
                        child: ReadOnlyField(
                          icon: Icons.access_time,
                          label: 'Time',
                          value:
                              '${provider.selectedTime?.hour.toString().padLeft(2, '0')}:${provider.selectedTime?.minute.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sp.xl),
                  // Time of Day Indicator (Full Width)
                  TimeOfDayIndicator(currentTimeOfDay: provider.timeOfDay),
                  SizedBox(height: sp.xl),
                  // Existing check-in notice
                  if (provider.existingCheckin != null) ...[
                    const ExistingCheckinNotice(),
                    SizedBox(height: sp.xl),
                  ],
                  // Mood Selection
                  MoodSelector(
                    selectedMood: provider.mood,
                    availableMoods: provider.availableMoods,
                    onMoodSelected: provider.setMood,
                  ),
                  SizedBox(height: sp.xl2),
                  // Emotions Selection
                  EmotionSelector(
                    selectedEmotions: provider.emotions,
                    availableEmotions: provider.availableEmotions,
                    onEmotionToggled: provider.toggleEmotion,
                  ),
                  SizedBox(height: sp.xl2),
                  // Notes
                  NotesInput(
                    controller: _notesController,
                    onChanged: provider.setNotes,
                  ),
                  SizedBox(height: sp.xl2),
                  // Save Button
                  SaveButton(
                    isSaving: provider.isSaving,
                    isDisabled: provider.existingCheckin != null,
                    onPressed: () => provider.saveCheckin(context),
                  ),
                  SizedBox(height: sp.xl2),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
