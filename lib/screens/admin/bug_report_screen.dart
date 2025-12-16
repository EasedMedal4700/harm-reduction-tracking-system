import 'package:flutter/material.dart';
import '../../constants/theme/app_theme.dart';
import '../../services/user_service.dart';
import '../../utils/error_reporter.dart';
import '../../widgets/bug_report/bug_report_form_fields.dart';
import '../../widgets/bug_report/bug_report_submit_button.dart';

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
          backgroundColor: AppTheme.of(context).colors.success,
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit bug report: '),
          backgroundColor: AppTheme.of(context).colors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);

    return Scaffold(
      backgroundColor: t.colors.surface,
      appBar: AppBar(
        title: Text('Report a Bug', style: t.typography.titleLarge),
        backgroundColor: t.colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: t.colors.onSurface),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(t.spacing.m),
          children: [
            // Info Card
            Container(
              padding: EdgeInsets.all(t.spacing.m),
              decoration: BoxDecoration(
                color: t.colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(t.shapes.radiusM),
                border: Border.all(color: t.colors.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: t.colors.primary,
                    size: 24,
                  ),
                  SizedBox(width: t.spacing.m),
                  Expanded(
                    child: Text(
                      'Help us improve by reporting bugs or issues you encounter',
                      style: t.typography.bodyMedium.copyWith(
                        color: t.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: t.spacing.l),

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
            SizedBox(height: t.spacing.l),

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
    final t = AppTheme.of(context);
    switch (severity) {
      case 'Critical':
        return Icon(Icons.error, color: t.colors.error, size: 20);
      case 'High':
        return Icon(Icons.warning, color: t.colors.warning, size: 20);
      case 'Medium':
        return Icon(Icons.info, color: t.colors.primary, size: 20);
      case 'Low':
        return Icon(Icons.check_circle, color: t.colors.success, size: 20);
      default:
        return Icon(Icons.info, color: t.colors.onSurfaceVariant, size: 20);
    }
  }
}
