// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI-only expand/collapse state.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';

class AnalyticsFilterCard extends StatefulWidget {
  final Widget filterContent;
  const AnalyticsFilterCard({super.key, required this.filterContent});
  @override
  State<AnalyticsFilterCard> createState() => _AnalyticsFilterCardState();
}

class _AnalyticsFilterCardState extends State<AnalyticsFilterCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  AnimationController? _animationController;
  Animation<double>? _rotationAnimation;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animationController == null) {
      _animationController = AnimationController(
        duration: context.animations.normal,
        vsync: this,
      );
      _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_animationController != null) {
        _isExpanded
            ? _animationController!.forward()
            : _animationController!.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final tx = context.text;
    final sp = context.spacing;
    final c = context.colors;
    final ac = context.accent;
    return AnimatedContainer(
      duration: th.animations.normal,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sp.md),
        border: Border.all(
          color: _isExpanded
              ? ac.primary.withValues(alpha: th.opacities.border)
              : c.border,
          width: _isExpanded ? 1.4 : th.borders.thin,
        ),
        boxShadow: _isExpanded ? th.cardShadow : [],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(sp.md),
              bottom: Radius.circular(_isExpanded ? 0 : sp.md),
            ),
            child: Container(
              padding: EdgeInsets.all(sp.lg),
              decoration: _isExpanded
                  ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: c.border,
                          width: th.borders.thin,
                        ),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  // Icon container
                  AnimatedContainer(
                    duration: th.animations.normal,
                    padding: EdgeInsets.all(sp.md),
                    decoration: BoxDecoration(
                      color: ac.primary.withValues(
                        alpha: _isExpanded
                            ? th.opacities.selected
                            : th.opacities.overlay,
                      ),
                      borderRadius: BorderRadius.circular(sp.sm),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: ac.primary,
                      size: th.sizes.iconMd,
                    ),
                  ),
                  SizedBox(width: sp.lg),
                  // Titles
                  Expanded(
                    child: Column(
                      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Advanced Filters',
                              style: tx.bodyBold.copyWith(color: c.textPrimary),
                            ),
                            if (_isExpanded) ...[
                              SizedBox(width: sp.sm),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: sp.sm,
                                  vertical: sp.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: ac.primary.withValues(
                                    alpha: th.opacities.low,
                                  ),
                                  borderRadius: BorderRadius.circular(sp.sm),
                                ),
                                child: Text(
                                  'ACTIVE',
                                  style: tx.overline.copyWith(
                                    color: ac.primary,
                                    fontWeight: tx.bodyBold.fontWeight,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: sp.xs),
                        Text(
                          _isExpanded
                              ? 'Refine your analytics data'
                              : 'Tap to customize data visibility',
                          style: tx.caption.copyWith(color: c.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: sp.md),
                  // Chevron
                  RotationTransition(
                    turns:
                        _rotationAnimation ?? const AlwaysStoppedAnimation(0),
                    child: Container(
                      padding: EdgeInsets.all(sp.xs),
                      decoration: BoxDecoration(
                        color: c.border.withValues(alpha: th.opacities.high),
                        shape: context.shapes.boxShapeCircle,
                      ),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: c.textSecondary,
                        size: th.sizes.iconSm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          AnimatedSize(
            duration: th.animations.normal,
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Container(
                    padding: EdgeInsets.all(sp.lg),
                    child: widget.filterContent,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
