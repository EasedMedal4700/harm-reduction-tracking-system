import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/old_common/drawer_menu.dart';
import '../widgets/daily_checkin/readonly_field.dart';
import '../widgets/daily_checkin/time_of_day_indicator.dart';
import '../widgets/daily_checkin/existing_checkin_notice.dart';
import '../widgets/daily_checkin/mood_selector.dart';
import '../widgets/daily_checkin/emotion_selector.dart';
import '../widgets/daily_checkin/notes_input.dart';
import '../widgets/daily_checkin/save_button.dart';
import '../providers/daily_checkin_provider.dart';
import '../constants/deprecated/ui_colors.dart';
import '../constants/deprecated/theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? UIColors.darkBackground
        : UIColors.lightBackground;
    final surfaceColor = isDark ? UIColors.darkSurface : UIColors.lightSurface;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Daily Check-In',
          style: TextStyle(
            fontWeight: ThemeConstants.fontBold,
            color: textColor,
          ),
        ),
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
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
      drawer: const DrawerMenu(),
      body: RefreshIndicator(
        onRefresh: () async {
          final provider = context.read<DailyCheckinProvider>();
          await provider.checkExistingCheckin();
        },
        child: Consumer<DailyCheckinProvider>(
          builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(width: ThemeConstants.space16),
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
                const SizedBox(height: ThemeConstants.space24),

                // Time of Day Indicator (Full Width)
                TimeOfDayIndicator(currentTimeOfDay: provider.timeOfDay),
                const SizedBox(height: ThemeConstants.space24),

                // Existing check-in notice
                if (provider.existingCheckin != null) ...[
                  const ExistingCheckinNotice(),
                  const SizedBox(height: ThemeConstants.space24),
                ],

                // Mood Selection
                MoodSelector(
                  selectedMood: provider.mood,
                  availableMoods: provider.availableMoods,
                  onMoodSelected: provider.setMood,
                ),
                const SizedBox(height: ThemeConstants.space32),

                // Emotions Selection
                EmotionSelector(
                  selectedEmotions: provider.emotions,
                  availableEmotions: provider.availableEmotions,
                  onEmotionToggled: provider.toggleEmotion,
                ),
                const SizedBox(height: ThemeConstants.space32),

                // Notes
                NotesInput(
                  controller: _notesController,
                  onChanged: provider.setNotes,
                ),
                const SizedBox(height: ThemeConstants.space32),

                // Save Button
                SaveButton(
                  isSaving: provider.isSaving,
                  isDisabled: provider.existingCheckin != null,
                  onPressed: () => provider.saveCheckin(context),
                ),
                const SizedBox(height: ThemeConstants.space32),
              ],
            ),
          );
        },
        ),
      ),
    );
  }
}
