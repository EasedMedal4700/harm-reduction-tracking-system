import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Provides AppTheme down the widget tree.
/// Similar to MediaQuery, Theme.of(context), etc.
class AppThemeProvider extends InheritedWidget {
  final AppTheme theme;

  const AppThemeProvider({
    super.key,
    required this.theme,
    required Widget child,
  }) : super(child: child);

  static AppTheme of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();

    if (provider == null) {
      throw FlutterError(
        'AppThemeProvider.of(context) called with no AppThemeProvider in the widget tree.\n'
        'Wrap your MaterialApp (or root widget) with AppThemeProvider.',
      );
    }

    return provider.theme;
  }

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) {
    // Rebuild descendants only when theme object changes
    return oldWidget.theme != theme;
  }
}
