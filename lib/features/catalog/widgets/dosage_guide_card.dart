// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/layout/common_spacer.dart';

/// Widget for displaying dosage information for a specific ROA
class DosageGuideCard extends StatelessWidget {
  final Map<String, dynamic>? doseData;
  final String selectedMethod;
  final Color accentColor;
  const DosageGuideCard({
    super.key,
    required this.doseData,
    required this.selectedMethod,
    required this.accentColor,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    if (doseData == null) {
      return _buildWarningCard(
        context,
        'No dosage information available for $selectedMethod administration.',
      );
    }
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Row(
          children: [
            Icon(Icons.medication_outlined, color: accentColor),
            CommonSpacer.horizontal(th.sp.xs),
            Text(
              'Dose Ranges (Informational)',
              style: th.tx.heading3.copyWith(color: th.colors.textPrimary),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: th.sp.sm,
                vertical: th.sp.xs,
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: th.opacities.overlay),
                borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              ),
              child: Text(
                selectedMethod,
                style: th.tx.label.copyWith(color: accentColor),
              ),
            ),
          ],
        ),
        CommonSpacer.vertical(th.sp.lg),
        _buildDoseCard(context, 'Light', doseData!['Light'], th.colors.success),
        CommonSpacer.vertical(th.sp.xs),
        _buildDoseCard(
          context,
          'Common',
          doseData!['Common'],
          th.colors.warning,
        ),
        CommonSpacer.vertical(th.sp.xs),
        _buildDoseCard(context, 'Strong', doseData!['Strong'], th.colors.error),
        if (doseData!['Heavy'] != null) ...[
          CommonSpacer.vertical(th.sp.xs),
          _buildDoseCard(
            context,
            'Heavy',
            doseData!['Heavy'],
            th.accent.secondary,
          ),
        ],
      ],
    );
  }

  Widget _buildDoseCard(
    BuildContext context,
    String label,
    String? range,
    Color color,
  ) {
    final th = context.theme;

    if (range == null) return const SizedBox.shrink();
    return CommonCard(
      padding: EdgeInsets.all(th.sp.md),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(th.sp.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: th.opacities.overlay),
              shape: context.shapes.boxShapeCircle,
            ),
            child: Icon(
              _getDoseIcon(label),
              color: color,
              size: th.sizes.iconSm,
            ),
          ),
          CommonSpacer.horizontal(th.sp.lg),
          Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text(
                label,
                style: th.tx.captionBold.copyWith(color: color),
              ),
              SizedBox(height: th.sp.xs),
              Text(
                range,
                style: th.tx.bodyBold.copyWith(color: th.colors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getDoseIcon(String label) {
    switch (label.toLowerCase()) {
      case 'light':
        return Icons.wb_sunny_outlined;
      case 'common':
        return Icons.person_outline;
      case 'strong':
        return Icons.local_fire_department_outlined;
      case 'heavy':
        return Icons.warning_amber_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  Widget _buildWarningCard(BuildContext context, String message) {
    final th = context.theme;

    return Container(
      padding: EdgeInsets.all(th.sp.md),
      decoration: BoxDecoration(
        color: th.colors.warning.withValues(alpha: th.opacities.overlay),
        borderRadius: BorderRadius.circular(th.shapes.radiusMd),
        border: Border.all(
          color: th.colors.warning.withValues(alpha: th.opacities.slow),
        ),
      ),
      child: Row(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Icon(Icons.warning_amber_rounded, color: th.colors.warning),
          SizedBox(width: th.sp.sm),
          Expanded(
            child: Text(
              message,
              style: th.tx.body.copyWith(color: th.colors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
