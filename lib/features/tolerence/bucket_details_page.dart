import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import '../../models/bucket_definitions.dart';
import '../../models/tolerance_model.dart';
import '../../common/layout/common_spacer.dart';


import 'widgets/bucket_details/bucket_header_card.dart';
import 'widgets/bucket_details/bucket_description_card.dart';
import 'widgets/bucket_details/bucket_status_card.dart';
import 'widgets/bucket_details/bucket_decay_timeline_card.dart';
import 'widgets/bucket_details/bucket_contributing_uses_card.dart';
import 'widgets/bucket_details/bucket_notes_card.dart';
import 'widgets/bucket_details/bucket_baseline_card.dart';

/// Detailed page showing bucket-specific tolerance information
/// Displays: decay graph, contributing uses, notes, days to baseline
class BucketDetailsPage extends StatelessWidget {
  final String bucketType;
  final NeuroBucket bucket;
  final double tolerancePercent; // 0–100
  final double rawLoad;
  final List<UseLogEntry> contributingUses;
  final double daysToBaseline;
  final String? substanceNotes;

  const BucketDetailsPage({
    super.key,
    required this.bucketType,
    required this.bucket,
    required this.tolerancePercent,
    required this.rawLoad,
    required this.contributingUses,
    required this.daysToBaseline,
    this.substanceNotes,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(BucketDefinitions.getDisplayName(bucketType)),
        backgroundColor: c.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sp.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            BucketHeaderCard(
              bucketType: bucketType,
              tolerancePercent: tolerancePercent,
            ),
            CommonSpacer.vertical(sp.lg),

            // Description
            BucketDescriptionCard(
              bucketType: bucketType,
            ),
            CommonSpacer.vertical(sp.lg),

            // Current status
            BucketStatusCard(
              bucket: bucket,
              tolerancePercent: tolerancePercent,
              rawLoad: rawLoad,
            ),
            CommonSpacer.vertical(sp.lg),

            // Decay timeline (visual representation)
            BucketDecayTimelineCard(
              tolerancePercent: tolerancePercent,
            ),
            CommonSpacer.vertical(sp.lg),

            // Contributing uses
            if (contributingUses.isNotEmpty) ...[
              BucketContributingUsesCard(
                contributingUses: contributingUses,
              ),
              CommonSpacer.vertical(sp.lg),
            ],

            // Substance-specific notes
            if (substanceNotes != null && substanceNotes!.isNotEmpty) ...[
              BucketNotesCard(
                substanceNotes: substanceNotes!,
              ),
              CommonSpacer.vertical(sp.lg),
            ],

            // Days to baseline
            BucketBaselineCard(
              daysToBaseline: daysToBaseline,
            ),
          ],
        ),
      ),
    );
  }
}




