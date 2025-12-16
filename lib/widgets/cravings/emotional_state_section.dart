import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

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
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    
    return Container(
      padding: EdgeInsets.all(sp.md),
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
              Icon(Icons.favorite, color: a.primary),
              SizedBox(width: sp.sm),
              Text(
                'Emotional State',
                style: t.typography.heading4.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: sp.md),
          
          FeelingSelection(
            feelings: selectedEmotions,
            onFeelingsChanged: onEmotionsChanged,
            secondaryFeelings: secondaryEmotions,
            onSecondaryFeelingsChanged: onSecondaryEmotionsChanged,
          ),
          
          SizedBox(height: sp.lg),
          
          Text(
            'Thoughts',
            style: t.typography.body.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: sp.sm),
          TextFormField(
            initialValue: thoughts,
            onChanged: onThoughtsChanged,
            maxLines: 3,
            style: t.typography.body.copyWith(color: c.textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: c.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(sh.radiusMd),
                borderSide: BorderSide(color: c.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(sh.radiusMd),
                borderSide: BorderSide(color: c.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(sh.radiusMd),
                borderSide: BorderSide(color: a.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

