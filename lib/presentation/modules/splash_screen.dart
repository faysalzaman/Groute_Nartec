// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/home_screen.dart';
import 'package:groute_nartec/presentation/widgets/logo_widget.dart';

import 'auth/view/login_screen.dart';

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
  bool _rememberMe = false;
  String? _accessToken;
  bool _isLoading = true;

  Future<void> _loadUserData() async {
    final rememberMe = await AppPreferences.getRememberMe();
    final token = await AppPreferences.getAccessToken();

    setState(() {
      _rememberMe = rememberMe;
      _accessToken = token;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    // Load user preferences
    _loadUserData();

    // Initialize animation controller with 4 seconds duration
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

    // Navigate to next screen after animation completes
    Timer(const Duration(seconds: 5), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    // If widget has a predefined next screen, use that
    if (widget.nextScreen != null) {
      AppNavigator.pushReplacement(context, widget.nextScreen!);
      return;
    }

    // Check if the user is logged in and has remember me enabled
    if (_rememberMe && _accessToken != null && _accessToken!.isNotEmpty) {
      // User is logged in and has remember me enabled - go to home screen
      AppNavigator.pushReplacement(context, const HomeScreen());
    } else {
      // Not logged in or remember me not enabled - go to login screen
      AppNavigator.pushReplacement(context, const LoginScreen());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kAuthBackgroundImg),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.5,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Hero(tag: "logo", child: LogoWidget()),
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
