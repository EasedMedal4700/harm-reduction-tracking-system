// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Riverpod controller owning bucket-specific tolerance detail state.
//        This controller slices system-level tolerance data for one bucket.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/bucket_definitions.dart';
import '../../services/tolerance_engine_service.dart';

part 'bucket_details_controller.freezed.dart';

/// ============================================================================
/// STATE
/// ============================================================================

@freezed
class BucketDetailsState with _$BucketDetailsState {
  const factory BucketDetailsState({
    /// Canonical bucket identifier (e.g. "gaba", "stimulant")
    required String bucketType,

    /// Tolerance percentage (0–100)
    required double tolerancePercent,

    /// Raw accumulated load for this bucket
    required double rawLoad,

    /// Estimated days until baseline recovery
    required double daysToBaseline,

    /// Substances contributing to this bucket
    required List<ToleranceContribution> contributingSubstances,

    /// Optional educational / harm-reduction notes
    String? substanceNotes,
  }) = _BucketDetailsState;
}

/// ============================================================================
/// PROVIDER
/// ============================================================================

final bucketDetailsProvider = FutureProvider.autoDispose
    .family<BucketDetailsState, ({String userId, String bucketType})>((
      ref,
      args,
    ) async {
      final controller = BucketDetailsController(ref);
      return controller.load(userId: args.userId, bucketType: args.bucketType);
    });

/// ============================================================================
/// CONTROLLER
/// ============================================================================

class BucketDetailsController {
  final Ref _ref;

  BucketDetailsController(this._ref);

  Future<BucketDetailsState> load({
    required String userId,
    required String bucketType,
  }) async {
    // Normalize legacy bucket names
    final normalizedBucket = BucketDefinitions.normalizeBucketName(bucketType);

    // 1. Compute full system tolerance (single source of truth)
    final result = await ToleranceEngineService.computeSystemTolerance(
      userId: userId,
    );

    // 2. Slice bucket-specific values
    final tolerancePercent = result.bucketPercents[normalizedBucket] ?? 0.0;

    final rawLoad = result.bucketRawLoads[normalizedBucket] ?? 0.0;

    final daysToBaseline = result.daysUntilBaseline[normalizedBucket] ?? 0.0;

    // 3. Fetch breakdown of contributing substances
    final contributions = await ToleranceEngineService.getBucketBreakdown(
      userId: userId,
      bucketName: normalizedBucket,
    );

    return BucketDetailsState(
      bucketType: normalizedBucket,
      tolerancePercent: tolerancePercent,
      rawLoad: rawLoad,
      daysToBaseline: daysToBaseline,
      contributingSubstances: contributions,
      substanceNotes: null,
    );
  }
}
