import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../utils/error_reporter.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
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
        const SnackBar(
          content: Text('✓ Bug report submitted successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit bug report: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? UIColors.darkBackground : UIColors.lightBackground;
    final surfaceColor = isDark ? UIColors.darkSurface : UIColors.lightSurface;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Report a Bug'),
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info Card
            Card(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Help us improve by reporting bugs or issues you encounter',
                        style: TextStyle(
                          color: isDark ? Colors.blue.shade300 : Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

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
            const SizedBox(height: 24),

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
    switch (severity) {
      case 'Critical':
        return const Icon(Icons.error, color: Colors.red, size: 20);
      case 'High':
        return const Icon(Icons.warning, color: Colors.orange, size: 20);
      case 'Medium':
        return const Icon(Icons.info, color: Colors.blue, size: 20);
      case 'Low':
        return const Icon(Icons.check_circle, color: Colors.green, size: 20);
      default:
        return const Icon(Icons.info, color: Colors.grey, size: 20);
    }
  }
}
