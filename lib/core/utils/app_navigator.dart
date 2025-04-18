import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

class AppNavigator {
  // Prevent instantiation
  AppNavigator._();

  // Default transition duration
  static const Duration _defaultDuration = Duration(milliseconds: 300);

  /// Navigate to a new screen with fade transition
  static Future<T?> push<T>(
    BuildContext context,
    Widget screen, {
    Duration duration = _defaultDuration,
  }) {
    return Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: screen,
        duration: duration,
      ),
    );
  }

  /// Navigate to a new screen and remove all previous screens
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget screen, {
    Duration duration = _defaultDuration,
  }) {
    return Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: screen,
        duration: duration,
      ),
      (route) => false,
    );
  }

  /// Navigate to a new screen and replace the current screen
  static Future<T?> pushReplacement<T>(
    BuildContext context,
    Widget screen, {
    Duration duration = _defaultDuration,
  }) {
    return Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: screen,
        duration: duration,
      ),
    );
  }

  /// Pop the current screen
  static void back<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  // New methods using GoRouter
  // static void goTo(BuildContext context, String route) {
  //   context.go(route);
  // }

  // static void pushTo(BuildContext context, String route) {
  //   context.push(route);
  // }

  // static void replace(BuildContext context, String route) {
  //   context.replace(route);
  // }

  // static void pop<T>(BuildContext context, [T? result]) {
  //   context.pop(result);
  // }
}
