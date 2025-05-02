import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/view/screens/auth/cubit/auth_cubit.dart';
import 'package:groute_nartec/view/screens/auth/cubit/auth_state.dart';
import 'package:groute_nartec/view/screens/dashboard/home_screen.dart';
import 'package:groute_nartec/view/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/view/widgets/dialogs/nfc_scan_dialog.dart';
import 'package:groute_nartec/view/widgets/logo_widget.dart';
import 'package:groute_nartec/view/widgets/text_fields/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccessState) {
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            AppNavigator.push(context, const HomeScreen());
          }
        } else if (state is AuthErrorState) {
          AppSnackbars.danger(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(loginBackground),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Hero(tag: "logo", child: LogoWidget()),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Sign in to your account',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),

                      // Login Form
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.05),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormField(
                                height: isSmallScreen ? 40 : 45,
                                fontSize: isSmallScreen ? 11 : 12,
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                hintText: 'Enter your email',
                                hintTextSize: isSmallScreen ? 11 : 12,
                                labelText: 'Email',
                                lableTextSize: isSmallScreen ? 11 : 12,
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
                              SizedBox(height: screenHeight * 0.01),
                              CustomTextFormField(
                                height: isSmallScreen ? 40 : 45,
                                fontSize: isSmallScreen ? 11 : 12,
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                hintText: 'Enter your password',
                                hintTextSize: isSmallScreen ? 11 : 12,
                                labelText: 'Password',
                                lableTextSize: isSmallScreen ? 11 : 12,
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
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: isSmallScreen ? 11 : 12,
                                    ),
                                  ),
                                ),
                              ),
                              CustomElevatedButton(
                                height: isSmallScreen ? 35 : 40,
                                fontSize: isSmallScreen ? 11 : 12,
                                title: "LOGIN",
                                buttonState:
                                    state is AuthLoadingState
                                        ? ButtonState.loading
                                        : state is AuthSuccessState
                                        ? ButtonState.success
                                        : ButtonState.normal,
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // NFC Card Login Option
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Or login with NFC Card',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            CustomElevatedButton(
                              title: "TAP NFC CARD",

                              backgroundColor: Colors.green.shade700,
                              buttonState:
                                  state is AuthLoadingState
                                      ? ButtonState.loading
                                      : ButtonState.normal,
                              leadingIcon: Icons.nfc,
                              height: isSmallScreen ? 35 : 40,
                              fontSize: isSmallScreen ? 11 : 12,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => NFCScanDialog(
                                        authCubit: context.read<AuthCubit>(),
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
