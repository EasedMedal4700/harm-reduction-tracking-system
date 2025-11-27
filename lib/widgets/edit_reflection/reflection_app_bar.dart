import 'package:flutter/material.dart';

class ReflectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSaving;
  final VoidCallback onSave;

  const ReflectionAppBar({
    super.key,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Edit Reflection'),
      actions: [
        if (isSaving)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else
          TextButton(
            onPressed: onSave,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
