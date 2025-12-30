// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod-managed screen; widgets are UI-only.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/bug_report_form_fields.dart';
import 'widgets/bug_report_submit_button.dart';
import 'providers/bug_report_providers.dart';

class BugReportScreen extends ConsumerStatefulWidget {
  const BugReportScreen({super.key});
  @override
  ConsumerState<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends ConsumerState<BugReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepsController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    ref.listen(bugReportControllerProvider, (previous, next) {
      final event = next.uiEvent;
      event.map(
        snackbar: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
              backgroundColor: e.isError ? c.error : c.success,
              duration: context.animations.toast,
            ),
          );
          ref.read(bugReportControllerProvider.notifier).clearUiEvent();
        },
        none: (_) {},
      );
    });

    final state = ref.watch(bugReportControllerProvider);

    Widget getSeverityIcon(String severity) {
      switch (severity) {
        case 'Critical':
          return Icon(Icons.error, color: c.error, size: th.sizes.iconSm);
        case 'High':
          return Icon(Icons.warning, color: c.warning, size: th.sizes.iconSm);
        case 'Medium':
          return Icon(Icons.info, color: c.info, size: th.sizes.iconSm);
        case 'Low':
          return Icon(
            Icons.check_circle,
            color: c.success,
            size: th.sizes.iconSm,
          );
        default:
          return Icon(
            Icons.info,
            color: c.textSecondary,
            size: th.sizes.iconSm,
          );
      }
    }

    return Scaffold(
      backgroundColor: c.surface,
      appBar: AppBar(
        title: Text('Report a Bug', style: tx.titleLarge),
        backgroundColor: c.surface,
        elevation: th.sizes.elevationNone,
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
                    size: th.sizes.iconMd,
                  ),
                  SizedBox(width: sp.md),
                  Expanded(
                    child: Text(
                      'Help us improve by reporting bugs or issues you encounter',
                      style: tx.bodyMedium.copyWith(color: c.textSecondary),
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
              severity: state.severity,
              category: state.category,
              severityLevels: BugReportOptions.severityLevels,
              categories: BugReportOptions.categories,
              onSeverityChanged: (value) {
                if (value == null) return;
                ref
                    .read(bugReportControllerProvider.notifier)
                    .setSeverity(value);
              },
              onCategoryChanged: (value) {
                if (value == null) return;
                ref
                    .read(bugReportControllerProvider.notifier)
                    .setCategory(value);
              },
              getSeverityIcon: (s) => getSeverityIcon(s),
            ),
            SizedBox(height: sp.lg),
            // Submit Button
            BugReportSubmitButton(
              isSubmitting: state.isSubmitting,
              onSubmit: () {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                ref
                    .read(bugReportControllerProvider.notifier)
                    .submit(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      steps: _stepsController.text,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
