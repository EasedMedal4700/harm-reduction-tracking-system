// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../constants/blood_levels_constants.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../common/inputs/input_field.dart';

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
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    return CommonCard(
      padding: EdgeInsets.all(sp.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Header row
          Row(
            children: [
              Icon(
                Icons.tune,
                size: context.sizes.iconSm,
                color: th.accent.primary,
              ),
              CommonSpacer.horizontal(sp.sm),
              Text(
                'Timeline Controls',
                style: tx.heading4.copyWith(color: c.textPrimary),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.xl),
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
              CommonSpacer.horizontal(sp.xl),
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
          CommonSpacer.vertical(sp.xl),
          _buildScaleSelector(context),
          CommonSpacer.vertical(sp.xl),
          Text(
            'Quick Presets:',
            style: tx.bodyBold.copyWith(color: c.textPrimary),
          ),
          CommonSpacer.vertical(sp.sm),
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
    final tx = context.text;
    final sp = context.spacing;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(label, style: tx.bodySmall.copyWith(color: c.textSecondary)),
        SizedBox(height: sp.xs),
        CommonInputField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: sp.sm),
            child: Center(
              widthFactor: 1,
              child: Text(
                'h',
                style: tx.caption.copyWith(color: c.textSecondary),
              ),
            ),
          ),
          onFieldSubmitted: (val) {
            final parsed = int.tryParse(val);
            if (parsed != null &&
                parsed > 0 &&
                parsed <= BloodLevelsConstants.maxTimelineHours) {
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
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    return Row(
      children: [
        Icon(
          Icons.vertical_align_top,
          size: context.sizes.iconSm,
          color: c.textSecondary,
        ),
        SizedBox(width: sp.sm),
        Text(
          'Y-Axis Scale:',
          style: tx.caption.copyWith(color: c.textSecondary),
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
    final th = context.theme;
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return InkWell(
      borderRadius: BorderRadius.circular(sh.radiusSm),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
        decoration: BoxDecoration(
          color: selected
              ? th.accent.primary.withValues(alpha: context.opacities.selected)
              : c.surfaceVariant,
          borderRadius: BorderRadius.circular(sh.radiusSm),
          border: Border.all(
            color: selected ? th.accent.primary : c.border,
            width: selected ? context.borders.medium : context.borders.thin,
          ),
        ),
        child: Text(
          label,
          style: tx.captionBold.copyWith(
            color: selected ? th.accent.primary : c.textSecondary,
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
    final th = context.theme;
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    final bool isSelected = (hoursBack == back && hoursForward == forward);
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
              ? th.accent.primary.withValues(alpha: context.opacities.selected)
              : c.surfaceVariant,
          borderRadius: BorderRadius.circular(sh.radiusSm),
          border: Border.all(
            color: isSelected ? th.accent.primary : c.border,
            width: isSelected ? context.borders.medium : context.borders.thin,
          ),
        ),
        child: Text(
          label,
          style: tx.captionBold.copyWith(
            color: isSelected ? th.accent.primary : c.textSecondary,
          ),
        ),
      ),
    );
  }
}
