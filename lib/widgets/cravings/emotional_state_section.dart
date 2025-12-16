import 'package:flutter/material.dart';
import '../../constants/theme/app_theme.dart';
import '../log_entry/feeling_selection.dart';

class EmotionalStateSection extends StatelessWidget {
  final List<String> selectedEmotions;
  final Map<String, List<String>> secondaryEmotions;
  final ValueChanged<List<String>> onEmotionsChanged;
  final ValueChanged<Map<String, List<String>>> onSecondaryEmotionsChanged;
  final String? thoughts;
  final ValueChanged<String> onThoughtsChanged;

  const EmotionalStateSection({
    super.key,
    required this.selectedEmotions,
    required this.secondaryEmotions,
    required this.onEmotionsChanged,
    required this.onSecondaryEmotionsChanged,
    required this.thoughts,
    required this.onThoughtsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    
    return Container(
      padding: EdgeInsets.all(t.spacing.m),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusLg),
        border: Border.all(color: t.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: t.colors.primary),
              SizedBox(width: t.spacing.s),
              Text(
                'Emotional State',
                style: t.typography.titleMedium.copyWith(
                  color: t.colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.m),
          
          FeelingSelection(
            feelings: selectedEmotions,
            onFeelingsChanged: onEmotionsChanged,
            secondaryFeelings: secondaryEmotions,
            onSecondaryFeelingsChanged: onSecondaryEmotionsChanged,
          ),
          
          SizedBox(height: t.spacing.l),
          
          Text(
            'Thoughts',
            style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
          ),
          SizedBox(height: t.spacing.s),
          TextFormField(
            initialValue: thoughts,
            onChanged: onThoughtsChanged,
            maxLines: 3,
            style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
            decoration: InputDecoration(
              filled: true,
              fillColor: t.colors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(t.shapes.radiusM),
                borderSide: BorderSide(color: t.colors.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(t.shapes.radiusM),
                borderSide: BorderSide(color: t.colors.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(t.shapes.radiusM),
                borderSide: BorderSide(color: t.colors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
