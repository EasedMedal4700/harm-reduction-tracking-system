// MIGRATION COMPLETE – Theme-based dialog.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Dialog for cleaning/filtering error logs with various options
class ErrorCleanupDialog extends StatefulWidget {
  final List<String> platformOptions;
  final List<String> screenOptions;

  const ErrorCleanupDialog({
    required this.platformOptions,
    required this.screenOptions,
    super.key,
  });

  @override
  State<ErrorCleanupDialog> createState() => _ErrorCleanupDialogState();
}

class _ErrorCleanupDialogState extends State<ErrorCleanupDialog> {
  final _daysController = TextEditingController();
  String? _platform;
  String? _screen;
  bool _deleteAll = false;

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return AlertDialog(
      backgroundColor: t.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(t.spacing.md),
        side: BorderSide(color: t.colors.border),
      ),
      title: Text(
        'Clean Error Logs',
        style: t.typography.heading3.copyWith(
          color: t.colors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              value: _deleteAll,
              title: Text(
                'Delete entire table',
                style: t.typography.body.copyWith(
                  color: t.colors.textPrimary,
                ),
              ),
              subtitle: Text(
                'This action cannot be undone',
                style: t.typography.bodySmall.copyWith(
                  color: t.colors.textSecondary,
                ),
              ),
              activeColor: t.accent.primary,
              onChanged: (value) {
                setState(() => _deleteAll = value);
              },
            ),

            if (!_deleteAll) ...[
              TextField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                style: t.typography.body.copyWith(
                  color: t.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Older than (days)',
                  hintText: 'e.g., 30',
                  labelStyle: t.typography.bodySmall.copyWith(
                    color: t.colors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(t.spacing.sm),
                  ),
                ),
              ),

              SizedBox(height: t.spacing.md),

              DropdownButtonFormField<String>(
                value: _platform,
                decoration: InputDecoration(
                  labelText: 'Platform (optional)',
                  labelStyle: t.typography.bodySmall.copyWith(
                    color: t.colors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(t.spacing.sm),
                  ),
                ),
                items: widget.platformOptions
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: t.typography.body.copyWith(
                            color: t.colors.textPrimary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _platform = value),
              ),

              SizedBox(height: t.spacing.md),

              DropdownButtonFormField<String>(
                value: _screen,
                decoration: InputDecoration(
                  labelText: 'Screen (optional)',
                  labelStyle: t.typography.bodySmall.copyWith(
                    color: t.colors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(t.spacing.sm),
                  ),
                ),
                items: widget.screenOptions
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: t.typography.body.copyWith(
                            color: t.colors.textPrimary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _screen = value),
              ),
            ],
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            'Cancel',
            style: t.typography.button.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final olderThanDays = int.tryParse(_daysController.text);
            Navigator.of(context).pop({
              'deleteAll': _deleteAll,
              'olderThanDays': olderThanDays,
              'platform': _platform,
              'screen': _screen,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: t.accent.primary,
            foregroundColor: t.colors.textInverse,
            padding: EdgeInsets.symmetric(
              horizontal: t.spacing.lg,
              vertical: t.spacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(t.spacing.sm),
            ),
            shadowColor: t.colors.overlayHeavy,
          ),
          child: Text(
            'Confirm',
            style: t.typography.button.copyWith(
              color: t.colors.textInverse,
            ),
          ),
        ),
      ],
    );
  }
}
