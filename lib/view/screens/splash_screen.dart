import 'dart:async';

import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';

import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final Widget? nextScreen;

  const SplashScreen({super.key, this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with 5 seconds duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 4,
      ), // Animation duration within the 5 seconds
    );

    // Scale animation: logo grows from 0.2 to 1.0 size
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Rotate animation: logo rotates 360 degrees
    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Opacity animation: logo fades in
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Start the animation
    _controller.forward();

    // Navigate to next screen after 5 seconds
    Timer(const Duration(seconds: 5), () {
      AppNavigator.push(context, LoginScreen());
      // context.go(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // backgroundColor: isDark ? AppColors.grey900 : AppColors.lightBackground,
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Image.asset(kLogoImg, width: 200, height: 200),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
