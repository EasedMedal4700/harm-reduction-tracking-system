import 'package:flutter/material.dart';
import '../models/bucket_definitions.dart';
import '../models/tolerance_model.dart';
import '../constants/deprecated/theme_constants.dart';
import '../constants/deprecated/ui_colors.dart';
import '../widgets/bucket_details/bucket_header_card.dart';
import '../widgets/bucket_details/bucket_description_card.dart';
import '../widgets/bucket_details/bucket_status_card.dart';
import '../widgets/bucket_details/bucket_decay_timeline_card.dart';
import '../widgets/bucket_details/bucket_contributing_uses_card.dart';
import '../widgets/bucket_details/bucket_notes_card.dart';
import '../widgets/bucket_details/bucket_baseline_card.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? UIColors.darkBackground : UIColors.lightBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(BucketDefinitions.getDisplayName(bucketType)),
        backgroundColor: isDark ? UIColors.darkSurface : Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ThemeConstants.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            BucketHeaderCard(
              bucketType: bucketType,
              tolerancePercent: tolerancePercent,
              isDark: isDark,
            ),
            SizedBox(height: ThemeConstants.space16),

            // Description
            BucketDescriptionCard(
              bucketType: bucketType,
              isDark: isDark,
            ),
            SizedBox(height: ThemeConstants.space16),

            // Current status
            BucketStatusCard(
              bucket: bucket,
              tolerancePercent: tolerancePercent,
              rawLoad: rawLoad,
              isDark: isDark,
            ),
            SizedBox(height: ThemeConstants.space16),

            // Decay timeline (visual representation)
            BucketDecayTimelineCard(
              tolerancePercent: tolerancePercent,
              isDark: isDark,
            ),
            SizedBox(height: ThemeConstants.space16),

            // Contributing uses
            if (contributingUses.isNotEmpty) ...[
              BucketContributingUsesCard(
                contributingUses: contributingUses,
                isDark: isDark,
              ),
              SizedBox(height: ThemeConstants.space16),
            ],

            // Substance-specific notes
            if (substanceNotes != null && substanceNotes!.isNotEmpty) ...[
              BucketNotesCard(
                substanceNotes: substanceNotes!,
                isDark: isDark,
              ),
              SizedBox(height: ThemeConstants.space16),
            ],

            // Days to baseline
            BucketBaselineCard(
              daysToBaseline: daysToBaseline,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}
