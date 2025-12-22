// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and AppTheme.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:intl/intl.dart';
import '../../../../models/drug_catalog_entry.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

class DrugCatalogList extends StatelessWidget {
  final List<DrugCatalogEntry> entries;
  final Function(DrugCatalogEntry) onToggleFavorite;

  const DrugCatalogList({
    super.key,
    required this.entries,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No drugs found.',
          style: t.typography.bodyMedium.copyWith(
            color: t.colors.textSecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(t.spacing.md),
      itemCount: entries.length,
      separatorBuilder: (context, index) => CommonSpacer.vertical(t.spacing.md),
      itemBuilder: (context, index) {
        final drug = entries[index];
        return DrugCatalogTile(
          drug: drug,
          onToggleFavorite: () => onToggleFavorite(drug),
        );
      },
    );
  }
}

class DrugCatalogTile extends StatelessWidget {
  final DrugCatalogEntry drug;
  final VoidCallback onToggleFavorite;

  const DrugCatalogTile({
    super.key,
    required this.drug,
    required this.onToggleFavorite,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final text = context.text;

    return CommonCard(
      child: Padding(
        padding: EdgeInsets.all(t.spacing.md),
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          children: [
            Row(
              mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
              children: [
                Expanded(child: Text(drug.name, style: text.heading4)),
                IconButton(
                  icon: Icon(
                    drug.favorite ? Icons.star : Icons.star_border,
                    color: drug.favorite ? t.accent.primary : c.textSecondary,
                  ),
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
            const CommonSpacer.vertical(8),
            _buildInfoRow(context, 'Categories:', drug.categories.join(', ')),
            _buildInfoRow(context, 'Total uses:', '${drug.totalUses}'),
            _buildInfoRow(
              context,
              'Average dose:',
              drug.avgDose.toStringAsFixed(2),
            ),
            _buildInfoRow(context, 'Last used:', _formatDate(drug.lastUsed)),
            _buildInfoRow(
              context,
              'Most active day:',
              '${drug.weekdayUsage.mostActive}',
            ),
            _buildInfoRow(
              context,
              'Least active day:',
              '${drug.weekdayUsage.leastActive}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final t = context.theme;
    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.xs),
      child: Row(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          SizedBox(
            width: context.sizes.cardWidthSm,
            child: Text(
              label,
              style: t.typography.bodySmall.copyWith(
                color: t.colors.textSecondary,
                fontWeight: context.text.bodyBold.fontWeight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: t.typography.bodySmall.copyWith(
                color: t.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
