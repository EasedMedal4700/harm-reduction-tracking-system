import 'package:flutter/material.dart';
import '../../constants/theme/app_theme.dart';

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
    final t = AppTheme.of(context);
    
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isSubmitting ? null : onSubmit,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.all(t.spacing.m),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.shapes.radiusM),
          ),
          backgroundColor: t.colors.primary,
          foregroundColor: t.colors.onPrimary,
        ),
        child: isSubmitting
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(t.colors.onPrimary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bug_report),
                  SizedBox(width: t.spacing.s),
                  Text(
                    'Submit Bug Report',
                    style: t.typography.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
