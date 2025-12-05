import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmotionSelector extends StatefulWidget {
  final List<String> selectedEmotions;
  final List<String> availableEmotions;
  final Function(String) onEmotionToggled;

  const EmotionSelector({
    super.key,
    required this.selectedEmotions,
    required this.availableEmotions,
    required this.onEmotionToggled,
  });

  @override
  State<EmotionSelector> createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector>
    with SingleTickerProviderStateMixin {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedEmotions.toSet();
  }

  @override
  void didUpdateWidget(covariant EmotionSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // keep internal selection in sync if parent changes selection
    if (!listEquals(oldWidget.selectedEmotions, widget.selectedEmotions)) {
      _selected = widget.selectedEmotions.toSet();
    }
  }

  void _toggle(String emotion) {
    setState(() {
      if (_selected.contains(emotion)) {
        _selected.remove(emotion);
      } else {
        _selected.add(emotion);
      }
    });
    widget.onEmotionToggled(emotion);
  }

  Widget _buildChip(String emotion) {
    final isSelected = _selected.contains(emotion);
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: isSelected
            ? LinearGradient(
                colors: [theme.colorScheme.primary.withOpacity(0.14), theme.colorScheme.primary.withOpacity(0.06)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isSelected ? null : theme.cardColor,
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
          width: isSelected ? 1.6 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
      ),
        child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => _toggle(emotion),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
                  ),
                  child: Text(
                    emotion,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emotions',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select up to a few that match how you feel',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // chips area — responsive 3-per-row grid
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 10.0;
              // subtract horizontal padding (container has 16) and some buffer
              final available = constraints.maxWidth;
              final chipWidth = (available - (spacing * 2)) / 3;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: widget.availableEmotions.map((e) {
                  final usedWidth = chipWidth < 100.0 ? 100.0 : chipWidth;
                  return SizedBox(
                    width: usedWidth,
                    child: _buildChip(e),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
