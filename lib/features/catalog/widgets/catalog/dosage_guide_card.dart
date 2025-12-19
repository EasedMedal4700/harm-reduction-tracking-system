// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

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
    final t = context.theme;
    if (doseData == null) {
      return _buildWarningCard(
        context,
        'No dosage information available for $selectedMethod administration.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.medication_outlined, color: accentColor),
            const CommonSpacer.horizontal(4),
            Text(
              'Dose Ranges (Informational)',
              style: t.text.heading3.copyWith(
                color: t.colors.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.sm,
                vertical: t.spacing.xs,
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              ),
              child: Text(
                selectedMethod,
                style: t.text.label.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const CommonSpacer.vertical(16),
        _buildDoseCard(context, 'Light', doseData!['Light'], Colors.green),
        const CommonSpacer.vertical(4),
        _buildDoseCard(context, 'Common', doseData!['Common'], Colors.orange),
        const CommonSpacer.vertical(4),
        _buildDoseCard(context, 'Strong', doseData!['Strong'], Colors.red),
        if (doseData!['Heavy'] != null) ...[
          const CommonSpacer.vertical(4),
          _buildDoseCard(context, 'Heavy', doseData!['Heavy'], Colors.purple),
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
    final t = context.theme;
    if (range == null) return const SizedBox.shrink();

    return CommonCard(
      padding: EdgeInsets.all(t.spacing.md),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(t.spacing.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getDoseIcon(label), color: color, size: 20),
          ),
          const CommonSpacer.horizontal(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: t.typography.captionBold.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                range,
                style: t.typography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: t.colors.textPrimary,
                ),
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
    final t = context.theme;
    return Container(
      padding: EdgeInsets.all(t.spacing.md),
      decoration: BoxDecoration(
        color: t.colors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(color: t.colors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: t.colors.warning),
          SizedBox(width: t.spacing.sm),
          Expanded(
            child: Text(
              message,
              style: t.text.body.copyWith(
                color: t.colors.warning,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
