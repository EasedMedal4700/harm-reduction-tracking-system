import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme/common usage, not fully migrated.
import 'package:flutter/material.dart';



/// Quick action tile for the home grid
class QuickActionTile extends StatefulWidget {
  final AppTheme theme;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? customColor;

  const QuickActionTile({
    required this.theme,
    required this.icon,
    required this.label,
    required this.onTap,
    this.customColor,
    super.key,
  });

  @override
  State<QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<QuickActionTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.customColor ?? widget.theme.accent.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppThemeConstants.animationFast,
          curve: AppThemeConstants.animationCurve,
          padding: EdgeInsets.all(widget.theme.spacing.lg),
          decoration: widget.theme.cardDecoration(
            hovered: _hovered,
            neonBorder: widget.theme.isDark && _hovered,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with background
              AnimatedContainer(
                duration: AppThemeConstants.animationFast,
                padding: EdgeInsets.all(widget.theme.spacing.md),
                decoration: BoxDecoration(
                  color: color.withOpacity(widget.theme.isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
                  boxShadow: _hovered && widget.theme.isDark
                      ? widget.theme.getNeonGlow(intensity: 0.3)
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  size: AppThemeConstants.iconLg,
                  color: color,
                ),
              ),
              
              SizedBox(height: widget.theme.spacing.sm),
              
              // Label
              Text(
                widget.label,
                style: widget.theme.typography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.theme.colors.textPrimary,
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
  final AppTheme theme;
  final List<QuickActionData> actions;

  const QuickActionsGrid({
    required this.theme,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.only(bottom: theme.spacing.md),
            child: Text(
              'Quick Actions',
              style: theme.typography.heading3,
            ),
          ),
          
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: theme.spacing.md,
              mainAxisSpacing: theme.spacing.md,
              childAspectRatio: 1.0,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return QuickActionTile(
                theme: theme,
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


