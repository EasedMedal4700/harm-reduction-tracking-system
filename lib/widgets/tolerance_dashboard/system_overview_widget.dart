import 'package:flutter/material.dart';
import '../../models/tolerance_model.dart';
import '../../models/bucket_definitions.dart';
import '../../utils/tolerance_calculator.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../tolerance/system_bucket_card.dart';

class SystemOverviewWidget extends StatelessWidget {
  final ToleranceResult? systemTolerance;
  final Map<String, bool> substanceActiveStates;
  final Map<String, Map<String, double>> substanceContributions;
  final String? selectedBucket;
  final Function(String) onBucketSelected;
  final bool isDark;

  const SystemOverviewWidget({
    super.key,
    required this.systemTolerance,
    required this.substanceActiveStates,
    required this.substanceContributions,
    required this.selectedBucket,
    required this.onBucketSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final orderedBuckets = BucketDefinitions.orderedBuckets;
    final systemData = systemTolerance;
    
    if (systemData == null) {
      // Loading state
      return Card(
        color: isDark ? UIColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
          side: BorderSide(
            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'System Tolerance Overview',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
        ),
        const SizedBox(height: ThemeConstants.space12),
        
        // Horizontal scrollable bucket cards
        SizedBox(
          height: 140, // Fixed height for cards
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: orderedBuckets.length,
            separatorBuilder: (context, index) => const SizedBox(width: ThemeConstants.space12),
            itemBuilder: (context, index) {
              final bucketType = orderedBuckets[index];
              final tolerancePercent = (systemData.bucketPercents[bucketType] ?? 0.0).clamp(0.0, 100.0);
              final state = ToleranceCalculator.classifyState(tolerancePercent);
              
              // Check if any substance is active for this bucket
              final contributions = substanceContributions[bucketType];
              final isActive = contributions != null && contributions.isNotEmpty;
              
              return SystemBucketCard(
                bucketType: bucketType,
                tolerancePercent: tolerancePercent,
                state: state,
                isActive: isActive,
                isSelected: selectedBucket == bucketType,
                onTap: () => onBucketSelected(bucketType),
              );
            },
          ),
        ),
      ],
    );
  }
}
