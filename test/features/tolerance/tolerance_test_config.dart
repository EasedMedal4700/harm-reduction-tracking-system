/// Test configuration for tolerance feature integration tests
class ToleranceTestConfig {
  /// Bucket to check in integration tests
  static const String testBucket = 'gaba';

  /// Minimum acceptable percentage for the test bucket
  static const double minBucketPercent = 0.0;

  /// Maximum wait time for tolerance page to load (seconds)
  static const int maxLoadWaitSeconds = 10;

  /// Test substance slug to look for (optional - empty means any substance)
  static const String testSubstanceSlug = 'alcohol';
}
