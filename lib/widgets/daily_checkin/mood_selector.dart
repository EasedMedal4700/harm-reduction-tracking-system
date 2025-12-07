import 'package:flutter/material.dart';
import '../../constants/emus/app_mood.dart';  // Import the new constants file

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

class _MoodSelectorState extends State<MoodSelector> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
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

  Color _getThumbColor(double value) {
    final moodIndex = (value - 1).toInt();
    final moods = ['Poor', 'Struggling', 'Neutral', 'Good', 'Great'];
    final mood = moods[moodIndex];
    switch (mood) {
      case 'Poor':
        return const Color(0xFFFF6B6B);
      case 'Struggling':
        return const Color(0xFFF0A04B);
      case 'Neutral':
        return const Color(0xFFCCCCCC);
      case 'Good':
        return const Color(0xFF6BCB77);
      case 'Great':
        return const Color(0xFF4ECDC4);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reverse mapping: first mood ('Poor') -> 1.0 (left), last mood ('Great') -> max (right)
    final moodToValue = {
      for (int i = 0; i < widget.availableMoods.length; i++)
        widget.availableMoods[i]: (widget.availableMoods.length - i).toDouble()
    };

    final valueToMood = {
      for (int i = 0; i < widget.availableMoods.length; i++)
        (widget.availableMoods.length - i).toDouble(): widget.availableMoods[i]
    };

    // Get current slider value (default to first mood if none selected)
    final currentValue =
        widget.selectedMood != null ? moodToValue[widget.selectedMood]! : 1.0;

    final selectedMoodIndex = (currentValue - 1).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Emojis above slider (Poor to Great)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final isSelected = index == selectedMoodIndex;
            final emoji = ['😞', '😕', '😐', '🙂', '😄'][index];
            return GestureDetector(
              onTap: () {
                widget.onMoodSelected(['Poor', 'Struggling', 'Neutral', 'Good', 'Great'][index]);
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
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // Slider with custom theme
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6.0, // Thicker track
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            activeTrackColor: _getThumbColor(currentValue),
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: _getThumbColor(currentValue),
            overlayColor: _getThumbColor(currentValue).withOpacity(0.2),
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
        const SizedBox(height: 8),
        // Text labels below (Poor to Great)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Poor', 'Struggling', 'Neutral', 'Good', 'Great']
              .map((label) => Text(
                    label,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
