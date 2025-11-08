import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class BloodLevelsPage extends StatelessWidget {
  const BloodLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Levels'),
      ),
      body: const Center(
        child: Text(
          'TBC',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}