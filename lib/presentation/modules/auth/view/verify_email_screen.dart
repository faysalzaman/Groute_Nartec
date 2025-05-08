import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_cubit.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_state.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:pinput/pinput.dart';

class VeryEmailScreen extends StatefulWidget {
  const VeryEmailScreen({super.key});

  @override
  State<VeryEmailScreen> createState() => _VeryEmailScreenState();
}

class _VeryEmailScreenState extends State<VeryEmailScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Track the current step in the verification process
  int _currentStep = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.grey[50],
      title: "Verify Email",
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerifyEmailSuccess) {
            setState(() {
              _currentStep = 1; // Move to OTP verification step
            });
            AppSnackbars.success(context, "OTP sent to your email");
          } else if (state is VerifyEmailError) {
            AppSnackbars.danger(
              context,
              state.errorMessage.replaceAll("Exception: ", ""),
            );
          } else if (state is VerifyOtpSuccess) {
            setState(() {
              _currentStep = 2; // Move to password reset step
            });
            AppSnackbars.success(context, "Code verified successfully");
          } else if (state is VerifyOtpError) {
            AppSnackbars.danger(
              context,
              state.errorMessage.replaceAll("Exception: ", ""),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stepper indicator
                  Row(
                    children: [
                      _buildStepIndicator(0, "Email"),
                      _buildStepDivider(),
                      _buildStepIndicator(1, "OTP"),
                      _buildStepDivider(),
                      _buildStepIndicator(2, "Password"),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Content based on current step
                  if (_currentStep == 0) _buildEmailStep(),
                  if (_currentStep == 1) _buildOtpStep(),
                  if (_currentStep == 2) _buildPasswordStep(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryBlue : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                (step + 1).toString(),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primaryBlue : Colors.grey[600],
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider() {
    return Container(width: 40, height: 2, color: Colors.grey[300]);
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Enter your email address",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        const Text(
          "We'll send a 6-digit verification code to your email",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Email",
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 30),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return CustomElevatedButton(
              title: "Send Verification Code",
              buttonState:
                  state is VerifyEmailLoading
                      ? ButtonState.loading
                      : ButtonState.idle,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().verifyEmail(_emailController.text);
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primaryBlue, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryBlue),
      ),
    );

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          setState(() {
            _currentStep = 2; // Move to password reset step
          });
          AppSnackbars.success(context, "Code verified successfully");
        } else if (state is VerifyOtpError) {
          AppSnackbars.danger(
            context,
            state.errorMessage.replaceAll("Exception: ", ""),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the verification code",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Text(
              "We've sent a 6-digit code to ${_emailController.text}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Center(
              child: Pinput(
                controller: _otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) {
                  // Auto-verify when all 6 digits are entered
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>().verifyOtp(pin);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the verification code';
                  }
                  if (value.length != 6 ||
                      !RegExp(r'^\d{6}$').hasMatch(value)) {
                    return 'Please enter a valid 6-digit code';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            CustomElevatedButton(
              title: "Verify Code",
              buttonState:
                  state is VerifyOtpLoading
                      ? ButtonState.loading
                      : ButtonState.idle,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().verifyOtp(_otpController.text);
                }
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed:
                    state is VerifyEmailLoading
                        ? null
                        : () {
                          // Resend OTP logic
                          context.read<AuthCubit>().verifyEmail(
                            _emailController.text,
                          );
                        },
                child: Text(
                  "Didn't receive the code? Resend",
                  style: TextStyle(
                    color:
                        state is VerifyEmailLoading
                            ? Colors.grey
                            : AppColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordStep() {
    // Add a state variable to track if passwords match
    final passwordsMatch =
        _confirmPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text == _passwordController.text;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          AppSnackbars.success(context, "Password reset successfully");
          Navigator.of(context).pop();
        } else if (state is ResetPasswordError) {
          AppSnackbars.danger(
            context,
            state.errorMessage.replaceAll("Exception: ", ""),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set new password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            const Text(
              "Your password must be at least 8 characters",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "New password",
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
              ),
              onChanged: (value) {
                // Trigger a rebuild when password changes to update the match indicator
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm password",
                prefixIcon: const Icon(Icons.lock_outline),
                // Add the green tick icon when passwords match
                suffixIcon:
                    passwordsMatch
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
              ),
              onChanged: (value) {
                // Trigger a rebuild when confirm password changes to update the match indicator
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            CustomElevatedButton(
              title: "Reset Password",
              buttonState:
                  state is ResetPasswordLoading
                      ? ButtonState.loading
                      : ButtonState.idle,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Pass the parameters required for password reset
                  context.read<AuthCubit>().resetPassword(
                    _passwordController.text,
                    _emailController.text,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
