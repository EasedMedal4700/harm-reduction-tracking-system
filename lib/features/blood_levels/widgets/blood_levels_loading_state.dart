// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonLoader.
import 'package:flutter/material.dart';
import '../../../common/feedback/common_loader.dart';

/// Loading state for blood levels
class BloodLevelsLoadingState extends StatelessWidget {
  const BloodLevelsLoadingState({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: CommonLoader());
  }
}
