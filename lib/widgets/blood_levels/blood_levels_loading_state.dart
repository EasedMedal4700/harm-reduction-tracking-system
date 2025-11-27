import 'package:flutter/material.dart';

/// Loading state for blood levels
class BloodLevelsLoadingState extends StatelessWidget {
  const BloodLevelsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
