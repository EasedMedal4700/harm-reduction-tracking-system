import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart'; // Import Override from src
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';

/// Legacy wrapper functions - consider using TestUtils from flutter_test_config.dart instead
Widget wrapWithAppTheme(Widget child) {
  return AppThemeProvider(
    theme: AppTheme.light(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

Widget wrapWithAppThemeApp({required Widget home}) {
  return AppThemeProvider(
    theme: AppTheme.light(),
    child: MaterialApp(home: home),
  );
}

Widget wrapWithAppThemeAndProvidersApp({
  required Widget home,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: AppThemeProvider(
      theme: AppTheme.light(),
      child: MaterialApp(home: home),
    ),
  );
}

/// Enhanced test wrapper with more options
Widget createEnhancedTestWrapper({
  required Widget child,
  List<Override> providerOverrides = const [],
  ThemeMode themeMode = ThemeMode.light,
  Size? size,
  bool disableAnimations = true,
}) {
  return ProviderScope(
    overrides: providerOverrides,
    child: AppThemeProvider(
      theme: themeMode == ThemeMode.light ? AppTheme.light() : AppTheme.dark(),
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        home: Scaffold(body: child),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(size: size ?? const Size(400, 800)),
          child: child!,
        ),
      ),
    ),
  );
}
