import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SplashUtils {
  static WidgetsBinding? _widgetsBinding;

  // Prevents app from closing splash screen, app layout will be build but not displayed.
  static void preserve({required WidgetsBinding widgetsBinding}) {
    _widgetsBinding = widgetsBinding;
    _widgetsBinding?.deferFirstFrame();
  }

  static void remove({bool isFirst = false}) {
    _widgetsBinding?.allowFirstFrame();
    if (isFirst) _widgetsBinding?.scheduleWarmUpFrame();
    _widgetsBinding = null;
  }
}
