import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

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
    required this.hoursBack,
    required this.hoursForward,
    required this.adaptiveScale,
    required this.onHoursBackChanged,
    required this.onHoursForwardChanged,
    required this.onAdaptiveScaleChanged,
    this.onPresetSelected,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonTeal : UIColors.lightAccentRed;
    
    return Container(
      padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: UIColors.lightBorder,
                width: ThemeConstants.borderThin,
              ),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune,
                size: 18,
                color: accentColor,
              ),
              SizedBox(width: ThemeConstants.space8),
              Text(
                'Timeline Controls',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space16),
          
          // Hours back and forward inputs
          Row(
            children: [
              Expanded(
                child: _buildTimeInput(
                  label: 'Hours Back',
                  value: hoursBack,
                  onChanged: (val) => onHoursBackChanged(val ?? hoursBack),
                  isDark: isDark,
                ),
              ),
              SizedBox(width: ThemeConstants.space16),
              Expanded(
                child: _buildTimeInput(
                  label: 'Hours Forward',
                  value: hoursForward,
                  onChanged: (val) => onHoursForwardChanged(val ?? hoursForward),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space16),
          
          // Scale toggle
          Row(
            children: [
              Icon(
                Icons.vertical_align_top,
                size: 16,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              SizedBox(width: ThemeConstants.space8),
              Text(
                'Y-Axis Scale:',
                style: TextStyle(
                  fontSize: ThemeConstants.fontXSmall,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              const Spacer(),
              _buildScaleButton('Fixed 100%', !adaptiveScale, () => onAdaptiveScaleChanged(false), isDark, accentColor),
              SizedBox(width: ThemeConstants.space8),
              _buildScaleButton('Adaptive', adaptiveScale, () => onAdaptiveScaleChanged(true), isDark, accentColor),
            ],
          ),
          SizedBox(height: ThemeConstants.space12),
          
          // Preset buttons
          Text(
            'Quick Presets:',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetButton('24h', 12, 12, context, isDark, accentColor),
              _buildPresetButton('48h', 24, 24, context, isDark, accentColor),
              _buildPresetButton('72h', 24, 48, context, isDark, accentColor),
              _buildPresetButton('1 Week', 72, 96, context, isDark, accentColor),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeInput({
    required String label,
    required int value,
    required Function(int?) onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontSmall,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        SizedBox(height: ThemeConstants.space4),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.space12,
              vertical: ThemeConstants.space8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              borderSide: BorderSide(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              ),
            ),
            suffixText: 'h',
            suffixStyle: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
            filled: true,
            fillColor: isDark 
                ? UIColors.darkSurface.withValues(alpha: 0.5)
                : UIColors.lightSurface,
          ),
          style: TextStyle(
            fontSize: ThemeConstants.fontXSmall,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
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
  
  Widget _buildScaleButton(String label, bool selected, VoidCallback onTap, bool isDark, Color accentColor) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.space12,
          vertical: ThemeConstants.space8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? accentColor.withValues(alpha: isDark ? 0.2 : 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
          border: Border.all(
            color: selected
                ? accentColor
                : (isDark ? UIColors.darkBorder : UIColors.lightBorder),
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontXSmall,
            fontWeight: selected ? ThemeConstants.fontBold : ThemeConstants.fontMediumWeight,
            color: selected
                ? accentColor
                : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPresetButton(String label, int back, int forward, BuildContext context, bool isDark, Color accentColor) {
    final isSelected = hoursBack == back && hoursForward == forward;
    
    return InkWell(
      onTap: () {
        if (onPresetSelected != null) {
          onPresetSelected!(back, forward);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.space12,
          vertical: ThemeConstants.space8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: isDark ? 0.2 : 0.15)
              : (isDark
                  ? UIColors.darkSurface.withValues(alpha: 0.5)
                  : UIColors.lightSurface),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
          border: Border.all(
            color: isSelected
                ? accentColor
                : (isDark ? UIColors.darkBorder : UIColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontXSmall,
            fontWeight: isSelected ? ThemeConstants.fontSemiBold : ThemeConstants.fontMediumWeight,
            color: isSelected
                ? accentColor
                : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}
