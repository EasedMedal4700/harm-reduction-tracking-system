import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppThemeExtension. AppTheme parameters removed.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
/// Quick action tile for the home grid
class QuickActionTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? customColor;
  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.customColor,
  });
  @override
  State<QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<QuickActionTile> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final tx = context.text;
    final effectiveColor = widget.customColor ?? th.accent.primary;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        child: AnimatedContainer(
          duration: context.animations.fast,
          curve: Curves.easeOut,
          padding: EdgeInsets.all(sp.lg),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(sh.radiusMd),
            boxShadow: th.cardShadow,
            border: th.isDark && _hovered
                ? Border.all(color: th.accent.primary, width: 1)
                : null,
          ),
          child: Column(
            mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
            children: [
              // Icon with background
              AnimatedContainer(
                duration: context.animations.fast,
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(
                    alpha: th.isDark ? 0.2 : 0.1,
                  ),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  boxShadow: _hovered && th.isDark
                      ? [
                          BoxShadow(
                            color: th.accent.primary.withValues(alpha: 0.3),
                            blurRadius: context.sizes.blurRadiusMd,
                            spreadRadius: context.sizes.spreadRadiusMd,
                          ),
                        ]
                      : null,
                ),
                child: Icon(widget.icon, size: sp.lg, color: effectiveColor),
              ),
              SizedBox(height: sp.sm),
              // Label
              Text(
                widget.label,
                style: tx.bodySmall.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
                maxLines: 2,
                overflow: AppLayout.textOverflowEllipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grid of quick action tiles
class QuickActionsGrid extends StatelessWidget {
  final List<QuickActionData> actions;
  const QuickActionsGrid({super.key, required this.actions});
  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final sp = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.only(bottom: sp.md),
            child: Text('Quick Actions', style: tx.heading3),
          ),
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: sp.md,
              mainAxisSpacing: sp.md,
              childAspectRatio: 1.0,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return QuickActionTile(
                icon: action.icon,
                label: action.label,
                onTap: action.onTap,
                customColor: action.color,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Data class for quick action
class QuickActionData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const QuickActionData({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}
