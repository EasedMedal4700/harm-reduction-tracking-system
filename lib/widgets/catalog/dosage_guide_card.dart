import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

/// Widget for displaying dosage information for a specific ROA
class DosageGuideCard extends StatelessWidget {
  final Map<String, dynamic>? doseData;
  final String selectedMethod;
  final bool isDark;
  final Color accentColor;

  const DosageGuideCard({
    super.key,
    required this.doseData,
    required this.selectedMethod,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (doseData == null) {
      return _buildWarningCard(
        'No dosage information available for $selectedMethod administration.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.medication_outlined, color: accentColor),
            const SizedBox(width: 8),
            Text(
              'Dosage Guide',
              style: TextStyle(
                fontSize: ThemeConstants.fontLarge,
                fontWeight: ThemeConstants.fontBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                selectedMethod,
                style: TextStyle(
                  fontSize: 12,
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDoseCard('Light', doseData!['Light'], Colors.green),
        const SizedBox(height: 8),
        _buildDoseCard('Common', doseData!['Common'], Colors.orange),
        const SizedBox(height: 8),
        _buildDoseCard('Strong', doseData!['Strong'], Colors.red),
        if (doseData!['Heavy'] != null) ...[
          const SizedBox(height: 8),
          _buildDoseCard('Heavy', doseData!['Heavy'], Colors.purple),
        ],
      ],
    );
  }

  Widget _buildDoseCard(String label, String? range, Color color) {
    if (range == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getDoseIcon(label), color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                range,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
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

  Widget _buildWarningCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark ? Colors.amber[200] : Colors.amber[900],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
