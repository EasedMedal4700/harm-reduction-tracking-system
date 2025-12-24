// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Riverpod provider for EncryptionServiceV2.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/encryption_service_v2.dart';

/// Provides a singleton instance of EncryptionServiceV2.
///
/// Why provider-based:
/// - Testable (can be overridden)
/// - Mockable
/// - Lifecycle controlled
/// - No direct instantiation in UI or controllers
final encryptionServiceProvider = Provider<EncryptionServiceV2>((ref) {
  return EncryptionServiceV2();
});
