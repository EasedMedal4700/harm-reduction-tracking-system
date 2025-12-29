// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Service.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_drug_use_app/common/logging/logger.dart';

class NavigationService {
  GlobalKey<NavigatorState>? _navigatorKey;

  void bind(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  BuildContext? get _context => _navigatorKey?.currentContext;

  void replace(String location) {
    final context = _context;
    if (context == null || !context.mounted) {
      logger.warning('NavigationService.replace: no mounted context');
      return;
    }
    GoRouter.of(context).go(location);
  }

  void push(String location) {
    final context = _context;
    if (context == null || !context.mounted) {
      logger.warning('NavigationService.push: no mounted context');
      return;
    }
    GoRouter.of(context).push(location);
  }

  void pop() {
    final context = _context;
    if (context == null || !context.mounted) {
      logger.warning('NavigationService.pop: no mounted context');
      return;
    }
    GoRouter.of(context).pop();
  }
}
