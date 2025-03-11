import 'package:flutter/material.dart';

class AppNavigatorObserver extends NavigatorObserver {
  static AppNavigatorObserver instance = AppNavigatorObserver();
  String currentRoute = '';
  String previousRoute = '';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = route.settings.name ?? '';
    this.previousRoute = previousRoute?.settings.name ?? '';
    print('didPush: ${route.str}, previousRoute= ${previousRoute?.str}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = previousRoute?.settings.name ?? '';
    this.previousRoute = route.settings.name ?? '';
    print('didPop: ${route.str}, previousRoute= ${previousRoute?.str}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = previousRoute?.settings.name ?? '';
    this.previousRoute = route.settings.name ?? '';
    print('didRemove: ${route.str}, previousRoute= ${previousRoute?.str}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    currentRoute = newRoute?.settings.name ?? '';
    previousRoute = oldRoute?.settings.name ?? '';
    print('didReplace: ${newRoute?.str}, previousRoute= ${oldRoute?.str}');
  }

  @override
  void didStartUserGesture(Route<dynamic> route,
      Route<dynamic>? previousRoute,) =>
      print('didStartUserGesture: ${route.str}, '
          'previousRoute= ${previousRoute?.str}');

  @override
  void didStopUserGesture() => print('didStopUserGesture');
}

extension on Route<dynamic> {
  String get str => 'route(${settings.name}: ${settings.arguments})';
}
