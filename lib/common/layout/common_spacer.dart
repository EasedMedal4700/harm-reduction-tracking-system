// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: No theme dependencies.
/// Consistent spacing component

import 'package:flutter/material.dart';

class CommonSpacer extends StatelessWidget {
  final double height;
  final double width;

  const CommonSpacer({this.height = 0, this.width = 0, super.key});

  const CommonSpacer.vertical(double size, {super.key})
    : height = size,
      width = 0;

  const CommonSpacer.horizontal(double size, {super.key})
    : height = 0,
      width = size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}
