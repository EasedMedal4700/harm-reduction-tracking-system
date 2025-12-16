import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';


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
              Icon(Icons.flag, color: a.primary),
              SizedBox(width: sp.sm),
              Text(
                'Outcome',
                style: t.typography.heading4.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: sp.md),
          
          Text(
            'What did you do?',
            style: t.typography.body.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: sp.sm),
          TextFormField(
            initialValue: whatDidYouDo,
            onChanged: onWhatDidYouDoChanged,
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
          SizedBox(height: sp.md),
          
          SwitchListTile(
            title: Text(
              'Acted on craving?',
              style: t.typography.body.copyWith(color: c.textPrimary),
            ),
            value: actedOnCraving,
            onChanged: onActedOnCravingChanged,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

