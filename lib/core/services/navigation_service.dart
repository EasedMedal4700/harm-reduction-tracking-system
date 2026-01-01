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

  bool canPop() {
    return _navigatorKey?.currentState?.canPop() ?? false;
  }

  void pop<T extends Object?>([T? result]) {
    final navigator = _navigatorKey?.currentState;
    if (navigator == null) {
      logger.warning('NavigationService.pop: no navigator state');
      return;
    }

    if (!navigator.canPop()) {
      logger.warning('NavigationService.pop: cannot pop');
      return;
    }

    navigator.pop<T>(result);
  }

  void popToRoot() {
    final navigator = _navigatorKey?.currentState;
    if (navigator == null) {
      logger.warning('NavigationService.popToRoot: no navigator state');
      return;
    }
    navigator.popUntil((route) => route.isFirst);
  }

  void replace(String location) {
    final context = _context;
    if (context == null || !context.mounted) {
      logger.warning('NavigationService.replace: no mounted context');
      return;
    }
    GoRouter.of(context).go(location);
  }

  void replaceTop(String location) {
    final context = _context;
    if (context == null || !context.mounted) {
      logger.warning('NavigationService.replaceTop: no mounted context');
      return;
    }
    GoRouter.of(context).replace(location);
  }

  void push(String location, {Object? extra}) {
    final context = _context;
    if (context == null || !context.mounted) {
      logger.warning('NavigationService.push: no mounted context');
      return;
    }
    GoRouter.of(context).push(location, extra: extra);
  }

  Future<T?> pushForResult<T extends Object?>(
    String location, {
    Object? extra,
  }) async {
    final context = _context;
    if (context == null || !context.mounted) {
      logger.warning('NavigationService.pushForResult: no mounted context');
      return null;
    }
    return GoRouter.of(context).push<T>(location, extra: extra);
  }

  void pushReplacement(String location) {
    final context = _context;
    if (context == null || !context.mounted) {
      logger.warning('NavigationService.pushReplacement: no mounted context');
      return;
    }
    GoRouter.of(context).pushReplacement(location);
  }
}
