// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-compliant.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
    final text = context.text;
    final sp = context.spacing;
    final c = context.colors;
    final acc = context.accent;

    return AnimatedContainer(
      duration: t.animations.normal,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sp.md),
        border: Border.all(
          color: _isExpanded
              ? acc.primary.withValues(alpha: t.opacities.border)
              : c.border,
          width: _isExpanded ? 1.4 : t.borders.thin,
        ),
        boxShadow: _isExpanded ? t.cardShadow : [],
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
                          width: t.borders.thin,
                        ),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  // Icon container
                  AnimatedContainer(
                    duration: t.animations.normal,
                    padding: EdgeInsets.all(sp.md),
                    decoration: BoxDecoration(
                      color: acc.primary.withValues(
                        alpha: _isExpanded
                            ? t.opacities.selected
                            : t.opacities.overlay,
                      ),
                      borderRadius: BorderRadius.circular(sp.sm),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: acc.primary,
                      size: t.sizes.iconMd,
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
                              style: text.bodyBold.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                            if (_isExpanded) ...[
                              SizedBox(width: sp.sm),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: sp.sm,
                                  vertical: sp.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: acc.primary.withValues(
                                    alpha: t.opacities.low,
                                  ),
                                  borderRadius: BorderRadius.circular(sp.sm),
                                ),
                                child: Text(
                                  'ACTIVE',
                                  style: text.overline.copyWith(
                                    color: acc.primary,
                                    fontWeight: text.bodyBold.fontWeight,
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
                          style: text.caption.copyWith(color: c.textSecondary),
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
                        color: c.border.withValues(alpha: t.opacities.high),
                        shape: context.shapes.boxShapeCircle,
                      ),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: c.textSecondary,
                        size: t.sizes.iconSm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          AnimatedSize(
            duration: t.animations.normal,
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
