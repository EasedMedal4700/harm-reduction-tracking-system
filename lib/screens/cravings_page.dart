import 'package:flutter/material.dart';

class CravingsPage extends StatelessWidget {
  const CravingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cravings'),
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