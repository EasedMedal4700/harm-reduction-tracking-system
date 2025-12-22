// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Detail sheet widget. Fully theme-compliant.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';
import 'package:mobile_drug_use_app/common/buttons/common_outlined_button.dart';
import '../../../../common/layout/common_spacer.dart';

class ActivityDetailSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<DetailItem> details;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActivityDetailSheet({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.details,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(sh.radiusLg)),
        border: Border.all(color: c.border),
        boxShadow: t.cardShadow,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            _buildHandleBar(context),
            CommonSpacer.vertical(sp.lg),
            _buildHeader(context),
            CommonSpacer.vertical(sp.xl),
            _buildDetailsList(context),
            CommonSpacer.vertical(sp.xl),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleBar(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    return Container(
      margin: EdgeInsets.only(top: sp.sm),
      width: sp.xl2,
      height: sp.xs,
      decoration: BoxDecoration(
        color: c.border,
        borderRadius: BorderRadius.circular(sh.radiusXs),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final t = context.theme;
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.lg),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(sp.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor,
                  accentColor.withValues(alpha: t.opacities.gradientEnd),
                ],
              ),
              borderRadius: BorderRadius.circular(sh.radiusSm),
            ),
            child: Icon(icon, color: c.textInverse, size: sp.xl),
          ),
          CommonSpacer.horizontal(sp.lg),
          Expanded(
            child: Text(
              title,
              style: text.heading3.copyWith(color: c.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: details.map((detail) {
          final highlight = detail.highlight;

          return Padding(
            padding: EdgeInsets.only(bottom: sp.lg),
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  detail.label,
                  style: text.label.copyWith(color: c.textSecondary),
                ),
                CommonSpacer.vertical(sp.xs),

                Container(
                  padding: highlight
                      ? EdgeInsets.symmetric(horizontal: sp.sm, vertical: sp.xs)
                      : null,
                  decoration: highlight
                      ? BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(sh.radiusSm),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.3),
                          ),
                        )
                      : null,
                  child: Text(
                    detail.value,
                    style: text.bodyLarge.copyWith(
                      color: highlight ? accentColor : c.textPrimary,
                      fontWeight: highlight
                          ? text.bodyBold.fontWeight
                          : text.body.fontWeight,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;

    return Padding(
      padding: EdgeInsets.all(sp.lg),
      child: Row(
        children: [
          /// DELETE BUTTON
          Expanded(
            child: CommonOutlinedButton(
              onPressed: onDelete,
              icon: Icons.delete_outline,
              label: 'Delete',
              color: c.error,
              borderColor: c.error,
            ),
          ),

          CommonSpacer.horizontal(sp.md),

          /// EDIT BUTTON
          Expanded(
            flex: AppLayout.flex2,
            child: CommonPrimaryButton(
              onPressed: onEdit,
              icon: Icons.edit,
              label: 'Edit Entry',
              backgroundColor: accentColor,
              textColor: c.textInverse,
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail item (unchanged)
class DetailItem {
  final String label;
  final String value;
  final bool highlight;

  DetailItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });
}
