import 'package:flutter/material.dart';
import '../services/error_logging_service.dart';

class ScreenTrackingNavigatorObserver
    extends RouteObserver<PageRoute<dynamic>> {
  void _setCurrentScreen(Route<dynamic>? route) {
    if (route is PageRoute) {
      final name = route.settings.name ?? route.runtimeType.toString();
      ErrorLoggingService.instance.updateCurrentScreen(name);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _setCurrentScreen(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _setCurrentScreen(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _setCurrentScreen(previousRoute);
  }
}
