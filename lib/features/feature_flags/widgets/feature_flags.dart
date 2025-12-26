// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Review for theme/context migration if needed.
// Feature flag widgets for controlling access to app features.
//
// Usage:
// ```dart
// import 'package:mobile_drug_use_app/widgets/feature_flags/feature_flags.dart';
//
// // Wrap a page with FeatureGate
// FeatureGate(
//   featureName: FeatureFlags.homePage,
//   child: HomePage(),
// )
// ```
export 'feature_gate.dart';
export 'feature_disabled_screen.dart';
