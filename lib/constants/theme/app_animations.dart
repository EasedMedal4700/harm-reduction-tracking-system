import 'package:flutter/material.dart';

/// Animation constants for the application
class AppAnimations {
  const AppAnimations();

  final Duration fast = const Duration(milliseconds: 150);
  final Duration normal = const Duration(milliseconds: 300);
  final Duration slow = const Duration(milliseconds: 500);
  final Duration toast = const Duration(seconds: 3);

  final Curve curve = Curves.easeInOut;
  final Curve curveEmphasized = Curves.easeOutCubic;
}
