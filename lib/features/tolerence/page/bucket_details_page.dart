// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI-only bucket details page. All tolerance data must be provided via Riverpod.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';

import '../../../models/bucket_definitions.dart';
import '../../../common/layout/common_spacer.dart';

// Widgets
import '../widgets/bucket_details/bucket_header_card.dart';
import '../widgets/bucket_details/bucket_description_card.dart';
import '../widgets/bucket_details/bucket_status_card.dart';
import '../widgets/bucket_details/bucket_decay_timeline_card.dart';
import '../widgets/bucket_details/bucket_contributing_uses_card.dart';
import '../widgets/bucket_details/bucket_notes_card.dart';
import '../widgets/bucket_details/bucket_baseline_card.dart';
import '../../../providers/session_providers.dart';

// Controller
import '../widgets/bucket_details/bucket_details_controller.dart';

class BucketDetailsPage extends ConsumerWidget {
  final String bucketType;

  const BucketDetailsPage({super.key, required this.bucketType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final sp = context.spacing;

    // TODO: replace with your real session/user provider
    final userId = ref.watch(currentUserIdProvider);

    final state = ref.watch(
      bucketDetailsProvider((userId: userId, bucketType: bucketType)),
    );

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(BucketDefinitions.getDisplayName(bucketType)),
        backgroundColor: c.surface,
        elevation: context.sizes.elevationNone,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) => SingleChildScrollView(
          padding: EdgeInsets.all(sp.lg),
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              BucketHeaderCard(
                bucketType: data.bucketType,
                tolerancePercent: data.tolerancePercent,
              ),
              CommonSpacer.vertical(sp.lg),

              BucketDescriptionCard(bucketType: data.bucketType),
              CommonSpacer.vertical(sp.lg),

              BucketStatusCard(
                bucketType: data.bucketType,
                tolerancePercent: data.tolerancePercent,
                rawLoad: data.rawLoad,
              ),
              CommonSpacer.vertical(sp.lg),

              BucketDecayTimelineCard(tolerancePercent: data.tolerancePercent),
              CommonSpacer.vertical(sp.lg),

              if (data.contributingSubstances.isNotEmpty) ...[
                BucketContributingUsesCard(
                  contributions: data.contributingSubstances,
                ),
                CommonSpacer.vertical(sp.lg),
              ],

              if (data.substanceNotes?.isNotEmpty == true) ...[
                BucketNotesCard(substanceNotes: data.substanceNotes!),
                CommonSpacer.vertical(sp.lg),
              ],

              BucketBaselineCard(daysToBaseline: data.daysToBaseline),
            ],
          ),
        ),
      ),
    );
  }
}
