
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Review for theme/context migration if needed.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final acc = context.accent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: isSelected
            ? LinearGradient(
                colors: [acc.primary.withValues(alpha: 0.14), acc.primary.withValues(alpha: 0.06)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isSelected ? null : c.surface,
        border: Border.all(
          color: isSelected ? acc.primary : c.border,
          width: isSelected ? 1.6 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: acc.primary.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ]
            : t.cardShadow,
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
                    color: isSelected ? acc.primary : c.textPrimary.withValues(alpha: 0.9),
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
                  color: acc.primary,
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
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      padding: EdgeInsets.all(sp.md),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: Border.all(color: c.border),
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
                      style: t.text.heading3.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select up to a few that match how you feel',
                      style: t.text.bodySmall.copyWith(color: t.colors.textSecondary.withValues(alpha: 0.8)),
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
