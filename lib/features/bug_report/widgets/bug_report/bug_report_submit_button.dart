import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';


class BugReportSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const BugReportSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final acc = context.accent;
    
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isSubmitting ? null : onSubmit,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.all(sp.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sh.radiusMd),
          ),
          backgroundColor: acc.primary,
          foregroundColor: c.textInverse,
        ),
        child: isSubmitting
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(c.textInverse),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bug_report),
                  SizedBox(width: sp.sm),
                  Text(
                    'Submit Bug Report',
                    style: text.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

