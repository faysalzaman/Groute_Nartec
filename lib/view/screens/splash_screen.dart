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
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with 5 seconds duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Scale animation: logo grows from 0.2 to 1.0 size
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack),
      ),
    );

    // Blinking animation: logo fades in and out multiple times
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation
    _controller.forward();

    // Navigate to next screen after 5 seconds
    Timer(const Duration(seconds: 5), () {
      AppNavigator.push(context, LoginScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: isDark ? AppColors.grey900 : AppColors.lightBackground,
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Image.asset(kGrouteSplashImg, width: 200, height: 200),
              ),
            );
          },
        ),
      ),
    );
  }
}
