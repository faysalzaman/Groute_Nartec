import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/view/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/view/widgets/test_fields/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.luminosity),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo or App Name
                    Text(
                      'GROUTE',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Login Form
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            height: 45,
                            fontSize: 12,
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            hintText: 'Enter your email',
                            hintTextSize: 12,
                            labelText: 'Email',
                            lableTextSize: 12,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            onCompleted: () {
                              FocusScope.of(
                                context,
                              ).requestFocus(_passwordFocusNode);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            fontSize: 12,
                            height: 45,
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            hintText: 'Enter your password',
                            hintTextSize: 12,
                            labelText: 'Password',
                            lableTextSize: 12,
                            prefixIcon: Icons.lock_outline,
                            suffixIcon:
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                            onSuffixIconPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                              FocusScope.of(context).unfocus();
                            },
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();

                                // Navigate to forgot password screen
                              },
                              child: const Text(
                                'Forgot Password?',

                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          CustomElevatedButton(
                            height: 40,
                            fontSize: 12,
                            title: "LOGIN",
                            buttonState: ButtonState.normal,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // NFC Card Login Option
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Or login with NFC Card',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomElevatedButton(
                            title: "TAP NFC CARD",
                            backgroundColor: Colors.green.shade700,
                            buttonState: ButtonState.normal,
                            leadingIcon: Icons.nfc,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),

                          // ElevatedButton.icon(
                          //   onPressed: () {
                          //     FocusScope.of(context).unfocus();

                          //     // Handle NFC card logic
                          //   },
                          //   icon: const Icon(Icons.contactless),
                          //   label: const Text('TAP NFC CARD'),
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.green.shade700,
                          //     foregroundColor: Colors.white,
                          //     padding: const EdgeInsets.symmetric(
                          //       vertical: 12,
                          //       horizontal: 24,
                          //     ),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Sign Up Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to sign up screen
                          },
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
