// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Bug Report Screen. Migrated to use AppTheme. No hardcoded values.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

import '../../services/user_service.dart';
import '../../utils/error_reporter.dart';
import 'widgets/bug_report/bug_report_form_fields.dart';
import 'widgets/bug_report/bug_report_submit_button.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({super.key});

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepsController = TextEditingController();
  
  String _severity = 'Medium';
  String _category = 'General';
  bool _isSubmitting = false;

  final List<String> _severityLevels = ['Low', 'Medium', 'High', 'Critical'];
  final List<String> _categories = [
    'General',
    'UI/UX',
    'Performance',
    'Data Entry',
    'Analytics',
    'Crash',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  Future<void> _submitBugReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final userId = UserService.getCurrentUserId();
      
      await ErrorReporter.instance.reportError(
        error: Exception(_titleController.text),
        stackTrace: StackTrace.current,
        screenName: 'BugReport',
        extraData: {
          'type': 'user_bug_report',
          'title': _titleController.text,
          'description': _descriptionController.text,
          'steps_to_reproduce': _stepsController.text,
          'severity': _severity,
          'category': _category,
          'uuid_user_id': userId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(' Bug report submitted successfully'),
          backgroundColor: context.colors.success,
          duration: context.animations.toast,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit bug report: $e'),
          backgroundColor: context.colors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Scaffold(
      backgroundColor: c.surface,
      appBar: AppBar(
        title: Text('Report a Bug', style: context.text.titleLarge),
        backgroundColor: c.surface,
        elevation: t.sizes.elevationNone,
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(sp.md),
          children: [
            // Info Card
            Container(
              padding: EdgeInsets.all(sp.md),
              decoration: BoxDecoration(
                color: c.surfaceVariant,
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(color: c.border),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: c.info,
                    size: t.sizes.iconMd,
                  ),
                  SizedBox(width: sp.md),
                  Expanded(
                    child: Text(
                      'Help us improve by reporting bugs or issues you encounter',
                      style: context.text.bodyMedium.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sp.lg),

            // Form Fields
            BugReportFormFields(
              titleController: _titleController,
              descriptionController: _descriptionController,
              stepsController: _stepsController,
              severity: _severity,
              category: _category,
              severityLevels: _severityLevels,
              categories: _categories,
              onSeverityChanged: (value) {
                setState(() => _severity = value!);
              },
              onCategoryChanged: (value) {
                setState(() => _category = value!);
              },
              getSeverityIcon: _getSeverityIcon,
            ),
            SizedBox(height: sp.lg),

            // Submit Button
            BugReportSubmitButton(
              isSubmitting: _isSubmitting,
              onSubmit: _submitBugReport,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSeverityIcon(String severity) {
    final t = context.theme;
    final c = context.colors;
    switch (severity) {
      case 'Critical':
        return Icon(Icons.error, color: c.error, size: t.sizes.iconSm);
      case 'High':
        return Icon(Icons.warning, color: c.warning, size: t.sizes.iconSm);
      case 'Medium':
        return Icon(Icons.info, color: c.info, size: t.sizes.iconSm);
      case 'Low':
        return Icon(Icons.check_circle, color: c.success, size: t.sizes.iconSm);
      default:
        return Icon(Icons.info, color: c.textSecondary, size: t.sizes.iconSm);
    }
  }
}

