import 'package:flutter/material.dart';

class NavigationService {
  final navigatorKey = GlobalKey<NavigatorState>();

  void replace(String route) {
    navigatorKey.currentState?.pushReplacementNamed(route);
  }

  void push(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }

  void pop() {
    navigatorKey.currentState?.pop();
  }
}
