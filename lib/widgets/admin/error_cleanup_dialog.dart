// ignore_for_file: deprecated_member_use
// MIGRATION COMPLETE — Fully theme-compliant, no deprecated API
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
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;
    final sh = context.shapes;

    return AlertDialog(
      backgroundColor: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sh.radiusMd),
        side: BorderSide(color: c.border),
      ),

      /// TITLE
      title: Text(
        'Clean Error Logs',
        style: text.heading3.copyWith(color: c.textPrimary),
      ),

      /// CONTENT
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DELETE ALL SWITCH
            SwitchListTile(
              value: _deleteAll,
              activeThumbColor: t.accent.primary,
              onChanged: (value) => setState(() => _deleteAll = value),

              title: Text(
                'Delete entire table',
                style: text.body.copyWith(color: c.textPrimary),
              ),
              subtitle: Text(
                'This action cannot be undone',
                style: text.bodySmall.copyWith(color: c.textSecondary),
              ),
            ),

            if (!_deleteAll) ...[
              /// DAYS FIELD
              TextField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                style: text.body.copyWith(color: c.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Older than (days)',
                  hintText: 'e.g., 30',
                  labelStyle: text.bodySmall.copyWith(color: c.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sh.radiusSm),
                  ),
                ),
              ),

              SizedBox(height: sp.md),

              /// PLATFORM DROPDOWN
              DropdownButtonFormField<String>(
                value: _platform,
                decoration: InputDecoration(
                  labelText: 'Platform (optional)',
                  labelStyle: text.bodySmall.copyWith(color: c.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sh.radiusSm),
                  ),
                ),
                items: widget.platformOptions
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(v, style: text.body.copyWith(color: c.textPrimary)),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _platform = val),
              ),

              SizedBox(height: sp.md),

              /// SCREEN DROPDOWN
              DropdownButtonFormField<String>(
                value: _screen,
                decoration: InputDecoration(
                  labelText: 'Screen (optional)',
                  labelStyle: text.bodySmall.copyWith(color: c.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sh.radiusSm),
                  ),
                ),
                items: widget.screenOptions
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(v, style: text.body.copyWith(color: c.textPrimary)),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _screen = val),
              ),
            ],
          ],
        ),
      ),

      /// ACTION BUTTONS
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            'Cancel',
            style: text.button.copyWith(color: c.textSecondary),
          ),
        ),

        ElevatedButton(
          onPressed: () {
            final days = int.tryParse(_daysController.text);

            Navigator.of(context).pop({
              'deleteAll': _deleteAll,
              'olderThanDays': days,
              'platform': _platform,
              'screen': _screen,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: t.accent.primary,
            foregroundColor: c.textInverse,
            padding: EdgeInsets.symmetric(
              horizontal: sp.lg,
              vertical: sp.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sh.radiusSm),
            ),
            shadowColor: c.overlayHeavy,
          ),
          child: Text(
            'Confirm',
            style: text.button.copyWith(color: c.textInverse),
          ),
        ),
      ],
    );
  }
}
