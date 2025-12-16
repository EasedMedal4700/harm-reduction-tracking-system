import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Fully migrated to AppThemeExtension. AppTheme parameters removed.

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
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    final effectiveColor = widget.customColor ?? t.accent.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(sp.lg),
          decoration: t.cardDecoration(
            hovered: _hovered,
            neonBorder: t.isDark && _hovered,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with background
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(
                    alpha: t.isDark ? 0.2 : 0.1,
                  ),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  boxShadow: _hovered && t.isDark
                      ? t.getNeonGlow(intensity: 0.3)
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  size: sp.iconLg,
                  color: effectiveColor,
                ),
              ),

              SizedBox(height: sp.sm),

              // Label
              Text(
                widget.label,
                style: text.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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

  const QuickActionsGrid({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.only(bottom: sp.md),
            child: Text(
              'Quick Actions',
              style: text.heading3,
            ),
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
