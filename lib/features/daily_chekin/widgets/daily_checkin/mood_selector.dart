// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and AppTheme. Kept custom slider logic.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/enums/app_mood.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../constants/theme/app_color_palette.dart';
import '../../../../constants/theme/app_accent_colors.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

/// Widget for selecting mood from available options
class MoodSelector extends StatefulWidget {
  final String? selectedMood;
  final List<String> availableMoods;
  final Function(String) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.availableMoods,
    required this.onMoodSelected,
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: context.animations.normal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
    _scaleController.forward();
  }

  @override
  void didUpdateWidget(covariant MoodSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMood != widget.selectedMood) {
      _scaleController.reset();
      _scaleController.forward();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Color _getThumbColor(double value, ColorPalette c, AccentColors a) {
    final moodIndex = (value - 1).toInt();
    final moods = ['Poor', 'Struggling', 'Neutral', 'Good', 'Great'];
    final mood = moods[moodIndex];
    switch (mood) {
      case 'Poor':
        return c.error;
      case 'Struggling':
        return c.warning;
      case 'Neutral':
        return c.textSecondary;
      case 'Good':
        return c.success;
      case 'Great':
        return a.primary;
      default:
        return c.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final text = context.text;
    final sp = context.spacing;

    // Reverse mapping: first mood ('Poor') -> 1.0 (left), last mood ('Great') -> max (right)
    final moodToValue = {
      for (int i = 0; i < widget.availableMoods.length; i++)
        widget.availableMoods[i]: (widget.availableMoods.length - i).toDouble(),
    };

    final valueToMood = {
      for (int i = 0; i < widget.availableMoods.length; i++)
        (widget.availableMoods.length - i).toDouble(): widget.availableMoods[i],
    };

    // Get current slider value (default to first mood if none selected)
    final currentValue = widget.selectedMood != null
        ? moodToValue[widget.selectedMood]!
        : 1.0;

    final selectedMoodIndex = (currentValue - 1).toInt();

    return CommonCard(
      padding: EdgeInsets.all(sp.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentCenter,
        children: [
          Text(
            'How are you feeling?',
            style: text.heading4,
            textAlign: AppLayout.textAlignCenter,
          ),
          const CommonSpacer.vertical(16),
          // Emojis above slider (Poor to Great)
          Row(
            mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
            children: List.generate(5, (index) {
              final isSelected = index == selectedMoodIndex;
              final emoji = ['😞', '😕', '😐', '🙂', '😄'][index];
              return GestureDetector(
                onTap: () {
                  widget.onMoodSelected(
                    ['Poor', 'Struggling', 'Neutral', 'Good', 'Great'][index],
                  );
                },
                child: AnimatedBuilder(
                  animation: _scaleController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isSelected ? _scaleAnimation.value : 1.0,
                      child: Opacity(
                        opacity: isSelected ? _fadeAnimation.value : 0.7,
                        child: Text(
                          emoji,
                          style: TextStyle(
                            fontSize: t.typography.displaySmall.fontSize,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          const CommonSpacer.vertical(8),
          // Slider with custom theme
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6.0, // Thicker track
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
              activeTrackColor: _getThumbColor(currentValue, c, a),
              inactiveTrackColor: c.border,
              thumbColor: _getThumbColor(currentValue, c, a),
              overlayColor: _getThumbColor(
                currentValue,
                c,
                a,
              ).withValues(alpha: 0.2),
            ),
            child: Slider(
              value: currentValue,
              min: 1.0,
              max: widget.availableMoods.length.toDouble(),
              divisions: widget.availableMoods.length - 1,
              label: widget.selectedMood != null
                  ? '${moodEmojis[widget.selectedMood]} ${widget.selectedMood}'
                  : '${moodEmojis[widget.availableMoods.last]} ${widget.availableMoods.last}',
              onChanged: (value) {
                final mood = valueToMood[value]!;
                widget.onMoodSelected(mood);
              },
            ),
          ),
          const CommonSpacer.vertical(8),
          // Text labels below (Poor to Great)
          Row(
            mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
            children: ['Poor', 'Struggling', 'Neutral', 'Good', 'Great']
                .map(
                  (label) => Text(
                    label,
                    style: text.bodySmall.copyWith(
                      fontWeight: text.body.fontWeight,
                    ),
                    textAlign: AppLayout.textAlignCenter,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
