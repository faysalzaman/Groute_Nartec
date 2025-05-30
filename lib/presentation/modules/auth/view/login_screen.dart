import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_cubit.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_state.dart';
import 'package:groute_nartec/presentation/modules/auth/view/verify_email_screen.dart';
import 'package:groute_nartec/presentation/modules/dashboard/home_screen.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/dialogs/nfc_login_dialog.dart';
import 'package:groute_nartec/presentation/widgets/logo_widget.dart';
import 'package:groute_nartec/presentation/widgets/text_fields/custom_textfield.dart';
import 'package:groute_nartec/core/constants/app_preferences.dart';

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
  bool _rememberMe = false;
  bool _isNfcEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
    _checkNfcStatus();
  }

  Future<void> _loadRememberMeStatus() async {
    final rememberMe = await AppPreferences.getRememberMe();
    setState(() {
      _rememberMe = rememberMe;
    });
  }

  Future<void> _checkNfcStatus() async {
    final isEnabled = await AppPreferences.getDriverIsNFCEnabled() ?? false;
    setState(() {
      _isNfcEnabled = isEnabled;
    });
  }

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
          // Save remember me preference when login is successful
          await AppPreferences.setRememberMe(_rememberMe);

          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            AppNavigator.pushReplacement(context, const HomeScreen());
          }
        } else if (state is AuthErrorState) {
          AppSnackbars.danger(context, state.errorMessage);
        } else if (state is NfcAuthSuccessState) {
          // Also save remember me preference for NFC auth
          await AppPreferences.setRememberMe(_rememberMe);

          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            AppNavigator.pushReplacement(context, const HomeScreen());
          }
        } else if (state is NfcAuthErrorState) {
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
                image: AssetImage(kAuthBackgroundImg),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    checkColor: Colors.white,
                                    activeColor: AppColors.primaryBlue,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Remember me',
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: isSmallScreen ? 11 : 12,
                                    ),
                                  ),

                                  const Spacer(),

                                  // Move Forgot Password button here
                                  TextButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      AppNavigator.push(
                                        context,
                                        const VeryEmailScreen(),
                                      );
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
                                ],
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
                                        : ButtonState.idle,
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
                                  state is NfcAuthLoadingState
                                      ? ButtonState.loading
                                      : state is NfcAuthSuccessState
                                      ? ButtonState.success
                                      : ButtonState.idle,
                              leadingIcon: Icons.nfc,
                              height: isSmallScreen ? 35 : 40,
                              fontSize: isSmallScreen ? 11 : 12,
                              onPressed:
                                  !_isNfcEnabled
                                      ? null // Disable button when NFC is not enabled
                                      : () {
                                        FocusScope.of(context).unfocus();
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => NFCLoginDialog(
                                                authCubit:
                                                    context.read<AuthCubit>(),
                                              ),
                                        );
                                      },
                            ),
                            if (!_isNfcEnabled)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'NFC login is disabled\n You can enable NFC in your profile',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: isSmallScreen ? 11 : 12,
                                  ),
                                ),
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
