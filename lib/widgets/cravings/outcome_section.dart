import 'package:flutter/material.dart';
import '../../common/app_theme.dart';

class OutcomeSection extends StatelessWidget {
  final String? whatDidYouDo;
  final ValueChanged<String> onWhatDidYouDoChanged;
  final bool actedOnCraving;
  final ValueChanged<bool> onActedOnCravingChanged;

  const OutcomeSection({
    super.key,
    required this.whatDidYouDo,
    required this.onWhatDidYouDoChanged,
    required this.actedOnCraving,
    required this.onActedOnCravingChanged,
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
              Icon(Icons.flag, color: t.colors.primary),
              SizedBox(width: t.spacing.s),
              Text(
                'Outcome',
                style: t.typography.titleMedium.copyWith(
                  color: t.colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.m),
          
          Text(
            'What did you do?',
            style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
          ),
          SizedBox(height: t.spacing.s),
          TextFormField(
            initialValue: whatDidYouDo,
            onChanged: onWhatDidYouDoChanged,
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
          SizedBox(height: t.spacing.m),
          
          SwitchListTile(
            title: Text(
              'Acted on craving?',
              style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
            ),
            value: actedOnCraving,
            onChanged: onActedOnCravingChanged,
            activeColor: t.colors.primary,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
