import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';
import 'package:groute_nartec/presentation/modules/auth/view/login_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/home_screen.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait for UI to build first
    await Future.delayed(Duration.zero);

    final rememberMe = await AppPreferences.getRememberMe();
    final token = await AppPreferences.getAccessToken();

    if (rememberMe && token != null && token.isNotEmpty) {
      // User is logged in and has remember me enabled
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      // Not logged in or remember me not enabled
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: AppLoading()));
  }
}
