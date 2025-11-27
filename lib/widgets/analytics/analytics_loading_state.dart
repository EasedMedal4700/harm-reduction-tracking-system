import 'package:flutter/material.dart';

/// Widget displaying a loading indicator for the analytics page
class AnalyticsLoadingState extends StatelessWidget {
  const AnalyticsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
