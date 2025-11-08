import 'package:flutter/material.dart';
import '../widgets/common/drawer_menu.dart';

class PersonalLibraryPage extends StatelessWidget {
  const PersonalLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Library'),
      ),
      drawer: const DrawerMenu(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Library',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This is a temporary page for your personal library. '
              'Here you can save notes, resources, or reminders.',
            ),
            SizedBox(height: 16),
            Text(
              'Coming Soon: Saved articles, personal notes, and custom resources.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}