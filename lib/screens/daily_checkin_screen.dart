import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/daily_checkin_provider.dart';
import '../constants/ui_colors.dart';
import '../constants/theme_constants.dart';

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
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

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
      body: Consumer<DailyCheckinProvider>(
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
                      child: _buildReadOnlyField(
                        context,
                        icon: Icons.calendar_today,
                        label: 'Date',
                        value:
                            '${provider.selectedDate.year}-${provider.selectedDate.month.toString().padLeft(2, '0')}-${provider.selectedDate.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                    const SizedBox(width: ThemeConstants.space16),
                    Expanded(
                      child: _buildReadOnlyField(
                        context,
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
                _buildTimeOfDayIndicator(context, provider.timeOfDay),
                const SizedBox(height: ThemeConstants.space24),

                // Existing check-in notice
                if (provider.existingCheckin != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ThemeConstants.radiusMedium,
                      ),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Check-in already exists for this time.',
                            style: TextStyle(
                              color: Colors.red[300],
                              fontWeight: FontWeight.bold,
                              fontSize: ThemeConstants.fontSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (provider.existingCheckin != null)
                  const SizedBox(height: ThemeConstants.space24),

                // Mood Selection
                Text(
                  'How are you feeling?',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontLarge,
                    fontWeight: ThemeConstants.fontBold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: ThemeConstants.space16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: provider.availableMoods.map((mood) {
                    final isSelected = provider.mood == mood;
                    return _buildMoodChip(
                      context,
                      mood,
                      isSelected,
                      () => provider.setMood(mood),
                    );
                  }).toList(),
                ),
                const SizedBox(height: ThemeConstants.space32),

                // Emotions Selection
                Text(
                  'Emotions',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontLarge,
                    fontWeight: ThemeConstants.fontBold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: ThemeConstants.space16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: provider.availableEmotions.map((emotion) {
                    final isSelected = provider.emotions.contains(emotion);
                    return _buildEmotionChip(
                      context,
                      emotion,
                      isSelected,
                      () => provider.toggleEmotion(emotion),
                    );
                  }).toList(),
                ),
                const SizedBox(height: ThemeConstants.space32),

                // Notes
                Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontLarge,
                    fontWeight: ThemeConstants.fontBold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: ThemeConstants.space8),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Any thoughts or observations?',
                    hintStyle: TextStyle(
                      color: secondaryTextColor.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: isDark ? UIColors.darkSurface : Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ThemeConstants.radiusMedium,
                      ),
                      borderSide: BorderSide(
                        color: isDark
                            ? UIColors.darkBorder
                            : UIColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ThemeConstants.radiusMedium,
                      ),
                      borderSide: BorderSide(
                        color: isDark
                            ? UIColors.darkBorder
                            : UIColors.lightBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ThemeConstants.radiusMedium,
                      ),
                      borderSide: BorderSide(
                        color: isDark
                            ? UIColors.darkNeonCyan
                            : UIColors.lightAccentBlue,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onChanged: provider.setNotes,
                ),
                const SizedBox(height: ThemeConstants.space32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        provider.isSaving || provider.existingCheckin != null
                        ? null
                        : () => provider.saveCheckin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? UIColors.darkNeonCyan
                          : UIColors.lightAccentBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ThemeConstants.radiusLarge,
                        ),
                      ),
                      disabledBackgroundColor: isDark
                          ? Colors.white10
                          : Colors.grey[300],
                    ),
                    child: provider.isSaving
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Save Check-In',
                            style: TextStyle(
                              fontSize: ThemeConstants.fontMedium,
                              fontWeight: ThemeConstants.fontBold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: ThemeConstants.space32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReadOnlyField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? UIColors.darkBorder : UIColors.lightBorder;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final labelColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: labelColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontMediumWeight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOfDayIndicator(
    BuildContext context,
    String currentTimeOfDay,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? UIColors.darkBorder : UIColors.lightBorder;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _buildTimeSegment(context, 'Morning', currentTimeOfDay == 'morning'),
          Container(width: 1, color: borderColor),
          _buildTimeSegment(
            context,
            'Afternoon',
            currentTimeOfDay == 'afternoon',
          ),
          Container(width: 1, color: borderColor),
          _buildTimeSegment(context, 'Evening', currentTimeOfDay == 'evening'),
        ],
      ),
    );
  }

  Widget _buildTimeSegment(BuildContext context, String label, bool isActive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark
        ? UIColors.darkNeonCyan
        : UIColors.lightAccentBlue;
    final inactiveTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: isActive
            ? BoxDecoration(color: activeColor.withOpacity(0.15))
            : null,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : inactiveTextColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: ThemeConstants.fontSmall,
          ),
        ),
      ),
    );
  }

  Widget _buildMoodChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark
        ? UIColors.darkNeonCyan
        : UIColors.lightAccentBlue;
    final inactiveBorder = isDark ? UIColors.darkBorder.withValues(alpha: 0.3) : UIColors.lightBorder;
    final inactiveBg = isDark ? UIColors.darkSurface : Colors.grey.shade50;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      activeColor.withValues(alpha: 0.25),
                      activeColor.withValues(alpha: 0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : inactiveBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? activeColor : inactiveBorder,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected && isDark
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : isSelected
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: ThemeConstants.fontMedium,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark
        ? UIColors.darkNeonPurple
        : UIColors.lightAccentPurple;
    final inactiveBorder = isDark ? UIColors.darkBorder.withValues(alpha: 0.3) : UIColors.lightBorder;
    final inactiveBg = isDark ? UIColors.darkSurface : Colors.grey.shade50;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      activeColor.withValues(alpha: 0.25),
                      activeColor.withValues(alpha: 0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : inactiveBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? activeColor : inactiveBorder,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected && isDark
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.check_circle,
                    size: 16,
                    color: activeColor,
                  ),
                ),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? activeColor : textColor,
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
