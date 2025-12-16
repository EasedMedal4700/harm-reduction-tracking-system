import 'app_theme_constants.dart';

class Spacing {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xl2;
  final double xl3;

  final double cardPadding;
  final double cardMargin;

  const Spacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xl2,
    required this.xl3,
    required this.cardPadding,
    required this.cardMargin,
  });

  factory Spacing.normal() => const Spacing(
        xs: AppThemeConstants.spaceXs,
        sm: AppThemeConstants.spaceSm,
        md: AppThemeConstants.spaceMd,
        lg: AppThemeConstants.spaceLg,
        xl: AppThemeConstants.spaceXl,
        xl2: AppThemeConstants.space2xl,
        xl3: AppThemeConstants.space3xl,
        cardPadding: AppThemeConstants.cardPadding,
        cardMargin: AppThemeConstants.cardMargin,
      );

  factory Spacing.compact() => const Spacing(
        xs: AppThemeConstants.spaceXsCompact,
        sm: AppThemeConstants.spaceSmCompact,
        md: AppThemeConstants.spaceMdCompact,
        lg: AppThemeConstants.spaceLgCompact,
        xl: AppThemeConstants.spaceXlCompact,
        xl2: AppThemeConstants.space2xlCompact,
        xl3: AppThemeConstants.space3xlCompact,
        cardPadding: AppThemeConstants.cardPaddingCompact,
        cardMargin: AppThemeConstants.cardMarginCompact,
      );
}
