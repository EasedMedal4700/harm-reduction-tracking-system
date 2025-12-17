import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';

Widget wrapWithAppTheme(Widget child) {
  return AppThemeProvider(
    theme: AppTheme.light(),
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

Widget wrapWithAppThemeApp({required Widget home}) {
  return AppThemeProvider(
    theme: AppTheme.light(),
    child: MaterialApp(
      home: home,
    ),
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
      child: MaterialApp(
        home: home,
      ),
    ),
  );
}
