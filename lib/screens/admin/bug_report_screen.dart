import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../utils/error_reporter.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

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
          'user_id': userId,
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

            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Bug Title *',
                hintText: 'Brief description of the issue',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Severity
            DropdownButtonFormField<String>(
              value: _severity,
              decoration: InputDecoration(
                labelText: 'Severity',
                prefixIcon: const Icon(Icons.priority_high),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _severityLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Row(
                    children: [
                      _getSeverityIcon(level),
                      const SizedBox(width: 8),
                      Text(level),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _severity = value!);
              },
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _category = value!);
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                hintText: 'What happened? What did you expect to happen?',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              maxLength: 500,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please describe the bug';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Steps to Reproduce
            TextFormField(
              controller: _stepsController,
              decoration: InputDecoration(
                labelText: 'Steps to Reproduce (Optional)',
                hintText: '1. Go to...\n2. Click on...\n3. See error...',
                prefixIcon: const Icon(Icons.format_list_numbered),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              maxLength: 300,
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitBugReport,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bug_report),
                        SizedBox(width: 8),
                        Text(
                          'Submit Bug Report',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
