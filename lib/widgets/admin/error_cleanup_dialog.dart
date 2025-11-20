import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: const Text('Clean Error Logs'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              value: _deleteAll,
              title: const Text('Delete entire table'),
              subtitle: const Text('This action cannot be undone'),
              onChanged: (value) {
                setState(() {
                  _deleteAll = value;
                });
              },
            ),
            if (!_deleteAll) ...[
              TextField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Older than (days)',
                  hintText: 'e.g., 30',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _platform,
                decoration:
                    const InputDecoration(labelText: 'Platform (optional)'),
                items: widget.platformOptions
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _platform = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _screen,
                decoration:
                    const InputDecoration(labelText: 'Screen (optional)'),
                items: widget.screenOptions
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _screen = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
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
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
