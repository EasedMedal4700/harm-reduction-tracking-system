// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to new AppTheme system. All deprecated UIColors/ThemeConstants removed.
// Uses context.theme, context.colors, context.text, context.spacing, context.shapes.

import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Controls for adjusting metabolism timeline view parameters
class MetabolismTimelineControls extends StatelessWidget {
  final int hoursBack;
  final int hoursForward;
  final bool adaptiveScale;
  final Function(int) onHoursBackChanged;
  final Function(int) onHoursForwardChanged;
  final Function(bool) onAdaptiveScaleChanged;
  final Function(int, int)? onPresetSelected;

  const MetabolismTimelineControls({
    super.key,
    required this.hoursBack,
    required this.hoursForward,
    required this.adaptiveScale,
    required this.onHoursBackChanged,
    required this.onHoursForwardChanged,
    required this.onAdaptiveScaleChanged,
    this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: Border.all(color: c.border),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Icon(Icons.tune, size: 18, color: t.accent.primary),
              SizedBox(height: sp.sm, width: sp.sm),
              Text(
                'Timeline Controls',
                style: text.heading4.copyWith(color: c.textPrimary),
              ),
            ],
          ),

          SizedBox(height: sp.lg),

          // Hours back / forward
          Row(
            children: [
              Expanded(
                child: _buildTimeInput(
                  context,
                  label: 'Hours Back',
                  value: hoursBack,
                  onChanged: onHoursBackChanged,
                ),
              ),
              SizedBox(width: sp.lg),
              Expanded(
                child: _buildTimeInput(
                  context,
                  label: 'Hours Forward',
                  value: hoursForward,
                  onChanged: onHoursForwardChanged,
                ),
              ),
            ],
          ),

          SizedBox(height: sp.lg),

          _buildScaleSelector(context),

          SizedBox(height: sp.lg),

          Text(
            'Quick Presets:',
            style: text.bodyBold.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: sp.sm),

          Wrap(
            spacing: sp.sm,
            runSpacing: sp.sm,
            children: [
              _buildPresetButton(context, '24h', 12, 12),
              _buildPresetButton(context, '48h', 24, 24),
              _buildPresetButton(context, '72h', 24, 48),
              _buildPresetButton(context, '1 Week', 72, 96),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------
  // TIME INPUT FIELD
  // -------------------------
  Widget _buildTimeInput(
    BuildContext context, {
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.bodySmall.copyWith(color: c.textSecondary)),
        SizedBox(height: sp.xs),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: sp.md,
              vertical: sp.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusSm),
              borderSide: BorderSide(color: c.border),
            ),
            filled: true,
            fillColor: c.surfaceVariant,
            suffixText: 'h',
            suffixStyle: text.caption.copyWith(color: c.textSecondary),
          ),
          style: text.body,
          onFieldSubmitted: (val) {
            final parsed = int.tryParse(val);
            if (parsed != null && parsed > 0 && parsed <= 168) {
              onChanged(parsed);
            }
          },
        ),
      ],
    );
  }

  // -------------------------
  // SCALE TOGGLE ROW
  // -------------------------
  Widget _buildScaleSelector(BuildContext context) {
    final text = context.text;
    final sp = context.spacing;
    final c = context.colors;

    return Row(
      children: [
        Icon(Icons.vertical_align_top, size: 16, color: c.textSecondary),
        SizedBox(width: sp.sm),
        Text(
          'Y-Axis Scale:',
          style: text.caption.copyWith(color: c.textSecondary),
        ),
        const Spacer(),
        _buildScaleButton(context, 'Fixed 100%', !adaptiveScale, () {
          onAdaptiveScaleChanged(false);
        }),
        SizedBox(width: sp.sm),
        _buildScaleButton(context, 'Adaptive', adaptiveScale, () {
          onAdaptiveScaleChanged(true);
        }),
      ],
    );
  }

  Widget _buildScaleButton(
    BuildContext context,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    final t = context.theme;
    final sp = context.spacing;
    final sh = context.shapes;
    final c = context.colors;
    final text = context.text;

    return InkWell(
      borderRadius: BorderRadius.circular(sh.radiusSm),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
        decoration: BoxDecoration(
          color: selected
              ? t.accent.primary.withOpacity(0.2)
              : c.surfaceVariant,
          borderRadius: BorderRadius.circular(sh.radiusSm),
          border: Border.all(
            color: selected ? t.accent.primary : c.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: text.captionBold.copyWith(
            color: selected ? t.accent.primary : c.textSecondary,
          ),
        ),
      ),
    );
  }

  // -------------------------
  // PRESET BUTTON
  // -------------------------
  Widget _buildPresetButton(
    BuildContext context,
    String label,
    int back,
    int forward,
  ) {
    final t = context.theme;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;
    final c = context.colors;

    final bool isSelected =
        (hoursBack == back && hoursForward == forward);

    return InkWell(
      onTap: () {
        if (onPresetSelected != null) {
          onPresetSelected!(back, forward);
        }
      },
      borderRadius: BorderRadius.circular(sh.radiusSm),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? t.accent.primary.withOpacity(0.2)
              : c.surfaceVariant,
          borderRadius: BorderRadius.circular(sh.radiusSm),
          border: Border.all(
            color: isSelected ? t.accent.primary : c.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: text.captionBold.copyWith(
            color: isSelected ? t.accent.primary : c.textSecondary,
          ),
        ),
      ),
    );
  }
}
